using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Site_frmAccessRestricted : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string Instance = ConfigurationManager.AppSettings["Instance"];
            // Display the restricted page name
            if (Session["AccessDeniedPage"] != null)
            {
                lblRestrictedPage.Text = "Access Denied: You don't have permission to access <b>"
                                          + Session["AccessDeniedPage"].ToString() + "</b>.";
            }

            // Get the access names from the session
            if (Session["AccessNames"] != null)
            {
                List<string> accessNames = (List<string>)Session["AccessNames"];
                string pageLinks = "";

                foreach (string page in accessNames)
                {
                    // Use string concatenation instead of interpolation
                    if (!string.IsNullOrWhiteSpace(Instance)) {
                        pageLinks += "<li><a href='" + Instance + "/" + page + "'>" + page + "</a></li>";

                    }
                    else
                    {
                        pageLinks += "<li><a href='/" + page + "'>" + page + "</a></li>";

                    }
                }

                litAllowedPages.Text = pageLinks; // Set the text of the Literal control
            }
            else
            {
                litAllowedPages.Text = "<li><i>No pages available</i></li>"; // Message if no pages found
            }

        }
    }
}