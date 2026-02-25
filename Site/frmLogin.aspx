<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmLogin.aspx.cs" Inherits="Site_frmLogin" %>

<%@ Register Src="~/sysCtrl/msg_Box.ascx" TagPrefix="uc1" TagName="msg_Box" %>


<link href="../favicon.png" rel="shortcut icon" type="image/x-icon" />
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <title>Lab Management</title>

    <!-- Favicon -->
    <link rel="shortcut icon" href="../favicon.png" type="image/x-icon" />

    <!-- CSS -->
    <link id="Stylesheet" href="<%= ResolveUrl("~/Site/Login/css/LTR/Decibel_ltr.css") %>" rel="stylesheet" type="text/css" />

    <!-- JavaScript -->
    <script type="text/javascript" src="<%= ResolveUrl("~/Site/Login/script/jquery.min.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/Site/Login/script/reelslideshow.js") %>"></script>

    <script type="text/javascript">
        function stopscroll() {
            if (document.getElementById("divChangePassword").style.visibility == 'hidden') {
                $("body").css("overflow", "hidden");
            } else {
                $("body").css("overflow", "visible");
            }
        }
    </script>

    <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-28041744-1']);
        _gaq.push(['_trackPageview']);

        (function () {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
    </script>

    <style>
        .custom_modal {
            width: 500px;
            min-height: 225px;
            background-color: whitesmoke;
        }

        .custom_header {
            width: 500px;
            height: 50px;
            background-color: #5AD1F8;
        }

        .err_MSG {
            text-align: center;
            margin-top: 60px;
            margin-bottom: 50px;
        }

        .err_MSG_Button {
            text-align: center;
            margin-bottom: 20px;
        }

        .auto-style1 {
            width: 100%;
        }
    </style>
</head>
<body>
    <form id="form" runat="server">
        

        

           

          
       
        <script type="text/javascript">
            WebForm_AutoFocus('tb_UserId');
        </script>
    </form>
    <asp:Panel ID="pnlMSG" runat="server" Visible="false">
                        <uc1:msg_Box ID="ctrl_MSG" runat="server" />
                    </asp:Panel>
</body>
</html>

