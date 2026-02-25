<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrystalReport.aspx.cs" Inherits="Site_frmCrystalReport" %>
<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.3500.0, Culture=neutral, PublicKeyToken=692FBEA5521E1304"
    Namespace="CrystalDecisions.Web" TagPrefix="cr" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
   <cr:CrystalReportViewer ID="CrystalReportViewer1" runat="server"
    AutoDataBind="true"
    EnableDatabaseLogonPrompt="false"
    EnableParameterPrompt="false"
    ToolPanelView="None"
    Width="100%"
    Height="1000px" />

<iframe id="iframeRpt" runat="server" width="100%" height="800px" style="border:none;"></iframe>
</body>
</html>
