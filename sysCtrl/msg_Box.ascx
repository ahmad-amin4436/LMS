<%@ Control Language="C#" AutoEventWireup="true" CodeFile="msg_Box.ascx.cs" Inherits="sysCtrl_msg_Box" %>

<style>
        .custom_modal {
            width: 500px;
            min-height: 225px;
            /*background-color: #F7FBEF;*/
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

<div id="ctrl_MSG" class="custom_modal" runat="server">
    <div class="custom_header">
        <div style="padding: 15px; float: left;">
            <asp:Label ID="lblHearder" runat="server" Text="Label" Font-Names="Calibri" Font-Size="Large">Dr. Akmal Lab</asp:Label>
        </div>
        <div style="padding: 15px; float: right; text-align: right;">
            <asp:Button ID="btnClose" runat="server" Text="X" Font-Bold="true" OnClick="btnClose_Click" />
        </div>
    </div>
    <div class="err_MSG">
        <asp:Label ID="lbl_msg" runat="server" Text="Label" Font-Names="Calibri" Font-Size="Large"></asp:Label>
    </div>
    <div class="err_MSG_Button">
        <asp:Button ID="btn_OK" runat="server" Text="OK" Font-Bold="true" Width="100px" Height="25px" OnClick="btn_OK_Click" />
    </div>
</div>
