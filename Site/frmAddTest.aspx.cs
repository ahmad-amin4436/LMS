using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Site_frmAddTest : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
    string PatientID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string ID = Request.QueryString["ID"];
        string decryptedTestID = modMain.Decrypt(ID);
        if (ID != null)
        {
            PatientID = decryptedTestID;
        }
        if (!IsPostBack)
        {
            string query3 = "SELECT ID, Code, Name, Rate,TemplateID FROM Test;";

            DataTable dataTable3 = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query3, conn);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dataTable3);
                conn.Close();

            }
            ListItem defaultItem = new ListItem("Please select the test", "");
            defaultItem.Attributes["disabled"] = "disabled"; // Optional: makes it unselectable
            defaultItem.Selected = true;
            ddlTestName.Items.Insert(0, defaultItem);
            if (dataTable3.Rows.Count > 0)
            {
                foreach (DataRow row in dataTable3.Rows)
                {
                    string testName = row["Name"].ToString();
                    string testId = row["ID"].ToString();
                    ddlTestName.Items.Add(new ListItem(testName, testId));
                    if (testName == "Specific Test Name")
                    {
                        ddlTestName.SelectedValue = testId;
                    }
                }

            }
        }

        //PatientID = Session["PatientID"] != null ? Session["PatientID"].ToString().Trim() : string.Empty;


        if (!string.IsNullOrEmpty(PatientID))
        {
            string query = "SELECT * FROM [Patient] WHERE ID = @PatientID";
            string query2 = @"
                            SELECT 
                                COUNT(*) AS TestCount, 
                                SUM(TRY_CAST(Rate AS DECIMAL(18, 2))) AS TotalTestRate 
                            FROM 
                                [CaseDetail] 
                            WHERE 
                                PatientID = @PatientID;";

            DataTable dataTable = new DataTable();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@PatientID", PatientID); // Use parameterized queries to avoid SQL injection
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dataTable);
                conn.Close();

            }

            DataTable dataTable2 = new DataTable();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query2, conn))
                {
                    // Use precise parameter type and size
                    cmd.Parameters.Add("@PatientID", SqlDbType.Int).Value = PatientID;

                    conn.Open();

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(dataTable2);
                    }
                }
            }


            // Check if data is returned
            if (dataTable.Rows.Count > 0)
            {
                DataRow row = dataTable.Rows[0];
                //string PatientName = row["PatientName"].ToString();
                string FirstName = row["FirstName"].ToString();
                string LastName = row["LastName"].ToString();
                // Now populate the input fields with the values from the DataTable
                txtPatientID.Text = row["ID"].ToString();
                txtMRNumber.Text = row["MedicalRecordNo"].ToString();
                txtFirstName.Text = FirstName;
                txtLastName.Text = LastName;
                txtAgeSex.Text = row["Age"].ToString();
                string Gender = row["Sex"].ToString();
                if (Gender == "1")
                {
                    txtGender.Text = "Male";
                }
                if (Gender == "2")
                {
                    txtGender.Text = "Female";
                }
                if (Gender == "3")
                {
                    txtGender.Text = "Custom";
                }
                txtNic.Text = row["NIC"].ToString();
                txtPhone.Text = row["Phone"].ToString();
                txtMobile.Text = row["Mobile"].ToString();
                txtAddress.Text = row["Address"].ToString();
                txtEmail.Text = row["Email"].ToString();
                txtRegistrationDate.Text = Convert.ToDateTime(row["DateRegistered"]).ToString("yyyy-MM-dd"); // If it's a DateTime, format it accordingly
                txtCABG.Text = row["CABGNo"].ToString();

                txtRegDate.Text = Convert.ToDateTime(row["DateRegistered"]).ToString("dd/MM/yyyy h:mm:ss tt");  // formatted
                txtRegLocation.Text = row["Location"].ToString();
                txtConsultant.Text = row["Consultant"].ToString();
                txtComments.Text = row["Comments"].ToString();
            }
            if (dataTable2.Rows.Count > 0)
            {
                DataRow row = dataTable2.Rows[0];
                txtTotalTests.Text = row["TestCount"].ToString();
                txtTotalAmount.Text = row["TotalTestRate"].ToString();

            }
            if (!IsPostBack)
            {
                LoadTests();
                LoadGridData();
            }


        }

    }
    private void LoadGridData()
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string query = "SELECT * FROM [CaseDetail] WHERE PatientID = @PatientID";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@PatientID", txtPatientID.Text);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            ViewState["CaseDetailData"] = dt; // store in ViewState
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
    }


    public void LoadTests()
    {
        string query2 = @"SELECT ID, TestID, ConductedAt, TestName, Rate, ReportingDate FROM 
                                [CaseDetail] 
                            WHERE 
                                PatientID = @PatientID;";
        DataTable dataTable2 = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query2, conn);
            cmd.Parameters.AddWithValue("@PatientID", PatientID); // Use parameterized queries to avoid SQL injection
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable2);
            conn.Close();

        }
        // Check if data is returned

        GridView1.DataSource = dataTable2;
        GridView1.DataBind();
    }
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex; // Set the new page index
        LoadTests(); // Rebind data
    }


    protected void PreviousPageButton_Click(object sender, EventArgs e)
    {
        // Check if we are not on the first page
        if (GridView1.PageIndex > 0)
        {
            GridView1.PageIndex -= 1;  // Move to the previous page
            LoadTests();         // Rebind the data for the new page
        }
    }

    protected void NextPageButton_Click(object sender, EventArgs e)
    {
        // Check if we are not on the last page
        if (GridView1.PageIndex < GridView1.PageCount - 1)
        {
            GridView1.PageIndex += 1;  // Move to the next page
            LoadTests();         // Rebind the data for the new page
        }
    }


    public static string GenerateTestID()
    {
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz";
        var random = new Random();
        var result = new StringBuilder(10);

        for (int i = 0; i < 10; i++)
        {
            result.Append(chars[random.Next(chars.Length)]);
        }

        return result.ToString();
    }
    public static string GenerateCaseID()
    {
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz";
        var random = new Random();
        var result = new StringBuilder(5);

        for (int i = 0; i < 5; i++)
        {
            result.Append(chars[random.Next(chars.Length)]);
        }

        return result.ToString();
    }
    protected void btnUpload_Click(object sender, EventArgs e)
    {
        if (FilePrescription.HasFile)
        {
            try
            {
                string description = txtDescription.Text;
                byte[] fileBytes = null;
                if (FilePrescription.PostedFile != null)
                {
                    BinaryReader binaryReader = new BinaryReader(FilePrescription.PostedFile.InputStream);
                    fileBytes = binaryReader.ReadBytes(FilePrescription.PostedFile.ContentLength);
                }

                long patientId = 0;
                if (!string.IsNullOrEmpty(txtPatientID.Text))
                {
                    patientId = Convert.ToInt64(txtPatientID.Text);
                }

                long uploadedBy = 0;
                if (Session["UserID"] != null)
                {
                    uploadedBy = Convert.ToInt64(Session["UserID"]);
                }

                modMain.CallPrescriptionSP(
                    1, // mode
                    0, // id for insert
                    description,
                    fileBytes,
                    patientId,
                    DateTime.Now,
                    uploadedBy
                );

                string encryptedPatientID = modMain.Encrypt(txtPatientID.Text);
                Response.Redirect("frmAddTest.aspx?ID=" + encryptedPatientID);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }
        else
        {
            Response.Write("<script>alert('No File Selected.');</script>");
        }
    }

    [System.Web.Services.WebMethod]
    public static string AddDiscount(string discountValue, string totalAmount)
    {
        if (!string.IsNullOrEmpty(discountValue) && !string.IsNullOrEmpty(totalAmount))
        {
            decimal discount = Convert.ToDecimal(discountValue);
            decimal total = Convert.ToDecimal(totalAmount);

            decimal discountAmount = total * (discount / 100);
            decimal finalAmount = total - discountAmount;

            return ((int)finalAmount).ToString();
        }
        else
        {
            return "";
        }
    }

    protected void Delete_Command(object sender, CommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            string id = e.CommandArgument.ToString();

            // Delete from database
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM [CaseDetail] WHERE ID = @id";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@id", id.Trim());
                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();
            }

            // Remove from ViewState and rebind
            DataTable dt = ViewState["CaseDetailData"] as DataTable;
            if (dt != null)
            {
                DataRow[] rows = dt.Select("ID = '" + id + "'");
                if (rows.Length > 0)
                {
                    dt.Rows.Remove(rows[0]);
                }
                ViewState["CaseDetailData"] = dt;
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
            LoadGridData();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

    }


    protected void txtDiscount_Load(object sender, EventArgs e)
    {
        string discountedAmount = AddDiscount("0", txtTotalAmount.Text);
        txtLessAmount.Text = discountedAmount;
        txtGrandTotal.Text = discountedAmount;
    }



    private DataRow GetTestDataByTestID(int testId)
    {
        // Assuming you have a DataTable of test data
        DataTable dataTable3 = GetTestData(); // This is your method to get the data table

        // Find the row where TestID matches
        DataRow[] result = dataTable3.Select("ID = " + testId);

        if (result.Length > 0)
        {
            return result[0]; // Return the first match
        }

        return null; // Return null if no match is found
    }
    private DataTable GetTestData()
    {
        // Create a sample DataTable with test data
        string query3 = "SELECT ID, Code, Name, Rate,TemplateID FROM Test";

        DataTable dataTable3 = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query3, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable3);
            conn.Close();

        }

        return dataTable3;
    }
    protected void ddlTestName_SelectedIndexChanged(object sender, EventArgs e)
    {
        string selectedTestId = ddlTestName.SelectedValue;

        if (!string.IsNullOrEmpty(selectedTestId))
        {
            DataRow selectedTestData = GetTestDataByTestID(int.Parse(selectedTestId));

            if (selectedTestData != null)
            {
                ID.Text = selectedTestData["ID"].ToString();
                TestRate.Text = selectedTestData["Rate"].ToString();
                TestName.Text = selectedTestData["Name"].ToString();
                TemplateID.Text = selectedTestData["TemplateID"].ToString();
            }
        }
    }

    protected void btnAddTest_Click(object sender, EventArgs e)
    {
        // Check for empty required fields
        if (string.IsNullOrWhiteSpace(ID.Text) &&
            string.IsNullOrWhiteSpace(TestName.Text) &&
            string.IsNullOrWhiteSpace(TemplateID.Text) &&
            string.IsNullOrWhiteSpace(TestRate.Text) &&
            string.IsNullOrWhiteSpace(RepDate.Text))
        {
            // Show SweetAlert using ScriptManager
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                "Swal.fire({ icon: 'warning', title: 'Test Not Selected', text: 'Please Select the test to proceed!' });", true);
            return;
        }
        else
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            string query = @"INSERT INTO CaseDetail (TestID, TestName, Rate, ReportingDate, PatientID, ConductedAt, CreatedDate, Status,TemplateID) 
                     VALUES (@TestID, @TestName, @TestRate, @RepDate, @PatientID, @ConductAt, @CreatedDate, @Status,@TemplateID)";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TestID", ID.Text);
                cmd.Parameters.AddWithValue("@TestName", TestName.Text);
                cmd.Parameters.AddWithValue("@TemplateID", TemplateID.Text);
                cmd.Parameters.AddWithValue("@TestRate", TestRate.Text);
                cmd.Parameters.AddWithValue("@RepDate",
                    !string.IsNullOrWhiteSpace(RepDate.Text) ? Convert.ToDateTime(RepDate.Text) : DateTime.Now);
                cmd.Parameters.AddWithValue("@PatientID", txtPatientID.Text);
                cmd.Parameters.AddWithValue("@ConductAt", "");
                cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@Status", "0");

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            // Rebind the GridView instead of redirecting
            BindGridView();
            string query2 = @"
                            SELECT 
                                COUNT(*) AS TestCount, 
                                SUM(TRY_CAST(Rate AS DECIMAL(18, 2))) AS TotalTestRate 
                            FROM 
                                [CaseDetail] 
                            WHERE 
                                PatientID = @PatientID;";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query2, conn);
                cmd.Parameters.AddWithValue("@PatientID", txtPatientID.Text);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtTotalTests.Text = reader["TestCount"].ToString();
                    txtTotalAmount.Text = reader["TotalTestRate"].ToString();

                    // Trigger the discount calculation manually
                    decimal discount = 0;
                    decimal.TryParse(txtDiscount.Text, out discount);

                    decimal total = Convert.ToDecimal(reader["TotalTestRate"]);
                    decimal discountAmount = total * (discount / 100);
                    decimal grandTotal = total - discountAmount;

                    txtLessAmount.Text = grandTotal.ToString("F2");
                    txtGrandTotal.Text = grandTotal.ToString("F2");
                }

                reader.Close();
                conn.Close();
            }
            // Optionally clear the form
            ID.Text = TestName.Text = TemplateID.Text = TestRate.Text = RepDate.Text = "";
        }

    }



    private void BindGridView()
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        string query = "SELECT * FROM CaseDetail WHERE PatientID = @PatientID";

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@PatientID", txtPatientID.Text);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
    }
    protected void btnSaveCase_Click(object sender, EventArgs e)
    {
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            string query = @"
                INSERT INTO [Case]([CaseNumber],[PatientID],[RegistrationDate],[RegistrationLocation],[ConsultantName],[Comments],[TotalTests],[TotalAmount],[ReportingDate],[Discount],[GrandTotal],[PaymentMethod],[Less],[PaidAmount],[BankPaid],[Due],[PatientBill],[LabCopy],[SampleLabel],[CreatedDate]) 
                           VALUES (@CaseNumber, @PatientID, @RegistrationDate, @RegistrationLocation,  @ConsultantName, @Comments, @TotalTests, @TotalAmount, @ReportingDate, @Discount, @GrandTotal, @PaymentMethod, @Less, @PaidAmount, @BankPaid, @Due, @PatientBill, @LabCopy, @SampleLabel, @CreatedDate)";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@CaseNumber", GenerateCaseID().ToString());
                command.Parameters.AddWithValue("@PatientID", txtPatientID.Text);
                command.Parameters.AddWithValue("@RegistrationDate", Convert.ToDateTime(txtRegistrationDate.Text));
                command.Parameters.AddWithValue("@RegistrationLocation", txtRegLocation.Text);

                command.Parameters.AddWithValue("@ConsultantName", txtConsultant.Text);
                command.Parameters.AddWithValue("@Comments", txtComments.Text);
                command.Parameters.AddWithValue("@TotalTests", txtTotalTests.Text);
                command.Parameters.AddWithValue("@TotalAmount", Convert.ToDecimal(txtTotalAmount.Text));
                command.Parameters.AddWithValue("@ReportingDate", !string.IsNullOrWhiteSpace(CaseRepoDate.Text) ? Convert.ToDateTime(CaseRepoDate.Text) : DateTime.Now);
                command.Parameters.AddWithValue("@Discount", txtDiscount.Text);
                command.Parameters.AddWithValue("@GrandTotal", Convert.ToDecimal(txtGrandTotal.Text));
                command.Parameters.AddWithValue("@PaymentMethod", PaymentMethod.Text);
                command.Parameters.AddWithValue("@Less", Convert.ToDecimal(txtLessAmount.Text));
                command.Parameters.AddWithValue("@PaidAmount", Convert.ToInt32(txtTotalPaid.Text));
                command.Parameters.AddWithValue("@BankPaid", BankPaid.Checked);
                command.Parameters.AddWithValue("@Due", txtBalance.Text);
                command.Parameters.AddWithValue("@PatientBill", PatientBill.Checked);
                command.Parameters.AddWithValue("@LabCopy", LabCopy.Checked);
                command.Parameters.AddWithValue("@SampleLabel", SampleLabel.Checked);
                command.Parameters.AddWithValue("@CreatedDate", DateTime.Now);

                connection.Open();
                int rowsAffected = command.ExecuteNonQuery();
                if (rowsAffected > 0)
                {
                    connection.Close();
                    string PatientID = txtPatientID.Text;
                    UpdatePatientStatus(PatientID);
                    string encryptedPatientID = modMain.Encrypt(txtPatientID.Text);
                    Response.Redirect("frmCrystalReport.aspx?ID=" + encryptedPatientID, false); // Fix: Use 'false' to avoid thread abortion
                    Context.ApplicationInstance.CompleteRequest();
                }

            }
        }
    }

    public void UpdatePatientStatus(string PatientID)
    {
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            string query = @"Update Patient Set Status = 1 where ID = @PatientID";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@PatientID", PatientID);
                connection.Open();
                int rowsAffected = command.ExecuteNonQuery();
                if (!string.IsNullOrEmpty(PatientID))
                {
                    Response.Redirect("frmReportViewer.aspx?ID=" + PatientID, false); // Fix: Use 'false' to avoid thread abortion
                    Context.ApplicationInstance.CompleteRequest(); // Ensures redirection without aborting the thread
                }
            }
        }
    }

    protected void txtDiscount_TextChanged(object sender, EventArgs e)
    {
        decimal discount = 0;
        decimal totalAmount = 0;

        // Validate and parse the discount input
        if (!decimal.TryParse(txtDiscount.Text, out discount) || discount < 0 || discount > 100)
        {
            txtDiscount.Text = "0"; // Reset invalid discount to 0
            discount = 0;
        }

        // Validate and parse the total amount input
        if (!decimal.TryParse(txtTotalAmount.Text, out totalAmount) || totalAmount < 0)
        {
            txtTotalAmount.Text = "0"; // Reset invalid total amount to 0
            totalAmount = 0;
        }

        // Calculate discounted amount
        decimal discountedAmount = totalAmount - (totalAmount * (discount / 100));

        // Set the calculated values to the respective TextBoxes
        txtLessAmount.Text = discountedAmount.ToString("F2"); // Format as 2 decimal places
        txtGrandTotal.Text = discountedAmount.ToString("F2");
    }

    protected void txtTotalPaid_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtTotalPaid.Text) && !string.IsNullOrEmpty(txtGrandTotal.Text))
        {
            decimal Paid = Convert.ToDecimal(txtTotalPaid.Text);
            decimal Total = Convert.ToDecimal(txtGrandTotal.Text);

            // Calculate the discount and final amount
            decimal balance = Total - Paid;
            decimal finalAmount = balance;

            txtBalance.Text = ((int)finalAmount).ToString();  // Remove values after the decimal
            DueReceived.Text = ((int)finalAmount).ToString();  // Remove values after the decimal
            PaidAmount.Text = txtTotalPaid.Text;  // Remove values after the decimal
        }
        else
        {
            txtBalance.Text = string.Empty; ;
        }
    }


}
