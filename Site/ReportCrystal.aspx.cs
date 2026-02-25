using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;
using QRCoder;
using System.IO;
//using ZXing;
using System.Drawing;
using System.Data.SqlClient;
using System.Configuration;
using ZXing;

public partial class Site_ReportCrystal : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string encryptedID = Request.QueryString["ID"];
            string btn = Request.QueryString["btn"];
            int decryptedID = Convert.ToInt32(modMain.Decrypt(encryptedID));
            string Domain = ConfigurationManager.AppSettings["Domain"].ToString();
            string QRLink = Domain + "/" + "Site/ReportCrystal.aspx?ID=" + encryptedID + "&btn=" + btn;
            GenerateQRCode(QRLink);

            LoadCrystalReport(decryptedID, btn); // Example: Pass PatientID
        }
    }
    public string GenerateQRCode(string text)
    {
        // Create a BarcodeWriter instance
        BarcodeWriter barcodeWriter = new BarcodeWriter();
        barcodeWriter.Format = BarcodeFormat.QR_CODE;

        // Generate the QR code image
        Bitmap qrCodeImage = barcodeWriter.Write(text);

        // Define the file path to save the QR code
        string qrCodePath = Server.MapPath("~/Reports/QRCode.png");

        // Save the QR code image to the server
        qrCodeImage.Save(qrCodePath, System.Drawing.Imaging.ImageFormat.Png);
        byte[] fileBytes = System.IO.File.ReadAllBytes(qrCodePath);
        modMain.SaveQRBytes(fileBytes);
        return qrCodePath;
    }

    private void LoadCrystalReport(int patientId, string btn)
    {
        // Load the correct .rpt file0
        ReportDocument report = new ReportDocument();
        string rptFile = string.Empty;
        if (btn == "1")
            rptFile = "ReportWithGraph.rpt";
        else if (btn == "2")
            rptFile = "ReportWithGraphWithoutHeader.rpt";
        else if (btn == "3")
            rptFile = "ReportWithoutGraph.rpt";
        else if (btn == "4")
            rptFile = "ReportWithoutHeader.rpt";
        else
            throw new ArgumentException("Invalid btn parameter");

        report.Load(Server.MapPath("~/Reports/" + rptFile));

        // Prepare DataSet
        DataSet ds = new DataSet();

        // 1) Main report data via OLE DB
        string oleDbConnStr = ConfigurationManager.AppSettings["OLEDBConnection"];
        using (OleDbConnection conn = new OleDbConnection(oleDbConnStr))
        {
            conn.Open();

            OleDbCommand cmdMain = new OleDbCommand("usp_GetPatientInvoiceData", conn);
            cmdMain.CommandType = CommandType.StoredProcedure;
            cmdMain.Parameters.AddWithValue("@PatientID", patientId);
            OleDbDataAdapter adapterMain = new OleDbDataAdapter(cmdMain);
            adapterMain.Fill(ds, "PatientInvoiceData");

            // Fetch all TestIDs for this patient
            DataTable testIdsTable = GetTestID(patientId);

            // 2) Build unified PatientTestData table
            DataTable patientTestDataTable = new DataTable("PatientTestData");
            patientTestDataTable.Columns.Add("TestName", typeof(string));
            patientTestDataTable.Columns.Add("FieldName", typeof(string));
            patientTestDataTable.Columns.Add("FieldValueString", typeof(string));
            patientTestDataTable.Columns.Add("FieldValueNumeric", typeof(double));
            patientTestDataTable.Columns.Add("CutoffValue", typeof(string));
            patientTestDataTable.Columns.Add("PatientValue", typeof(string));
            patientTestDataTable.Columns.Add("Unit", typeof(string));
            patientTestDataTable.Columns.Add("NormalValue", typeof(string));
            patientTestDataTable.Columns.Add("SortOrder", typeof(int));
            patientTestDataTable.Columns.Add("TestID", typeof(int));
            patientTestDataTable.Columns.Add("CreatedDate", typeof(DateTime));
            patientTestDataTable.Columns.Add("Remarks", typeof(string));

            for (int i = 0; i < testIdsTable.Rows.Count; i++)
            {
                int testId = Convert.ToInt32(testIdsTable.Rows[i]["ID"]);
                OleDbCommand cmdSub = new OleDbCommand("SP_GetCrystaTestResults", conn);
                cmdSub.CommandType = CommandType.StoredProcedure;
                cmdSub.Parameters.AddWithValue("@TestID", testId);

                DataTable tempResult = new DataTable();
                OleDbDataAdapter adapterSub = new OleDbDataAdapter(cmdSub);
                adapterSub.Fill(tempResult);

                for (int r = 0; r < tempResult.Rows.Count; r++)
                {
                    DataRow row = tempResult.Rows[r];
                    DataRow newRow = patientTestDataTable.NewRow();

                    newRow["TestName"] = row["TestName"];
                    newRow["FieldName"] = row["FieldName"];
                    string fv = row["FieldValueString"] as string;
                    newRow["FieldValueString"] = (fv != null ? fv : string.Empty);
                    if (row["FieldValueNumeric"] != DBNull.Value)
                        newRow["FieldValueNumeric"] = Convert.ToDouble(row["FieldValueNumeric"]);
                    else
                        newRow["FieldValueNumeric"] = DBNull.Value;

                    newRow["CutoffValue"] = row["CutoffValue"];
                    newRow["PatientValue"] = row["PatientValue"];
                    newRow["Unit"] = row["Unit"];
                    newRow["NormalValue"] = row["NormalValue"];
                    newRow["Remarks"] = row["Remarks"];
                    // Guard against DBNull for SortOrder
                    if (row["SortOrder"] != DBNull.Value)
                        newRow["SortOrder"] = Convert.ToInt32(row["SortOrder"]);
                    else
                        newRow["SortOrder"] = 0;
                    newRow["TestID"] = Convert.ToInt32(row["TestID"]);
                    if (row["CreatedDate"] != DBNull.Value)
                        newRow["CreatedDate"] = Convert.ToDateTime(row["CreatedDate"]);
                    else
                        newRow["CreatedDate"] = DateTime.MinValue;

                    patientTestDataTable.Rows.Add(newRow);
                }
            }

            ds.Tables.Add(patientTestDataTable);
        }

        // 3) Bind to Crystal
        report.SetDataSource(ds.Tables["PatientInvoiceData"]);
        ReportDocument subreport = report.OpenSubreport("SubInvoice");
        subreport.SetDataSource(ds.Tables["PatientTestData"]);

        // 4) Apply SQL logon info
        ConnectionInfo connInfo = new ConnectionInfo();
        connInfo.ServerName = ConfigurationManager.AppSettings["ServerName"];
        connInfo.DatabaseName = ConfigurationManager.AppSettings["DataBase"];
        connInfo.UserID = ConfigurationManager.AppSettings["UserName"];
        connInfo.Password = ConfigurationManager.AppSettings["Password"];
        connInfo.Type = ConnectionInfoType.SQL;
        foreach (CrystalDecisions.CrystalReports.Engine.Table tbl in report.Database.Tables)
        {
            TableLogOnInfo logOnInfo = tbl.LogOnInfo;
            logOnInfo.ConnectionInfo = connInfo;
            tbl.ApplyLogOnInfo(logOnInfo);
        }

        // 5) Export and show
        string exportPath = Server.MapPath("~/Reports/Reports.pdf");
        report.ExportToDisk(ExportFormatType.PortableDocFormat, exportPath);
        iframeRpt.Attributes["src"] = ResolveUrl("~/Reports/Reports.pdf");
    }

    private DataTable GetTestID(int patientId)
    {
        DataTable dt = new DataTable();
        string query = "SELECT ID FROM [CaseDetail] WHERE PatientID = @PatientID";

        using (SqlConnection con = new SqlConnection(connectionString))
        using (SqlCommand command = new SqlCommand(query, con))
        {
            command.Parameters.AddWithValue("@PatientID", patientId);
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                adapter.Fill(dt);
            }
        }

        return dt;
    }

}