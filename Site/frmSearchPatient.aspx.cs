using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Text;
using System.Collections.Generic;
using System.Web.UI;
using System.Linq;

public partial class Site_frmSearchPatient : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if the user is logged in
        if (Session["Username"] == null)
        {
            Response.Redirect("~/frmLoginNew.aspx", false); // Use ~ for root-relative path
            Context.ApplicationInstance.CompleteRequest();  // Avoids ThreadAbortException
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

        if (!IsPostBack)
        {
            LoadPatientData();
            LoadCenters();
        }
    }
    string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    private void LoadCenters()
    {
        string query = "SELECT ID, Name FROM [Center] ORDER BY ID";

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            rptCenters.DataSource = dt;
            rptCenters.DataBind();
        }
    }
    protected void rptCenters_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DataRowView row = (DataRowView)e.Item.DataItem;

            CheckBox chkCenter = (CheckBox)e.Item.FindControl("chkCenter");
            Literal litCenterCode = (Literal)e.Item.FindControl("litCenterCode");
            Literal litCenterName = (Literal)e.Item.FindControl("litCenterName");
            HiddenField hdnCenterID = (HiddenField)e.Item.FindControl("hdnCenterID");

            litCenterCode.Text = row["ID"].ToString();
            litCenterName.Text = row["Name"].ToString();
            hdnCenterID.Value = row["ID"].ToString();

            // You can add logic here to pre-select centers if needed
        }
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkSelectAll = (CheckBox)sender;
        bool isChecked = chkSelectAll.Checked;

        foreach (RepeaterItem item in rptCenters.Items)
        {
            CheckBox chkCenter = (CheckBox)item.FindControl("chkCenter");
            if (chkCenter != null)
            {
                chkCenter.Checked = isChecked;
            }
        }

        UpdateSelectedCentersButtonText();
    }

    private void UpdateSelectedCentersButtonText()
    {
        List<string> selectedCenters = new List<string>();

        foreach (RepeaterItem item in rptCenters.Items)
        {
            CheckBox chkCenter = (CheckBox)item.FindControl("chkCenter");
            Literal litCenterCode = (Literal)item.FindControl("litCenterCode");

            if (chkCenter != null && litCenterCode != null && chkCenter.Checked)
            {
                selectedCenters.Add(litCenterCode.Text);
            }
        }

        if (selectedCenters.Count > 0)
        {
            btnCenter.Text = string.Join(",", selectedCenters);
            if (selectedCenters.Count > 3)
            {
                btnCenter.Text += ",...";
            }
        }
        else
        {
            btnCenter.Text = "Select Centers";
        }
    }
    private void LoadPatientData()
    {
        string query = @"SELECT * FROM [Patient] ORDER BY CreatedDate DESC";

        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(dataTable);
        }

        // Add a calculated column 
        dataTable.Columns.Add("StatusDescription", typeof(string));

        foreach (DataRow row in dataTable.Rows)
        {
            switch (row["Status"].ToString())
            {
                case "0":
                    row["StatusDescription"] = "New Patient";
                    break;
                case "1":
                    row["StatusDescription"] = "At Laboratory";
                    break;
                case "2":
                    row["StatusDescription"] = "At Doctor";
                    break;
                case "3":
                    row["StatusDescription"] = "Conducted";
                    break;
                default:
                    row["StatusDescription"] = "Unknown Status";
                    break;
            }
        }

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
        // Get selected center IDs
        List<string> selectedCenterIDs = new List<string>();
        foreach (RepeaterItem item in rptCenters.Items)
        {
            CheckBox chkCenter = (CheckBox)item.FindControl("chkCenter");
            HiddenField hdnCenterID = (HiddenField)item.FindControl("hdnCenterID");

            if (chkCenter != null && hdnCenterID != null && chkCenter.Checked)
            {
                selectedCenterIDs.Add(hdnCenterID.Value);
            }
        }

        // Retrieve filter parameters
        string patientID = txtPatientID.Text.Trim();
        string name = txtName.Text.Trim();
        string nic = txtNIC.Text.Trim();
        string phone = txtPhone.Text.Trim();
        string sex = ddlSex.SelectedValue;
        string status = ddlStatus.SelectedValue;
        string Email = txtEmail.Text;
        DateTime? fromDate = string.IsNullOrEmpty(txtFromDate.Text) ? (DateTime?)null : Convert.ToDateTime(txtFromDate.Text);
        DateTime? toDate = string.IsNullOrEmpty(txtToDate.Text) ? (DateTime?)null : Convert.ToDateTime(txtToDate.Text);

        var data = GetFilteredPatients(patientID, name, Email, nic, phone, sex, status, fromDate, toDate, selectedCenterIDs);

        GridView1.DataSource = data;
        GridView1.DataBind();
    }

    private DataTable GetFilteredPatients(string patientID, string patientName, string Email, string nic, string phoneNumber,
                                          string genderID, string status, DateTime? fromDate, DateTime? toDate,
                                          List<string> selectedCenterIDs)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            StringBuilder query = new StringBuilder();
            query.Append("SELECT * FROM [Patient] WHERE 1=1");

            List<SqlParameter> parameters = new List<SqlParameter>();

            if (!string.IsNullOrEmpty(patientID))
            {
                query.Append(" AND [ID] = @PatientID");
                parameters.Add(new SqlParameter("@PatientID", patientID));
            }
            if (!string.IsNullOrEmpty(status))
            {
                query.Append(" AND [Status] = @Status");
                parameters.Add(new SqlParameter("@Status", status));
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

            // Add center filter if any centers are selected
            if (selectedCenterIDs != null && selectedCenterIDs.Count > 0)
            {
                query.Append(" AND [CenterID] IN (");
                for (int i = 0; i < selectedCenterIDs.Count; i++)
                {
                    string paramName = "@CenterID" + i;
                    query.Append(paramName);
                    parameters.Add(new SqlParameter(paramName, selectedCenterIDs[i]));

                    if (i < selectedCenterIDs.Count - 1)
                    {
                        query.Append(", ");
                    }
                }
                query.Append(")");
            }

            SqlCommand cmd = new SqlCommand(query.ToString(), conn);
            cmd.Parameters.AddRange(parameters.ToArray());

            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Add a calculated column for status description
                dt.Columns.Add("StatusDescription", typeof(string));
                foreach (DataRow row in dt.Rows)
                {
                    switch (row["Status"].ToString())
                    {
                        case "0":
                            row["StatusDescription"] = "New Patient";
                            break;
                        case "1":
                            row["StatusDescription"] = "At Laboratory";
                            break;
                        case "2":
                            row["StatusDescription"] = "At Doctor";
                            break;
                        case "3":
                            row["StatusDescription"] = "Conducted";
                            break;
                        default:
                            row["StatusDescription"] = "Unknown Status";
                            break;
                    }
                }

                return dt;
            }
        }
    }


    protected void btnAddTest_Click(object sender, EventArgs e)
    {
        IButtonControl btn = (IButtonControl)sender;
        string id = btn.CommandArgument;
        string encryptedID = modMain.Encrypt(id);
        // Use the ID value as needed
        // For example, you can redirect the user to another page with the ID as a query parameter
        Response.Redirect("frmAddTest.aspx?ID=" + encryptedID);

    }

    protected void btnSaveCase_Click(object sender, EventArgs e)
    {
        IButtonControl btn = (IButtonControl)sender;
        string id = btn.CommandArgument;
        string encryptedID = modMain.Encrypt(id);

        // Open in new tab using JavaScript
        string script = "window.open('frmCrystalReport.aspx?ID=" + encryptedID + "', '_blank');";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenReport", script, true);
    }


    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = DataBinder.Eval(e.Row.DataItem, "Status").ToString();
            long PatientID = Convert.ToInt64(DataBinder.Eval(e.Row.DataItem, "ID"));
            bool IsDue = IsPaymentRemains(PatientID);
            // Find action controls (LinkButton in dropdown)
            WebControl btnViewTest = (WebControl)e.Row.FindControl("btnAddTest");
            WebControl btnInvoice = (WebControl)e.Row.FindControl("btnSaveCase");
            WebControl btnViewReport = (WebControl)e.Row.FindControl("btnApprove");
            WebControl btnPrescription = (WebControl)e.Row.FindControl("btnPrescription");
            WebControl btnApproveG = (WebControl)e.Row.FindControl("btnApproveG");
            WebControl btnApproveWG = (WebControl)e.Row.FindControl("btnApproveWG");
            WebControl btnApproveWH = (WebControl)e.Row.FindControl("btnApproveWH");
            WebControl btnClearDues = (WebControl)e.Row.FindControl("btnClearDues");

            if (btnViewTest != null && btnInvoice != null && btnViewReport != null)
            {
                // Hide all by default
                btnViewTest.Visible = false;
                btnInvoice.Visible = false;
                btnViewReport.Visible = false;
                btnPrescription.Visible = false;
                btnApproveG.Visible = false;
                btnApproveWG.Visible = false;
                btnApproveWH.Visible = false;
                btnClearDues.Visible = false;

                switch (status)
                {
                    case "0": // New Patient
                        btnViewTest.Visible = true;
                        break;

                    case "1": // At Laboratory
                        btnViewTest.Visible = true;
                        btnInvoice.Visible = true;
                        break;

                    case "2": // At Doctor
                        btnViewTest.Visible = true;
                        btnInvoice.Visible = true;
                        btnViewReport.Visible = true;
                        btnApproveWH.Visible = true;
                        btnApproveG.Visible = true;
                        btnApproveWG.Visible = true;
                        if (IsDue)
                        {
                            btnClearDues.Visible = true;
                        }
                        break;

                    case "3": // Conducted
                        btnViewTest.Visible = true;
                        btnInvoice.Visible = true;
                        btnViewReport.Visible = true;
                        btnApproveWH.Visible = true;
                        btnApproveG.Visible = true;
                        btnApproveWG.Visible = true;
                        btnPrescription.Visible = true;
                        if (IsDue)
                        {
                            btnClearDues.Visible = true;
                        }
                        break;

                        // Optionally handle "Conducted" or other status if needed
                }
            }
        }
    }

    public bool IsPaymentRemains(long PatientID)
    {
        return modMain.IsPaymentRemains(PatientID);
    }
    protected void btnApprove_Click(object sender, EventArgs e)
    {
        IButtonControl btn = (IButtonControl)sender;
        string id = btn.CommandArgument;
        string encryptedID = modMain.Encrypt(id);

        // Open in new tab using JavaScript
        string script = "window.open('ReportCrystal.aspx?ID=" + encryptedID + "&btn=1', '_blank');";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenReport", script, true);
    }


    protected void btnPrescription_Click(object sender, EventArgs e)
    {

    }

    protected void btnApproveWH_Click(object sender, EventArgs e)
    {
        IButtonControl btn = (IButtonControl)sender;
        string id = btn.CommandArgument;
        string encryptedID = modMain.Encrypt(id);

        // Open in new tab using JavaScript
        string script = "window.open('ReportCrystal.aspx?ID=" + encryptedID + "&btn=4', '_blank');";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenReport", script, true);
    }

    protected void btnApproveG_Click(object sender, EventArgs e)
    {
        IButtonControl btn = (IButtonControl)sender;
        string id = btn.CommandArgument;
        string encryptedID = modMain.Encrypt(id);

        // Open in new tab using JavaScript
        string script = "window.open('ReportCrystal.aspx?ID=" + encryptedID + "&btn=2', '_blank');";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenReport", script, true);
    }

    protected void btnApproveWG_Click(object sender, EventArgs e)
    {
        IButtonControl btn = (IButtonControl)sender;
        string id = btn.CommandArgument;
        string encryptedID = modMain.Encrypt(id);

        // Open in new tab using JavaScript
        string script = "window.open('ReportCrystal.aspx?ID=" + encryptedID + "&btn=3', '_blank');";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenReport", script, true);
    }

    protected void btnClearDues_Click(object sender, EventArgs e)
    {
        IButtonControl btn = (IButtonControl)sender;
        long PatientID = Convert.ToInt64(btn.CommandArgument);
        decimal Due = modMain.GetPaymentRemains(PatientID);
        if (Due > 0)
        {
            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                "ShowDuesModal",
                "$('#DuesModal').modal('show');",
                true
            );
        }
    }
}
