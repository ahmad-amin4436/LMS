using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for modMain
/// </summary>
public class modMain
{
    public static string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    public modMain()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static string Encrypt(string input)
    {
        return Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(input));
    }
    public static string Decrypt(string encodedInput)
    {
        return System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(encodedInput));
    }
    public static void SaveQRBytes(byte[] fileBytes)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("SaveQRBytes", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@QRCode", fileBytes);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }
    }
    public static DataTable GetUserPageAccess(string RoleName)
    {
        DataTable dt = new DataTable();
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("SP_GetUserPageAccess", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@RoleName", RoleName);
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }
        }
        return dt;
    }
    public static DataSet GetCentersDetails(string searchText, int start, int length, string sortField, string sortOrder)
    {
        DataSet ds = new DataSet();

        using (SqlConnection conn = new SqlConnection(connectionString))
        using (SqlCommand cmd = new SqlCommand("SP_GetCentersDetails", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrWhiteSpace(searchText) ? DBNull.Value : (object)searchText);
            cmd.Parameters.AddWithValue("@Start", start);
            cmd.Parameters.AddWithValue("@Length", length);
            cmd.Parameters.AddWithValue("@SortField", string.IsNullOrEmpty(sortField) ? "CreatedDate" : sortField);
            cmd.Parameters.AddWithValue("@SortOrder", string.IsNullOrEmpty(sortOrder) ? "DESC" : sortOrder);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
        }

        return ds;
    }
    public static void CallPrescriptionSP(int mode, long id, string description, byte[] prescriptionFile, long patientId, DateTime uploadingDateTime, long uploadedBy)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("SP_Prescription", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@Mode", SqlDbType.Int).Value = mode;
                cmd.Parameters.Add("@ID", SqlDbType.BigInt).Value = id == 0 ? (object)DBNull.Value : id;
                cmd.Parameters.Add("@Description", SqlDbType.VarChar).Value = string.IsNullOrEmpty(description) ? (object)DBNull.Value : description;
                cmd.Parameters.Add("@Prescription", SqlDbType.VarBinary).Value = (prescriptionFile != null && prescriptionFile.Length > 0) ? (object)prescriptionFile : DBNull.Value;
                cmd.Parameters.Add("@PatientID", SqlDbType.BigInt).Value = patientId == 0 ? (object)DBNull.Value : patientId;
                cmd.Parameters.Add("@UploadingDateTime", SqlDbType.DateTime).Value = uploadingDateTime == DateTime.MinValue ? (object)DBNull.Value : uploadingDateTime;
                cmd.Parameters.Add("@UploadedBy", SqlDbType.BigInt).Value = uploadedBy == 0 ? (object)DBNull.Value : uploadedBy;

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }


    public void CallCentersProcedure(
      int mode, int? id,int? code, string name, string description, byte type, bool isLab,
      bool? isCreditEnabled, decimal? creditLimit, short? creditDays, decimal? balance,
      string rateTypeId, string address, string city, string country, string phone,
      string fax, string email, string contactPerson, string contactPhone, string contactMobile,
      string contactEmail, string createdBy, DateTime createdDate, string modifiedBy, DateTime modifiedDate,
      bool status, decimal? rebate, decimal? specialDiscount, decimal? courierCharges)
        {
        using (SqlConnection conn = new SqlConnection(connectionString))
        using (SqlCommand cmd = new SqlCommand("SP_Centers", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@Mode", mode);
            cmd.Parameters.AddWithValue("@ID", id.HasValue ? (object)code.Value : DBNull.Value);
            cmd.Parameters.AddWithValue("@Code", code.HasValue ? (object)code.Value : DBNull.Value);
            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@Description", description ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Type", (object)type);
            cmd.Parameters.AddWithValue("@IsLab", isLab);
            cmd.Parameters.AddWithValue("@IsCreditEnabled", (object)isCreditEnabled ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@CreditLimit", (object)creditLimit ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@CreditDays", (object)creditDays ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Balance", (object)balance ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@RateTypeID", rateTypeId);
            cmd.Parameters.AddWithValue("@Address", address ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@City", city ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Country", country ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Phone", phone ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Fax", fax ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Email", email ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@ContactPerson", contactPerson ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@ContactPhone", contactPhone ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@ContactMobile", contactMobile ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@ContactEmail", contactEmail ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@CreatedBy", createdBy);
            cmd.Parameters.AddWithValue("@CreatedDate", createdDate);
            cmd.Parameters.AddWithValue("@ModifiedBy", modifiedBy);
            cmd.Parameters.AddWithValue("@ModifiedDate", modifiedDate);
            cmd.Parameters.AddWithValue("@Status", status);
            cmd.Parameters.AddWithValue("@Rebate", (object)rebate ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@SpecialDiscount", (object)specialDiscount ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@CourierCharges", (object)courierCharges ?? DBNull.Value);

            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }
    public static void UpdateDiscounts(int id, decimal discount, decimal discountR4)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("usp_UpdateDiscounts", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@Discount", discount);
                cmd.Parameters.AddWithValue("@DiscountR4", discountR4);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
    public static bool IsPaymentRemains(long PatientID)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("SP_IsPaymentRemains", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PatientID", PatientID);
                con.Open();

                object result = cmd.ExecuteScalar(); // Get first column of first row

                if (result != null && result != DBNull.Value)
                {
                    decimal due = Convert.ToDecimal(result);
                    return due > 0;
                }

                return false;
            }
        }
    }
    public static decimal GetPaymentRemains(long PatientID)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("SP_IsPaymentRemains", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PatientID", PatientID);
                con.Open();

                object result = cmd.ExecuteScalar(); // Get first column of first row

                if (result != null && result != DBNull.Value)
                {
                    decimal due = Convert.ToDecimal(result);
                    return due;
                }

                return 0;
            }
        }
    }




}