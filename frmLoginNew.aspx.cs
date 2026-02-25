using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class frmLoginNew : System.Web.UI.Page
{
    public static string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {

    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUserID.Text.Trim();
        string password = txtPassword.Text.Trim();

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            lblMessage.Text = "Username and password are required.";
            lblMessage.ForeColor = System.Drawing.Color.Red;
            return;
        }

        try
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string query = @"
    SELECT UserId, UserName, RoleName,Centers 
    FROM Users 
    WHERE UserName = @UserName AND Password = @Password";


                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserName", username);
                    command.Parameters.AddWithValue("@Password", password);

                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        string roleName = reader["RoleName"].ToString();
                        string userId = reader["UserId"].ToString();
                        string Centers = reader["Centers"].ToString();

                        // Store user details in session
                        Session["UserId"] = userId;
                        Session["Username"] = username;
                        Session["RoleName"] = roleName;
                        Session["Centers"] = Centers;

                        reader.Close();

                        // Get Multiple AccessIDs from RolesTable
                        List<string> accessIds = GetAccessIDs(roleName, connection);
                        Session["AccessIDs"] = accessIds;
                        DataTable dt = modMain.GetUserPageAccess(roleName);
                        // Get Access Names from AccessTable for all AccessIDs
                        List<string> accessNames = GetAccessNames(accessIds, connection);
                        Session["AccessNames"] = accessNames;

                        connection.Close();
                        if ((int)dt.Rows[0]["id"] == 1)
                        {
                            Response.Redirect("Site/frmIndex.aspx", false);
                        }
                        else if ((int)dt.Rows[0]["id"] == 2)
                        {
                            Response.Redirect("Site/frmLaboratory.aspx", false);
                        }
                        else if ((int)dt.Rows[0]["id"] == 3)
                        {
                            Response.Redirect("Site/frmDoctorApproval.aspx", false);
                        }
                        else if ((int)dt.Rows[0]["id"] == 4)
                        {
                            Response.Redirect("Site/frmExpense.aspx", false);
                        }
                        else if ((int)dt.Rows[0]["id"] == 5)
                        {
                            Response.Redirect("Site/frmManagement.aspx", false);
                        }
                        else if ((int)dt.Rows[0]["id"] == 6)
                        {
                            Response.Redirect("Site/frmSearchPatient.aspx", false);
                        }
                        else if ((int)dt.Rows[0]["id"] == 7)
                        {
                            Response.Redirect("Site/frmCash.aspx", false);
                        }
                        else
                        {
                            Response.Redirect("Site/frmIndex.aspx", false);
                        }
                        // Redirect to the main page
                    }
                    else
                    {
                        lblMessage.Text = "Invalid username or password.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = "Error: " + ex.Message;
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
    }

    // Method to retrieve AccessID based on RoleName
    private List<string> GetAccessIDs(string roleName, SqlConnection connection)
    {
        List<string> accessIds = new List<string>();

        string query = "SELECT AccessID FROM RolesTable WHERE RoleName = @RoleName";
        using (SqlCommand command = new SqlCommand(query, connection))
        {
            command.Parameters.AddWithValue("@RoleName", roleName);
            SqlDataReader reader = command.ExecuteReader();

            while (reader.Read())
            {
                accessIds.Add(reader["AccessID"].ToString());
            }
            reader.Close();
        }

        return accessIds;
    }

    // Method to retrieve AccessNames based on AccessID
    private List<string> GetAccessNames(List<string> accessIds, SqlConnection connection)
    {
        List<string> accessNames = new List<string>();

        if (accessIds.Count == 0) return accessNames;

        string query = "SELECT AccessName FROM AccessTable WHERE id IN (" + string.Join(",", accessIds) + ")";

        using (SqlCommand command = new SqlCommand(query, connection))
        {
            SqlDataReader reader = command.ExecuteReader();

            while (reader.Read())
            {
                accessNames.Add(reader["AccessName"].ToString());
            }
            reader.Close();
        }

        return accessNames;
    }
    public bool validateForm()
    {
        modMain objMN = new modMain();
        try
        {
            if (txtUserID.Text.Length == 0)
            {
                return false;
            }

            if (txtPassword.Text.Length == 0)
            {
                return false;
            }

            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
        finally
        {
            objMN = null;
        }
    }

}