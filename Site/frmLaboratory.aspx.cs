using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.Services;
using Newtonsoft.Json;
using System.Web;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using RtfPipe; // Import RtfPipe library
using System.Text.RegularExpressions; // Required for Regex
using System.Globalization;

public partial class Site_frmLaboratory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if the user is logged in
        if (Session["Username"] == null)
        {
            Response.Redirect("~/frmLoginNew.aspx");
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

        // Existing functionality to load patient data and bind the repeater
        if (!IsPostBack)
        {
            LoadPatientData();
            rptAntimicrobialGroups.DataSource = GetAntimicrobialGroups();
            rptAntimicrobialGroups.DataBind();
            BindDropdown();
            BindSpecificGravityDropdown();
            //txtCSCollectionDate.Text = DateTime.Now.ToString();
            //txtStoolCSCollectionDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm"); // Format for datetime-local input
            //txtSemenCollectionDate.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm");
            //lblBGCollectionDate.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            //txtHBVCollectionDate.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");


        }

    }
    public class TreeNode
    {
        public string Code { get; set; } // Code for the antimicrobial group
        public string Name { get; set; } // Name of the group or antimicrobial
        public int AntimicrobialID { get; set; }  // Store the ID of the antimicrobial
        public List<TreeNode> Children { get; set; } // List of children (antimicrobials)

        // Constructor to initialize the Children property
        public TreeNode()
        {
            Children = new List<TreeNode>();
        }
    }

    public string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    public List<TreeNode> GetAntimicrobialGroups()
    {
        List<TreeNode> antimicrobialGroups = new List<TreeNode>();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();

            string groupQuery = "SELECT Code, Name FROM AntimicrobialGroups";
            using (SqlCommand groupCmd = new SqlCommand(groupQuery, conn))
            {
                using (SqlDataReader groupReader = groupCmd.ExecuteReader())
                {
                    while (groupReader.Read())
                    {
                        TreeNode groupNode = new TreeNode
                        {
                            Code = groupReader["Code"].ToString(),
                            Name = groupReader["Name"].ToString(),
                            Children = new List<TreeNode>()
                        };

                        string antimicrobialQuery = "SELECT AntimicrobialID, Name FROM Antimicrobial WHERE Code = @Code";
                        using (SqlCommand antimicrobialCmd = new SqlCommand(antimicrobialQuery, conn))
                        {
                            antimicrobialCmd.Parameters.AddWithValue("@Code", groupNode.Code);
                            using (SqlDataReader antimicrobialReader = antimicrobialCmd.ExecuteReader())
                            {
                                while (antimicrobialReader.Read())
                                {
                                    groupNode.Children.Add(new TreeNode
                                    {
                                        AntimicrobialID = Convert.ToInt32(antimicrobialReader["AntimicrobialID"]),
                                        Name = antimicrobialReader["Name"].ToString()
                                    });
                                }
                            }
                        }

                        antimicrobialGroups.Add(groupNode);
                    }
                }
            }
        }

        return antimicrobialGroups;
    }

    protected void btnSaveUrineCsResult_Click(object sender, EventArgs e)
    {
        int patientTestID = (int)HttpContext.Current.Session["PateintTestID"];

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("InsertUrineCultureSensitivity", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // Use current server date/time instead of user input
                string rawInput = txtCSCollectionDate.Text.Trim().TrimEnd(',');
                DateTime collectionDate;
                string[] formats = { "yyyy-MM-ddTHH:mm", "yyyy-MM-ddTHH:mm:ss" };

                if (DateTime.TryParseExact(rawInput, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out collectionDate))
                {
                    cmd.Parameters.AddWithValue("@CollectionDateTime", collectionDate);
                }
                else
                {
                    lblMessage.Text = "Invalid date format: " + rawInput;
                    return;
                }

                cmd.Parameters.AddWithValue("@SampleID", txtCSSampleID.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@MediaUsed", txtMediaUsed.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@IncubationConditions", txtIncubation.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@ColonyCount", txtColonyCount.Text.Trim().Replace(",", "").Replace(" ", ""));
                cmd.Parameters.AddWithValue("@OrganismName", ddlOrganism.SelectedValue.Trim());
                cmd.Parameters.AddWithValue("@MixedGrowth", chkMixedGrowth.Checked ? 1 : 0);
                cmd.Parameters.AddWithValue("@Remarks", txtCSRemarks.Text.Trim().Replace(",", ""));


                try
                {
                    conn.Open();
                    int newId = Convert.ToInt32(cmd.ExecuteScalar());
                    if (newId > 0)
                    {
                        if (UpdateTestStatus(patientTestID))
                        {
                            int patientId = Convert.ToInt32(ViewState["SelectedPatientId"]);
                            if (GetPatientTestCount(patientId) == 0)
                            {
                                UpdatePatientStatus(patientId);
                            }
                        }
                    }
                    lblMessage.Text = "Record saved successfully. ID: " + newId;
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                }
            }
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "refreshPage", "location.reload();", true);

    }


    //Perfectly working below method for antimicrobial
    protected void btnSave_Click(object sender, EventArgs e)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();

            foreach (RepeaterItem groupItem in rptAntimicrobialGroups.Items)
            {
                Repeater rptAntimicrobials = (Repeater)groupItem.FindControl("rptAntimicrobials");

                foreach (RepeaterItem item in rptAntimicrobials.Items)
                {
                    HiddenField hfAntimicrobialID = (HiddenField)item.FindControl("hfAntimicrobialID");
                    TextBox txtValue1 = (TextBox)item.FindControl("txtValue1");
                    TextBox txtValue2 = (TextBox)item.FindControl("txtValue2");

                    // Get values after trimming spaces and commas
                    string sensitive1 = txtValue1.Text.Trim().Trim(',');
                    string sensitive2 = txtValue2.Text.Trim().Trim(',');

                    // If both are empty, skip to the next item
                    if (string.IsNullOrWhiteSpace(sensitive1) && string.IsNullOrWhiteSpace(sensitive2))
                    {
                        continue;
                    }

                    // Get and clean AntimicrobialID
                    string antimicrobialIDValue = hfAntimicrobialID.Value.Trim().Trim(',');

                    // Skip if AntimicrobialID is empty
                    if (string.IsNullOrEmpty(antimicrobialIDValue))
                    {
                        continue;
                    }

                    // Convert to HashSet to remove duplicate IDs
                    HashSet<int> antimicrobialIDs = new HashSet<int>();

                    foreach (string id in antimicrobialIDValue.Split(','))
                    {
                        int antimicrobialID;
                        if (int.TryParse(id.Trim(), out antimicrobialID))
                        {
                            antimicrobialIDs.Add(antimicrobialID);
                        }
                    }

                    // Insert only once per unique AntimicrobialID
                    foreach (int antimicrobialID in antimicrobialIDs)
                    {
                        string query = "INSERT INTO CultureAntimicrobialSensitivity " +
                                       "(TestID, AntimicrobialID, Sensitive1, Sensitive2, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) " +
                                       "VALUES (@TestID, @AntimicrobialID, @Sensitive1, @Sensitive2, @CreatedBy, @CreatedDate, @ModifiedBy, @ModifiedDate)";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@TestID", 1);
                            cmd.Parameters.AddWithValue("@AntimicrobialID", antimicrobialID);
                            cmd.Parameters.AddWithValue("@Sensitive1", string.IsNullOrEmpty(sensitive1) ? DBNull.Value : (object)sensitive1);
                            cmd.Parameters.AddWithValue("@Sensitive2", string.IsNullOrEmpty(sensitive2) ? DBNull.Value : (object)sensitive2);
                            cmd.Parameters.AddWithValue("@CreatedBy", "admin");
                            cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                            cmd.Parameters.AddWithValue("@ModifiedBy", "admin");
                            cmd.Parameters.AddWithValue("@ModifiedDate", DateTime.Now);

                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }
        }
    }

    [WebMethod]
    public static void SaveImageToViewState(string base64Image, string key)
    {
        // Convert base64 string to byte array
        byte[] imageBytes = Convert.FromBase64String(base64Image.Split(',')[1]);

        // Store in ViewState (must use a static HttpContext to access ViewState in static method)
        HttpContext.Current.Session[key] = imageBytes;
    }
    protected void btnSaveTestDetail_Click(object sender, EventArgs e)
    {
        string result = commentText.Text.Replace(",", "");
        string result2 = commentText2.Text.Replace(",", "");
        string resultText = Request.Form["resultText"].Replace(",", "");
        string resultText2 = Request.Form["resultText2"].Replace(",", "");
        string code = txtTestResultCode.Text.Trim().Replace(",", "");
        string code2 = txtTestResultCode2.Text.Trim().Replace(",", "");
        byte[] image1 = HttpContext.Current.Session["Image1"] as byte[];
        byte[] image2 = HttpContext.Current.Session["Image2"] as byte[];
        int patientTestID = (int)HttpContext.Current.Session["PateintTestID"];
        string createdBy = Session["Username"] != null ? Session["Username"].ToString() : null;
        if (string.IsNullOrEmpty(createdBy))
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError", "alert('User not logged in.');", true);
            return;
        }
        DateTime createdDate = DateTime.Now;
        DateTime modifiedDate = DateTime.Now;
        int rowAfftcted = 0;
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                if (string.IsNullOrEmpty(result) || string.IsNullOrEmpty(result2))
                {
                    string query = @"
                UPDATE TextTypeResult 
                SET 
                    Result = @Result, 
                    Result2 = @Result2, 
                    ModifiedDate = @ModifiedDate, 
                    ModifiedBy = @ModifiedBy 
                WHERE TestID = @TestID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TestID", patientTestID);
                        cmd.Parameters.AddWithValue("@Result", resultText.Replace(",", ""));
                        cmd.Parameters.AddWithValue("@Result2", resultText2.Replace(",", ""));
                        cmd.Parameters.AddWithValue("@ModifiedDate", modifiedDate);
                        cmd.Parameters.AddWithValue("@ModifiedBy", createdBy);
                        rowAfftcted = cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    string checkQuery = "SELECT COUNT(*) FROM TextTypeResult WHERE TestID = @TestID AND Code = @Code";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@TestID", patientTestID);
                        checkCmd.Parameters.AddWithValue("@Code", code);
                        int recordExists = (int)checkCmd.ExecuteScalar();

                        if (recordExists > 0)
                        {
                            string updateQuery = @"
                        UPDATE TextTypeResult 
                        SET 
                            Result = @Result, 
                            Result2 = @Result2, 
                            ModifiedDate = @ModifiedDate, 
                            ModifiedBy = @ModifiedBy 
                        WHERE TestID = @TestID AND Code = @Code";
                            using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                            {
                                updateCmd.Parameters.AddWithValue("@TestID", patientTestID);
                                updateCmd.Parameters.AddWithValue("@Code", code);
                                updateCmd.Parameters.AddWithValue("@Result", resultText.Replace(",", ""));
                                updateCmd.Parameters.AddWithValue("@Result2", resultText2.Replace(",", ""));
                                updateCmd.Parameters.AddWithValue("@ModifiedDate", modifiedDate);
                                updateCmd.Parameters.AddWithValue("@ModifiedBy", createdBy);
                                rowAfftcted = updateCmd.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            string insertQuery = @"
                        INSERT INTO TextTypeResult 
                            (TestID, Result, Result2, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, Code, Code2) 
                        VALUES 
                            (@TestID, @Result, @Result2, @CreatedDate, @CreatedBy, @ModifiedDate, @ModifiedBy, @Code, @Code2);
                        SELECT SCOPE_IDENTITY();";

                            using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                            {
                                cmd.Parameters.AddWithValue("@TestID", patientTestID);
                                cmd.Parameters.AddWithValue("@Result", result.Replace(",", ""));
                                cmd.Parameters.AddWithValue("@Result2", result2.Replace(",", ""));
                                cmd.Parameters.AddWithValue("@Code", code.Replace(",", ""));
                                cmd.Parameters.AddWithValue("@Code2", code2.Replace(",", ""));
                                cmd.Parameters.AddWithValue("@CreatedDate", createdDate);
                                cmd.Parameters.AddWithValue("@CreatedBy", createdBy);
                                cmd.Parameters.AddWithValue("@ModifiedDate", createdDate);
                                cmd.Parameters.AddWithValue("@ModifiedBy", createdBy);
                                rowAfftcted = cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
                if (image1 != null)
                {
                    InsertImageIntoDatabase(conn, patientTestID, image1, "Image 1 Description");
                }
                if (image2 != null)
                {
                    InsertImageIntoDatabase(conn, patientTestID, image2, "Image 2 Description");
                }
                if (rowAfftcted > 0)
                {
                    if (UpdateTestStatus(patientTestID))
                    {
                        int patientId = Convert.ToInt32(ViewState["SelectedPatientId"]);
                        if (GetPatientTestCount(patientId) == 0)
                        {
                            UpdatePatientStatus(patientId);
                        }
                    }
                }
                ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess", "alert('Data and images saved successfully!');", true);
                Response.Redirect("frmLaboratory.aspx");

            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError", string.Format("alert('Error: {0}');", ex.Message), true);
        }
    }

    private void BindDropdown()
    {
        // Create a connection to the SQL Server database
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            try
            {
                // Open the connection
                conn.Open();

                // Create a SQL command to fetch the data
                string query = "SELECT TOP (1000) [ColourID], [Colour] FROM [Color]";
                SqlCommand cmd = new SqlCommand(query, conn);

                // Execute the query and get the data in a DataReader
                SqlDataReader reader = cmd.ExecuteReader();

                // Check if there is data
                if (reader.HasRows)
                {
                    // Bind the data to the DropDownList
                    ddlColour.DataSource = reader;
                    ddlColour.DataTextField = "Colour"; // Text to display in dropdown
                    ddlColour.DataValueField = "ColourID"; // Value of the selected item
                    ddlColour.DataBind();
                }

                // Close the DataReader
                reader.Close();
            }
            catch (Exception ex)
            {
                // Handle any errors (e.g., display error message)
                Console.WriteLine("Error: " + ex.Message);
            }
        }
    }

    private void BindSpecificGravityDropdown()
    {
        // Create a connection to the SQL Server database
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            try
            {
                // Open the connection
                conn.Open();

                // SQL query to fetch the specific gravity data
                string query = "SELECT TOP (1000) [GrevityCode], [Gravity] FROM [Gravity]";
                SqlCommand cmd = new SqlCommand(query, conn);

                // Execute the query and get the data in a DataReader
                SqlDataReader reader = cmd.ExecuteReader();

                // Check if there is data
                if (reader.HasRows)
                {
                    // Bind the data to the DropDownList
                    ddlSpecificGravity.DataSource = reader;
                    ddlSpecificGravity.DataTextField = "Gravity"; // Text to display in dropdown
                    ddlSpecificGravity.DataValueField = "GrevityCode"; // Value of the selected item
                    ddlSpecificGravity.DataBind();
                }

                // Close the DataReader
                reader.Close();
            }
            catch (Exception ex)
            {
                // Handle any errors (e.g., display error message)
                Console.WriteLine("Error: " + ex.Message);
            }
        }
    }
    
    private void InsertImageIntoDatabase(SqlConnection conn, int patientTestID, byte[] image, string description)
    {
        string query = @"
    INSERT INTO TestResultImages 
        (TestId, Slide, Description) 
    VALUES 
        (@TestId, @Slide, @Description)";

        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            // Add parameters
            cmd.Parameters.AddWithValue("@TestId", patientTestID); // Use patientTestID from session
            cmd.Parameters.AddWithValue("@Slide", image); // Store the image as bytes
            cmd.Parameters.AddWithValue("@Description", description); // Add a description

            // Execute the query
            cmd.ExecuteNonQuery();
        }
    }
    [WebMethod]
    public static string GetTestResults()
    {
        List<Dictionary<string, string>> results = new List<Dictionary<string, string>>();
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT TestID, RTRIM(Code) AS Code, RTRIM(Result) AS Result FROM [TextTypeResult]";
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Dictionary<string, string> row = new Dictionary<string, string>
            {
                { "TestID", reader["TestID"].ToString() },
                { "Code", reader["Code"].ToString() }
            };
                results.Add(row);
            }
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        string jsonResult = js.Serialize(results);
        System.Diagnostics.Debug.WriteLine("JSON Output: " + jsonResult); // Logs output
        return jsonResult;
    }
    [WebMethod]
    public static string GetTestResultById(string testId)
    {
        string result = string.Empty;
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT Result FROM [TextTypeResult] WHERE TestID = @TestID";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@TestID", testId);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                result = reader["Result"].ToString();
            }
        }

        return new JavaScriptSerializer().Serialize(result);
    }

    [WebMethod]
    public static string GetTestResultsForDropdown2()
    {
        List<Dictionary<string, string>> results = new List<Dictionary<string, string>>();
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        try
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT TestID, (Code2) AS Code2 FROM TextTypeResult"; // Using Code2 column
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    Dictionary<string, string> row = new Dictionary<string, string>
                {
                    { "TestID", reader["TestID"].ToString() },
                    { "Code2", reader["Code2"].ToString() }
                };
                    results.Add(row);
                }
            }
        }
        catch (Exception ex)
        {
            return new JavaScriptSerializer().Serialize(new { error = ex.Message });
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        string jsonResult = js.Serialize(results);
        System.Diagnostics.Debug.WriteLine("JSON Output: " + jsonResult); // Logs output
        return jsonResult;
    }

    [WebMethod]
    public static string GetTestResultByIdForDropdown2(string testId)
    {
        string result = string.Empty;
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        try
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT RTRIM(Result2) AS Result2 FROM [TextTypeResult] WHERE TestID = @TestID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TestID", testId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    result = reader["Result2"].ToString();
                }
            }
        }
        catch (Exception ex)
        {
            return new JavaScriptSerializer().Serialize(new { error = ex.Message });
        }

        return new JavaScriptSerializer().Serialize(result);
    }
    protected void btnUploadFiles_Click(object sender, EventArgs e)
    {
        // Retrieve PatientTestID from session
        int patientTestID = Convert.ToInt32(HttpContext.Current.Session["PateintTestID"]);

        // Check if files were uploaded
        HttpFileCollection files = HttpContext.Current.Request.Files;
        if (files.Count > 0)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    foreach (string fileKey in files)
                    {
                        HttpPostedFile file = files[fileKey];
                        if (file.ContentLength > 0)
                        {
                            // Convert the image to a byte array
                            byte[] imageBytes;
                            using (BinaryReader br = new BinaryReader(file.InputStream))
                            {
                                imageBytes = br.ReadBytes(file.ContentLength);
                            }

                            // Insert into TestResultImages
                            string imageQuery = @"
                        INSERT INTO TestResultImages 
                            (TestId, Slide, Description) 
                        VALUES 
                            (@TestId, @Slide, @Description)";

                            using (SqlCommand imageCmd = new SqlCommand(imageQuery, conn))
                            {
                                imageCmd.Parameters.AddWithValue("@TestId", patientTestID);
                                imageCmd.Parameters.AddWithValue("@Slide", imageBytes);
                                imageCmd.Parameters.AddWithValue("@Description", file.FileName); // Use file name as description
                                imageCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                // Show success message
                ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess", "alert('Files uploaded successfully!');", true);
            }
            catch (Exception ex)
            {
                // Handle exceptions
                ScriptManager.RegisterStartupScript(this, GetType(), "showError", string.Format("alert('Error: {0}');", ex.Message), true);
            }
        }
        else
        {
            // No files uploaded
            ScriptManager.RegisterStartupScript(this, GetType(), "showError", "alert('No files selected.');", true);
        }
    }
    private void LoadPatientData()
    {
        string query = @"SELECT * FROM [Patient] where Status = 1 ORDER BY CreatedDate DESC";

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
    [WebMethod]
    public static string GetTestComments()
    {
        List<Dictionary<string, string>> testResults = new List<Dictionary<string, string>>();

        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = "SELECT CommentCode FROM TestResultComments WHERE Status = 0";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Dictionary<string, string> test = new Dictionary<string, string>
                    {
                        { "CommentCode", reader["CommentCode"].ToString() }
                    };
                        testResults.Add(test);
                    }
                }
            }
        }

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        return serializer.Serialize(testResults);
    }

    [WebMethod]
    public static string GetCommentByCommentCode(string commentCode)
    {
        string comment = "";

        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = "SELECT TOP 1 Comments FROM TestResultComments WHERE CommentCode = @CommentCode AND Status = 0";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@CommentCode", commentCode);
                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    comment = result.ToString();

                    // Remove RTF formatting using Regex
                    comment = Regex.Replace(comment, @"\\[a-z]+\d*", " ");  // Remove \commands
                    comment = Regex.Replace(comment, @"[\{\}]", "");        // Remove { }
                    comment = Regex.Replace(comment, @"\\par", "\n");       // Convert \par to new line
                }
            }
        }

        return comment;
    }

    [WebMethod]
    public static string GetTestResults2()
    {
        List<CommentData> commentsList = new List<CommentData>();
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT CommentCode FROM TestResultComments WHERE TestCode = 'SPMN' AND Status = 0";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        commentsList.Add(new CommentData
                        {
                            CommentCode = reader["CommentCode"].ToString()
                        });
                    }
                }
            }
        }

        return JsonConvert.SerializeObject(commentsList);
    }

    public class CommentData
    {
        public string CommentCode { get; set; }
    }

    [WebMethod]
    public static string GetCommentDetails(string commentCode)
    {
        string commentText = "";
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT Comments FROM TestResultComments WHERE CommentCode = @CommentCode";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@CommentCode", commentCode);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    commentText = result.ToString();

                    commentText = CleanRTF(commentText);

                }
            }
        }

        return commentText.Trim();  // Returning the cleaned comment text
    }
    private static string CleanRTF(string rtfText)
    {
        // Remove RTF header and unnecessary metadata
        rtfText = Regex.Replace(rtfText, @"^{\\rtf.*?}", "", RegexOptions.Singleline);

        // Remove RTF control words (e.g., \par, \fs17, \viewkind4\uc1)
        rtfText = Regex.Replace(rtfText, @"\\[a-z]+\d*", "", RegexOptions.IgnoreCase);

        // Remove curly braces {} and extra slashes
        rtfText = Regex.Replace(rtfText, @"[{}]", "");

        // Replace \par with a new line for proper formatting
        rtfText = Regex.Replace(rtfText, @"\\par", "\n");

        // Remove any remaining escape sequences
        rtfText = Regex.Replace(rtfText, @"\\[^\s]+", "");

        return rtfText.Trim();
    }
    [WebMethod]
    public static string GetZnStainingOptions()
    {
        List<StainingData> stainingList = new List<StainingData>();
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT CommentCode FROM TestResultComments WHERE TestCode = 'ZN' AND Status = 0";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        stainingList.Add(new StainingData
                        {
                            CommentCode = reader["CommentCode"].ToString()
                        });
                    }
                }
            }
        }

        return JsonConvert.SerializeObject(stainingList);
    }

    [WebMethod]
    public static string GetZnCommentDetails(string commentCode)
    {
        string commentText = "";
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT Comments FROM TestResultComments WHERE CommentCode = @CommentCode";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@CommentCode", commentCode);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    commentText = CleanRTF2(result.ToString());
                }
            }
        }

        return commentText.Trim();
    }

    private static string CleanRTF2(string rtfText)
    {
        rtfText = Regex.Replace(rtfText, @"^{\\rtf.*?}", "", RegexOptions.Singleline);
        rtfText = Regex.Replace(rtfText, @"\\[a-z]+\d*", "", RegexOptions.IgnoreCase);
        rtfText = Regex.Replace(rtfText, @"[{}]", "");
        rtfText = Regex.Replace(rtfText, @"\\par", "\n");
        rtfText = Regex.Replace(rtfText, @"\\[^\s]+", "");

        return rtfText.Trim();
    }
    // Define the class
    public class StainingData
    {
        public string CommentCode { get; set; }
    }
    [WebMethod]
    public static string GetGramStainingOptions()
    {
        List<StainingData> stainingList = new List<StainingData>();
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT CommentCode FROM TestResultComments WHERE TestCode = 'GRS' AND Status = 0";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        stainingList.Add(new StainingData
                        {
                            CommentCode = reader["CommentCode"].ToString()
                        });
                    }
                }
            }
        }

        return JsonConvert.SerializeObject(stainingList);
    }

    [WebMethod]
    public static string GetGramCommentDetails(string commentCode)
    {
        string commentText = "";
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT Comments FROM TestResultComments WHERE CommentCode = @CommentCode";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@CommentCode", commentCode);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    commentText = CleanRTF(result.ToString());
                }
            }
        }

        return commentText.Trim();
    }
    [WebMethod]
    public static string GetCultureOptions()
    {
        List<StainingData> cultureList = new List<StainingData>();
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT CommentCode FROM TestResultComments WHERE TestCode = 'C/S' AND Status = 0";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        cultureList.Add(new StainingData
                        {
                            CommentCode = reader["CommentCode"].ToString()
                        });
                    }
                }
            }
        }

        return JsonConvert.SerializeObject(cultureList);
    }

    [WebMethod]
    public static string GetCultureCommentDetails(string commentCode)
    {
        string commentText = "";
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT Comments FROM TestResultComments WHERE CommentCode = @CommentCode";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@CommentCode", commentCode);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    commentText = CleanRTF(result.ToString());
                }
            }
        }

        return commentText.Trim();
    }
    [WebMethod]
    public static string SaveCultureSensitivity(string Specimen, string Direct, string ZnStain, string GramStain, string Culture, string Comments, string CreatedBy, string CreatedDate)
    {
        int patientTestID = Convert.ToInt32(HttpContext.Current.Session["PateintTestID"]);

        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        int testID = Convert.ToInt32(HttpContext.Current.Session["PatientTestID"]);

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = @"INSERT INTO CultureSensitivity 
                        (TestID, Specimen, Direct, ZNStain, GramStain, Culture, Comments, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) 
                        VALUES 
                        (@TestID, @Specimen, @Direct, @ZnStain, @GramStain, @Culture, @Comments, @CreatedBy, @CreatedDate, @ModifiedBy, GETDATE())";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Specimen", Specimen);
                cmd.Parameters.AddWithValue("@Direct", Direct);
                cmd.Parameters.AddWithValue("@TestID", patientTestID);
                cmd.Parameters.AddWithValue("@ZnStain", ZnStain);
                cmd.Parameters.AddWithValue("@GramStain", GramStain);
                cmd.Parameters.AddWithValue("@Culture", Culture);
                cmd.Parameters.AddWithValue("@Comments", Comments);
                cmd.Parameters.AddWithValue("@CreatedBy", CreatedBy);
                cmd.Parameters.AddWithValue("@CreatedDate", Convert.ToDateTime(CreatedDate));
                cmd.Parameters.AddWithValue("@ModifiedBy", CreatedBy); // Assuming same user modifies

                conn.Open();
                int rowsAffected = cmd.ExecuteNonQuery();

                return rowsAffected > 0 ? "Success" : "Error: No rows inserted.";
            }
        }
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
        LinkButton btnViewTest = (LinkButton)sender;
        patientId = Convert.ToInt32(btnViewTest.CommandArgument);
        var testResults = GetTestResults(patientId);

        ViewState["SelectedPatientId"] = patientId;
        Session["SelectedPatientId"] = patientId;
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
                    T.Type,
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
                    P.ID = @PatientID AND CD.Status=0;
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
    int Type;
    protected void btnAddTestResult_Click(object sender, EventArgs e)
    {
        //DataTable dt = ViewState["TestData"] as DataTable;
        //dt.Rows.Add("1", "2", "3", "4"); // Add empty row for new input
        //ViewState["TestData"] = dt;


        LinkButton btnAddTestResult = (LinkButton)sender;
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
        Type = Convert.ToInt32(args[5]);
        ViewState["Type"] = Type;
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
            query = @"
                    SELECT TCV.[CutoffValue], T.Code AS TestID, T.Name 
                    FROM [TestCutoffValues] AS TCV 
                    LEFT OUTER JOIN Test AS T ON T.Code = TCV.TestCode 
                    WHERE T.Code = '" + Code + @"';
                ";

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
            query = @"SELECT TNV.TestID, T.Unit, T.Code, T.Name, T.Type, TNV.FromValue, TNV.ToValue 
                  FROM [TestNormalValues] AS TNV 
                  INNER JOIN Test AS T ON T.ID = TNV.TestID 
                  WHERE TestID = " + TestID + " AND Gender = " + Gender + " AND TemplateID = " + TemplateID + " ORDER BY T.CreatedDate DESC";
        }

        DataTable dataTable = new DataTable();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand(query, conn);
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
        if (ViewState["TemplateID"].ToString() == "4" && ViewState["Type"].ToString() == "0")
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
        if (ViewState["TemplateID"].ToString() == "4" && ViewState["Type"].ToString() == "1"    )
        {
            string script = "$('#DLCTestModal').modal('show');";
            ClientScript.RegisterStartupScript(this.GetType(), "myScript", script, true);
        }
        if (ViewState["TemplateID"].ToString() == "6" || ViewState["Code"].ToString() == "3440")
        {
            if (ViewState["Code"].ToString() == "2800")
            {
                foreach (DataControlField column in gvAddResult.Columns)
                {
                    if (column.HeaderText == "Result P-N" || column.HeaderText == "Blood Group")
                    {
                        column.Visible = true;
                    }
                    if (column.HeaderText == "Unit" || column.HeaderText == "From Value" || column.HeaderText == "To Value" || column.HeaderText == "Cut off Value" || column.HeaderText == "Patient Value" || column.HeaderText == "Result")
                    {
                        column.Visible = false;
                    }
                }
            }
            else
            {
                foreach (DataControlField column in gvAddResult.Columns)
                {
                    if (column.HeaderText == "Result P-N")
                    {
                        column.Visible = true;
                    }
                    if (column.HeaderText == "Unit" || column.HeaderText == "From Value" || column.HeaderText == "To Value" || column.HeaderText == "Cut off Value" || column.HeaderText == "Patient Value" || column.HeaderText == "Result")
                    {
                        column.Visible = false;
                    }
                }
            }
        }
        if (ViewState["TemplateID"].ToString() == "3")
        {
            foreach (DataControlField column in gvAddResult.Columns)
            {
                if (column.HeaderText == "Cut off Value" || column.HeaderText == "Patient Value" || column.HeaderText == "Result P-N")
                {
                    column.Visible = true;
                }
                if (column.HeaderText == "Unit" || column.HeaderText == "From Value" || column.HeaderText == "To Value" || column.HeaderText == "Result")
                {
                    column.Visible = false;
                }
            }
        }
        if (ViewState["TemplateID"].ToString() == "5")
        {
            foreach (DataControlField column in gvAddResult.Columns)
            {
                if (column.HeaderText == "Result" || column.HeaderText == "Unit" || column.HeaderText == "Result P-N")
                {
                    column.Visible = true;
                }
                if (column.HeaderText == "From Value" || column.HeaderText == "To Value" || column.HeaderText == "Cut off Value" || column.HeaderText == "Patient Value")
                {
                    column.Visible = false;
                }
            }
        }
        if (ViewState["TemplateID"].ToString() == "27")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "openUrineTestModal();", true);
        }

        DataTable dt = ViewState["TestData"] as DataTable;
        gvAddResult.DataSource = ViewState["TestData"] as DataTable;
        gvAddResult.DataBind();
    }
    [WebMethod]
    public static string LoadDLCData(int TestID, int Type, int TemplateID, int PatientTestID)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        DataTable dt = new DataTable();
        HttpContext.Current.Session["PateintTestID"] = PatientTestID;
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("SP_GetParameterTest", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@TestID", TestID);
                cmd.Parameters.AddWithValue("@Type", Type);
                cmd.Parameters.AddWithValue("@TemplateID", TemplateID);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    con.Open();
                    da.Fill(dt); // First, fill the DataTable with data from the database

                    // Add the "Result" column if it doesn't exist
                    if (!dt.Columns.Contains("Result"))
                    {
                        dt.Columns.Add("Result", typeof(string));
                    }

                    // Ensure all rows have an empty "Result" value
                    foreach (DataRow row in dt.Rows)
                    {
                        row["Result"] = ""; // Set empty value
                    }

                    con.Close();
                }
            }
        }

        // Convert DataTable to JSON and return
        return JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string LoadCBCData(int TestID, int Gender)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        DataSet ds = new DataSet();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("SP_GetProfileTests", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@TestID", (object)TestID ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Gender", (object)Gender ?? DBNull.Value);

            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(ds);
        }

        // Access 4th table safely
        if (ds.Tables.Count > 3)
        {
            DataTable originalTable = ds.Tables[3];

            DataTable updatedTable = originalTable.Clone(); // Clone structure

            foreach (DataRow row in originalTable.Rows)
            {
                updatedTable.ImportRow(row);

                if (row["ID"].ToString() == "187") // After Creatinine
                {
                    DataRow newRow = updatedTable.NewRow();
                    newRow["ID"] = 186; // Unique ID (or use "BUN186" if string)
                    newRow["Name"] = "BUN/CREATININE RATIO";
                    newRow["Unit"] = "Ratio";
                    newRow["FromValue"] = "8";
                    newRow["ToValue"] = "22";

                    updatedTable.Rows.Add(newRow);
                }
            }

            // Replace original table with updated one
            ds.Tables.RemoveAt(3);
            ds.Tables.Add(updatedTable);

            // Use updated table for JSON serialization
            return JsonConvert.SerializeObject(updatedTable);
        }

        // Fallback in case there aren't enough tables
        return JsonConvert.SerializeObject(new DataTable());
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
        DropDownList ddlResultBloodGroup = row.FindControl("ddlResultBloodGroup") as DropDownList;

        string TESTID = (row.Cells[GetColumnIndexByHeaderText("Test ID")].Text ?? string.Empty).Trim();
        string TestName = (row.Cells[GetColumnIndexByHeaderText("Test Name")].Text ?? string.Empty).Trim();
        string fromValue = (row.Cells[GetColumnIndexByHeaderText("From Value")].Text ?? string.Empty).Trim();
        string toValue = (row.Cells[GetColumnIndexByHeaderText("To Value")].Text ?? string.Empty).Trim();
        string unit = (row.Cells[GetColumnIndexByHeaderText("Unit")].Text ?? string.Empty).Trim();
        string BloodGroup = (row.Cells[GetColumnIndexByHeaderText("Blood Group")].Text ?? string.Empty).Trim();

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
        if (!string.IsNullOrWhiteSpace(ddlResultBloodGroup.SelectedValue))
        {
           result = "Blood: " + ddlResultBloodGroup.SelectedValue + " & Rh: " + result;
        }
        if (!string.IsNullOrWhiteSpace(ddlResult.SelectedValue) && !string.IsNullOrWhiteSpace(txtResult.Text))
        {
           result = result + " ("+ddlResult.SelectedValue+")";
        }
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
                cmd.Parameters.AddWithValue("@ParameterCode", !string.IsNullOrWhiteSpace(TESTID) ? TESTID : (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Parameter", !string.IsNullOrWhiteSpace(TestName) ? TestName : (object)DBNull.Value);
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
                cmd.Parameters.AddWithValue("@Status", "2");

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

    protected void btnSaveUrineResult_Click(object sender, EventArgs e)
    {
        int patientTestID = Convert.ToInt32(HttpContext.Current.Session["PateintTestID"]);

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("SP_UrineDataInsert", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // Add parameters while handling NULL values
                cmd.Parameters.AddWithValue("@TestID", patientTestID);
                cmd.Parameters.AddWithValue("@Colour", string.IsNullOrWhiteSpace(ddlColour.Text) ? (object)DBNull.Value : ddlColour.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@SPGravity", string.IsNullOrWhiteSpace(ddlSpecificGravity.Text) ? (object)DBNull.Value : ddlSpecificGravity.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Turbidity", string.IsNullOrWhiteSpace(txtTurbidity.Text) ? (object)DBNull.Value : txtTurbidity.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Deposit", string.IsNullOrWhiteSpace(txtDeposit.Text) ? (object)DBNull.Value : txtDeposit.Text.Trim().Replace(",", ""));

                // Chemical Examination
                cmd.Parameters.AddWithValue("@PH", string.IsNullOrWhiteSpace(txtPH.Text) ? (object)DBNull.Value : txtPH.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Sugar", string.IsNullOrWhiteSpace(txtSugar.Text) ? (object)DBNull.Value : txtSugar.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Ketones", string.IsNullOrWhiteSpace(txtKetones.Text) ? (object)DBNull.Value : txtKetones.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Proteins", string.IsNullOrWhiteSpace(txtProteins.Text) ? (object)DBNull.Value : txtProteins.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Blood", string.IsNullOrWhiteSpace(txtBlood.Text) ? (object)DBNull.Value : txtBlood.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Heamoglobin", string.IsNullOrWhiteSpace(txtHaemoglobin.Text) ? (object)DBNull.Value : txtHaemoglobin.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Uroilinogen", string.IsNullOrWhiteSpace(txtUrobilinogen.Text) ? (object)DBNull.Value : txtUrobilinogen.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Bilirubin", string.IsNullOrWhiteSpace(txtBilirubin.Text) ? (object)DBNull.Value : txtBilirubin.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Nitrite", string.IsNullOrWhiteSpace(txtNitrite.Text) ? (object)DBNull.Value : txtNitrite.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@SpotProtein", string.IsNullOrWhiteSpace(txtSpotUrinaryProtein.Text) ? (object)DBNull.Value : txtSpotUrinaryProtein.Text.Trim().Replace(",", ""));

                // Microscopic Examination
                cmd.Parameters.AddWithValue("@PusCells", string.IsNullOrWhiteSpace(txtPusCells.Text) ? (object)DBNull.Value : txtPusCells.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@RedBloodCell", string.IsNullOrWhiteSpace(txtRBC.Text) ? (object)DBNull.Value : txtRBC.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@EpithelialCells", string.IsNullOrWhiteSpace(txtEpithelialCells.Text) ? (object)DBNull.Value : txtEpithelialCells.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@GramlarCasts", string.IsNullOrWhiteSpace(txtCastsGranular.Text) ? (object)DBNull.Value : txtCastsGranular.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@RBCCasts", string.IsNullOrWhiteSpace(txtCastsRBC.Text) ? (object)DBNull.Value : txtCastsRBC.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@WBCCasts", string.IsNullOrWhiteSpace(txtCastsWBC.Text) ? (object)DBNull.Value : txtCastsWBC.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@HyalineCasts", string.IsNullOrWhiteSpace(txtCastsHyaline.Text) ? (object)DBNull.Value : txtCastsHyaline.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@CellularCasts", string.IsNullOrWhiteSpace(txtCastsCellular.Text) ? (object)DBNull.Value : txtCastsCellular.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@OtherCasts", string.IsNullOrWhiteSpace(txtCastsOther.Text) ? (object)DBNull.Value : txtCastsOther.Text.Trim().Replace(",", ""));

                // Crystals
                cmd.Parameters.AddWithValue("@UricAcidCrystals", string.IsNullOrWhiteSpace(txtCrystalsUricAcid.Text) ? (object)DBNull.Value : txtCrystalsUricAcid.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@CalcuimOxalateCrystals", string.IsNullOrWhiteSpace(txtCrystalsCalciumOxalate.Text) ? (object)DBNull.Value : txtCrystalsCalciumOxalate.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@TriplePhosphate", string.IsNullOrWhiteSpace(txtCrystalsTriplePhosphate.Text) ? (object)DBNull.Value : txtCrystalsTriplePhosphate.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@OtherCrystal", string.IsNullOrWhiteSpace(txtCrystalsOther.Text) ? (object)DBNull.Value : txtCrystalsOther.Text.Trim().Replace(",", ""));

                // Additional
                cmd.Parameters.AddWithValue("@Organisms", string.IsNullOrWhiteSpace(txtOrganisms.Text) ? (object)DBNull.Value : txtOrganisms.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Amorphous", string.IsNullOrWhiteSpace(txtAmorphous.Text) ? (object)DBNull.Value : txtAmorphous.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Misc", string.IsNullOrWhiteSpace(txtMisc.Text) ? (object)DBNull.Value : txtMisc.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@Notes", string.IsNullOrWhiteSpace(txtNotes.Text) ? (object)DBNull.Value : txtNotes.Text.Trim().Replace(",", ""));
                cmd.Parameters.AddWithValue("@OtherCastsLebel", string.IsNullOrWhiteSpace(txtCastsOther.Text) ? (object)DBNull.Value : txtCastsOther.Text.Trim().Replace(",", ""));

                // Created/Modified Info
                cmd.Parameters.AddWithValue("@CreatedBy", "YourUsername"); // Replace with actual username logic
                cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@ModifiedBy", DBNull.Value);
                cmd.Parameters.AddWithValue("@ModifiedDate", DBNull.Value);

                try
                {
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected != 0)
                    {
                        // Update related test and patient status logic
                        if (UpdateTestStatus(patientTestID))
                        {
                            int patientId = Convert.ToInt32(Session["SelectedPatientId"]);
                            if (GetPatientTestCount(patientId) == 0)
                            {
                                UpdatePatientStatus(patientId);
                            }
                        }
                    }
                    //                if (ViewState["TestID"] == null || ViewState["Gender"] == null ||
                    //ViewState["TemplateID"] == null || ViewState["Code"] == null)
                    //                {
                    //                    System.Diagnostics.Debug.WriteLine("One or more ViewState variables are null.");
                    //                    return;
                    //                }

                    BindGrid(Convert.ToInt32(ViewState["TestID"]),
                             ViewState["Gender"].ToString(),
                             Convert.ToInt32(ViewState["TemplateID"]),
                             Convert.ToInt32(ViewState["Code"]));


                    gvAddResult.EditIndex = -1;
                    BindGrid(Convert.ToInt32(ViewState["TestID"]), ViewState["Gender"].ToString(), Convert.ToInt32(ViewState["TemplateID"]), Convert.ToInt32(ViewState["Code"]));
                    Response.Redirect("../Site/frmLaboratory.aspx", true);
                    // Consider adding a success message here
                }
                catch (Exception ex)
                {
                    Response.Redirect("../Site/frmLaboratory.aspx", true);
                    System.Diagnostics.Debug.WriteLine("Error inserting urine data: " + ex.Message);
                }
            }
        }
    }

    protected void btnDLC_Click(object sender, EventArgs e)
    {
        //string txtNewValue = Request.Form["txtNewValue"]; // Fetch value directly from form

        //string NewValue = txtNewValue.Text;


    }

    public class DLCTestResult
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Result { get; set; }
        public string Comments { get; set; }
        public string Unit { get; set; }
        public string NormalValue { get; set; }
        public bool? EditableRow { get; set; }
        public decimal? CriticalValueLowerBound { get; set; }
        public decimal? CriticalValueUpperBound { get; set; }
        public string ReportName { get; set; }
        public string Format { get; set; }
        public int? SortOrder { get; set; }
        public bool? CalculatedValue { get; set; }
        public string CalculatedValueFormula { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string Remarks { get; set; }
        public string GroupReportName { get; set; }
        public int? TestProfileId { get; set; }
        public int? TestCode { get; set; }
        public string TestHeading { get; set; }
        public decimal? FromValue { get; set; }
        public string TextValue { get; set; }
        public decimal? ToValue { get; set; }
        public string ValueFormat { get; set; }
    }

    [WebMethod]
    public static string UpdateItems(string updatedData)
    {
        try
        {
            // Deserialize JSON string into a list of objects
            List<DLCTestResult> updatedItems = JsonConvert.DeserializeObject<List<DLCTestResult>>(updatedData);
            Site_frmLaboratory obj = new Site_frmLaboratory();
            obj.InsertIntoDatabase(updatedItems, obj.connectionString);

            foreach (var item in updatedItems)
            {
                // Example: Save to database
                // DatabaseHelper.UpdateItem(item.ItemId, item.Result);
            }

            return "Success";
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }
    [WebMethod]
    public static string UpdateItemsCBC(string updatedData)
    {
        try
        {
            // Deserialize JSON string into a list of objects
            List<DLCTestResult> updatedItems = JsonConvert.DeserializeObject<List<DLCTestResult>>(updatedData);
            Site_frmLaboratory obj = new Site_frmLaboratory();
            obj.InsertIntoDatabase(updatedItems, obj.connectionString);

            foreach (var item in updatedItems)
            {
                // Example: Save to database
                // DatabaseHelper.UpdateItem(item.ItemId, item.Result);
            }

            return "Success";
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }
    public void InsertIntoDatabase(List<DLCTestResult> results, string connectionString)
    {
        int successCount = 0; // Counter to track successful inserts

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            int patientTestID = Convert.ToInt32(HttpContext.Current.Session["PateintTestID"]);

            foreach (var item in results.Where(r => !string.IsNullOrEmpty(r.Result)))
            {
                using (SqlCommand cmd = new SqlCommand("SP_InsertTestResultValueType", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TestID", (object)patientTestID ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@ParameterCode", (object)item.ID ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Parameter", (object)item.Name ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Result", (object)item.Result ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Comments", (object)item.Comments ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Unit", (object)item.Unit ?? DBNull.Value);
                    // Handle NormalValue formatting
                    cmd.Parameters.AddWithValue("@NormalValue",
                                             (item.FromValue.HasValue && item.ToValue.HasValue)
                                                 ? (object)(item.FromValue + " - " + item.ToValue)
                                                 : DBNull.Value);
                    cmd.Parameters.AddWithValue("@EditableRow", (object)item.EditableRow ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CriticalValueLowerBound", (object)item.CriticalValueLowerBound ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CriticalValueUpperBound", (object)item.CriticalValueUpperBound ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@ReportName", (object)item.ReportName ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Format", (object)item.Format ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@SortOrder", (object)item.SortOrder ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CalculatedValue", (object)item.CalculatedValue ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CalculatedValueFormula", (object)item.CalculatedValueFormula ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CreatedBy", (object)item.CreatedBy ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CreatedDate", (object)DateTime.Now ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@ModifiedBy", (object)item.ModifiedBy ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@ModifiedDate", (object)item.ModifiedDate ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Remarks", (object)item.Remarks ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@GroupReportName", (object)item.GroupReportName ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@TestProfileId", (object)item.TestProfileId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@TestCode", (object)item.TestCode ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@TestHeading", (object)item.TestHeading ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@FromValue", (object)item.FromValue ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@TextValue", (object)item.TextValue ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@ToValue", (object)item.ToValue ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@ValueFormat", (object)item.ValueFormat ?? DBNull.Value);

                    int rowsAffected = cmd.ExecuteNonQuery(); // Execute command

                    if (rowsAffected > 0)
                    {
                        successCount++; // Increment success count if insert was successful
                    }
                }
            }
            if (successCount > 0)
            {
                // Update related test and patient statsssus logic
                if (UpdateTestStatus(patientTestID))
                {
                    int patientId = Convert.ToInt32(Session["SelectedPatientId"]);
                    if (GetPatientTestCount(patientId) == 0)
                    {
                        UpdatePatientStatus(patientId);
                    }
                }
            }
            else
            {
                Console.WriteLine("No data was inserted. Ensure valid results exist.");
            }
        }

        Console.WriteLine("Data inserted successfully using stored procedure!");
    }


    protected void btnSaveSemen_Click(object sender, EventArgs e)
    {

        /* ---------- 0. Safety checks ---------- */
        if (Session["PateintTestID"] == null)
        {
            ClientScript.RegisterStartupScript(GetType(), "msg",
                "alert('Patient not selected!');", true);
            return;
        }

        int patientTestID = Convert.ToInt32(HttpContext.Current.Session["PateintTestID"]);  // moved into a variable

        int? semenID = null;

        using (SqlConnection conn = new SqlConnection(
                   ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
        using (SqlCommand cmd = new SqlCommand("usp_SemenAnalysis_Save", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            /* 1) single OUTPUT parameter */
            SqlParameter idParam = new SqlParameter("@SemenAnalysisID", SqlDbType.Int);
            idParam.Direction = ParameterDirection.InputOutput;
            idParam.Value = DBNull.Value;
            cmd.Parameters.Add(idParam);

            /* 2) patient‑related inputs */
            cmd.Parameters.Add("@PatientTestID", SqlDbType.Int).Value = patientTestID;

            /* 3) non‑decimal inputs */
            cmd.Parameters.AddWithValue("@CollectionDateTime",
                ParseDateTime(txtCollectionDateTime.Text));

            cmd.Parameters.AddWithValue("@SampleID",
                txtSampleID.Text.Trim().Replace(",", ""));

            string sampleSource = rdoSampleTaken.Checked ? "L"
                                : rdoSampleBrought.Checked ? "B" : null;
            cmd.Parameters.AddWithValue("@SampleSource",
                (object)sampleSource ?? DBNull.Value);

            cmd.Parameters.AddWithValue("@IntervalEA_Min",
                ParseInt(txtIntervalEA.Text));

            cmd.Parameters.AddWithValue("@Appearance",
                string.IsNullOrWhiteSpace(ddlAppearance.SelectedValue)
                    ? (object)DBNull.Value
                    : ddlAppearance.SelectedValue.Trim().Replace(",", ""));

            cmd.Parameters.AddWithValue("@Liquefaction",
                string.IsNullOrWhiteSpace(ddlLiquefaction.SelectedValue)
                    ? (object)DBNull.Value
                    : ddlLiquefaction.SelectedValue.Trim().Replace(",", ""));

            cmd.Parameters.AddWithValue("@Consistency",
                string.IsNullOrWhiteSpace(DropDownList1.SelectedValue)
                    ? (object)DBNull.Value
                    : DropDownList1.SelectedValue.Trim().Replace(",", ""));

            cmd.Parameters.AddWithValue("@PusCells", TextBox4.Text.Trim().Replace(",", ""));
            cmd.Parameters.AddWithValue("@RedBloodCells", txtRedBloodCells.Text.Trim().Replace(",", ""));
            cmd.Parameters.AddWithValue("@EpithelialCells", TextBox5.Text.Trim().Replace(",", ""));
            cmd.Parameters.AddWithValue("@Miscellaneous", txtMiscellaneous.Text.Trim().Replace(",", ""));

            cmd.Parameters.AddWithValue("@NoteShort", txtNoteShort.Text.Trim().Replace(",", ""));
            cmd.Parameters.AddWithValue("@NoteDetailedHTML", txtNoteEditor.Text.Trim().Replace(",", ""));

            /* 4) DECIMAL inputs (via helper) */
            AddDecimalParam(cmd, "@DurationAbstinenceDays", txtAbstinence.Text, 6, 2);
            AddDecimalParam(cmd, "@Volume_mL", txtVolume.Text, 5, 2);
            AddDecimalParam(cmd, "@pH", TextBox3.Text, 6, 2);

            AddDecimalParam(cmd, "@RapidProgressionPct", txtRapidProg.Text, 5, 2);
            AddDecimalParam(cmd, "@NonProgressiveMotilityPct", txtNonProg.Text, 5, 2);
            AddDecimalParam(cmd, "@SlowProgressionPct", txtSlowProg.Text, 5, 2);
            AddDecimalParam(cmd, "@DeadPct", txtDead.Text, 5, 2);
            AddDecimalParam(cmd, "@AgglutinationPct", txtAgglutination.Text, 5, 2);
            AddDecimalParam(cmd, "@VitalityPctLive", txtVitality.Text, 5, 2);
            AddDecimalParam(cmd, "@Concentration_MillPerMl", txtConcentration.Text, 10, 2);

            AddDecimalParam(cmd, "@NormalMorphologyPct", txtNormal.Text, 5, 2);
            AddDecimalParam(cmd, "@AbnormalMorphologyPct", txtAbnormal.Text, 5, 2);
            AddDecimalParam(cmd, "@HeadDefectsPct", txtHeadDefects.Text, 5, 2);
            AddDecimalParam(cmd, "@TailDefectsPct", txtTailDefects.Text, 5, 2);
            AddDecimalParam(cmd, "@NeckMidpieceDefectsPct", txtNeckMidpieceDefects.Text, 5, 2);
            AddDecimalParam(cmd, "@CytoplasmicDropletsPct", txtCytoplasmicDroplets.Text, 5, 2);
            AddDecimalParam(cmd, "@PinheadPct", txtPinhead.Text, 5, 2);

            AddDecimalParam(cmd, "@SpermMARTestPct", txtSpermMAR.Text, 5, 2);

            /* 5) Execute */
            conn.Open();

            int rowsAffected = cmd.ExecuteNonQuery();
            if (rowsAffected != 0)
            {
                // Update related test and patient status logic
                if (UpdateTestStatus(patientTestID))
                {
                    int patientId = Convert.ToInt32(HttpContext.Current.Session["SelectedPatientId"]);
                    if (GetPatientTestCount(patientId) == 0)
                    {
                        UpdatePatientStatus(patientId);
                    }
                }
            }
            semenID = idParam.Value == DBNull.Value ? (int?)null
                                                    : Convert.ToInt32(idParam.Value);
        }
        
        /* 6) Notify user */
        ScriptManager.RegisterStartupScript(
            this, GetType(), "saved",
            "alert('Semen analysis saved successfully.');", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "refreshPage", "location.reload();", true);

    }
    private void AddDecimalParam(SqlCommand cmd,
                                string name,
                                string text,
                                byte precision,
                                byte scale)
    {
        SqlParameter p = cmd.Parameters.Add(name, SqlDbType.Decimal);
        p.Precision = precision;   // must match the proc/table definition
        p.Scale = scale;

        decimal val;
        if (decimal.TryParse(text, NumberStyles.Any,
                             CultureInfo.InvariantCulture, out val))
            p.Value = val;          // good numeric value
        else
            p.Value = DBNull.Value; // blank or invalid → NULL
    }
    private object ParseInt(string text)
    {
        int result;
        return int.TryParse(text, out result) ? (object)result : DBNull.Value;
    }
    private object ParseDateTime(string text)
    {
        if (string.IsNullOrWhiteSpace(text))
            return DBNull.Value;

        DateTime dt;
        if (DateTime.TryParseExact(
                text.Trim(),
                new[] { "yyyy-MM-ddTHH:mm", "yyyy-MM-ddTHH:mm:ss" },
                CultureInfo.InvariantCulture,
                DateTimeStyles.AssumeLocal,
                out dt))
            return dt;

        if (DateTime.TryParse(
                text.Trim(),
                CultureInfo.CurrentCulture,
                DateTimeStyles.AssumeLocal,
                out dt))
            return dt;

        return DBNull.Value;
    }

    protected void btnSaveReport_Click(object sender, EventArgs e)
    {
        int? hbElectroID = null; // For new insert; use an actual value for update

        using (SqlConnection conn = new SqlConnection(
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
        using (SqlCommand cmd = new SqlCommand("usp_HB_Electrophoresis_Save", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            
            // Add all form inputs
            cmd.Parameters.Add("@CollectionDateTime", SqlDbType.DateTime).Value = DBNull.Value;
            // …or simply don’t add the parameter at all…
            object sessionValue = HttpContext.Current.Session["PateintTestID"];
            if (sessionValue != null && sessionValue.ToString() != "")
            {
                cmd.Parameters.AddWithValue("@HBElectroID", Convert.ToInt64(sessionValue));
            }
            else
            {
                cmd.Parameters.AddWithValue("@HBElectroID", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@SampleID", txtHBESampleID.Text.Trim().Replace(",", ""));

            cmd.Parameters.AddWithValue("@HBA_Pct", ParseNullableDecimal(txtHBA.Text));
            cmd.Parameters.AddWithValue("@HBF_Pct", ParseNullableDecimal(txtHBF.Text));
            cmd.Parameters.AddWithValue("@HBS_Pct", ParseNullableDecimal(txtHBS.Text));
            cmd.Parameters.AddWithValue("@HBA2_Pct", ParseNullableDecimal(txtHBA2.Text));
            cmd.Parameters.AddWithValue("@HBA1_Pct", ParseNullableDecimal(txtHBA1.Text));
            cmd.Parameters.AddWithValue("@HBD_Pct", ParseNullableDecimal(txtHBD.Text));
            cmd.Parameters.AddWithValue("@HBE_Pct", ParseNullableDecimal(txtHBE.Text));
            cmd.Parameters.AddWithValue("@HBDSE_Pct", ParseNullableDecimal(txtHBCombined.Text));
            cmd.Parameters.AddWithValue("@Others_Pct", ParseNullableDecimal(txtOthers.Text));

            cmd.Parameters.AddWithValue("@Comments", txtComment.Text.Trim().Replace(",", ""));

            // You need to fetch WYSIWYG content via JS into a hidden field before submitting
            string detailedComment = txtDetailedComment.Value != null
                ? txtDetailedComment.Value.Trim().Replace(",", "")
                : null;

            cmd.Parameters.AddWithValue("@DetailedComment", (object)detailedComment ?? DBNull.Value);

            cmd.Parameters.AddWithValue("@UserName", (User.Identity.Name ?? "System").Replace(",", ""));

            conn.Open();
            int patientTestID = Convert.ToInt32(Session["PateintTestID"]);

            int rowsAffected = cmd.ExecuteNonQuery();
            if (rowsAffected != 0)
            {
                // Update related test and patient status logic
                if (UpdateTestStatus(patientTestID))
                {
                    int patientId = Convert.ToInt32(Session["SelectedPatientId"]);
                    if (GetPatientTestCount(patientId) == 0)
                    {
                        UpdatePatientStatus(patientId);
                    }
                }
            }
            // You can show success message, refresh GridView, etc.
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "refreshPage", "location.reload();", true);
    }
    private object ParseNullableDecimal(string input)
    {
        decimal val;                              // declare first
        if (decimal.TryParse(input, out val))
            return val;                           // boxed decimal
        else
            return DBNull.Value;
    }

    protected void btnSaveStoolCS_Click(object sender, EventArgs e)
    {
        // 0.  Basic safety checks
        if (Session["PateintTestID"] == null)   // (typo preserved from your code)
        {
            ClientScript.RegisterStartupScript(GetType(), "msg",
     "alert('Patient not selected!');", true);

            return;
        }

        int patientTestID = Convert.ToInt32(Session["PateintTestID"]);
        string cs = System.Configuration.ConfigurationManager
                       .ConnectionStrings["DefaultConnection"].ConnectionString;   // adjust name

        // helper to return DBNull.Value when the control is blank/“Select”
        Func<string, object> NullOrValue = v =>
             string.IsNullOrEmpty(v) ? (object)DBNull.Value : v;

        try
        {
            using (SqlConnection conn = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("dbo.SP_StoolExamination_Save", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                /* ---------- Parameters ---------- */
                cmd.Parameters.Add("@PatientTestID", SqlDbType.Int)
                              .Value = patientTestID;

                cmd.Parameters.Add("@Color", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlColor.SelectedValue);
                cmd.Parameters.Add("@Odour", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlOdour.SelectedValue);
                cmd.Parameters.Add("@Consistency", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlConsistency.SelectedValue);
                cmd.Parameters.Add("@Reaction", SqlDbType.NVarChar, 10)
                              .Value = NullOrValue(ddlReaction.SelectedValue);

                cmd.Parameters.Add("@Parasite", SqlDbType.NVarChar, 100)
                              .Value = NullOrValue(txtParasite.Text.Trim());

                cmd.Parameters.Add("@Mucus", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlMucus.SelectedValue);
                cmd.Parameters.Add("@FrankBlood", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlFrankBlood.SelectedValue);
                cmd.Parameters.Add("@OccultBlood", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlOccultBlood.SelectedValue);

                cmd.Parameters.Add("@Ova", SqlDbType.NVarChar, 50)
                              .Value = NullOrValue(ddlOva.SelectedValue);
                cmd.Parameters.Add("@CystsOfProtozoa", SqlDbType.NVarChar, 50)
                              .Value = NullOrValue(ddlCysts.SelectedValue);
                cmd.Parameters.Add("@VegetativeForms", SqlDbType.NVarChar, 50)
                              .Value = NullOrValue(ddlVegetative.SelectedValue);

                cmd.Parameters.Add("@PusCellsPerHPF", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(txtPusCells.Text.Trim());
                cmd.Parameters.Add("@RedBloodCellsPerHPF", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(txtRBC.Text.Trim());

                cmd.Parameters.Add("@Macrophages", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlMacrophages.SelectedValue);
                cmd.Parameters.Add("@EpithelialCells", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlEpithelial.SelectedValue);
                cmd.Parameters.Add("@YeastCells", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlYeast.SelectedValue);
                cmd.Parameters.Add("@Fat", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlFat.SelectedValue);
                cmd.Parameters.Add("@MuscleCells", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlMuscleCells.SelectedValue);
                cmd.Parameters.Add("@Starch", SqlDbType.NVarChar, 20)
                              .Value = NullOrValue(ddlStarch.SelectedValue);

                cmd.Parameters.Add("@Remarks", SqlDbType.NVarChar)
                              .Value = NullOrValue(txtRemarks.Text.Trim());

                // output parameter if you need the new ID later
                //SqlParameter outID = cmd.Parameters.Add("@NewID", SqlDbType.Int);
                //outID.Direction = ParameterDirection.Output;

                conn.Open();

                int rowsAffected = cmd.ExecuteNonQuery();
                if (rowsAffected != 0)
                {
                    // Update related test and patient status logic
                    if (UpdateTestStatus(patientTestID))
                    {
                        int patientId = Convert.ToInt32(Session["SelectedPatientId"]);
                        if (GetPatientTestCount(patientId) == 0)
                        {
                            UpdatePatientStatus(patientId);
                        }
                    }
                }
                //int newID = (outID.Value != DBNull.Value) ? (int)outID.Value : 0;

                // tell the UI
                //           ClientScript.RegisterStartupScript(GetType(), "ok",
                //"alert('Saved successfully. ID = " + newID + "');", true);

                // TODO: clear/reset controls, refresh grid, close modal, etc.
            }
        }
        catch (Exception ex)
        {
            string.Format("alert('Error saving record: {0}');", ex.Message.Replace("'", "\\'"));

        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "refreshPage", "location.reload();", true);
    }

    protected void btnSaveHcvPcrResult_Click(object sender, EventArgs e)
    {
        //------------------------------------------------------------
        // 1) Get raw HTML from hidden field
        //------------------------------------------------------------
        string html = HiddenEditorContent.Value;           // e.g. "<p><b>Hello, world</b></p>"

        if (string.IsNullOrWhiteSpace(html))
        {
            lblStatus.CssClass = "text-danger ml-3";
            lblStatus.Text = "Please enter notes before saving.";
            return;
        }

        //------------------------------------------------------------
        // 2) Strip commas exactly the same way you did elsewhere
        //------------------------------------------------------------
        string cleanedHtml = html.Trim().Replace(",", ""); // ← NO commas now

        //------------------------------------------------------------
        // 3) Optional foreign‑key to parent HCV‑PCR row
        //------------------------------------------------------------
        int? resultID = null;   // Example: resultID = int.Parse(hdnHcvPcrResultID.Value);

        //------------------------------------------------------------
        // 4) Insert (or update) via stored procedure
        //------------------------------------------------------------
        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        try
        {
            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand("dbo.usp_HcvPcrQuantitationNotes_Save", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@NoteID", SqlDbType.Int).Value = 0;    // 0 ⇒ INSERT
                cmd.Parameters["@NoteID"].Direction = ParameterDirection.InputOutput;

                object sessionValue = HttpContext.Current.Session["PateintTestID"];
                if (sessionValue != null && sessionValue.ToString() != "")
                {
                    cmd.Parameters.AddWithValue("@HcvPcrResultID", Convert.ToInt64(sessionValue));
                }
                else
                {
                    cmd.Parameters.AddWithValue("@HcvPcrResultID", DBNull.Value);
                }


                cmd.Parameters.AddWithValue("@NotesHtml", cleanedHtml);    // ← comma‑free HTML
                cmd.Parameters.AddWithValue("@CreatedBy",
                    string.IsNullOrEmpty(User.Identity.Name) ? (object)DBNull.Value : User.Identity.Name);

                conn.Open();
                int patientTestID = Convert.ToInt32(Session["PateintTestID"]);

                int rowsAffected = cmd.ExecuteNonQuery();
                if (rowsAffected != 0)
                {
                    // Update related test and patient status logic
                    if (UpdateTestStatus(patientTestID))
                    {
                        int patientId = Convert.ToInt32(Session["SelectedPatientId"]);
                        if (GetPatientTestCount(patientId) == 0)
                        {
                            UpdatePatientStatus(patientId);
                        }
                    }
                }
                int savedNoteID = (int)cmd.Parameters["@NoteID"].Value;

                // Preview & status
                lblStatus.CssClass = "text-success ml-3";
                lblStatus.Text = "Notes saved (ID = " + savedNoteID + ").";
            }
        }
        catch (Exception ex)
        {
            lblStatus.CssClass = "text-danger ml-3";
            lblStatus.Text = "Error saving notes: " + ex.Message;
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "refreshPage", "location.reload();", true);
    }
}

