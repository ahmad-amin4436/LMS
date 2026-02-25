<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAccessRestricted.aspx.cs" Inherits="Site_frmAccessRestricted" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Access Restricted</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style type="text/css">
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f7fa;
            color: #333;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }
        
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
        }
        
        h1 {
            color: #d32f2f;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .icon {
            font-size: 60px;
            color: #d32f2f;
            margin-bottom: 20px;
        }
        
        .message {
            background-color: #ffebee;
            border-left: 4px solid #d32f2f;
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 0 4px 4px 0;
        }
        
        .allowed-pages {
            margin-top: 30px;
        }
        
        .allowed-pages h3 {
            color: #2c3e50;
            font-size: 18px;
            margin-bottom: 15px;
        }
        
        .page-list {
            list-style-type: none;
            padding: 0;
        }
        
        .page-list li {
            padding: 10px 15px;
            margin-bottom: 8px;
            background-color: #f8f9fa;
            border-radius: 4px;
            transition: all 0.3s ease;
        }
        
        .page-list li:hover {
            background-color: #e9ecef;
            transform: translateX(5px);
        }
        
        .page-list a {
            color: #2980b9;
            text-decoration: none;
            display: block;
        }
        
        .page-list a:hover {
            text-decoration: underline;
        }
        
        .footer {
            margin-top: 30px;
            text-align: center;
            color: #7f8c8d;
            font-size: 14px;
        }
        
        @media (max-width: 600px) {
            .container {
                margin: 20px;
                padding: 20px;
            }
            
            h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <div class="icon">⛔</div>
                <h1>Access Restricted</h1>
            </div>
            
            <div class="message">
                    <asp:Label ID="lblRestrictedPage" runat="server" ForeColor="Red"></asp:Label>
                <p>You don't have sufficient permissions to access the requested page. Please contact your system administrator if you believe this is an error.</p>
            </div>
            
            <div class="allowed-pages">
                <h3>You have access to the following pages:</h3>
                <ul class="page-list">
                    <asp:Literal ID="litAllowedPages" runat="server"></asp:Literal>
                </ul>
            </div>
            
            <div class="footer">
                <p>© <%= DateTime.Now.Year %> PathoXpert. All rights reserved.</p>
            </div>
        </div>
    </form>
</body>
</html>