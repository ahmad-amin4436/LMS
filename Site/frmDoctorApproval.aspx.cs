using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

public partial class Site_frmDoctorApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPatientData();
        }
    }
    string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    private void LoadPatientData()
    {
        string query = @"SELECT * FROM [Patient] where Status = 2 ORDER BY CreatedDate DESC";

        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
        }

        // Add a calculated column for Age/Sex
        //dataTable.Columns.Add("AgeSex", typeof(string));
        //foreach (DataRow row in dataTable.Rows)

        //{
        //    row["AgeSex"] = row["Age"] + " Yr(s)/ " + row["GenderID"];
        //}

        // Bind data to GridView
        GridView1.DataSource = dataTable;
        GridView1.DataBind();
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        // Set the new page index
        GridView1.PageIndex = e.NewPageIndex;

        // Rebind data (just the GridView)
        LoadPatientData();
    }

    protected void PreviousPageButton_Click(object sender, EventArgs e)
    {
        // Check if we are not on the first page
        if (GridView1.PageIndex > 0)
        {
            GridView1.PageIndex -= 1;  // Move to the previous page
            LoadPatientData();         // Rebind the data for the new page
        }
    }

    protected void NextPageButton_Click(object sender, EventArgs e)
    {
        // Check if we are not on the last page
        if (GridView1.PageIndex < GridView1.PageCount - 1)
        {
            GridView1.PageIndex += 1;  // Move to the next page
            LoadPatientData();         // Rebind the data for the new page
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string patientID = txtPatientID.Text.Trim();
        string name = txtName.Text.Trim();
        string nic = txtNIC.Text.Trim();
        string phone = txtPhone.Text.Trim();
        string sex = ddlSex.SelectedValue;
        string Email = txtEmail.Text;
        DateTime? fromDate = string.IsNullOrEmpty(txtFromDate.Text) ? (DateTime?)null : Convert.ToDateTime(txtFromDate.Text);
        DateTime? toDate = string.IsNullOrEmpty(txtToDate.Text) ? (DateTime?)null : Convert.ToDateTime(txtToDate.Text);

        var data = GetFilteredPatients(patientID, name, Email, nic, phone, sex, fromDate, toDate);

        GridView1.DataSource = data;
        GridView1.DataBind();
    }

    private DataTable GetFilteredPatients(string patientID, string patientName, string Email, string nic, string phoneNumber,
                                          string genderID, DateTime? fromDate, DateTime? toDate)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            StringBuilder query = new StringBuilder();
            query.Append("SELECT * FROM [Patient] WHERE Status = 1 AND 1=1");

            List<SqlParameter> parameters = new List<SqlParameter>();

            if (!string.IsNullOrEmpty(patientID))
            {
                query.Append(" AND [ID] = @PatientID");
                parameters.Add(new SqlParameter("@PatientID", patientID));
            }
            if (!string.IsNullOrEmpty(Email))
            {
                query.Append(" AND [Email] = @Email");
                parameters.Add(new SqlParameter("@Email", Email));
            }
            if (!string.IsNullOrEmpty(patientName))
            {
                query.Append(" AND [FirstName] LIKE @Name");
                parameters.Add(new SqlParameter("@Name", "%" + patientName + "%"));
            }
            if (!string.IsNullOrEmpty(nic))
            {
                query.Append(" AND [NIC] LIKE @NIC");
                parameters.Add(new SqlParameter("@NIC", "%" + nic + "%"));
            }
            if (!string.IsNullOrEmpty(phoneNumber))
            {
                query.Append(" AND [Mobile] LIKE @Mobile");
                parameters.Add(new SqlParameter("@Mobile", "%" + phoneNumber + "%"));
            }
            if (!string.IsNullOrEmpty(genderID))
            {
                query.Append(" AND [Sex] = @Sex");
                parameters.Add(new SqlParameter("@Sex", genderID));
            }
            if (fromDate.HasValue)
            {
                query.Append(" AND [CreatedDate] >= @FromDate");
                parameters.Add(new SqlParameter("@FromDate", fromDate.Value));
            }
            if (toDate.HasValue)
            {
                query.Append(" AND [CreatedDate] <= @ToDate");
                parameters.Add(new SqlParameter("@ToDate", toDate.Value));
            }

            SqlCommand cmd = new SqlCommand(query.ToString(), conn);
            cmd.Parameters.AddRange(parameters.ToArray());

            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }
    }

    int patientId;
    protected void btnViewTest_Click(object sender, EventArgs e)
    {
        Button btnViewTest = (Button)sender;
        patientId = Convert.ToInt32(btnViewTest.CommandArgument);
        var testResults = GetTestResults(patientId);

        ViewState["SelectedPatientId"] = patientId;
        gvTestResults.DataSource = testResults;
        gvTestResults.DataBind();

        pnlTestResults.Visible = true;

    }
    private DataTable GetTestResults(int patientId)
    {
        DataTable table = new DataTable();
        string query = @"
                SELECT 
                    CD.[ID], 
                    CD.[TestID], 
                    CD.[TestName], 
                    CD.[TemplateID],
                    T.[Code],
                    P.Sex 
                FROM 
                    CaseDetail AS CD
                INNER JOIN 
                    Patient AS P
                ON 
                    P.ID = CD.PatientID
                INNER JOIN 
                    Test AS T
                ON 
                   T.ID = CD.TestID
                WHERE 
                    P.ID = @PatientID AND CD.Status=1;
            ";
        DataTable dataTable = new DataTable();
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@PatientID", patientId);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
            conn.Close();
        }
        return dataTable;
    }

    protected void btnTestNextPage_Click(object sender, EventArgs e)
    {
        if (gvTestResults.PageIndex < gvTestResults.PageCount - 1)
        {
            gvTestResults.PageIndex++;
            GetTestResults(patientId);
        }
    }

    protected void btnTestPreviousPage_Click(object sender, EventArgs e)
    {
        if (gvTestResults.PageIndex > 0)
        {
            gvTestResults.PageIndex--;
            GetTestResults(patientId);
        }
    }
    string Gender = "";
    int TestID;
    int TestUniqueID;
    int TemplateID;
    int Code;
    protected void btnAddTestResult_Click(object sender, EventArgs e)
    {
        //DataTable dt = ViewState["TestData"] as DataTable;
        //dt.Rows.Add("1", "2", "3", "4"); // Add empty row for new input
        //ViewState["TestData"] = dt;


        Button btnAddTestResult = (Button)sender;
        string[] args = btnAddTestResult.CommandArgument.ToString().Split(',');

        TestUniqueID = Convert.ToInt32(args[0]);  // Parse the first argument as an integer
        ViewState["TestUniqueID"] = TestUniqueID.ToString();
        Gender = args[1];      // Use the second argument as a string
        ViewState["Gender"] = Gender;
        TestID = Convert.ToInt32(args[2]);      // Use the second argument as a string
        TemplateID = Convert.ToInt32(args[3]);
        ViewState["TemplateID"] = TemplateID;
        Code = Convert.ToInt32(args[4]);
        ViewState["Code"] = Code;
        // Call the method with the parsed arguments
        BindGrid(TestID, Gender, TemplateID, Code);

    }
    private DataTable GetTestData(int? TestID, string Gender, int TemplateID, int Code)
    {
        string query = "";

        if (Gender == "Male")
        {
            Gender = "0";
        }
        if (Gender == "Female")
        {
            Gender = "1";
        }
        if (Gender == "Other")
        {
            Gender = "2";
        }

        if (TestID == null)
        {
            query = @"SELECT * FROM [TestNormalValues] ORDER BY CreatedDate DESC";
        }
        else if (TemplateID == 3)
        {
            query = @"Select top 1 TestID, Result, CutoffValue, PatientValue from [TestResultPatientCutoffValueType] where TestID = @TestID Order by CreatedDate Desc";

        }
        //else if(TemplateID == 4)
        //{
        //    query = @"SELECT TNV.TestID, T.Code, T.Name 
        //          FROM [TestNormalValues] AS TNV 
        //          INNER JOIN Test AS T ON T.Code = TNV.TestID 
        //          WHERE TestID = " + TestID + " AND Gender = " + Gender + " AND TemplateID = " + TemplateID + " ORDER BY T.CreatedDate DESC";
        //}
        else
        {
            query = @"Select top 1 TestID, Result, Unit, FromValue, ToValue from [TestResultValueType] where TestID = @TestID order by CreatedDate Desc";
        }

        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@TestID", Convert.ToInt32(ViewState["TestUniqueID"]));
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
        }


        return dataTable;
    }

    private void BindGrid(int? TestID, string Gender, int TemplateID, int Code)
    {
        //if (ViewState["TestData"] == null)
        ViewState["TestData"] = GetTestData(TestID, Gender, TemplateID, Code);
        if (ViewState["TemplateID"].ToString() == "4")
        {
            foreach (DataControlField column in gvAddResult.Columns)
            {
                if (column.HeaderText == "Result" || column.HeaderText == "Unit" || column.HeaderText == "From Value" || column.HeaderText == "To Value")
                {
                    column.Visible = true;
                }
                if (column.HeaderText == "Cut off Value" || column.HeaderText == "Patient Value" || column.HeaderText == "Result P-N")
                {
                    column.Visible = false;
                }
            }
        }
        if (ViewState["TemplateID"].ToString() == "6")
        {
            foreach (DataControlField column in gvAddResult.Columns)
            {
                if (column.HeaderText == "Result")
                {
                    column.Visible = true;
                }
                if (column.HeaderText == "Unit" || column.HeaderText == "From Value" || column.HeaderText == "To Value" || column.HeaderText == "Cut off Value" || column.HeaderText == "Patient Value" || column.HeaderText == "Result P-N")
                {
                    column.Visible = false;
                }
            }
        }
        if (ViewState["TemplateID"].ToString() == "3")
        {
            foreach (DataControlField column in gvAddResult.Columns)
            {
                if (column.HeaderText == "Cut off Value" || column.HeaderText == "Patient Value" || column.HeaderText == "Result")
                {
                    column.Visible = true;
                }
                if (column.HeaderText == "Unit" || column.HeaderText == "From Value" || column.HeaderText == "To Value" || column.HeaderText == "Result P-N")
                {
                    column.Visible = false;
                }
            }
        }

        DataTable dt = ViewState["TestData"] as DataTable;
        gvAddResult.DataSource = ViewState["TestData"] as DataTable;
        gvAddResult.DataBind();
    }

    protected void gvAddResult_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvAddResult.EditIndex = e.NewEditIndex;
        GridViewRow row = gvAddResult.Rows[e.NewEditIndex];
        TextBox txtCutOffValue = null;
        txtCutOffValue = row.FindControl("txtCutOffValue") as TextBox;

        //txtCutOffValue.Text = ViewState["CutoffValue"].ToString();

        if (ViewState["TemplateID"].ToString() == "4")
        {
            foreach (DataControlField column in gvAddResult.Columns)
            {
                if (column.HeaderText == "Result")
                {
                    column.Visible = false;
                }
            }
        }
        TestID = Convert.ToInt32((row.Cells[0].Text));
        //string Gender = (row.FindControl("lblResult") as Label)?.Text; // Adjust if Gender comes from another column or control
        Gender = ViewState["Gender"].ToString();
        Code = Convert.ToInt32(ViewState["Code"]);
        TemplateID = Convert.ToInt32(ViewState["TemplateID"]);
        BindGrid(TestID, Gender, TemplateID, Code);
    }

    protected void gvAddResult_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvAddResult.EditIndex = -1;


        // Call the method with the parsed arguments
        //BindGrid(TestID, Gender, TemplateID,Code);
    }

    protected void gvAddResult_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        DataTable dt = ViewState["TestData"] as DataTable;

        GridViewRow row = gvAddResult.Rows[e.RowIndex];
        string testID = ViewState["TestUniqueID"].ToString();

        TextBox txtPatientValue = row.FindControl("txtPatientValue") as TextBox;
        TextBox txtResult = row.FindControl("txtResult") as TextBox;
        DropDownList ddlResult = row.FindControl("ddlResult") as DropDownList;

        string fromValue = (row.Cells[GetColumnIndexByHeaderText("From Value")].Text ?? string.Empty).Trim();
        string toValue = (row.Cells[GetColumnIndexByHeaderText("To Value")].Text ?? string.Empty).Trim();
        string unit = (row.Cells[GetColumnIndexByHeaderText("Unit")].Text ?? string.Empty).Trim();
        string cutoffValue = string.Empty;

        int cutoffValueColumnIndex = GetColumnIndexByHeaderText("Cut off Value");

        if (cutoffValueColumnIndex >= 0)
        {
            TextBox txtCutoffValue = row.Cells[cutoffValueColumnIndex].Controls.OfType<TextBox>().FirstOrDefault();

            if (txtCutoffValue != null)
            {
                cutoffValue = txtCutoffValue.Text.Trim();
            }
            else
            {
                cutoffValue = row.Cells[cutoffValueColumnIndex].Text.Trim();
            }
        }
        decimal parsedFromValue = 0, parsedToValue = 0, parsedCutoffValue = 0, parsedPatientValue = 0;
        bool hasFromValue = decimal.TryParse(fromValue, out parsedFromValue);
        bool hasToValue = decimal.TryParse(toValue, out parsedToValue);
        bool hasPatientValue = txtPatientValue != null && decimal.TryParse(txtPatientValue.Text, out parsedPatientValue);

        string result = !string.IsNullOrWhiteSpace(txtResult.Text)
            ? txtResult.Text.Trim()
            : ddlResult != null && !string.IsNullOrWhiteSpace(ddlResult.SelectedValue)
                ? ddlResult.SelectedValue.Trim()
                : null;

        parsedFromValue = decimal.Parse(parsedFromValue.ToString("G29"));
        parsedToValue = decimal.Parse(parsedToValue.ToString("G29"));
        string normalValue = (hasFromValue && hasToValue)
            ? string.Format("{0}-{1}", parsedFromValue, parsedToValue)
            : null;

        DateTime createdDate = DateTime.Now;

        // Database insert logic
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string query = !string.IsNullOrWhiteSpace(cutoffValue)
                ? @"
                INSERT INTO [TestResultPatientCutoffValueType] (
                    TestID, ParameterCode, Parameter, Result, Unit, CreatedDate, CutoffValue, PatientValue
                ) VALUES (
                    @TestID, @ParameterCode, @Parameter, @Result, @Unit, @CreatedDate, @CutoffValue, @PatientValue
                )"
                : @"
                INSERT INTO [TestResultValueType] (
                    TestID, ParameterCode, Parameter, Result, Unit, NormalValue, CreatedDate, FromValue, ToValue
                ) VALUES (
                    @TestID, @ParameterCode, @Parameter, @Result, @Unit, @NormalValue, @CreatedDate, @FromValue, @ToValue
                )";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@TestID", testID);
                cmd.Parameters.AddWithValue("@ParameterCode", DBNull.Value);
                cmd.Parameters.AddWithValue("@Parameter", DBNull.Value);
                cmd.Parameters.AddWithValue("@Result", result);
                cmd.Parameters.AddWithValue("@Unit", !string.IsNullOrWhiteSpace(unit) ? unit : (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@CreatedDate", createdDate);

                if (!string.IsNullOrWhiteSpace(cutoffValue))
                {
                    cmd.Parameters.AddWithValue("@CutoffValue", Convert.ToDecimal(cutoffValue));
                    cmd.Parameters.AddWithValue("@PatientValue", hasPatientValue ? (object)parsedPatientValue : DBNull.Value);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@NormalValue", normalValue ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@FromValue", parsedFromValue);
                    cmd.Parameters.AddWithValue("@ToValue", parsedToValue);
                }

                int rowsAffected = cmd.ExecuteNonQuery();
                if (rowsAffected > 0)
                {
                    // Update related test and patient status logic
                    int testUniqueID = int.Parse(testID);
                    if (UpdateTestStatus(testUniqueID))
                    {
                        int patientId = Convert.ToInt32(ViewState["SelectedPatientId"]);
                        if (GetPatientTestCount(patientId) == 0)
                        {
                            UpdatePatientStatus(patientId);
                        }
                    }
                }
            }
        }

        // Reset GridView edit index and rebind data
        gvAddResult.EditIndex = -1;
        BindGrid(Convert.ToInt32(ViewState["TestID"]), ViewState["Gender"].ToString(), Convert.ToInt32(ViewState["TemplateID"]), Convert.ToInt32(ViewState["Code"]));
        Response.Redirect("../Site/frmLaboratory.aspx", true);

    }

    private int GetColumnIndexByHeaderText(string headerText)
    {
        foreach (DataControlField column in gvAddResult.Columns)
        {
            if (column.HeaderText == headerText)
            {
                return gvAddResult.Columns.IndexOf(column);
            }
        }
        return -1;
    }
    private bool UpdateTestStatus(int TestUniqueID)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand(@"Update [CaseDetail] Set Status = @Status where ID = @TestID", conn))
            {
                cmd.Parameters.AddWithValue("@TestID", TestUniqueID);
                cmd.Parameters.AddWithValue("@Status", "1");

                conn.Open();
                int rowAfftected = cmd.ExecuteNonQuery();
                if (rowAfftected > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
    }
    private bool UpdatePatientStatus(int patientId)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand(@"Update [Patient] Set Status = @Status where ID = @PatientID", conn))
            {
                cmd.Parameters.AddWithValue("@PatientID", patientId);
                cmd.Parameters.AddWithValue("@Status", "1");

                conn.Open();
                int rowAfftected = cmd.ExecuteNonQuery();
                if (rowAfftected > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
    }
    private int GetPatientTestCount(int patientID)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT COUNT(*) FROM [CaseDetail] WHERE Status = @Status AND PatientID = @PatientID", conn))
            {
                cmd.Parameters.AddWithValue("@PatientID", patientID); // Fixed variable naming
                cmd.Parameters.AddWithValue("@Status", 0);

                conn.Open();
                // Use ExecuteScalar to get the count from the SELECT query
                int count = (int)cmd.ExecuteScalar();
                conn.Close();
                return count;
            }
        }
    }


    protected void btnApprove_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        string id = btn.CommandArgument;
        string encryptedID = modMain.Encrypt(id);

        // Open in new tab using JavaScript
        string script = "window.open('ReportCrystal.aspx?ID="+encryptedID+ "&btn=1', '_blank');";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenReport", script, true);
    }


    protected void btnRetake_Click(object sender, EventArgs e)
    {
        Button btnRetake = (Button)sender;

        // Get the CommandArgument value (TestID)
        string testID = btnRetake.CommandArgument;

        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"Update [CaseDetail] set Status = @Status where ID = @TestID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@TestID", testID);
                    cmd.Parameters.AddWithValue("@Status", 0);
                    con.Open();
                    int rowAffected = cmd.ExecuteNonQuery();
                    int patientId = Convert.ToInt32(ViewState["SelectedPatientId"]);
                    if (rowAffected > 0)
                    {
                        UpdatePatientStatus(patientId);
                    }
                    Response.Redirect("../Site/frmDoctorApproval.aspx", true);

                }
            }
        }
        catch (Exception ex)
        {

        }
    }
}