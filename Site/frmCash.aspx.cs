using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

public partial class Site_frmCash : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCenters();
            txtFromDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm");
            txtToDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm");
            BindGridView();
        }
    }

    private void LoadCenters()
    {
        string query = "SELECT ID, (CAST(ID AS VARCHAR) + ' - ' + Name) AS CenterDisplay FROM Center";

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            try
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataReader reader = cmd.ExecuteReader();

                ddlCenterName.DataSource = reader;
                ddlCenterName.DataTextField = "CenterDisplay";
                ddlCenterName.DataValueField = "ID";
                ddlCenterName.DataBind();

                reader.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }

        ddlCenterName.Items.Insert(0, new ListItem("Select Center", ""));
    }

    protected void btnSearchCashSumary_Click(object sender, EventArgs e)
    {
        BindGridView();
    }

    private void BindGridView()
    {
        string rateTypeId = "Discount"; // default fallback

        if (ViewState["RateTypeID"] != null)
        {
            rateTypeId = ViewState["RateTypeID"].ToString().Trim();
        }
        long centerId = 0;

        if (!string.IsNullOrEmpty(ddlCenterName.SelectedValue))
        {
            try
            {
                centerId = Convert.ToInt64(ddlCenterName.SelectedValue);
            }
            catch
            {
                return;
            }
        }
        else
        {
            return;
        }

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("SP_GetCashSummary", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@RateTypeID", rateTypeId);
            cmd.Parameters.AddWithValue("@CenterID", centerId);
            cmd.Parameters.AddWithValue("@FromDate", Convert.ToDateTime(txtFromDate.Text));
            cmd.Parameters.AddWithValue("@ToDate", Convert.ToDateTime(txtToDate.Text));

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);

            gvCashSummary.DataSource = dt;
            gvCashSummary.DataBind();

            CalculateSums(dt);
        }
    }

    private void CalculateSums(DataTable dt)
    {
        decimal grandTotal = CalculateColumnSum(dt, "GrandTotal");
        decimal totalAmount = CalculateColumnSum(dt, "TotalAmount");
        decimal less = CalculateColumnSum(dt, "Less");
        decimal due = CalculateColumnSum(dt, "Due");
        decimal dueReceived = CalculateColumnSum(dt, "DueReceived");
        decimal bankPaid = CalculateColumnSum(dt, "BankPaid");
        decimal bankDueReceived = CalculateColumnSum(dt, "BankDueReceived");
        decimal TotalReceiveable = CalculateColumnSum(dt, "Receiveable");

        lblGrandTotal.Text = grandTotal.ToString("N2");
        lblTotalAmount.Text = totalAmount.ToString("N2");
        lblTotalReceivables.Text = TotalReceiveable.ToString("N2");
        lblLess.Text = less.ToString("N2");
        lblDue.Text = due.ToString("N2");
        lblDueReceived.Text = dueReceived.ToString("N2");
        lblBankPaid.Text = bankPaid.ToString("N2");
        lblBankDueReceived.Text = bankDueReceived.ToString("N2");

        decimal cashTotal = 0, chequeTotal = 0, cardTotal = 0;

        foreach (DataRow row in dt.Rows)
        {
            string paymentMethod = row["PaymentMethod"] == DBNull.Value ? "" : row["PaymentMethod"].ToString().Trim();

            decimal value = 0;
            decimal.TryParse(row["GrandTotal"].ToString(), out value);

            if (paymentMethod == "Cash") cashTotal += value;
            else if (paymentMethod == "Cheque") chequeTotal += value;
            else if (paymentMethod == "Card") cardTotal += value;
        }

        lblCashTotalAmount.Text = cashTotal.ToString("N2");
        lblChequeTotalAmount.Text = chequeTotal.ToString("N2");
        lblCardTotalAmount.Text = cardTotal.ToString("N2");

        lblTotalAmountReceived.Text = grandTotal.ToString("N2");
        lblNetbankcashAmount.Text = (cashTotal + chequeTotal + cardTotal).ToString("N2");

        decimal totalAdj = 0;
        foreach (DataRow row in dt.Rows)
        {
            decimal value;
            if (decimal.TryParse(row["TotalAmount"].ToString(), out value))
            {
                totalAdj += value;
            }
        }

        lblTotalAdjustmentAmount.Text = totalAdj.ToString("N2");
    }

    public decimal CalculateColumnSum(DataTable dt, string columnName)
    {
        decimal total = 0;

        foreach (DataRow row in dt.Rows)
        {
            decimal value;
            if (decimal.TryParse(row[columnName].ToString(), out value))
            {
                total += value;
            }
        }

        return total;
    }

    protected void gvCashSummary_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvCashSummary.PageIndex = e.NewPageIndex;
        BindGridView();
    }



    protected void ddlCenterName_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(ddlCenterName.SelectedValue))
            return;

        long centerId;
        if (!long.TryParse(ddlCenterName.SelectedValue, out centerId))
            return;

        string query = "SELECT RateTypeID FROM Center WHERE ID = @ID";

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            try
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ID", centerId);

                object rateTypeObj = cmd.ExecuteScalar();

                if (rateTypeObj != null && rateTypeObj != DBNull.Value)
                {
                    string rateTypeId = rateTypeObj.ToString();

                    // Optionally store in ViewState or use it directly
                    ViewState["RateTypeID"] = rateTypeId;

                    // Optionally: re-bind data based on RateTypeID
                    BindGridView(); // If needed to refresh grid
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }
    }
}
