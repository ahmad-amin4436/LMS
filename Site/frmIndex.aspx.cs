using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Site_frmIndex : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
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

                //ERR_MSG("123", false);
                init_cmbs();
                BindLocations();
                txtRegistrationDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm"); // Format for DateTimeLocal input

            }
        }
        catch (Exception ex)
        {
            ERR_MSG(ex.Message);
        }
        finally
        {
            ctrl_MSG.msg_Box_Close_Event += msg_Box_Close_Event;
        }
    }

    public void init_cmbs()
    {

    }
    private void BindLocations()
    {
        try
        {
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();

                // Populate Location dropdown from Users table
                string query = @"
    SELECT DISTINCT c.ID, c.Name 
    FROM [Users] u
    INNER JOIN [Center] c ON u.Centers = c.ID
    WHERE u.Centers = "+ Session["Centers"] .ToString()+ "";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlLocation.Items.Clear();
                        ddlLocation.Items.Add(new ListItem("--- Select Center ---", ""));
                        while (reader.Read())
                        {
                            string id = reader["ID"].ToString();
                            string name = reader["Name"].ToString();
                            ddlLocation.Items.Add(new ListItem(string.Format("{0} - {1}", id, name), id));

                        }
                    }
                }

                // Populate Reference dropdown
                string referenceQuery = "SELECT [ID], [Name] FROM [Reference] WHERE [Status] = 0"; // Adjust query as needed
                using (SqlCommand referenceCmd = new SqlCommand(referenceQuery, con))
                {
                    using (SqlDataReader referenceReader = referenceCmd.ExecuteReader())
                    {
                        ddlReference.Items.Clear();
                        ddlReference.Items.Add(new ListItem("--- Select Reference ---", ""));
                        while (referenceReader.Read())
                        {
                            string referenceID = referenceReader["ID"].ToString();
                            string referenceName = referenceReader["Name"].ToString();
                            ddlReference.Items.Add(new ListItem(referenceName, referenceID));
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ERR_MSG(ex.Message);
        }
    }
    private void ERR_MSG(string strErr, bool isError = true)
    {
        try
        {
            //ctrl_MSG.msg_Box_Close_Event += msg_Box_Close_Event;
            if (strErr.Length == 0)
            {
                //pnlMSG.Visible = false;
                return;
            }
            ctrl_MSG.str_MSG = strErr;
            // mpLabel.ForeColor = Drawing.Color.Pink
            if (isError)
                ctrl_MSG.is_ERR = true;
            if (!isError)
                ctrl_MSG.is_MSG = true;
            //ctrl_MSG.str_DATE_TIME = DateTime.Now.ToString("dd/MM/yyyy");
            pnlMSG.Attributes.Add("style", "Z-INDEX: 301; LEFT: 500px; POSITION: absolute; TOP: 130px");
            pnlMSG.Visible = true;
            ctrl_MSG.showControl();
        }
        catch (Exception)
        {
        }
        finally
        {
        }
    }

    protected void msg_Box_Close_Event(string strSENDERID)
    {
        try
        {
            pnlMSG.Visible = false;
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    protected void btnFinish_Click(object sender, EventArgs e)
    {
        try
        {
            // Retrieve values from the form
            var location = ddlLocation.SelectedValue;
            var firstName = txtFirstName.Text;
            var medicalRecordNo = txtMRNo.Text;
            var PatientNo = hfPatientNo.Value;
            var lastName = txtLastName.Text;
            var age = txtAge.Text;
            // Retrieve values from the form
            var reference = ddlReference.SelectedValue;


            var sex = ddlGender.SelectedValue;
            //DateTime? registrationDate = Convert.ToDateTime(txtRegistrationDate.Text);
            var email = txtEmail.Text;
            //DateTime dob = Convert.ToDateTime(txtDob.Text);
            //var blood = ddlBloodGroup.SelectedValue;
            var phone = txtPhone.Text;
            var marital = ddlMaritalStatus.SelectedValue;
            var nic = txtNIC.Text;
            var mobile = txtMobile.Text;
            var FHName = txtFatherHusbandName.Text;
            var country = ddlCountry.SelectedValue;
            var city = ddlCity.SelectedValue;
            var address = txtAddress.Text;
            var cabg = txtCABGNo.Text;
            var consultant = txtConsultant.Text;
            var comments = txtComments.Text;
            var Reference = ddlReference.SelectedValue;
            // Ensure a valid registration date, default to current date/time if invalid
            DateTime registrationDate;
            if (!DateTime.TryParse(txtRegistrationDate.Text, out registrationDate))
            {
                registrationDate = DateTime.Now; // Default to current date and time
            }


            // Database connection string
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            string testID = string.Empty; // Variable to store the Test ID

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                
                // Insert the patient record and get the newly inserted ID
                string query = @"INSERT INTO [Patient]
([FirstName],[LastName], [FHName],[MedicalRecordNo], [PatientNumber], [Sex], 
 [DateRegistered], [Email], [Mobile], [Phone], 
 [MaritalStatus], [NIC], [Country], [City], [Address], [CABGNo],
 [Age],
 [CreatedDate],[Status],[Location],[Consultant],[Comments],[ReferenceID]) 
 OUTPUT INSERTED.ID
 VALUES (@FirstName, @LastName, @FHName, @MedicalRecordNo, @PatientNumber, @GenderID, 
         @RegistrationDate, @Email, @MobileNumber, @PhoneNumber, 
         @MaritalStatusID, @NIC, @CountryID, @CityID, @Address, @CABGNumber, 
         @Age, 
         @CreatedDate, @Status, @Location,@Consultant, @Comments, @ReferenceID)
";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", firstName ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@LastName", lastName ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@FHName", FHName ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@MedicalRecordNo", medicalRecordNo ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@PatientNumber", PatientNo ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@GenderID", sex ?? (object)DBNull.Value);
                    //cmd.Parameters.AddWithValue("@RegistrationDate", registrationDate ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@RegistrationDate", registrationDate); // Updated to use default value
                    cmd.Parameters.AddWithValue("@Email", email ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@MobileNumber", mobile ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Age", string.IsNullOrWhiteSpace(age) ? (object)DBNull.Value : age);

                    cmd.Parameters.AddWithValue("@PhoneNumber", phone ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@MaritalStatusID", marital ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@NIC", nic ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@CountryID", country ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@CityID", city ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Address", address ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@CABGNumber", cabg ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@Status", 0);
                    cmd.Parameters.AddWithValue("@Location", location ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Consultant", consultant ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Comments", comments ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@ReferenceID", reference ?? (object)DBNull.Value);

                    // Execute and get the inserted Test ID
                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        testID = result.ToString();
                    }
                }

            }

            if (!string.IsNullOrEmpty(testID))
            {
                string EncryptedID = modMain.Encrypt(testID);
                Response.Redirect("frmAddTest.aspx?ID=" + EncryptedID, false); // Fix: Use 'false' to avoid thread abortion
                Context.ApplicationInstance.CompleteRequest(); // Ensures redirection without aborting the thread
            }
        }
        catch (Exception ex)
        {
            // Log the error (you can display it in a label or log it for debugging)


            // Alternatively, write to a log file
            System.IO.File.AppendAllText(Server.MapPath("~/ErrorLog.txt"), DateTime.Now + " - " + ex.ToString() + Environment.NewLine);
        }
    }
    public static string GenerateSecureID(int length = 8)
    {
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_-+=<>?";
        var result = new StringBuilder();
        var bytes = new byte[length];

        using (var rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(bytes);
            foreach (var b in bytes)
            {
                result.Append(chars[b % chars.Length]);
            }
        }

        return result.ToString();
    }
    public void init_Report(int PDF_1_EXLS_2)
    {
        try
        {
            Session["objDTST"] = "gobj_dtstsys";
            Session["objPara"] = "5";
            string Qstring = "";
            if (PDF_1_EXLS_2 == 2)
            {
                Server.Transfer("../Site/frmrpt/ReportViewer.aspx?ID=" + Qstring);
            }
            else
            {
                string strPage = "../Site/frmrpt/ReportViewer.aspx?ID=" + Qstring;
                NewWindow(strPage);
            }
        }
        catch (Exception ex)
        {
            ERR_MSG(ex.Message);
        }
        finally
        {

        }
    }

    protected void NewWindow(string url)
    {
        Response.Write(string.Format("<script>window.open('" + url + "','_blank','top=10,left=200,height=800px,width=1200,addressbar=yes,toolbar=no,directories=no,status=yes,scrollbars=yes,menubar=no,resizable=yes'); </script>"));
    }

    protected void txtAge_TextChanged(object sender, EventArgs e)
    {
        // Get the age input from the TextBox
        //string ageInput = txtAge.Text;

        //// Get the selected value from the DropDownList
        //string duration = ddlDuration.SelectedValue;

        //// Validate input
        //if (!string.IsNullOrEmpty(ageInput) && !string.IsNullOrEmpty(duration))
        //{
        //    int age;
        //    if (int.TryParse(ageInput, out age)) // Try parsing the age to an integer
        //    {
        //        DateTime dateOfBirth = DateTime.Now; // Start with the current date

        //        // Perform calculations based on the selected duration
        //        switch (duration)
        //        {
        //            case "Years.":
        //                dateOfBirth = DateTime.Now.AddYears(-age); // Subtract years
        //                break;
        //            case "Months.":
        //                dateOfBirth = DateTime.Now.AddMonths(-age); // Subtract months
        //                break;
        //            case "Days.":
        //                dateOfBirth = DateTime.Now.AddDays(-age); // Subtract days
        //                break;
        //            default:
        //                txtDob.Text = "Invalid duration.";
        //                return;
        //        }

        //        // Set the calculated result to the label
        //        txtDob.Text =  dateOfBirth.ToString("dd/MM/yyyy");
        //    }
        //    else
        //    {
        //        txtDob.Text = "Please enter a valid number for age.";
        //    }
        //}
        //else
        //{
        //    txtDob.Text = "Please fill in both age and duration.";
        //}
    }


}