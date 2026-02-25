using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Site_frmManagement : System.Web.UI.Page
{
    public static string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register the startup script to reinitialize Select2
        ScriptManager.RegisterStartupScript(this, this.GetType(), " ", " ();", true);

        // Check if the user is logged in
        if (Session["Username"] == null)
        {
            Response.Redirect("Site/frmIndex.aspx", false);
            return; // Exit the method if redirected
        }

        // Check for access permissions
        if (Session["AccessNames"] != null)
        {
            List<string> accessNames = (List<string>)Session["AccessNames"];
            string currentPage = Request.Url.AbsolutePath.TrimStart('/').ToLower(); // Normalize case

            // Check if the user has access to the current page
            if (!accessNames.Any(name => currentPage.Contains(name.ToLower())))
            {
                Session["AccessDeniedPage"] = currentPage; // Store the denied page for display
                Response.Redirect("frmAccessRestricted.aspx"); // Redirect to access restricted page
                return; // Exit the method after redirecting
            }


        }
        else
        {
            // If AccessNames is null, redirect to the restricted page
            Response.Redirect("frmAccessRestricted.aspx");
            return; // Exit the method after redirecting
        }

        // Existing functionality to load data and initialize tabs
        if (!IsPostBack)
        {
            LoadTestData();
            ViewState["CurrentPageIndex"] = 0;
            ViewState["SortField"] = "CreatedDate";
            ViewState["SortOrder"] = "DESC";
            LoadRateTypesForDropdown();
            LoadReferenceData();
            // LoadRateTypeData();
            LoadRateTypesData();
            LoadTestDepartmentData();
            LoadiLockUserData();
            LoadAccessPages();
            LoadRoles();
            BindCustonRateTypeGrid();
        }
        else
        {
            string activeTab = hfActiveTab.Value;
            ScriptManager.RegisterStartupScript(this, GetType(), "SetActiveTab", "$('.nav-tabs a[href=\"#" + activeTab + "\"]').tab('show');", true);
            ScriptManager.RegisterStartupScript(this, GetType(), "ScrollToTop", "scrollToTop();", true);
        }
    }
   

   
  
    private void LoadAccessPages()
    {
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT id, AccessName FROM AccessTable";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                List<ListItem> accessList = new List<ListItem>();

                while (reader.Read())
                {
                    string fullPageName = reader["AccessName"].ToString();

                    // Extract only the page name (removing 'Site/' and '.aspx')
                    string displayName = fullPageName.Replace("Site/", "").Replace(".aspx", "");

                    accessList.Add(new ListItem(displayName, reader["id"].ToString()));
                }

                ddlAccessPages.DataSource = accessList;
                ddlAccessPages.DataTextField = "Text";
                ddlAccessPages.DataValueField = "Value";
                ddlAccessPages.DataBind();
            }
        }
    }
    private void LoadRoles()
    {
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            // Use GROUP BY to ensure unique RoleName entries
            string query = "SELECT DISTINCT RoleName FROM RolesTable";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                List<ListItem> rolesList = new List<ListItem>();

                while (reader.Read())
                {
                    string roleName = reader["RoleName"].ToString();
                    rolesList.Add(new ListItem(roleName, roleName)); // Using RoleName as both text & value
                }

                ddlRoles.DataSource = rolesList;
                ddlRoles.DataTextField = "Text";
                ddlRoles.DataValueField = "Value";
                ddlRoles.DataBind();
            }
        }
    }

    protected void btnSaveRole_Click(object sender, EventArgs e)
    {
        string roleName = txtRoleName.Text.Trim(); // Get the role name
        List<int> selectedAccessIDs = ddlAccessPages.Items.Cast<ListItem>()
                                          .Where(i => i.Selected)
                                          .Select(i => int.Parse(i.Value))
                                          .ToList();

        if (!string.IsNullOrEmpty(roleName) && selectedAccessIDs.Count > 0)
        {
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // Insert each selected page with the role name
                string insertQuery = "INSERT INTO RolesTable (RoleName, AccessID) VALUES (@RoleName, @AccessID)";
                foreach (int accessID in selectedAccessIDs)
                {
                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@RoleName", roleName);
                        cmd.Parameters.AddWithValue("@AccessID", accessID);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            // Close the modal after saving
            Response.Redirect("~/Site/frmManagement.aspx");
        }
    }
    private void LoadCenters()
    {
        string query = "SELECT ID, Name FROM Center ORDER BY Name ASC";

        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
        }

        // Bind data to DropDownList
        ddlCenter.DataSource = dataTable;
        ddlCenter.DataTextField = "Name"; // Display the Name field
        ddlCenter.DataValueField = "ID";  // Store the ID field as the value
        ddlCenter.DataBind();
    }
    private void LoadiLockUserData()
    {
        string query = "SELECT * FROM Users ORDER BY CreatedDate DESC";

        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
        }

        // Bind data to GridView
        GridViewiLockUser.DataSource = dataTable;
        GridViewiLockUser.DataBind();
    }
    protected void btnAddUser_Click(object sender, EventArgs e)
    {
        // Clear fields before opening the modal
        ClearUserFields();

        // Load departments into the CheckBoxList
        LoadDepartments();

        // Load centers into the DropDownList
        LoadCenters();

        // Show the modal using JavaScript
        ScriptManager.RegisterStartupScript(this, GetType(), "ShowAddUserModal", "$('#addUserModal').modal('show');", true);
    }
    private void LoadDepartments()
    {
        string query = "SELECT ID, Name FROM TestDepartment ORDER BY Name ASC";

        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
        }

        // Bind data to CheckBoxList
        chkDepartments.DataSource = dataTable;
        chkDepartments.DataTextField = "Name"; // Display the Name field
        chkDepartments.DataValueField = "ID";  // Store the ID field as the value
        chkDepartments.DataBind();
    }
    protected void btnSaveUser_Click(object sender, EventArgs e)
    {
        hfActiveTab.Value = "step7";

        string UserName = txtUserName.Text.Trim();
        string FirstName = txtFirstName.Text.Trim();
        string LastName = txtLastName.Text.Trim();
        bool Disabled = chkDisabled.Checked;
        string Password = txtPassword.Text.Trim();
        string Email = txtuserEmail.Text.Trim();
        string Mobile = txtuserMobile.Text.Trim();
        string Address = txtAddress.Text.Trim();
        string City = txtuserCity.Text.Trim();
        string CreatedBy = "Admin";
        DateTime CreatedDate = DateTime.Now;

        // Collect selected department IDs
        string selectedDepartments = string.Join(",", chkDepartments.Items.Cast<ListItem>().Where(i => i.Selected).Select(i => i.Value));

        // Collect selected center IDs
        string selectedCenters = string.Join(",", ddlCenter.Items.Cast<ListItem>().Where(i => i.Selected).Select(i => i.Value));

        // Collect selected RoleName
        string selectedRoles = ddlRoles.SelectedValue;

        try
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query;

                // Check if we're updating an existing user
                if (!string.IsNullOrEmpty(hfID.Value))
                {
                    query = @"
                UPDATE Users 
                SET UserName = @UserName, 
                    FirstName = @FirstName, 
                    LastName = @LastName, 
                    Disabled = @Disabled, 
                    Password = @Password, 
                    Email = @Email, 
                    Mobile = @Mobile, 
                    Address = @Address, 
                    City = @City,
                    Department = @Department,
                    Centers = @Centers,
                    RoleName = @RoleName
                WHERE UserId = @UserId";
                }
                else // Inserting new user
                {
                    query = @"
                INSERT INTO Users (
                    UserName, FirstName, LastName, Disabled, Password, 
                    Email, Mobile, Address, City, CreatedBy, CreatedDate, Department, Centers, RoleName
                ) VALUES (
                    @UserName, @FirstName, @LastName, @Disabled, @Password, 
                    @Email,  @Mobile, @Address, @City, @CreatedBy, @CreatedDate, @Department, @Centers, @RoleName
                )";
                }

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserName", UserName);
                    command.Parameters.AddWithValue("@FirstName", FirstName);
                    command.Parameters.AddWithValue("@LastName", LastName);
                    command.Parameters.AddWithValue("@Disabled", Disabled);
                    command.Parameters.AddWithValue("@Password", Password);
                    command.Parameters.AddWithValue("@Email", Email);
                    command.Parameters.AddWithValue("@Mobile", Mobile);
                    command.Parameters.AddWithValue("@Address", Address);
                    command.Parameters.AddWithValue("@City", City);
                    command.Parameters.AddWithValue("@Department", selectedDepartments);
                    command.Parameters.AddWithValue("@Centers", selectedCenters);
                    command.Parameters.AddWithValue("@RoleName", selectedRoles);

                    if (!string.IsNullOrEmpty(hfID.Value))
                    {
                        command.Parameters.AddWithValue("@UserId", hfID.Value);
                    }
                    else
                    {
                        command.Parameters.AddWithValue("@CreatedBy", CreatedBy);
                        command.Parameters.AddWithValue("@CreatedDate", CreatedDate);
                    }

                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
            }
        }
        catch (Exception ex)
        {
            Response.Write("Error: " + ex.Message);
        }

        // Reload the GridView after saving
        LoadiLockUserData();

        // Close the modal
        ScriptManager.RegisterStartupScript(this, GetType(), "HideAddUserModal",
                "$('#addUserModal').modal('hide');", true);
    }
    private void SaveUserDepartments(string userName)
    {
        foreach (ListItem item in chkDepartments.Items)
        {
            if (item.Selected)
            {
                int departmentId = int.Parse(item.Value);

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                INSERT INTO UserDepartments (UserName, DepartmentId)
                VALUES (@UserName, @DepartmentId)";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserName", userName);
                        command.Parameters.AddWithValue("@DepartmentId", departmentId);

                        connection.Open();
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                }
            }
        }
    }
    private void ClearUserFields()
    {
        txtUserName.Text = string.Empty;
        txtFirstName.Text = string.Empty;
        txtLastName.Text = string.Empty;
        chkDisabled.Checked = false;
        txtPassword.Text = string.Empty;
        txtuserEmail.Text = string.Empty;
        txtuserMobile.Text = string.Empty;
        txtAddress.Text = string.Empty;
        txtuserCity.Text = string.Empty;

        // Clear the departments CheckBoxList
        chkDepartments.ClearSelection();

        // Clear the centers DropDownList
        ddlCenter.ClearSelection();
    }
    protected void GridViewiLockUser_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewiLockUser.PageIndex = e.NewPageIndex;
        LoadiLockUserData();
    }

    protected void iLockUserPreviousPageButton_Click(object sender, EventArgs e)
    {
        if (GridViewiLockUser.PageIndex > 0)
        {
            GridViewiLockUser.PageIndex -= 1;
            LoadiLockUserData();
        }
    }

    protected void iLockUserNextPageButton_Click(object sender, EventArgs e)
    {
        if (GridViewiLockUser.PageIndex < GridViewiLockUser.PageCount - 1)
        {
            GridViewiLockUser.PageIndex += 1;
            LoadiLockUserData();
        }
    }
    protected void GridViewiLockUser_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditRow")
        {
            string UserId = e.CommandArgument.ToString();
            hfID.Value = UserId; // Store the UserId for update operation

            string query = "SELECT * FROM Users WHERE UserId = @UserId";
            DataTable dataTable = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", UserId);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dataTable);
            }

            if (dataTable.Rows.Count > 0)
            {
                DataRow row = dataTable.Rows[0];

                // Populate all fields in the modal
                txtUserName.Text = row["UserName"].ToString();
                txtFirstName.Text = row["FirstName"].ToString();
                txtLastName.Text = row["LastName"].ToString();
                chkDisabled.Checked = Convert.ToBoolean(row["Disabled"]);
                txtPassword.Text = row["Password"].ToString();
                txtEmail.Text = row["Email"].ToString();
                txtuserMobile.Text = row["Mobile"].ToString();
                txtAddress.Text = row["Address"].ToString();
                txtCity.Text = row["City"].ToString();

                // Load departments and centers
                LoadDepartments();
                LoadCenters();
                LoadRoles();

                // Select saved departments
                string savedDepartments = row["Department"].ToString();
                if (!string.IsNullOrEmpty(savedDepartments))
                {
                    string[] departmentIds = savedDepartments.Split(',');
                    foreach (string departmentId in departmentIds)
                    {
                        ListItem item = chkDepartments.Items.FindByValue(departmentId);
                        if (item != null)
                        {
                            item.Selected = true;
                        }
                    }
                }

                // Select saved centers
                string savedCenters = row["Centers"].ToString();
                if (!string.IsNullOrEmpty(savedCenters))
                {
                    string[] centerIds = savedCenters.Split(',');
                    foreach (string centerId in centerIds)
                    {
                        ListItem item = ddlCenter.Items.FindByValue(centerId);
                        if (item != null)
                        {
                            item.Selected = true;
                        }
                    }
                }

                // Select saved role
                string savedRole = row["RoleName"].ToString();
                if (!string.IsNullOrEmpty(savedRole))
                {
                    ListItem item = ddlRoles.Items.FindByValue(savedRole);
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                }

                // Show the modal
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowAddUserModal", "$('#addUserModal').modal('show');", true);
            }
        }
    }
    private void LoadTestDepartmentData()
    {
        string query = "SELECT ID, Name, Status FROM TestDepartment ORDER BY Name ASC";

        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
        }

        // Bind data to GridView
        GridViewTestDepartment.DataSource = dataTable;
        GridViewTestDepartment.DataBind();
    }
    protected void btnSaveDepartment_Click(object sender, EventArgs e)
    {
        hfActiveTab.Value = "step6";

        string Name = txtDepartmentName.Text;
        bool Status = chkDepartmentStatus.Checked;

        try
        {
            if (!string.IsNullOrWhiteSpace(Name))
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query;

                    if (ViewState["DepartmentID"] != null) // Update existing record
                    {
                        int ID = Convert.ToInt32(ViewState["DepartmentID"]);
                        query = @"
                    UPDATE TestDepartment 
                    SET Name = @Name, Status = @Status 
                    WHERE ID = @ID";
                    }
                    else // Insert new record
                    {
                        query = @"
                    INSERT INTO TestDepartment (Name, Status)
                    VALUES (@Name, @Status)";
                    }

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Name", Name);
                        command.Parameters.AddWithValue("@Status", Status);

                        if (ViewState["DepartmentID"] != null)
                        {
                            command.Parameters.AddWithValue("@ID", ViewState["DepartmentID"]);
                        }

                        connection.Open();
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }

        // Reload the GridView after saving
        LoadTestDepartmentData();
        ClearDepartmentFields();
        ViewState["DepartmentID"] = null; // Reset the ID
        btnSaveDepartment.Text = "Save Department"; // Reset button text
    }
    private void ClearDepartmentFields()
    {
        txtDepartmentName.Text = string.Empty;
        chkDepartmentStatus.Checked = false;
    }
    protected void GridViewTestDepartment_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewTestDepartment.PageIndex = e.NewPageIndex;
        LoadTestDepartmentData();
    }

    protected void TestDepartmentPreviousPageButton_Click(object sender, EventArgs e)
    {
        if (GridViewTestDepartment.PageIndex > 0)
        {
            GridViewTestDepartment.PageIndex -= 1;
            LoadTestDepartmentData();
        }
    }

    protected void TestDepartmentNextPageButton_Click(object sender, EventArgs e)
    {
        if (GridViewTestDepartment.PageIndex < GridViewTestDepartment.PageCount - 1)
        {
            GridViewTestDepartment.PageIndex += 1;
            LoadTestDepartmentData();
        }
    }
    protected void GridViewTestDepartment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditRow")
        {
            int ID = Convert.ToInt32(e.CommandArgument);

            string query = "SELECT * FROM TestDepartment WHERE ID = @ID";
            DataTable dataTable = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", ID);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dataTable);
            }

            if (dataTable.Rows.Count > 0)
            {
                DataRow row = dataTable.Rows[0];

                txtDepartmentName.Text = row["Name"].ToString();
                chkDepartmentStatus.Checked = Convert.ToBoolean(row["Status"]);

                // Store the ID in a hidden field or ViewState for later use
                ViewState["DepartmentID"] = ID;

                // Change Button Text to "Update"
                btnSaveDepartment.Text = "Update Department";
            }
        }
    }
    protected void btnSaveRateType_Click(object sender, EventArgs e)
    {
        hfActiveTab.Value = "step5"; // Assuming "step5" is the ID of the RateTypes tab

        string Name = txtRateTypeName.Text;
        decimal Special = string.IsNullOrEmpty(txtSpecial.Text) ? 0 : decimal.Parse(txtSpecial.Text);
        decimal Routine = string.IsNullOrEmpty(txtRoutine.Text) ? 0 : decimal.Parse(txtRoutine.Text);
        decimal Rebate = string.IsNullOrEmpty(txtRebate.Text) ? 0 : decimal.Parse(txtRebate.Text);
        decimal Biopsy = string.IsNullOrEmpty(txtBiopsy.Text) ? 0 : decimal.Parse(txtBiopsy.Text);
        decimal PCR = string.IsNullOrEmpty(txtPCR.Text) ? 0 : decimal.Parse(txtPCR.Text);
        decimal Other = string.IsNullOrEmpty(txtOthers.Text) ? 0 : decimal.Parse(txtOthers.Text);
        decimal Radiology = string.IsNullOrEmpty(txtRadiology.Text) ? 0 : decimal.Parse(txtRadiology.Text);
        decimal Outside = string.IsNullOrEmpty(txtOutside.Text) ? 0 : decimal.Parse(txtOutside.Text);
        bool IsFixPrice = chkIsFixedPrice.Checked;
        bool Status = chkRateTypeInActive.Checked;

        try
        {
            if (!string.IsNullOrWhiteSpace(Name))
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query;

                    // Check if we're updating an existing rate type
                    if (Session["RateTypeID"] != null && Convert.ToInt32(Session["RateTypeID"]) > 0)
                    {
                        query = @"
                    UPDATE [RateType] SET 
                        Name = @Name, 
                        Special = @Special, 
                        Routine = @Routine, 
                        Rebate = @Rebate, 
                        Biopsy = @Biopsy, 
                        PCR = @PCR, 
                        Other = @Other, 
                        Radiology = @Radiology, 
                        Outside = @Outside, 
                        IsFixPrice = @IsFixPrice, 
                        Status = @Status
                    WHERE ID = @ID";
                    }
                    else // Inserting new rate type
                    {
                        query = @"
                    INSERT INTO [RateType] (
                        Name, Special, Routine, Rebate, Biopsy, PCR, Other, Radiology, Outside, IsFixPrice, Status
                    ) 
                    VALUES (
                        @Name, @Special, @Routine, @Rebate, @Biopsy, @PCR, @Other, @Radiology, @Outside, @IsFixPrice, @Status
                    )";
                    }

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Name", Name);
                        command.Parameters.AddWithValue("@Special", Special);
                        command.Parameters.AddWithValue("@Routine", Routine);
                        command.Parameters.AddWithValue("@Rebate", Rebate);
                        command.Parameters.AddWithValue("@Biopsy", Biopsy);
                        command.Parameters.AddWithValue("@PCR", PCR);
                        command.Parameters.AddWithValue("@Other", Other);
                        command.Parameters.AddWithValue("@Radiology", Radiology);
                        command.Parameters.AddWithValue("@Outside", Outside);
                        command.Parameters.AddWithValue("@IsFixPrice", IsFixPrice);
                        command.Parameters.AddWithValue("@Status", Status);

                        // Add ID parameter only for update
                        if (Session["RateTypeID"] != null && Convert.ToInt32(Session["RateTypeID"]) > 0)
                        {
                            command.Parameters.AddWithValue("@ID", Convert.ToInt32(Session["RateTypeID"]));
                        }

                        connection.Open();
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }

        // Reload the GridView after saving
        LoadRateTypesData();
        ClearRateTypeFields();

        // Reset the RateTypeID in session
        Session["RateTypeID"] = null;

        // Close the modal if it's open
        ScriptManager.RegisterStartupScript(this, GetType(), "HideModal", "$('#popupModal').modal('hide');", true);
    }

    private void LoadRateTypeData()
    {
        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            int ID = Convert.ToInt32(Session["RateTypeID"]);

            SqlCommand cmd = new SqlCommand("SP_GetTestRateDetails", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@RateTypeID", ID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
            //GridViewRow row = GridViewRateTypes.Rows[index];
            //txtRateTypesName.Text = row.Cells[0].Text;
            //txtRateTypesDescription.Text = row.Cells[1].Text;
            //chkRateTypesStatus.Checked = row.Cells[2].Text == "True";

        }

        GridViewRateType.DataSource = dataTable;
        GridViewRateType.DataBind();
    }
    private void LoadRateTypesForDropdown()
    {
        ddlRateTypeID.Items.Clear();

        ddlRateTypeID.Items.Add(new ListItem("R3", "Discount"));
        ddlRateTypeID.Items.Add(new ListItem("R4", "DiscountR4"));

        ddlRateTypeID.Items.Insert(0, new ListItem("--Select Rate Type--", ""));
    }

    protected void GridViewRateType_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewRateType.PageIndex = e.NewPageIndex;
        LoadRateTypeData();
    }
    private void ClearRateTypeFields()
    {
        txtRateTypeName.Text = string.Empty;
        txtSpecial.Text = string.Empty;
        txtRoutine.Text = string.Empty;
        txtRebate.Text = string.Empty;
        txtBiopsy.Text = string.Empty;
        txtPCR.Text = string.Empty;
        txtOthers.Text = string.Empty;
        txtRadiology.Text = string.Empty;
        txtOutside.Text = string.Empty;
        chkIsFixedPrice.Checked = false;
        chkRateTypeInActive.Checked = false;

        // Clear the session variable
        Session["RateTypeID"] = null;
    }
    protected void btnSaveReference_Click(object sender, EventArgs e)
    {
        hfActiveTab.Value = "step3";

        ScriptManager.RegisterStartupScript(this, GetType(), "SetActiveTab", "$('.nav-tabs a[href=\"#step3\"]').tab('show');", true);

        string Code = txtReferenceCode.Text;
        string Name = txtReferenceName.Text;
        string Address = txtReferenceAddress.Text;
        string City = txtCity.Text;
        string Phone = txtReferencePhone.Text;
        string Email = txtReferenceEmail.Text;
        int RateTypeID = int.Parse(ddlRateTypeReferemce.SelectedValue);
        string PaymentMode = ddlPaymentMode.SelectedValue;
        decimal CreditLimit = decimal.Parse(txtCreditLimit.Text);
        int CreditDays = int.Parse(txtCreditDays.Text);
        decimal CurrentBalance = decimal.Parse(txtCurrentBalance.Text);

        try
        {
            if (!string.IsNullOrWhiteSpace(Code))
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Reference (
                            Code, Name, Address, City, Phone, Email, RateTypeID, PaymentMode, 
                            CreditLimit, CreditDays, CurrentBalance
                        ) 
                        VALUES (
                            @Code, @Name, @Address, @City, @Phone, @Email, @RateTypeID, @PaymentMode, 
                            @CreditLimit, @CreditDays, @CurrentBalance
                        )";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Code", Code);
                        command.Parameters.AddWithValue("@Name", Name);
                        command.Parameters.AddWithValue("@Address", Address);
                        command.Parameters.AddWithValue("@City", City);
                        command.Parameters.AddWithValue("@Phone", Phone);
                        command.Parameters.AddWithValue("@Email", Email);
                        command.Parameters.AddWithValue("@RateTypeID", RateTypeID);
                        command.Parameters.AddWithValue("@PaymentMode", PaymentMode);
                        command.Parameters.AddWithValue("@CreditLimit", CreditLimit);
                        command.Parameters.AddWithValue("@CreditDays", CreditDays);
                        command.Parameters.AddWithValue("@CurrentBalance", CurrentBalance);

                        connection.Open();
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error:" + ex.Message);
        }

        // Reload the GridView after saving
        LoadReferenceData();
        ClearReferenceFields();
    }
    private void LoadReferenceData()
    {
        string query = "SELECT * FROM Reference ORDER BY Code DESC";

        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
        }

        // Bind data to GridView
        GridViewReference.DataSource = dataTable;
        GridViewReference.DataBind();
    }
    protected void GridViewReferences_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewReference.PageIndex = e.NewPageIndex;
        LoadReferenceData();
    }
    private void ClearReferenceFields()
    {
        txtCode.Text = string.Empty;
        txtName.Text = string.Empty;
        txtAddress.Text = string.Empty;
        txtCity.Text = string.Empty;
        txtPhone.Text = string.Empty;
        txtEmail.Text = string.Empty;
        ddlRateTypeID.SelectedIndex = 0;
        ddlPaymentMode.SelectedIndex = 0;
        txtCreditLimit.Text = string.Empty;
        txtCreditDays.Text = string.Empty;
        txtCurrentBalance.Text = string.Empty;
    }
    protected void btnSaveRateTypes_Click(object sender, EventArgs e)
    {
        string Name = txtRateTypesName.Text;
        string Description = txtRateTypesDescription.Text;
        bool Status = chkRateTypesStatus.Checked;

        try
        {
            if (!string.IsNullOrWhiteSpace(Name))
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                    INSERT INTO RateType (Name, Description, Status)
                    VALUES (@Name, @Description, @Status)";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Name", Name);
                        command.Parameters.AddWithValue("@Description", Description);
                        command.Parameters.AddWithValue("@Status", Status);

                        connection.Open();
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }

        // Reload the GridView after saving
        LoadRateTypesData();
        ClearRateTypesFields();
    }
    private void LoadRateTypesData()
    {
        string query = "SELECT * FROM RateType ORDER BY Name ASC";
        int ID = Convert.ToInt32(Session["RateTypeID"]);
        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
        }

        // Bind data to GridView
        GridViewRateTypes.DataSource = dataTable;
        GridViewRateTypes.DataBind();
    }
    protected void GridViewRateTypes_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewRateTypes.PageIndex = e.NewPageIndex;
        LoadRateTypesData();
    }

    protected void RateTypesPreviousPageButton_Click(object sender, EventArgs e)
    {
        if (GridViewRateTypes.PageIndex > 0)
        {
            GridViewRateTypes.PageIndex -= 1;
            LoadRateTypesData();
        }
    }

    protected void RateTypesNextPageButton_Click(object sender, EventArgs e)
    {
        if (GridViewRateTypes.PageIndex < GridViewRateTypes.PageCount - 1)
        {
            GridViewRateTypes.PageIndex += 1;
            LoadRateTypesData();
        }
    }
    protected void GridViewRateTypes_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditRateType")
        {
            // Get the ID of the row to edit
            int rateTypeID = Convert.ToInt32(e.CommandArgument);

            // Store the RateTypeID in session for the update operation
            Session["RateTypeID"] = rateTypeID;

            // Fetch the data for the selected RateType
            DataTable dt = GetRateTypeByID(rateTypeID);

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];

                // Populate the form fields with the data from the selected row
                txtRateTypeName.Text = row["Name"].ToString();
                txtSpecial.Text = row["Special"].ToString();
                txtRoutine.Text = row["Routine"].ToString();
                txtRebate.Text = row["Rebate"].ToString();
                txtBiopsy.Text = row["Biopsy"].ToString();
                txtPCR.Text = row["PCR"].ToString();
                txtOthers.Text = row["Other"].ToString();
                txtRadiology.Text = row["Radiology"].ToString();
                txtOutside.Text = row["Outside"].ToString();
                chkIsFixedPrice.Checked = Convert.ToBoolean(row["IsFixPrice"]);
                chkRateTypeInActive.Checked = Convert.ToBoolean(row["Status"]);

                // Load the rate details for this rate type
                LoadRateTypeData();

                // Show the modal
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowPopupModal", "$('#popupModal').modal('show');", true);
            }
        }
    }
    private DataTable GetRateTypeByID(int rateTypeID)
    {
        DataTable dt = new DataTable();
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string query = "SELECT * FROM RateType WHERE ID = @RateTypeID";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@RateTypeID", rateTypeID);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
        }
        return dt;
    }
    private void ClearRateTypesFields()
    {
        txtRateTypesName.Text = string.Empty;
        txtRateTypesDescription.Text = string.Empty;
        chkRateTypesStatus.Checked = false;
    }
    // Add Button in GridView
    protected void GridViewRateTypes_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Button btnEdit = new Button();
            btnEdit.Text = "Edit";
            btnEdit.CommandName = "EditRateType";
            btnEdit.CommandArgument = e.Row.RowIndex.ToString();
            btnEdit.CssClass = "btn btn-sm btn-primary";
            e.Row.Cells[3].Controls.Add(btnEdit);
        }
    }
    private DataTable LoadTestData()
    {
        string query = @"SELECT * FROM [Test] ORDER BY CreatedDate DESC";
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




        //TestGroup
        string TestGroup_Query = @"SELECT ID, Name FROM [TestGroup] ORDER BY CreatedDate DESC";

        DataTable TestGroup_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestGroup_Query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestGroup_DT);
        }
        foreach (DataRow row in TestGroup_DT.Rows)
        {
            string testName = row["Name"].ToString();
            string testId = row["ID"].ToString();
            ddlGroup.Items.Add(new ListItem(testName, testId));
            if (testName == "Specific Test Name")
            {
                ddlGroup.SelectedValue = testId;
            }
        }

        //TestSpecimen
        string TestSpecimen_Query = @"SELECT ID, Name FROM [TestSpecimen] ORDER BY CreatedDate DESC";

        DataTable TestSpecimen_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestSpecimen_Query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestSpecimen_DT);
        }
        foreach (DataRow row in TestSpecimen_DT.Rows)
        {
            string testName = row["Name"].ToString();
            string testId = row["ID"].ToString();
            ddlSpecimen.Items.Add(new ListItem(testName, testId));
            if (testName == "Specific Test Name")
            {
                ddlSpecimen.SelectedValue = testId;
            }
        }
        //TestDays
        string TestDays_Query = @"SELECT ID, Description FROM [TestDays]";

        DataTable TestDays_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestDays_Query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestDays_DT);
        }
        foreach (DataRow row in TestDays_DT.Rows)
        {
            string testName = row["Description"].ToString();
            string testId = row["ID"].ToString();
            ddlTestDays.Items.Add(new ListItem(testName, testId));
            if (testName == "Specific Test Name")
            {
                ddlTestDays.SelectedValue = testId;
            }
        }
        //Testtemplate
        string TestTemplate_Query = @"SELECT ID, Name FROM [TestTemplate]";

        DataTable TestTemplate_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestTemplate_Query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestTemplate_DT);
        }
        foreach (DataRow row in TestTemplate_DT.Rows)
        {
            string testName = row["Name"].ToString();
            string testId = row["ID"].ToString();
            ddlTestTemplate.Items.Add(new ListItem(testName, testId));
            ddlParameterTemplates.Items.Add(new ListItem(testName, testId));
            if (testName == "Specific Test Name")
            {
                ddlTestTemplate.SelectedValue = testId;
                ddlParameterTemplates.SelectedValue = testId;
            }
        }
        string TestDDL_Query = @"SELECT ID, Name FROM [Test]";

        DataTable TestDDL_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestDDL_Query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestDDL_DT);
        }

        // Clear existing items (if any) to avoid duplication
        ddlTest.Items.Clear();

        // Add a default "Select" option (optional)
        ddlTest.Items.Add(new ListItem("--Select Test--", ""));

        // Populate the dropdown
        foreach (DataRow row in TestDDL_DT.Rows)
        {
            string testName = row["Name"].ToString();
            string testId = row["ID"].ToString();
            ddlTest.Items.Add(new ListItem(testName, testId));
        }
        string Parameter_query = @"SELECT ID, TestID, Name, ReportName, Unit, TemplateID, SortOrder, Format, CreatedDate 
                             FROM TestParameter ORDER BY CreatedDate DESC";

        DataTable Parameter_dt = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(Parameter_query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(Parameter_dt);
        }

        // Add a calculated column for Age/Sex
        //dataTable.Columns.Add("AgeSex", typeof(string));
        //foreach (DataRow row in dataTable.Rows)
        //{
        //    row["AgeSex"] = row["Age"] + " Yr(s)/ " + row["GenderID"];
        //}

        string TestTypeDDL_Query = @"SELECT ID, Name FROM [TestType]";

        DataTable TestTypeDDL_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestTypeDDL_Query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestTypeDDL_DT);
        }

        // Clear existing items (if any) to avoid duplication
        ddlTestTypeSettings.Items.Clear();

        // Add a default "Select" option (optional)
        ddlTestTypeSettings.Items.Add(new ListItem("--Select Test--", ""));

        // Populate the dropdown
        foreach (DataRow row in TestTypeDDL_DT.Rows)
        {
            string testtypeName = row["Name"].ToString();
            string Id = row["ID"].ToString();
            ddlTestTypeSettings.Items.Add(new ListItem(testtypeName, Id));
        }
        // Bind data to GridView
        GridViewParameter.DataSource = Parameter_dt;
        GridViewParameter.DataBind();
        return dataTable;
    }
    protected void GridViewParameter_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

        GridViewParameter.PageIndex = e.NewPageIndex;
        LoadTestData(); // Rebind the GridView with updated page index
    }
    protected void GridViewParameter_RowEditing(object sender, GridViewEditEventArgs e)
    {

        GridViewRow row = GridViewParameter.Rows[e.NewEditIndex];

        // Get the TestID and TemplateID from the respective cells (assuming these columns exist)
        int TestID = Convert.ToInt32(((Label)row.FindControl("lblTestID")).Text);  // Or use the respective control for TestID (e.g., Label or TextBox)
        int TemplateID = Convert.ToInt32(((Label)row.FindControl("lblTemplateID")).Text); // Same for TemplateID

        // Retrieve the data using TestID and TemplateID
        DataTable dt = GetTestNormalValues(TestID, TemplateID);
        gvNormalValues2.DataSource = dt;
        gvNormalValues2.DataBind();
        GridViewParameter.EditIndex = e.NewEditIndex;

        LoadTestData(); // Rebind to show textboxes for editing
    }
    // Cancel Editing
    protected void GridViewParameter_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {

        GridViewParameter.EditIndex = -1;
        LoadTestData(); // Rebind to show original values
    }
    // Handle Updating
    protected void GridViewParameter_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridViewRow row = GridViewParameter.Rows[e.RowIndex];

        // Retrieve values from the edited fields
        string id = ((TextBox)row.FindControl("txtID")).Text;
        string createdDate = ((TextBox)row.FindControl("txtCreatedDate")).Text;
        string format = ((TextBox)row.FindControl("txtFormat")).Text;
        string sortOrder = ((TextBox)row.FindControl("txtSortOrder")).Text;
        string templateID = ((TextBox)row.FindControl("txtTemplateID")).Text;
        string unit = ((TextBox)row.FindControl("txtUnit")).Text;
        string reportName = ((TextBox)row.FindControl("txtReportName")).Text;
        string name = ((TextBox)row.FindControl("txtName")).Text;
        string testID = ((TextBox)row.FindControl("txtTestID")).Text;

        // Perform the update operation (Replace with actual database update logic)
        UpdateTestParameters(id, createdDate, format, sortOrder, templateID, unit, reportName, name, testID);

        // Exit edit mode
        GridViewParameter.EditIndex = -1;

        // Rebind data to reflect the changes
        LoadTestData();

    }
    private void UpdateTestParameters(string id, string createdDate, string format, string sortOrder, string templateID, string unit, string reportName, string name, string testID)
    {

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string query = @"UPDATE [TestParameter] 
                         SET CreatedDate = @CreatedDate, 
                             Format = @Format, 
                             SortOrder = @SortOrder, 
                             TemplateID = @TemplateID, 
                             Unit = @Unit, 
                             ReportName = @ReportName, 
                             Name = @Name, 
                             TestID = @TestID 
                         WHERE ID = @ID";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                // Add parameters to prevent SQL injection
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@CreatedDate", createdDate);
                cmd.Parameters.AddWithValue("@Format", format);
                cmd.Parameters.AddWithValue("@SortOrder", sortOrder);
                cmd.Parameters.AddWithValue("@TemplateID", templateID);
                cmd.Parameters.AddWithValue("@Unit", unit);
                cmd.Parameters.AddWithValue("@ReportName", reportName);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@TestID", testID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;

        // Reload data with current search term if any
        string searchTerm = txtSearch.Text.Trim().ToLower();
        if (!string.IsNullOrEmpty(searchTerm))
        {
            // Apply search filter
            DataTable dataTable = LoadTestData();
            var filteredRows = dataTable.AsEnumerable()
                .Where(row => row.Field<string>("Code").ToLower().Contains(searchTerm) ||
                              row.Field<string>("Name").ToLower().Contains(searchTerm));

            GridView1.DataSource = filteredRows.Any() ? filteredRows.CopyToDataTable() : null;
        }
        else
        {
            // Load all data without filter
            GridView1.DataSource = LoadTestData();
        }

        GridView1.DataBind();
    }
    protected void PreviousPageButton_Click(object sender, EventArgs e)
    {
        if (GridView1.PageIndex > 0)
        {
            GridView1.PageIndex--;
            BindGridViewWithCurrentFilter();
        }
    }

    protected void NextPageButton_Click(object sender, EventArgs e)
    {
        if (GridView1.PageIndex < GridView1.PageCount - 1)
        {
            GridView1.PageIndex++;
            BindGridViewWithCurrentFilter();
        }
    }
    private void BindGridViewWithCurrentFilter()
    {
        string searchTerm = txtSearch.Text.Trim().ToLower();

        if (!string.IsNullOrEmpty(searchTerm))
        {
            DataTable dataTable = LoadTestData();
            var filteredRows = dataTable.AsEnumerable()
                .Where(row => row.Field<string>("Code").ToLower().Contains(searchTerm) ||
                              row.Field<string>("Name").ToLower().Contains(searchTerm));

            GridView1.DataSource = filteredRows.Any() ? filteredRows.CopyToDataTable() : null;
        }
        else
        {
            GridView1.DataSource = LoadTestData();
        }

        GridView1.DataBind();
    }
    protected void btnSaveTest_Click(object sender, EventArgs e)
    {
        hfActiveTab.Value = "step1";

        string code = txtCode.Text;
        string name = txtName.Text;
        string groupId = ddlGroup.SelectedValue;
        string type = ddlType.SelectedValue;
        string synonyms = txtSynonyms.Text;
        bool status = chkStatus.Checked;
        string reportName = txtReportName.Text;
        string textHeading = txtHeading.Text;
        string reportGroup = txtReportGroup.Text;
        string testDays = ddlTestDays.SelectedValue;
        string reportingDays = ddlReportingDays.SelectedValue;
        string specimen = ddlSpecimen.SelectedValue;
        string specimenReqQty = txtSpecimenReqQty.Text;
        string sortOrder = txtSortOrder.Text;
        bool isSpecial = chkIsSpecial.Checked;
        decimal rate = decimal.Parse(txtRate.Text);
        string testTypeSettings = ddlTestTypeSettings.SelectedValue;
        string templateId = txtTemplateID.Text;

        try
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                if (!string.IsNullOrEmpty(txtTestID.Text))
                {
                    // Update existing test
                    int testId = Convert.ToInt32(txtTestID.Text);

                    string updateQuery = @"
                    UPDATE [Test] SET 
                        Code = @Code, 
                        Name = @Name, 
                        GroupID = @GroupID, 
                        TestType = @TestType, 
                        Synonyms = @Synonyms,  
                        ReportName = @ReportName, 
                        TestHeading = @TestHeading, 
                        ReportGroup = @ReportGroup, 
                        TestDays = @TestDays, 
                        ReportDays = @ReportDays, 
                        SpecimenID = @SpecimenID, 
                        SpecimenReqQuantity = @SpecimenReqQuantity, 
                        SortOrder = @SortOrder, 
                        IsSpecial = @IsSpecial, 
                        Rate = @Rate,
                        TemplateID = @TemplateID,
                        Type = @Type,
                        Status = @Status
                    WHERE ID = @ID";

                    using (SqlCommand command = new SqlCommand(updateQuery, connection))
                    {
                        command.Parameters.AddWithValue("@ID", testId);
                        command.Parameters.AddWithValue("@Code", code ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@Name", name ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@GroupID", groupId ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@TestType", testTypeSettings ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@Synonyms", synonyms ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@ReportName", reportName ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@TestHeading", textHeading ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@ReportGroup", reportGroup ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@TestDays", testDays ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@ReportDays", reportingDays ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@SpecimenID", specimen ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@SpecimenReqQuantity", specimenReqQty ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@SortOrder", sortOrder ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@IsSpecial", isSpecial);
                        command.Parameters.AddWithValue("@Rate", rate);
                        command.Parameters.AddWithValue("@TemplateID", templateId ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@Type", type ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@Status", status);

                        command.ExecuteNonQuery();
                    }
                }
                else
                {
                    // Insert new test
                    string insertQuery = @"
                    INSERT INTO [Test] (
                        Code, Name, GroupID, TestType, Synonyms,  
                        ReportName, TestHeading, ReportGroup, TestDays, ReportDays, 
                        SpecimenID, SpecimenReqQuantity, SortOrder, IsSpecial, Rate, TemplateID, Type, Status
                    ) 
                    VALUES (
                        @Code, @Name, @GroupID, @TestType, @Synonyms,  
                        @ReportName, @TestHeading, @ReportGroup, @TestDays, @ReportDays, 
                        @SpecimenID, @SpecimenReqQuantity, @SortOrder, @IsSpecial, @Rate, @TemplateID, @Type, @Status
                    );
                    SELECT SCOPE_IDENTITY();";

                    int testId;
                    using (SqlCommand command = new SqlCommand(insertQuery, connection))
                    {
                        command.Parameters.AddWithValue("@Code", code ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@Name", name ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@GroupID", groupId ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@TestType", testTypeSettings ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@Synonyms", synonyms ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@ReportName", reportName ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@TestHeading", textHeading ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@ReportGroup", reportGroup ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@TestDays", testDays ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@ReportDays", reportingDays ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@SpecimenID", specimen ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@SpecimenReqQuantity", specimenReqQty ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@SortOrder", sortOrder ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@IsSpecial", isSpecial);
                        command.Parameters.AddWithValue("@Rate", rate);
                        command.Parameters.AddWithValue("@TemplateID", templateId ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@Type", type ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@Status", status);

                        testId = Convert.ToInt32(command.ExecuteScalar());
                    }

                    // Insert normal values if gender is selected
                    if (!string.IsNullOrEmpty(ddlGender.SelectedValue))
                    {
                        string insertNormalValuesQuery = @"
                        INSERT INTO TestNormalValues (
                            TestID, Gender, FromAge, ToAge, FromValue, ToValue, Remarks, Status, CreatedDate
                        ) 
                        VALUES (
                            @TestID, @Gender, @FromAge, @ToAge, @FromValue, @ToValue, @Remarks, @Status, @CreatedDate
                        )";

                        using (SqlCommand command = new SqlCommand(insertNormalValuesQuery, connection))
                        {
                            command.Parameters.AddWithValue("@TestID", testId);
                            command.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                            command.Parameters.AddWithValue("@FromAge", string.IsNullOrEmpty(txtFromAge.Text) ? (object)DBNull.Value : txtFromAge.Text);
                            command.Parameters.AddWithValue("@ToAge", string.IsNullOrEmpty(txtToAge.Text) ? (object)DBNull.Value : txtToAge.Text);
                            command.Parameters.AddWithValue("@FromValue", string.IsNullOrEmpty(txtFromValue.Text) ? (object)DBNull.Value : txtFromValue.Text);
                            command.Parameters.AddWithValue("@ToValue", string.IsNullOrEmpty(txtToValue.Text) ? (object)DBNull.Value : txtToValue.Text);
                            command.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(txtRemarks.Text) ? (object)DBNull.Value : txtRemarks.Text);
                            command.Parameters.AddWithValue("@Status", false);
                            command.Parameters.AddWithValue("@CreatedDate", DateTime.Now);

                            command.ExecuteNonQuery();
                        }
                    }
                }
            }

            // Refresh the gridview
            LoadTestData();

            // Clear fields if it was a new entry
            if (string.IsNullOrEmpty(txtTestID.Text))
            {
                ClearTestFields();
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "successScript",
                "successSaved = true;", true);
        }
        catch (Exception ex)
        {
            // Handle error
            Response.Write("Error: " + ex.Message);
        }
    }

    private void ClearTestFields()
    {
        txtCode.Text = string.Empty;
        txtName.Text = string.Empty;
        txtSynonyms.Text = string.Empty;
        txtReportName.Text = string.Empty;
        txtHeading.Text = string.Empty;
        txtReportGroup.Text = string.Empty;
        txtSpecimenReqQty.Text = string.Empty;
        txtSortOrder.Text = string.Empty;
        txtRate.Text = string.Empty;
        txtTemplateID.Text = string.Empty;
        txtTestID.Text = string.Empty;

        txtFromAge.Text = string.Empty;
        txtToAge.Text = string.Empty;
        txtFromValue.Text = string.Empty;
        txtToValue.Text = string.Empty;
        txtRemarks.Text = string.Empty;

        ddlGroup.SelectedIndex = 0;
        ddlType.SelectedIndex = 0;
        ddlTestDays.SelectedIndex = 0;
        ddlReportingDays.SelectedIndex = 0;
        ddlSpecimen.SelectedIndex = 0;
        ddlTestTypeSettings.SelectedIndex = 0;
        ddlGender.SelectedIndex = 0;

        chkIsSpecial.Checked = false;
        chkStatus.Checked = false;
    }

    protected void btnSaveCenter_Click(object sender, EventArgs e)
    {
        hfActiveTab.Value = "step2";

        int id = 0;
        
        if (!string.IsNullOrWhiteSpace(hfID.Value))
        {
            id = Convert.ToInt32(hfID.Value);
        }
        
        int code = int.Parse(txtID.Text);
        string name = txtCenterName.Text;
        string rateTypeId = ddlRateTypeID.SelectedValue.ToString();
        byte type = string.IsNullOrEmpty(ddlType.Text) ? (byte)0 : byte.Parse(ddlType.Text);
        bool isLab = chkIsLab.Checked;
        bool status = chkStatus.Checked;
        string description = txtDescription.Text;
        string address = txtAddress.Text;
        string country = ddlCountry.Text;
        string city = ddlCity.Text;
        string phone = txtPhone.Text;
        string email = txtEmail.Text;
        decimal MaxDiscountLimit = Convert.ToDecimal(txtMaxDiscLimit.Text);
        decimal EndAt = Convert.ToDecimal(txtEndDate.Text);

        try
        {
            modMain mod = new modMain();

            bool isUpdate = !string.IsNullOrWhiteSpace(hfID.Value);
            int mode = isUpdate ? 2 : 1;

            mod.CallCentersProcedure(
                mode, id,code, name, description, type, isLab, null, EndAt, null, null, rateTypeId,
                address, city, country, phone, null, email, null, null, null, null,
                Session["UserId"].ToString(), DateTime.Now, Session["UserId"].ToString(), DateTime.Now, status, null, MaxDiscountLimit, null
            );

            string message = isUpdate ? "Center updated successfully!" : "Center created successfully!";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertMessage", "alert('" + message + "');   GenerateCenterTable();", true);

            ClearCenterFields();
            hfID.Value = "";
            btnSaveCenter.Text = "Save Center";
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertMessage", "alert('An error occurred.');", true);
        }
    }
    [System.Web.Services.WebMethod]
    public static object DeleteCenter(int id)
    {
        try
        {
            modMain mod = new modMain();
            mod.CallCentersProcedure(
                3, id,null, null, null, 0, false, null, null, null, null, "",
                null, null, null, null, null, null, null, null, null, null,
                null, DateTime.Now, null, DateTime.Now, false, null, null, null
            );

            return new { success = true, message = "Center deleted successfully." };
        }
        catch (Exception ex)
        {
            return new { success = false, message = "Error: " + ex.Message };
        }
    }



    // Add to Page_ Load

    [System.Web.Services.WebMethod]
    [System.Web.Script.Services.ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static object Centers(int draw, int start, int length,
                        string search = "",
                        string sortColumn = "createdDate",
                        string sortDirection = "desc")
    {
        DataSet result = modMain.GetCentersDetails(search, start, length, sortColumn, sortDirection);

        List<object> dataList = new List<object>();
        int totalRecords = 0;

        if (result != null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow row in result.Tables[0].Rows)
            {
                dataList.Add(new
                {
                    id = row["ID"],
                    code = row["Code"],
                    name = row["Name"],
                    type = row["Type"],
                    city = row["City"],
                    createdDate = row["CreatedDate"],
                    status = Convert.ToBoolean(row["Status"]),
                    // Hidden but returned
                    rateTypeId = row["RateTypeID"],
                    description = row["Description"],
                    address = row["Address"],
                    country = row["Country"],
                    phone = row["Phone"],
                    email = row["Email"],
                    isLab = row["IsLab"],
                    SpecialDiscount = row["SpecialDiscount"],
                    CreditLimit = row["CreditLimit"],
                    
                });

            }

            // Try to get total count from table 1
            if (result.Tables.Count > 1 && result.Tables[1].Rows.Count > 0)
            {
                totalRecords = Convert.ToInt32(result.Tables[1].Rows[0]["TotalRecords"]);
            }
            else
            {
                // Fallback: use row count of table 0
                totalRecords = result.Tables[0].Rows.Count;
            }
        }

        return new
        {
            draw = draw,
            recordsTotal = totalRecords,
            recordsFiltered = totalRecords,
            data = dataList
        };
    }

    protected void GridViewCenters_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditRow")
        {
            int ID = Convert.ToInt32(e.CommandArgument);

            string query = "SELECT * FROM Center WHERE ID = @ID";
            DataTable dataTable = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", ID);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dataTable);
            }

            if (dataTable.Rows.Count > 0)
            {
                DataRow row = dataTable.Rows[0];

                hfID.Value = row["ID"].ToString();
                txtID.Text = row["ID"].ToString();
                txtName.Text = row["Name"].ToString();
                ddlRateTypeID.SelectedValue = row["RateTypeID"].ToString(); // Set the selected RateTypeID
                ddlType.SelectedValue = row["Type"].ToString();
                chkIsLab.Checked = Convert.ToBoolean(row["IsLab"]);
                chkStatus.Checked = Convert.ToBoolean(row["Status"]);
                txtDescription.Text = row["Description"].ToString();
                txtAddress.Text = row["Address"].ToString();
                ddlCountry.SelectedValue = row["Country"].ToString();
                ddlCity.SelectedValue = row["City"].ToString();
                txtPhone.Text = row["Phone"].ToString();
                txtEmail.Text = row["Email"].ToString();

                // Change Button Text to "Update"
                btnSaveCenter.Text = "Update Center";
            }
        }
    }
    private void ClearCenterFields()
    {
        txtID.Text = string.Empty;
        txtName.Text = string.Empty;
        ddlRateTypeID.SelectedIndex = 0;
        ddlType.SelectedIndex = 0;
        chkIsLab.Checked = false;
        chkStatus.Checked = false;
        txtDescription.Text = string.Empty;
        txtAddress.Text = string.Empty;
        ddlCountry.SelectedIndex = 0;
        ddlCity.SelectedIndex = 0;
        txtPhone.Text = string.Empty;
        txtEmail.Text = string.Empty;
    }
    protected void btnEditTest_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        string id = btn.CommandArgument;

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();

            // Load Test main data
            string query = @"SELECT * FROM Test WHERE ID = @ID";
            DataTable testTable = new DataTable();

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@ID", id);
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(testTable);
            }

            if (testTable.Rows.Count > 0)
            {
                DataRow row = testTable.Rows[0];

                // Populate main test fields
                txtTestID.Text = row["ID"].ToString();
                txtCode.Text = row["Code"].ToString();
                txtName.Text = row["Name"].ToString();
                txtSynonyms.Text = row["Synonyms"].ToString();
                txtReportName.Text = row["ReportName"].ToString();
                txtHeading.Text = row["TestHeading"].ToString();
                txtReportGroup.Text = row["ReportGroup"].ToString();
                txtSpecimenReqQty.Text = row["SpecimenReqQuantity"].ToString();
                txtSortOrder.Text = row["SortOrder"].ToString();
                txtRate.Text = row["Rate"].ToString();
                txtTemplateID.Text = row["TemplateID"].ToString();

                // Set dropdowns
                ddlGroup.SelectedValue = row["GroupID"].ToString() ?? "0";
                ddlTestDays.SelectedValue = row["TestDays"].ToString() ?? "0";
                ddlReportingDays.SelectedValue = row["ReportDays"].ToString() ?? "0";
                ddlSpecimen.SelectedValue = row["SpecimenID"].ToString() ?? "0";
                ddlType.SelectedValue = row["Type"].ToString() ?? "0";
                ddlTestTypeSettings.SelectedValue = row["TestType"].ToString() ?? "0";

                // Checkboxes
                chkIsSpecial.Checked = Convert.ToBoolean(row["IsSpecial"]);
                chkStatus.Checked = Convert.ToBoolean(row["Status"]);

                // Display tabs based on Type
                string type = row["Type"].ToString();
                if (type == "0") // Normal
                {
                    lnkSettings.Style["display"] = "";
                    lnkParameters.Style["display"] = "none";
                    lnkProfile.Style["display"] = "none";
                }
                else if (type == "1") // Parameterized
                {
                    lnkParameters.Style["display"] = "";
                    lnkSettings.Style["display"] = "none";
                    lnkProfile.Style["display"] = "none";
                }
                else if (type == "2") // Profile
                {
                    lnkProfile.Style["display"] = "";
                    lnkParameters.Style["display"] = "none";
                    lnkSettings.Style["display"] = "none";
                }

                int testId = Convert.ToInt32(row["ID"]);
                int templateId = Convert.ToInt32(row["TemplateID"]);

                // Load related data based on Template or Type
                if (templateId == 3) // Cutoff template
                {
                    BindGrid(testId, templateId);
                }
                else if (type == "1") // Parameterized test
                {
                    LoadTestParameters(testId);
                }
                else if (type == "2") // Profile test
                {
                    LoadProfileTests(testId);
                }

                // Load Normal Values (if exist)
                string normalValuesQuery = @"SELECT TOP 1 * FROM TestNormalValues WHERE TestID = @TestID";
                DataTable normalValuesTable = new DataTable();

                using (SqlCommand normalValuesCmd = new SqlCommand(normalValuesQuery, connection))
                {
                    normalValuesCmd.Parameters.AddWithValue("@TestID", id);
                    SqlDataAdapter normalValuesAdapter = new SqlDataAdapter(normalValuesCmd);
                    normalValuesAdapter.Fill(normalValuesTable);
                }

                if (normalValuesTable.Rows.Count > 0)
                {
                    DataRow normalValuesRow = normalValuesTable.Rows[0];
                    ddlGender.SelectedValue = normalValuesRow["Gender"].ToString();
                    txtFromAge.Text = normalValuesRow["FromAge"].ToString();
                    txtToAge.Text = normalValuesRow["ToAge"].ToString();
                    txtFromValue.Text = normalValuesRow["FromValue"].ToString();
                    txtToValue.Text = normalValuesRow["ToValue"].ToString();
                    txtRemarks.Text = normalValuesRow["Remarks"].ToString();
                }
            }

            connection.Close();
        }
    }

    private void LoadTestParameters(int testId)
    {
        string query = @"SELECT * FROM TestParameter WHERE TestID = @TestID ORDER BY SortOrder";
        DataTable dt = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@TestID", testId);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dt);
        }

        GridViewParameter.DataSource = dt;
        GridViewParameter.DataBind();
    }

    private void LoadProfileTests(int profileId)
    {
        string query = @"SELECT t.*, tp.SortOrder 
                   FROM Test t
                   INNER JOIN TestProfile tp ON t.ID = tp.TestID
                   WHERE tp.ProfileID = @ProfileID
                   ORDER BY tp.SortOrder";
        DataTable dt = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@ProfileID", profileId);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dt);
        }

        gvProfileTest.DataSource = dt;
        gvProfileTest.DataBind();
    }

    private DataTable GetTestNormalValues(int? TestID, int? TemplateID)
    {
        string query = "";
        DataTable dataTable = new DataTable();

        if (!string.IsNullOrWhiteSpace(TestID.ToString()))
        {
            if (TemplateID == 3)
            {
                query = @"Select * from [TestCutoffValues] where TestCode =  " + TestID + "";
            }
            else
            {
                query = @"SELECT * FROM [TestNormalValues] where TestID = " + TestID + " ORDER BY CreatedDate DESC";
            }



            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dataTable);
            }
        }
        return dataTable;
    }
    private void BindGrid(int? TestID, int? TemplateID)
    {
        //if (ViewState["NormalValues"] == null)
        ViewState["NormalValues"] = GetTestNormalValues(TestID, TemplateID);
        if (TemplateID == 3)
        {
            gvCuttOffValues.DataSource = ViewState["NormalValues"] as DataTable;
            gvCuttOffValues.DataBind();
        }
        else
        {
            gvNormalValues.DataSource = ViewState["NormalValues"] as DataTable;
            gvNormalValues.DataBind();
        }
        Settings.Attributes["class"] = "tab-pane active";
        lnkSettings.Attributes["class"] = "nav-link active";
        LinkDetails.Attributes["class"] = "nav-link in-active text-dark font-weight-bold";

    }
    protected void gvNormalValues_RowEditing(object sender, GridViewEditEventArgs e)
    {

        gvNormalValues.EditIndex = e.NewEditIndex;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));
    }
    protected void gvNormalValues_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvNormalValues.EditIndex = -1;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));
    }
    protected void gvNormalValues_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        // Retrieve data from ViewState
        DataTable dt = ViewState["NormalValues"] as DataTable;

        // Find controls and update values
        GridViewRow row = gvNormalValues.Rows[e.RowIndex];
        dt.Rows[e.RowIndex]["Gender"] = (row.FindControl("txtGender") as TextBox).Text;
        dt.Rows[e.RowIndex]["FromAge"] = (row.FindControl("txtFromAge") as TextBox).Text;
        dt.Rows[e.RowIndex]["ToAge"] = (row.FindControl("txtToAge") as TextBox).Text;
        dt.Rows[e.RowIndex]["FromValue"] = (row.FindControl("txtFromValue") as TextBox).Text;
        dt.Rows[e.RowIndex]["ToValue"] = (row.FindControl("txtToValue") as TextBox).Text;
        dt.Rows[e.RowIndex]["Remarks"] = (row.FindControl("txtRemarks") as TextBox).Text;
        dt.Rows[e.RowIndex]["Status"] = (row.FindControl("txtStatus") as TextBox).Text;

        // Update the database with the new values
        UpdateDatabase(dt.Rows[e.RowIndex]);

        // Reset Edit Mode and bind the GridView
        gvNormalValues.EditIndex = -1;
        ViewState["NormalValues"] = dt;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));
    }
    protected void gvNormalValues2_RowEditing(object sender, GridViewEditEventArgs e)
    {

        gvNormalValues2.EditIndex = e.NewEditIndex;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));
    }
    protected void gvNormalValues2_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvNormalValues2.EditIndex = -1;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));
    }
    protected void gvNormalValues2_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        // Retrieve data from ViewState
        DataTable dt = ViewState["NormalValues"] as DataTable;

        // Find controls and update values
        GridViewRow row = gvNormalValues.Rows[e.RowIndex];
        dt.Rows[e.RowIndex]["Gender"] = (row.FindControl("txtGender") as TextBox).Text;
        dt.Rows[e.RowIndex]["FromAge"] = (row.FindControl("txtFromAge") as TextBox).Text;
        dt.Rows[e.RowIndex]["ToAge"] = (row.FindControl("txtToAge") as TextBox).Text;
        dt.Rows[e.RowIndex]["FromValue"] = (row.FindControl("txtFromValue") as TextBox).Text;
        dt.Rows[e.RowIndex]["ToValue"] = (row.FindControl("txtToValue") as TextBox).Text;
        dt.Rows[e.RowIndex]["Remarks"] = (row.FindControl("txtRemarks") as TextBox).Text;
        dt.Rows[e.RowIndex]["Status"] = (row.FindControl("txtStatus") as TextBox).Text;

        // Update the database with the new values
        UpdateDatabase(dt.Rows[e.RowIndex]);

        // Reset Edit Mode and bind the GridView
        gvNormalValues.EditIndex = -1;
        ViewState["NormalValues"] = dt;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));
    }
    private void UpdateDatabase(DataRow updatedRow)
    {
        // Assuming you have a method to execute SQL queries or stored procedures.
        // Retrieve the values from the updated row
        int ID = Convert.ToInt32(updatedRow["ID"]);
        int TestID = Convert.ToInt32(updatedRow["TestID"]);
        int Gender = Convert.ToInt32(updatedRow["Gender"]);
        int? FromAge = string.IsNullOrEmpty(updatedRow["FromAge"].ToString()) ? (int?)null : Convert.ToInt32(updatedRow["FromAge"]);
        int? ToAge = string.IsNullOrEmpty(updatedRow["ToAge"].ToString()) ? (int?)null : Convert.ToInt32(updatedRow["ToAge"]);
        decimal? FromValue = string.IsNullOrEmpty(updatedRow["FromValue"].ToString()) ? (decimal?)null : Convert.ToDecimal(updatedRow["FromValue"]);
        decimal? ToValue = string.IsNullOrEmpty(updatedRow["ToValue"].ToString()) ? (decimal?)null : Convert.ToDecimal(updatedRow["ToValue"]);
        string TextValue = updatedRow["TextValue"].ToString();
        string Remarks = updatedRow["Remarks"].ToString();
        bool Status = Convert.ToBoolean(updatedRow["Status"]);

        // Database connection and update logic
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("UPDATE TestNormalValues SET TestID = @TestID, Gender = @Gender, FromAge = @FromAge, ToAge = @ToAge, FromValue = @FromValue, ToValue = @ToValue, TextValue = @TextValue, Remarks = @Remarks, Status = @Status WHERE ID = @ID", conn))
            {
                cmd.Parameters.AddWithValue("@TestID", TestID);
                cmd.Parameters.AddWithValue("@Gender", Gender);
                cmd.Parameters.AddWithValue("@FromAge", (object)FromAge ?? DBNull.Value); // Allow nullable
                cmd.Parameters.AddWithValue("@ToAge", (object)ToAge ?? DBNull.Value);     // Allow nullable
                cmd.Parameters.AddWithValue("@FromValue", (object)FromValue ?? DBNull.Value); // Allow nullable
                cmd.Parameters.AddWithValue("@ToValue", (object)ToValue ?? DBNull.Value);     // Allow nullable
                cmd.Parameters.AddWithValue("@TextValue", TextValue);
                cmd.Parameters.AddWithValue("@Remarks", Remarks);
                cmd.Parameters.AddWithValue("@Status", Status);
                cmd.Parameters.AddWithValue("@ID", ID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
    private void UpdateCuttOffValues(DataRow updatedRow)
    {
        // Assuming you have a method to execute SQL queries or stored procedures.
        // Retrieve the values from the updated row
        int TestCode = Convert.ToInt32(updatedRow["TestCode"]);
        string Parameter = updatedRow["Parameter"].ToString();
        decimal CutoffValue = Convert.ToDecimal(updatedRow["CutoffValue"]);
        string Remarks = updatedRow["Remarks"].ToString();


        // Database connection and update logic
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("UPDATE [TestCutoffValues] SET TestCode = @TestCode, Parameter = @Parameter, CutoffValue = @CutoffValue, Remarks = @Remarks where TestCode=@TestCode", conn))
            {
                cmd.Parameters.AddWithValue("@TestCode", TestCode);
                cmd.Parameters.AddWithValue("@Parameter", Parameter);
                cmd.Parameters.AddWithValue("@CutoffValue", CutoffValue); // Allow nullable
                cmd.Parameters.AddWithValue("@Remarks", (object)Remarks ?? DBNull.Value);     // Allow nullable

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
    protected void btnSaveSettings_Click(object sender, EventArgs e)
    {

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string searchTerm = txtSearch.Text.Trim().ToLower();

        // Replace this with your actual data source retrieval logic.
        DataTable dataTable = LoadTestData();

        if (!string.IsNullOrEmpty(searchTerm))
        {
            var filteredRows = dataTable.AsEnumerable()
                .Where(row => row.Field<string>("Code").ToLower().Contains(searchTerm) ||
                              row.Field<string>("Name").ToLower().Contains(searchTerm));
            if (filteredRows.Any())
            {
                GridView1.DataSource = filteredRows.CopyToDataTable();
            }
            else
            {
                GridView1.DataSource = null;
            }
        }
        else
        {
            GridView1.DataSource = dataTable;
        }

        GridView1.DataBind();
    }
    protected void txtSearch_TextChanged(object sender, EventArgs e)
    {
        string searchTerm = txtSearch.Text.Trim().ToLower();

        // Replace this with your actual data source retrieval logic.
        DataTable dataTable = LoadTestData();

        if (!string.IsNullOrEmpty(searchTerm))
        {
            var filteredRows = dataTable.AsEnumerable()
                .Where(row => row.Field<string>("Code").ToLower().Contains(searchTerm) ||
                              row.Field<string>("Name").ToLower().Contains(searchTerm));
            if (filteredRows.Any())
            {
                GridView1.DataSource = filteredRows.CopyToDataTable();
            }
            else
            {
                GridView1.DataSource = null;
            }
        }
        else
        {
            GridView1.DataSource = dataTable;
        }

        GridView1.DataBind();
    }
    protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Get the selected value from the dropdown
        string selectedValue = ddlType.SelectedValue;


        if (selectedValue == "0")
        {
            // Make the Settings anchor link visible
            lnkSettings.Style["display"] = "";
            lnkParameters.Style["display"] = "none";
            lnkProfile.Style["display"] = "none";
        }
        else if (selectedValue == "1")
        {
            // Make the Settings anchor link visible
            lnkParameters.Style["display"] = "";
            lnkSettings.Style["display"] = "none";
            lnkProfile.Style["display"] = "none";
        }
        else if (selectedValue == "2")
        {
            // Make the Settings anchor link visible
            lnkProfile.Style["display"] = "";
            lnkParameters.Style["display"] = "none";
            lnkSettings.Style["display"] = "none";
        }
        else
        {
            lnkProfile.Style["display"] = "none";
            lnkParameters.Style["display"] = "none";
            lnkSettings.Style["display"] = "none";
        }

    }
    protected void lnkSettingss_Click(object sender, EventArgs e)
    {
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));

    }
    protected void gvCuttOffValues_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvCuttOffValues.EditIndex = e.NewEditIndex;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));
    }
    protected void gvCuttOffValues_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvCuttOffValues.EditIndex = -1;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));
    }
    protected void gvCuttOffValues_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        DataTable dt = ViewState["NormalValues"] as DataTable;

        // Find controls and update values
        GridViewRow row = gvCuttOffValues.Rows[e.RowIndex];
        dt.Rows[e.RowIndex]["TestCode"] = (row.FindControl("txtTestCode") as TextBox).Text;
        dt.Rows[e.RowIndex]["Parameter"] = (row.FindControl("txtParameter") as TextBox).Text;
        dt.Rows[e.RowIndex]["CutoffValue"] = (row.FindControl("txtCutoffValue") as TextBox).Text;
        dt.Rows[e.RowIndex]["Remarks"] = (row.FindControl("txtRemarks") as TextBox).Text;


        // Update the database with the new values
        UpdateCuttOffValues(dt.Rows[e.RowIndex]);

        // Reset Edit Mode and bind the GridView
        gvNormalValues.EditIndex = -1;
        ViewState["NormalValues"] = dt;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        // Rebind the GridView
        BindGrid(TestID, string.IsNullOrWhiteSpace(txtTemplateID.Text) ? (int?)null : Convert.ToInt32(txtTemplateID.Text));
    }
    protected void btnSaveParameter_Click(object sender, EventArgs e)
    {
        string Name = txtParameterName.Text;
        string ReportName = txtParameterReportName.Text;
        string TemplateID = ddlParameterTemplates.SelectedValue;
        string SortOrder = txtParameterSortOrder.Text;
        string Format = txtParameterSortOrder.Text;
        string Unit = txtParameterUnit.Text;


        try
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                    INSERT INTO [TestParameter] (
                       [TestID]
                      ,[Name]
                      ,[ReportName]
                      ,[Unit]
                      ,[TemplateID]
                      ,[SortOrder]
                      ,[Format]
                      ,[CreatedDate]
                    ) 
                    VALUES (
                        @TestID, @Name, @ReportName, @Unit, @TemplateID,  
                        @SortOrder, @Format, @CreatedDate
                    )";


                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@TestID", txtTestID.Text ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@Name", Name ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@ReportName", ReportName ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@Unit", Unit ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@TemplateID", TemplateID ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@SortOrder", SortOrder);
                    command.Parameters.AddWithValue("@Format", Format ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@CreatedDate", DateTime.Now);


                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();

                }
            }

        }
        catch (Exception ex)
        {
            Console.WriteLine("Error:" + ex.Message);
        }
    }
    protected void linkParameters_Click(object sender, EventArgs e)
    {
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        string Parameter_query = @"SELECT ID, TestID, Name, ReportName, Unit, TemplateID, SortOrder, Format, CreatedDate 
                             FROM TestParameter where TestID = @TestID  ORDER BY CreatedDate DESC";

        DataTable Parameter_dt = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(Parameter_query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(Parameter_dt);
        }

        // Add a calculated column for Age/Sex
        //dataTable.Columns.Add("AgeSex", typeof(string));
        //foreach (DataRow row in dataTable.Rows)
        //{
        //    row["AgeSex"] = row["Age"] + " Yr(s)/ " + row["GenderID"];
        //}

        // Bind data to GridView
        GridViewParameter.DataSource = Parameter_dt;
        GridViewParameter.DataBind();
        // Rebind the GridView
        // Define the JavaScript to switch to the 'Parameters' tab
        string script = "$('.nav-tabs a[href=\"#Parameters\"]').tab('show');";

        // Register the script to execute on the client-side
        ScriptManager.RegisterStartupScript(this, this.GetType(), "SetActiveTab", script, true);
        Parameters.Attributes["class"] = "tab-pane active";
        Parameters.Attributes["id"] = "nav-link active text-dark font-weight-bold";
        linkParameters.Attributes["class"] = "nav-link active text-dark font-weight-bold";
        LinkDetails.Attributes["class"] = "nav-link in-active text-dark font-weight-bold";
        Detail.Attributes["class"] = "tab-pane in-active text-dark font-weight-bold";
    }
    protected void LinkProfile_Click(object sender, EventArgs e)
    {
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        string TestDDL_Query = "";
        if (TestID != null && TestID != 0)
        {
            TestDDL_Query = @"SELECT ID, Name FROM [Test] where ID = @TestID";
        }
        else
        {
            TestDDL_Query = @"SELECT ID, Name FROM [Test]";
        }


        DataTable TestDDL_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestDDL_Query, conn);
            if (TestID != null && TestID != 0)
            {
                cmd.Parameters.AddWithValue("@TestID", TestID);
            }
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestDDL_DT);
        }
        ddlTest.Items.Clear();

        // Add a default "Select" option (optional)
        ddlTest.Items.Add(new ListItem("--Select Test--", ""));

        // Populate the dropdown
        foreach (DataRow row in TestDDL_DT.Rows)
        {
            string testName = row["Name"].ToString();
            string testId = row["ID"].ToString();
            ListItem item = new ListItem(testName, testId);
            ddlTest.Items.Add(item);
            item.Selected = true;
        }
        string TestProfile_Query = "";
        if (TestID != null && TestID != 0)
        {
            TestProfile_Query = @"SELECT [ProfileID] FROM [TestProfile] where TestID = @TestID";
        }
        else
        {
            TestProfile_Query = @"SELECT [ProfileID] FROM [TestProfile]";
        }
        DataTable TestProfile_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestProfile_Query, conn);
            if (TestID != null && TestID != 0)
            {
                cmd.Parameters.AddWithValue("@TestID", TestID);
            }
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestProfile_DT);
        }
        string ProfileTestIDs_Query = "";
        if (TestID != null && TestID != 0)
        {
            ProfileTestIDs_Query = @"SELECT [ProfileID], TestID, [SortOrder] FROM [TestProfile] WHERE ProfileID = @TestID";
        }
        else
        {
            ProfileTestIDs_Query = @"SELECT [ProfileID], TestID, [SortOrder] FROM [TestProfile]";

        }
        DataTable ProfileTestIDs_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(ProfileTestIDs_Query, conn);
            if (TestID != null && TestID != 0)
            {
                cmd.Parameters.AddWithValue("@TestID", TestID);
            }
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(ProfileTestIDs_DT);
        }

        // Store TestID along with SortOrder
        Dictionary<string, string> testIdWithSortOrder = new Dictionary<string, string>();
        foreach (DataRow row in ProfileTestIDs_DT.Rows)
        {
            string testId = row["TestID"].ToString();
            string sortOrder = row["SortOrder"].ToString();

            if (!testIdWithSortOrder.ContainsKey(testId))
            {
                testIdWithSortOrder.Add(testId, sortOrder);
            }
        }

        // If there are TestIDs, fetch all test details in one query
        DataTable Test_DT = new DataTable();
        if (testIdWithSortOrder.Count > 0)
        {
            string testIdsJoined = string.Join(",", testIdWithSortOrder.Keys.Select(id => "'" + id + "'"));

            string test_Query = @"SELECT * FROM [Test] WHERE ID IN (" + testIdsJoined + ")";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(test_Query, conn);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(Test_DT);
            }

            // Add SortOrder column to Test_DT if not exists
            if (!Test_DT.Columns.Contains("SortOrder"))
            {
                Test_DT.Columns.Add("SortOrder", typeof(string));
            }

            // Populate SortOrder in Test_DT based on TestID
            foreach (DataRow row in Test_DT.Rows)
            {
                string testId = row["ID"].ToString();
                if (testIdWithSortOrder.ContainsKey(testId))
                {
                    row["SortOrder"] = testIdWithSortOrder[testId];
                }
            }
        }

        // Bind DataTable to GridView
        gvProfileTest.DataSource = Test_DT;
        gvProfileTest.DataBind();

        // Now, Test_DT contains all relevant test details

        // Clear existing items (if any) to avoid duplication

        Profiles.Attributes["class"] = "tab-pane active";
        Parameters.Attributes["class"] = "tab-pane in-active";
        linkParameters.Attributes["class"] = "nav-link in-active text-dark font-weight-bold";
        LinkDetails.Attributes["class"] = "nav-link in-active text-dark font-weight-bold";
        Detail.Attributes["class"] = "tab-pane in-active text-dark font-weight-bold";
    }
    protected void gvProfileTest_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        string TestDDL_Query = @"SELECT ID, Name FROM [Test] where ID = @TestID";

        DataTable TestDDL_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestDDL_Query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestDDL_DT);
        }
        ddlTest.Items.Clear();

        // Add a default "Select" option (optional)
        ddlTest.Items.Add(new ListItem("--Select Test--", ""));

        // Populate the dropdown
        foreach (DataRow row in TestDDL_DT.Rows)
        {
            string testName = row["Name"].ToString();
            string testId = row["ID"].ToString();
            ListItem item = new ListItem(testName, testId);
            ddlTest.Items.Add(item);
            item.Selected = true;
        }
        string TestProfile_Query = @"SELECT [ProfileID] FROM [TestProfile] where TestID = @TestID";

        DataTable TestProfile_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestProfile_Query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestProfile_DT);
        }
        string ProfileTestIDs_Query = @"SELECT [ProfileID], TestID, [SortOrder] FROM [TestProfile] WHERE TestID = @TestID";

        DataTable ProfileTestIDs_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(ProfileTestIDs_Query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(ProfileTestIDs_DT);
        }

        // Store TestID along with SortOrder
        Dictionary<string, string> testIdWithSortOrder = new Dictionary<string, string>();
        foreach (DataRow row in ProfileTestIDs_DT.Rows)
        {
            string testId = row["TestID"].ToString();
            string sortOrder = row["SortOrder"].ToString();

            if (!testIdWithSortOrder.ContainsKey(testId))
            {
                testIdWithSortOrder.Add(testId, sortOrder);
            }
        }

        // If there are TestIDs, fetch all test details in one query
        DataTable Test_DT = new DataTable();
        if (testIdWithSortOrder.Count > 0)
        {
            string testIdsJoined = string.Join(",", testIdWithSortOrder.Keys.Select(id => "'" + id + "'"));

            string test_Query = @"SELECT * FROM [Test] WHERE ID IN (" + testIdsJoined + ")";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(test_Query, conn);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(Test_DT);
            }

            // Add SortOrder column to Test_DT if not exists
            if (!Test_DT.Columns.Contains("SortOrder"))
            {
                Test_DT.Columns.Add("SortOrder", typeof(string));
            }

            // Populate SortOrder in Test_DT based on TestID
            foreach (DataRow row in Test_DT.Rows)
            {
                string testId = row["ID"].ToString();
                if (testIdWithSortOrder.ContainsKey(testId))
                {
                    row["SortOrder"] = testIdWithSortOrder[testId];
                }
            }
        }

        // Bind DataTable to GridView
        gvProfileTest.DataSource = Test_DT;
        gvProfileTest.DataBind();
    }

    protected void gvProfileTest_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvProfileTest.EditIndex = -1;
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        string TestDDL_Query = @"SELECT ID, Name FROM [Test] where ID = @TestID";

        DataTable TestDDL_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestDDL_Query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestDDL_DT);
        }
        ddlTest.Items.Clear();

        // Add a default "Select" option (optional)
        ddlTest.Items.Add(new ListItem("--Select Test--", ""));

        // Populate the dropdown
        foreach (DataRow row in TestDDL_DT.Rows)
        {
            string testName = row["Name"].ToString();
            string testId = row["ID"].ToString();
            ListItem item = new ListItem(testName, testId);
            ddlTest.Items.Add(item);
            item.Selected = true;
        }
        string TestProfile_Query = @"SELECT [ProfileID] FROM [TestProfile] where TestID = @TestID";

        DataTable TestProfile_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestProfile_Query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestProfile_DT);
        }
        string ProfileTestIDs_Query = @"SELECT [ProfileID], TestID, [SortOrder] FROM [TestProfile] WHERE TestID = @TestID";

        DataTable ProfileTestIDs_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(ProfileTestIDs_Query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(ProfileTestIDs_DT);
        }

        // Store TestID along with SortOrder
        Dictionary<string, string> testIdWithSortOrder = new Dictionary<string, string>();
        foreach (DataRow row in ProfileTestIDs_DT.Rows)
        {
            string testId = row["TestID"].ToString();
            string sortOrder = row["SortOrder"].ToString();

            if (!testIdWithSortOrder.ContainsKey(testId))
            {
                testIdWithSortOrder.Add(testId, sortOrder);
            }
        }

        // If there are TestIDs, fetch all test details in one query
        DataTable Test_DT = new DataTable();
        if (testIdWithSortOrder.Count > 0)
        {
            string testIdsJoined = string.Join(",", testIdWithSortOrder.Keys.Select(id => "'" + id + "'"));

            string test_Query = @"SELECT * FROM [Test] WHERE ID IN (" + testIdsJoined + ")";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(test_Query, conn);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(Test_DT);
            }

            // Add SortOrder column to Test_DT if not exists
            if (!Test_DT.Columns.Contains("SortOrder"))
            {
                Test_DT.Columns.Add("SortOrder", typeof(string));
            }

            // Populate SortOrder in Test_DT based on TestID
            foreach (DataRow row in Test_DT.Rows)
            {
                string testId = row["ID"].ToString();
                if (testIdWithSortOrder.ContainsKey(testId))
                {
                    row["SortOrder"] = testIdWithSortOrder[testId];
                }
            }
        }

        // Bind DataTable to GridView
        gvProfileTest.DataSource = Test_DT;
        gvProfileTest.DataBind();
    }
    protected void gvProfileTest_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int testID = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

        TextBox txtTestName = (TextBox)GridView1.Rows[e.RowIndex].Cells[1].Controls[0];
        TextBox txtDescription = (TextBox)GridView1.Rows[e.RowIndex].Cells[2].Controls[0];
        TextBox txtPrice = (TextBox)GridView1.Rows[e.RowIndex].Cells[3].Controls[0];

        string updateQuery = "UPDATE [Test] SET Name = @Name, Code = @Code, SortOrder = @SortOrder WHERE ID = @TestID";

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(updateQuery, conn);
            cmd.Parameters.AddWithValue("@Name", txtName.Text);
            cmd.Parameters.AddWithValue("@Code", txtCode.Text);
            cmd.Parameters.AddWithValue("@SortOrder", txtSortOrder.Text);
            cmd.Parameters.AddWithValue("@TestID", testID);

            conn.Open();
            cmd.ExecuteNonQuery();
        }

        gvProfileTest.EditIndex = -1; // Exit edit mode
        int? TestID = string.IsNullOrEmpty(txtTestID.Text) ? (int?)null : Convert.ToInt32(txtTestID.Text);
        int? TestCode = string.IsNullOrWhiteSpace(txtCode.Text) ? (int?)null : Convert.ToInt32(txtCode.Text);
        if (txtTemplateID.Text == "3")
        {
            TestID = TestCode;
        }
        string TestDDL_Query = @"SELECT ID, Name FROM [Test] where ID = @TestID";

        DataTable TestDDL_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestDDL_Query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestDDL_DT);
        }
        ddlTest.Items.Clear();

        // Add a default "Select" option (optional)
        ddlTest.Items.Add(new ListItem("--Select Test--", ""));

        // Populate the dropdown
        foreach (DataRow row in TestDDL_DT.Rows)
        {
            string testName = row["Name"].ToString();
            string testId = row["ID"].ToString();
            ListItem item = new ListItem(testName, testId);
            ddlTest.Items.Add(item);
            item.Selected = true;
        }
        string TestProfile_Query = @"SELECT [ProfileID] FROM [TestProfile] where TestID = @TestID";

        DataTable TestProfile_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(TestProfile_Query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(TestProfile_DT);
        }
        string ProfileTestIDs_Query = @"SELECT [ProfileID], TestID, [SortOrder] FROM [TestProfile] WHERE TestID = @TestID";

        DataTable ProfileTestIDs_DT = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(ProfileTestIDs_Query, conn);
            cmd.Parameters.AddWithValue("@TestID", TestID);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(ProfileTestIDs_DT);
        }

        // Store TestID along with SortOrder
        Dictionary<string, string> testIdWithSortOrder = new Dictionary<string, string>();
        foreach (DataRow row in ProfileTestIDs_DT.Rows)
        {
            string testId = row["TestID"].ToString();
            string sortOrder = row["SortOrder"].ToString();

            if (!testIdWithSortOrder.ContainsKey(testId))
            {
                testIdWithSortOrder.Add(testId, sortOrder);
            }
        }

        // If there are TestIDs, fetch all test details in one query
        DataTable Test_DT = new DataTable();
        if (testIdWithSortOrder.Count > 0)
        {
            string testIdsJoined = string.Join(",", testIdWithSortOrder.Keys.Select(id => "'" + id + "'"));

            string test_Query = @"SELECT Name FROM [TestParameter] WHERE TestID IN (" + testIdsJoined + ")";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(test_Query, conn);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(Test_DT);
            }

            // Add SortOrder column to Test_DT if not exists
            if (!Test_DT.Columns.Contains("SortOrder"))
            {
                Test_DT.Columns.Add("SortOrder", typeof(string));
            }

            // Populate SortOrder in Test_DT based on TestID
            foreach (DataRow row in Test_DT.Rows)
            {
                string testId = row["ID"].ToString();
                if (testIdWithSortOrder.ContainsKey(testId))
                {
                    row["SortOrder"] = testIdWithSortOrder[testId];
                }
            }
        }

        // Bind DataTable to GridView
        gvProfileTest.DataSource = Test_DT;
        gvProfileTest.DataBind();
    }
    protected void LinkDetails_Click(object sender, EventArgs e)
    {
        Profiles.Attributes["class"] = "tab-pane in-active";
        LinkProfile.Attributes["class"] = "nav-link in-active text-dark font-weight-bold";

        Parameters.Attributes["class"] = "tab-pane in-active";
        linkParameters.Attributes["class"] = "nav-link in-active text-dark font-weight-bold";

        LinkDetails.Attributes["class"] = "nav-link active text-dark font-weight-bold";
        Detail.Attributes["class"] = "tab-pane active text-dark font-weight-bold";
    }
    protected void btnSaveProfie_Click(object sender, EventArgs e)
    {
        List<string> value = Session["SelectedItems"] as List<string>;
        if (value != null)
        {
            for (int i = 0; i < value.Count; i++)
            {
                Console.WriteLine("Index: " + i + ", Value: " + value[i] + "");
                SaveProfieInDataBase(i, value[i]);
            }
        }

    }
    public void SaveProfieInDataBase(int SortOrder, string TestID)
    {
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            string query = @"
                    INSERT INTO [TestProfile] (
                          [TestID]
                         ,[SortOrder]
                    ) 
                    VALUES (
                        @TestID, @SortOrder
                    )";


            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@TestID", TestID);
                command.Parameters.AddWithValue("@SortOrder", SortOrder);
                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();

            }
        }
    }
    public static string QuickCleanRtf(string rtf)
    {
        if (string.IsNullOrEmpty(rtf))
            return string.Empty;

        string plain = rtf;

        // Remove common RTF formatting tags
        plain = System.Text.RegularExpressions.Regex.Replace(plain, @"\\[a-z]+\d*", "");
        plain = System.Text.RegularExpressions.Regex.Replace(plain, @"\{\\.*?\}", "");
        plain = plain.Replace("{", "").Replace("}", "");
        plain = plain.Replace("\r\n", " ");
        plain = plain.Replace(@"\par", ", ");

        return plain.Trim();
    }

    protected void ddlTest_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<string> value = Session["SelectedItems"] as List<string>;
    }
    protected void ddlTest_TextChanged(object sender, EventArgs e)
    {
        // Retrieve selection order from Session
        List<string> selectedOrder = Session["SelectedItems"] as List<string> ?? new List<string>();

        // Get currently selected values from ListBox
        List<string> currentSelection = ddlTest.Items.Cast<ListItem>()
                                           .Where(i => i.Selected)
                                           .Select(i => i.Value)
                                           .ToList();

        // Maintain order by adding new selections at the end
        foreach (string selectedValue in currentSelection)
        {
            if (!selectedOrder.Contains(selectedValue))
            {
                selectedOrder.Add(selectedValue);
            }
        }

        // Remove unselected values
        selectedOrder = selectedOrder.Where(value => currentSelection.Contains(value)).ToList();

        // Store updated selection order in Session
        Session["SelectedItems"] = selectedOrder;

        // Assign Sort Order and Display Output
        int sortOrder = 1;
        foreach (var id in selectedOrder)
        {
            sortOrder++;
        }
    }

   

    protected void gvCustomRateType_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvCustomRateType.PageIndex = e.NewPageIndex;
        BindCustonRateTypeGrid();
    }

    protected void gvCustomRateType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        // You can handle custom command names here if needed
    }

    protected void gvCustomRateType_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvCustomRateType.EditIndex = e.NewEditIndex;
        BindCustonRateTypeGrid();
    }

    protected void gvCustomRateType_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvCustomRateType.EditIndex = -1;
        BindCustonRateTypeGrid();
    }

    protected void gvCustomRateType_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridViewRow row = gvCustomRateType.Rows[e.RowIndex];
        int id = Convert.ToInt32(gvCustomRateType.DataKeys[e.RowIndex].Value);

        string discount = ((TextBox)row.FindControl("txtDiscount")).Text.Trim();
        string discountR4 = ((TextBox)row.FindControl("txtDiscountR4")).Text.Trim();

        modMain.UpdateDiscounts(id, Convert.ToDecimal(discount), Convert.ToDecimal(discountR4));

        gvCustomRateType.EditIndex = -1;
        BindCustonRateTypeGrid();
    }
    private void BindCustonRateTypeGrid()
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("usp_GetCustomRateTypes", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvCustomRateType.DataSource = dt;
                    gvCustomRateType.DataBind();
                }
            }
        }
    }
}