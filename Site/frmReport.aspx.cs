using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Drawing;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using QRCoder;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Collections.Generic;

public partial class Site_frmReport : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        int ID = Convert.ToInt32(Request.QueryString["ID"]);
        LoadPatientData(ID);
        LoadTestDetails(ID);
        GenerateQRCode(ID);
        GetTestResultsByPatientId(ID);

    }
    public void GetTestResultsByPatientId(int patientId)
    {
        int testId = GetTestIdByPatientId(patientId);

        if (testId > 0)
        {
            // If TestID is found, call the GetTestResults procedure
            GetTestResults(testId);
        }
        else
        {
            Console.WriteLine("Patient ID not found in CaseDetail table.");
        }
    }

    private int GetTestIdByPatientId(int patientId)
    {
        int testId = 0;
        Dictionary<string, DataTable> testGroups = new Dictionary<string, DataTable>();

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();

            string query = "SELECT ID, TestName FROM [CaseDetail] WHERE PatientID = @PatientID";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@PatientID", patientId);
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int PatientTestID = Convert.ToInt32(reader["ID"]);
                        string PatientTestName = reader["TestName"].ToString();
                        DataSet testResults = GetTestResults(PatientTestID);

                        foreach (DataTable table in testResults.Tables)
                        {
                            if (table.Rows.Count > 0)
                            {
                                // Remove all-null/empty columns
                                List<DataColumn> columnsToRemove = new List<DataColumn>();
                                foreach (DataColumn col in table.Columns)
                                {
                                    bool allNullOrEmpty = true;
                                    foreach (DataRow row in table.Rows)
                                    {
                                        var value = row[col];
                                        if (value != DBNull.Value && !string.IsNullOrWhiteSpace(value.ToString()))
                                        {
                                            allNullOrEmpty = false;
                                            break;
                                        }
                                    }

                                    if (allNullOrEmpty)
                                    {
                                        columnsToRemove.Add(col);
                                    }
                                }

                                foreach (DataColumn col in columnsToRemove)
                                {
                                    table.Columns.Remove(col);
                                }

                                // Group tables by TestName
                                if (!testGroups.ContainsKey(PatientTestName))
                                {
                                    testGroups.Add(PatientTestName, table);
                                }
                            }
                        }
                    }
                }
            }
        }

        if (testGroups.Count > 0)
        {
            Panel container = new Panel();
            Literal patientInfo = new Literal(); // You can populate this as needed
            container.Controls.Add(patientInfo);

            foreach (var testGroup in testGroups)
            {
                string testName = testGroup.Key;
                DataTable table = testGroup.Value;

                // Add test name as heading
                Label heading = new Label();
                heading.Text = "<h3>" + testName + "</h3>";
                heading.Style["display"] = "block";
                heading.Style["margin-top"] = "20px";
                heading.Style["text-align"] = "center";
                heading.Style["font-weight"] = "bold";
                container.Controls.Add(heading);

                // Create a table
                Table resultTable = new Table();
                resultTable.Width = Unit.Percentage(100);
                resultTable.Style["border"] = "none";
                resultTable.Style["margin-bottom"] = "20px";
                resultTable.Style["text-align"] = "center";
                resultTable.CssClass = "test-result-table";
                resultTable.GridLines = GridLines.Both;

                int totalColumns = table.Columns.Count;
                int columnLimit = 6;
                int chunkCount = (int)Math.Ceiling((double)totalColumns / columnLimit);

                for (int chunk = 0; chunk < chunkCount; chunk++)
                {
                    int startCol = chunk * columnLimit;
                    int endCol = Math.Min(startCol + columnLimit, totalColumns);

                    // Header row
                    TableHeaderRow headerRow = new TableHeaderRow();
                    for (int i = startCol; i < endCol; i++)
                    {
                        TableHeaderCell headerCell = new TableHeaderCell();
                        headerCell.Text = table.Columns[i].ColumnName;
                        headerCell.Style["font-weight"] = "bold";
                        headerCell.Style["border-bottom"] = "2px solid black";
                        headerCell.Style["border-top"] = "none";
                        headerCell.Style["border-left"] = "none";
                        headerCell.Style["border-right"] = "none";

                        headerCell.Style["padding"] = "5px";
                        headerRow.Cells.Add(headerCell);
                    }
                    resultTable.Rows.Add(headerRow);

                    // Data rows
                    foreach (DataRow row in table.Rows)
                    {
                        TableRow dataRow = new TableRow();
                        for (int i = startCol; i < endCol; i++)
                        {
                            TableCell dataCell = new TableCell();
                            object value = row[table.Columns[i]];
                            dataCell.Text = value != null ? value.ToString() : string.Empty;
                            dataCell.Style["border-bottom"] = "1px solid #000";
                            dataCell.Style["border-top"] = "none";
                            dataCell.Style["border-left"] = "none";
                            dataCell.Style["border-right"] = "none";


                            dataCell.Style["padding"] = "5px";
                            dataRow.Cells.Add(dataCell);
                        }
                        resultTable.Rows.Add(dataRow);
                    }
                }

                container.Controls.Add(resultTable);
            }

            phTestResults.Controls.Add(container);
        }
        else
        {
            phTestResults.Controls.Add(new LiteralControl("No test results found."));
        }

        return testId;
    }

    protected void GvTestResults_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        // If the GridView has no data, hide the entire GridView (or specific rows)
        if (gvTestResults.Rows.Count == 0)
        {
            gvTestResults.Visible = false; // This hides the whole GridView
        }

        // Apply styles to the data rows and header rows
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // Only show bottom border for data rows
            e.Row.Style["border-top"] = "none";
            e.Row.Style["border-left"] = "none";
            e.Row.Style["border-right"] = "none";
            e.Row.Style["border-bottom"] = "1px solid #ddd";
        }
        else if (e.Row.RowType == DataControlRowType.Header)
        {
            // Style the header with a thicker bottom border
            e.Row.Style["border-top"] = "none";
            e.Row.Style["border-left"] = "none";
            e.Row.Style["border-right"] = "none";
            e.Row.Style["border-bottom"] = "2px solid black";
        }

        // Hide columns based on their header text for both data rows and header rows
        //if (e.Row.RowType == DataControlRowType.DataRow || e.Row.RowType == DataControlRowType.Header)
        //{
        //    // Loop through all cells and hide the ones based on their header text
        //    for (int i = 0; i < e.Row.Cells.Count; i++)
        //    {
        //        // Hide columns based on header text
        //        if (e.Row.Cells[i].Text == "ID" || e.Row.Cells[i].Text == "TestID" || e.Row.Cells[i].Text == "ParameterCode" ||
        //            e.Row.Cells[i].Text == "FromValue" || e.Row.Cells[i].Text == "ToValue")
        //        {
        //            e.Row.Cells[i].Visible = false;
        //        }
        //    }
        //}
    }
    // Function to execute the GetTestResults procedure
    private DataSet GetTestResults(int testId)
    {
        DataSet ds = new DataSet();

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();

            // Execute the GetTestResults procedure with the given TestID
            using (SqlCommand command = new SqlCommand("GetTestResults", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@TestID", testId);

                using (SqlDataAdapter da = new SqlDataAdapter(command))
                {
                    da.Fill(ds);
                }
            }
        }
        return ds;
    }
    private void LoadPatientData(int patientID)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string query = @"SELECT FirstName, Sex, DateRegistered, PatientNumber, ID 
                             FROM Patient WHERE ID = @PatientID";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@PatientID", patientID);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    lblPatientName.Text = reader["FirstName"].ToString();
                    lblAgeSex.Text = reader["Sex"].ToString();
                    lblRegDate.Text = Convert.ToDateTime(reader["DateRegistered"]).ToString("dd-MMM-yyyy");
                    lblPatientNumber.Text = reader["PatientNumber"].ToString();
                    lblPatientID.Text = reader["ID"].ToString();
                }
                reader.Close();
            }
        }
    }

    private void LoadTestDetails(int patientID)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string query = @"SELECT TestID, TestName FROM CaseDetail WHERE PatientID = @PatientID";


            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@PatientID", patientID);
                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                //rptPatientTests.DataSource = dt;
                //rptPatientTests.DataBind();
            }
        }
    }



    private void GenerateQRCode(int patientID)
    {
        string qrText = patientID.ToString();
        using (QRCodeGenerator qrGenerator = new QRCodeGenerator())
        {
            using (QRCodeData qrCodeData = qrGenerator.CreateQrCode(qrText, QRCodeGenerator.ECCLevel.Q))
            {
                using (QRCode qrCode = new QRCode(qrCodeData))
                {
                    using (Bitmap qrBitmap = qrCode.GetGraphic(10))
                    {
                        using (MemoryStream ms = new MemoryStream())
                        {
                            qrBitmap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                            byte[] byteImage = ms.ToArray();
                            string base64Image = Convert.ToBase64String(byteImage);
                            imgQRCode.ImageUrl = "data:image/png;base64," + base64Image;
                        }
                    }
                }
            }
        }
    }
}