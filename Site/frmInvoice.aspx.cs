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


public partial class Site_frmInvoice : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        string decryptedTestID = modMain.Decrypt(Request.QueryString["ID"]);
        int ID = Convert.ToInt32(decryptedTestID);
        LoadPatientData(ID);
        LoadTestDetails(ID);
        LoadPatientBillingDetails(ID);
        LoadPatientDetails(ID);
        GenerateQRCode(ID);
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
            string query = @"SELECT TestName, ReportingDate, Rate FROM CaseDetail WHERE PatientID = @PatientID";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@PatientID", patientID);
                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptPatientTests.DataSource = dt;
                rptPatientTests.DataBind();
            }
        }
    }

    private void LoadPatientBillingDetails(int patientID)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string query = @"SELECT TotalAmount, Discount, Due, PaidAmount FROM [Case] WHERE PatientID = @PatientID";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@PatientID", patientID);
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblTotal.Text = reader["TotalAmount"].ToString();
                        lblDiscount.Text = reader["Discount"].ToString();
                        lblToBePaid.Text = reader["TotalAmount"].ToString();
                        lblPaid.Text = reader["PaidAmount"].ToString();
                    }
                }
            }
        }
    }

    private void LoadPatientDetails(int patientID)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string query = @"
        SELECT c.RegistrationLocation, p.Phone, p.Email, p.Address 
        FROM [Case] c
        INNER JOIN Patient p ON c.PatientID = p.ID
        WHERE c.PatientID = @PatientID;";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@PatientID", patientID);
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblCenterName.Text = reader["RegistrationLocation"].ToString();
                        lblPhoneNumber.Text = reader["Phone"].ToString();
                        lblEmail.Text = reader["Email"].ToString();
                        lblAddress.Text = reader["Address"].ToString();
                        //lblContactPerson.Text = "N/A"; // No ContactPerson in Patient or Case table
                    }
                }
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