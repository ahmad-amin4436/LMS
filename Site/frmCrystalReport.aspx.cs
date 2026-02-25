using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;
using QRCoder;
using System.IO;
using ZXing;
using System.Drawing;
using System.Configuration;


public partial class Site_frmCrystalReport : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string encryptedID = Request.QueryString["ID"];
            string decryptedTestID = modMain.Decrypt(encryptedID);
            int ID = Convert.ToInt32(decryptedTestID);
            string Domain = ConfigurationManager.AppSettings["Domain"].ToString();
            string QRLink = Domain + "/" + "Site/frmCrystalReport.aspx?ID=" + encryptedID;
            GenerateQRCode(QRLink);
            // Pass the PatientID as needed
            LoadCrystalReport(ID); // Example:sa Pass PatientID
        }
    }

    private void LoadCrystalReport(int patientId)
    {
        // Create the ReportDocument
        ReportDocument report = new ReportDocument();
        string reportPath = Server.MapPath("~/Reports/Report2.rpt");
        report.Load(reportPath);

        // Generate the QR Code dynamically and get the image path

        // Pass the QR Code path to the report

        // Define the OLE DB connection string
        string oleDbConnectionString = ConfigurationManager.AppSettings["OLEDBConnection"].ToString();

        // Create a dataset for both main report and subreport data
        DataSet ds = new DataSet();

        using (OleDbConnection conn = new OleDbConnection(oleDbConnectionString))
        {
            try
            {
                // Open the connection
                conn.Open();

                // Fetch the main report data (PatientInvoiceData)
                OleDbCommand cmd = new OleDbCommand("usp_GetPatientInvoiceData", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@PatientID", patientId);

                OleDbDataAdapter adapter = new OleDbDataAdapter(cmd);
                adapter.Fill(ds, "PatientInvoiceData");

                // Fetch the subreport data (PatientTestData)
                OleDbCommand cmd2 = new OleDbCommand("usp_GetTestInvoiceData", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd2.Parameters.AddWithValue("@PatientID", patientId);

                OleDbDataAdapter adapter2 = new OleDbDataAdapter(cmd2);
                adapter2.Fill(ds, "PatientTestData");
            }
            catch (Exception ex)
            {
                // Handle any exceptions (e.g., database connection issues)
                Response.Write("Error: " + ex.Message);
                return;
            }
        }

        // Set the dataset as the data source for the main report
        report.SetDataSource(ds.Tables["PatientInvoiceData"]);

        // Set the data source for the subreport by opening it and applying the data source
        ReportDocument subreport = report.OpenSubreport("SubInvoice"); // Make sure "SubInvoice" matches the subreport name
        subreport.SetDataSource(ds.Tables["PatientTestData"]);
        
        // Apply connection information (if needed for OLE DB)
        ConnectionInfo connInfo = new ConnectionInfo
        {
            ServerName = ConfigurationManager.AppSettings["ServerName"],
            DatabaseName = ConfigurationManager.AppSettings["DataBase"],
            UserID = ConfigurationManager.AppSettings["UserName"],
            Password = ConfigurationManager.AppSettings["Password"],
            Type = ConnectionInfoType.SQL
        };

        // Apply connection info to all tables (main and subreport tables)
        foreach (Table table in report.Database.Tables)
        {
            TableLogOnInfo tableLogOnInfo = table.LogOnInfo;
            tableLogOnInfo.ConnectionInfo = connInfo;
            table.ApplyLogOnInfo(tableLogOnInfo);
        }

       
        // Optional: Export the report to PDF
        string exportPath = Server.MapPath("~/Reports/Output.pdf");
        report.ExportToDisk(ExportFormatType.PortableDocFormat, exportPath);
        iframeRpt.Attributes["src"] = ResolveUrl("~/Reports/Output.pdf");

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

}
