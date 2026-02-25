using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SiteMaster : MasterPage
{
    private const string AntiXsrfTokenKey = "__AntiXsrfToken";
    private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
    private string _antiXsrfTokenValue;

    protected void Page_Init(object sender, EventArgs e)
    {
        // The code below helps to protect against XSRF attacks
        var requestCookie = Request.Cookies[AntiXsrfTokenKey];
        Guid requestCookieGuidValue;
        if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
        {
            // Use the Anti-XSRF token from the cookie
            _antiXsrfTokenValue = requestCookie.Value;
            Page.ViewStateUserKey = _antiXsrfTokenValue;
        }
        else
        {
            // Generate a new Anti-XSRF token and save to the cookie
            _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
            Page.ViewStateUserKey = _antiXsrfTokenValue;

            var responseCookie = new HttpCookie(AntiXsrfTokenKey)
            {
                HttpOnly = true,
                Value = _antiXsrfTokenValue
            };
            if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
            {
                responseCookie.Secure = true;
            }
            Response.Cookies.Set(responseCookie);
        }

        Page.PreLoad += master_Page_PreLoad;
    }

    void master_Page_PreLoad(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Set Anti-XSRF token
            ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
            ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
        }
        else
        {
            // Validate the Anti-XSRF token
            if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
            {
                throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Username"] == null)
        {
            Response.Redirect("~/frmLoginNew.aspx", false); // Use ~ for root-relative path
            Context.ApplicationInstance.CompleteRequest();  // Avoids ThreadAbortException
            return;
        }
        lblUserName.Text = Session["Username"].ToString();
        if (Session["AccessNames"] != null)
        {
            List<string> accessNames = (List<string>)Session["AccessNames"];

            // Show/hide navigation items based on access
            divReception.Visible = accessNames.Contains("Site/frmIndex.aspx");
            divLaboratory.Visible = accessNames.Contains("Site/frmLaboratory.aspx");
            divDoctorApproval.Visible = accessNames.Contains("Site/frmDoctorApproval.aspx");
            divManagement.Visible = accessNames.Contains("Site/frmManagement.aspx");
            divExpense.Visible = accessNames.Contains("Site/frmExpense.aspx");
            divSearchPatient.Visible = accessNames.Contains("Site/frmSearchPatient.aspx");
            divAccount.Visible = accessNames.Contains("Site/frmExpense.aspx");
            divCash.Visible = accessNames.Contains("Site/frmCash.aspx");
            divaddnew.Visible = accessNames.Contains("Site/frmIndex.aspx");
        }
    }

}