using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Site_frmLogin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //ERR_MSG("");
        //ctrl_MSG.msg_Box_Close_Event += msg_Box_Close_Event;
        try
        {
            if (IsPostBack == false)
            {
                //ERR_MSG("123", false);
                init_cmbs();
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

    public bool validateForm()
    {
        modMain objMN = new modMain();
        try
        {
            //if (txtUserID.Text.Length == 0)
            //{
            //    ERR_MSG("Username is required ...");
            //    return false;
            //}

            //if (txtPassword.Text.Length == 0)
            //{
            //    ERR_MSG("Password is required ...");
            //    return false;
            //}

            return true;
        }
        catch (Exception ex)
        {
            ERR_MSG(ex.Message);
            return false;
        }
        finally
        {
            objMN = null;
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



    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        //try
        //{
        //    if (validateForm() == true)
        //    {
        //        Session["Username"] = txtUserID.Text;
        //        Server.Transfer("../Site/frmIndex.aspx");
        //    }
        //}
        //catch (Exception ex)
        //{
        //    ERR_MSG(ex.Message);
        //}
        //finally
        //{

        //}
    }



    protected void btnSave_Click(object sender, EventArgs e)
    {

    }
}