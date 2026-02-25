using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Site_frmExpense : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if the user is logged in
        if (Session["Username"] == null)
        {
            Server.Transfer("Site/frmLogin.aspx");
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
            BindExpensesRepeater();
            BindCentersDropdown();
            BindExpenseTypesDropdown();
            BindModalCentersDropdown();
            BindModalExpenseTypesDropdown();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindExpensesRepeater(1); // Always reset to page 1 when searching
    }
    protected void btnSaveExpense_Click(object sender, EventArgs e)
    {
        // Retrieve values from controls
        string centerID = ddlModalCenters.SelectedValue;  // DropDownList
        string expenseType = ddlModalExpenseTypes.SelectedValue;  // DropDownList
        string employeeName = Request.Form["employeeName"];  // Input field
        string amountText = Request.Form["amount"];
        string description = Request.Form["description"];

        decimal amount;
        if (!decimal.TryParse(amountText, out amount))
        {
            amount = 0; // Default if conversion fails
        }

        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            try
            {
                conn.Open();
                string query = "INSERT INTO Expenses (CenterID, ExpenseType, EmployeeName, Amount, Description, CreatedDate) VALUES (@CenterID, @ExpenseType, @EmployeeName, @Amount, @Description, @CreatedDate)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CenterID", centerID);
                    cmd.Parameters.AddWithValue("@ExpenseType", expenseType);
                    cmd.Parameters.AddWithValue("@EmployeeName", employeeName);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);

                    cmd.ExecuteNonQuery();
                }

                // Show success message and close modal
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Expense saved successfully!');", true);
            }
            catch (Exception ex)
            {
                // Handle error
            }
        }
    }
    private int PageSize = 10; // Number of items per page

    private void BindExpensesRepeater(int pageIndex = 1)
    {
        // Get filter values from controls
        DateTime? fromDate = !string.IsNullOrEmpty(Request.Form["fromDate"])
            ? DateTime.Parse(Request.Form["fromDate"])
            : (DateTime?)null;

        DateTime? toDate = !string.IsNullOrEmpty(Request.Form["toDate"])
            ? DateTime.Parse(Request.Form["toDate"])
            : (DateTime?)null;

        int? centerId = ddlCenters.SelectedIndex > 0
            ? int.Parse(ddlCenters.SelectedValue)
            : (int?)null;

        int? expenseTypeId = ddlExpenseTypes.SelectedIndex > 0
            ? int.Parse(ddlExpenseTypes.SelectedValue)
            : (int?)null;

        string searchText = Request.Form["searchText"];

        ExpenseDAL expenseDAL = new ExpenseDAL();
        DataSet ds = expenseDAL.GetExpenses(fromDate, toDate, centerId, expenseTypeId, searchText, pageIndex, PageSize);

        if (ds.Tables.Count > 0)
        {
            rptExpenses.DataSource = ds.Tables[0];
            rptExpenses.DataBind();

            // Get total count from second table
            if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
            {
                int totalRecords = Convert.ToInt32(ds.Tables[1].Rows[0]["TotalCount"]);
                BindPagination(totalRecords, pageIndex);
            }
        }
    }
    private void BindPagination(int totalRecords, int currentPage)
    {
        int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);

        // Clear existing pagination
        // pnlPagination.Controls.Clear();

        // Previous button
        if (currentPage > 1)
        {
            LinkButton prevLink = new LinkButton();
            prevLink.Text = "&laquo; Previous";
            prevLink.CommandName = "page";
            prevLink.CommandArgument = (currentPage - 1).ToString();
            prevLink.CssClass = "page-link";
            prevLink.Click += Page_Changed;

            //LiteralControl liPrev = new LiteralControl("<li class='page-item'>");
            //pnlPagination.Controls.Add(liPrev);
            //pnlPagination.Controls.Add(prevLink);
            //pnlPagination.Controls.Add(new LiteralControl("</li>"));
        }

        // Page numbers
        for (int i = 1; i <= totalPages; i++)
        {
            LiteralControl li = new LiteralControl("<li class='page-item'>");
            //  pnlPagination.Controls.Add(li);

            if (i == currentPage)
            {
                Label pageLabel = new Label();
                pageLabel.Text = i.ToString();
                pageLabel.CssClass = "page-link active";
                // pnlPagination.Controls.Add(pageLabel);
            }
            else
            {
                LinkButton pageLink = new LinkButton();
                pageLink.Text = i.ToString();
                pageLink.CommandName = "page";
                pageLink.CommandArgument = i.ToString();
                pageLink.CssClass = "page-link";
                pageLink.Click += Page_Changed;
                // pnlPagination.Controls.Add(pageLink);
            }

            //  pnlPagination.Controls.Add(new LiteralControl("</li>"));
        }

        // Next button
        if (currentPage < totalPages)
        {
            LinkButton nextLink = new LinkButton();
            nextLink.Text = "Next &raquo;";
            nextLink.CommandName = "page";
            nextLink.CommandArgument = (currentPage + 1).ToString();
            nextLink.CssClass = "page-link";
            nextLink.Click += Page_Changed;

            //LiteralControl liNext = new LiteralControl("<li class='page-item'>");
            //pnlPagination.Controls.Add(liNext);
            //pnlPagination.Controls.Add(nextLink);
            //pnlPagination.Controls.Add(new LiteralControl("</li>"));
        }
    }

    protected void Page_Changed(object sender, EventArgs e)
    {
        LinkButton button = (LinkButton)sender;
        int pageIndex = int.Parse(button.CommandArgument);
        BindExpensesRepeater(pageIndex);
    }

    private void BindModalExpenseTypesDropdown()
    {
        ExpenseDAL expenseDAL = new ExpenseDAL();
        DataTable dt = expenseDAL.GetExpenseTypes();

        ddlModalExpenseTypes.DataSource = dt;
        ddlModalExpenseTypes.DataTextField = "DisplayName";  // Changed from "Name" to "DisplayName"
        ddlModalExpenseTypes.DataValueField = "ID";
        ddlModalExpenseTypes.DataBind();

        ddlModalExpenseTypes.Items.Insert(0, new ListItem("-- Select Expense Type --", "0"));
    }

    private void BindModalCentersDropdown()
    {
        ExpenseDAL expenseDAL = new ExpenseDAL();
        DataTable dt = expenseDAL.GetCenters();

        ddlModalCenters.DataSource = dt;
        ddlModalCenters.DataTextField = "DisplayName";  // Changed from "Name" to "DisplayName"
        ddlModalCenters.DataValueField = "ID";
        ddlModalCenters.DataBind();

        ddlModalCenters.Items.Insert(0, new ListItem("-- Select Center --", "0"));
    }

    private void BindExpenseTypesDropdown()
    {
        ExpenseDAL expenseDAL = new ExpenseDAL();
        DataTable dt = expenseDAL.GetExpenseTypes();

        ddlExpenseTypes.DataSource = dt;
        ddlExpenseTypes.DataTextField = "DisplayName";  // Changed from "Name" to "DisplayName"
        ddlExpenseTypes.DataValueField = "ID";
        ddlExpenseTypes.DataBind();

        ddlExpenseTypes.Items.Insert(0, new ListItem("-- Select Expense Type --", "0"));
    }

    private void BindCentersDropdown()
    {
        ExpenseDAL expenseDAL = new ExpenseDAL();
        DataTable dt = expenseDAL.GetCenters();

        ddlCenters.DataSource = dt;
        ddlCenters.DataTextField = "DisplayName";  // Changed from "Name" to "DisplayName"
        ddlCenters.DataValueField = "ID";
        ddlCenters.DataBind();

        ddlCenters.Items.Insert(0, new ListItem("-- Select Center --", "0"));
    }
}

public class ExpenseDAL
{
    private string connectionString;

    public ExpenseDAL()
    {
        connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        if (string.IsNullOrEmpty(connectionString))
        {
            throw new Exception("Connection string is not found or empty in web.config.");
        }
    }

    public DataSet GetExpenses(DateTime? fromDate = null, DateTime? toDate = null,
                             int? centerId = null, int? expenseTypeId = null,
                             string searchText = null, int pageIndex = 1, int pageSize = 10)
    {
        DataSet ds = new DataSet();
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("Expenses_Type", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                // Add parameters
                cmd.Parameters.AddWithValue("@FromDate", fromDate.HasValue ? (object)fromDate.Value : DBNull.Value);
                cmd.Parameters.AddWithValue("@EndDate", toDate.HasValue ? (object)toDate.Value : DBNull.Value);
                cmd.Parameters.AddWithValue("@CenterID", centerId.HasValue ? (object)centerId.Value : DBNull.Value);
                cmd.Parameters.AddWithValue("@ExpenseTypeID", expenseTypeId.HasValue ? (object)expenseTypeId.Value : DBNull.Value);
                cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? DBNull.Value : (object)searchText);
                cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                conn.Open();
                da.Fill(ds);
            }
        }
        catch (Exception ex)
        {
            throw new Exception("Error fetching expenses: " + ex.Message);
        }
        return ds;
    }


    public int GetTotalExpenseCount()
    {
        int totalCount = 0;
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Expenses";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                totalCount = (int)cmd.ExecuteScalar();
            }
        }
        catch (Exception ex)
        {
            throw new Exception("Error getting total expense count: " + ex.Message);
        }
        return totalCount;
    }

    public DataTable GetCenters()
    {
        DataTable dt = new DataTable();
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Modified query to concatenate ID and Name
                string query = "SELECT ID, CAST(ID AS VARCHAR(10)) + ' - ' + Name AS DisplayName FROM Center";
                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                conn.Open();
                da.Fill(dt);
            }
        }
        catch (Exception ex)
        {
            throw new Exception("Error fetching centers: " + ex.Message);
        }
        return dt;
    }

    public DataTable GetExpenseTypes()
    {
        DataTable dt = new DataTable();
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Modified query to concatenate ID and Name
                string query = "SELECT ID, CAST(ID AS VARCHAR(10)) + ' - ' + Name AS DisplayName FROM ExpenseType";
                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                conn.Open();
                da.Fill(dt);
            }
        }
        catch (Exception ex)
        {
            throw new Exception("Error fetching expense types: " + ex.Message);
        }
        return dt;
    }
}
