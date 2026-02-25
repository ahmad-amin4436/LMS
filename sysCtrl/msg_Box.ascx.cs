using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class sysCtrl_msg_Box : System.Web.UI.UserControl
{
    public string str_MSG;
    public bool is_MSG = false;
    public bool is_ERR = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        btn_OK.Focus();
    }

    public void showControl()
    {
        try
        {
            btn_OK.Visible = false;
            //btn_YES.Visible = false;
            //btn_NO.Visible = false;

            if (is_MSG == true)
            {
                lbl_msg.ForeColor = Color.Green;
                btn_OK.Visible = true;
            }
            if (is_ERR == true)
            {
                btn_OK.Visible = true;
                lbl_msg.ForeColor = Color.Red;
                //str_MSG = str_MSG + "\n Plz contact to sys. admin.";
            }

            lbl_msg.Text = str_MSG;
            //lbldatetime.Text = str_DATE_TIME;
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
        finally
        {
        }
    }

    //Protected Sub btnClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnClose.Click
    //      RaiseEvent msg_Close_Event(txtSenderRef.Text)
    //End Sub
    // Public Event msg_Close_Event(ByVal strSENDERID As String)

    public event msg_Box_Close_EventEventHandler msg_Box_Close_Event;
    public delegate void msg_Box_Close_EventEventHandler(string strSENDERID);

    protected void btn_OK_Click(object sender, EventArgs e)
    {
        try
        {
            // Check if event is null
            if (msg_Box_Close_Event != null)
                msg_Box_Close_Event(string.Empty);
            //msg_Box_Close_Event.Invoke("123");
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    protected void btnClose_Click(object sender, EventArgs e)
    {
        try
        {
            // Check if event is null
            if (msg_Box_Close_Event != null)
                msg_Box_Close_Event(string.Empty);
            //msg_Box_Close_Event.Invoke("");
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }
}