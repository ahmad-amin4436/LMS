<%@ Page Title="Lab Report" Language="C#" AutoEventWireup="true" CodeFile="frmReport.aspx.cs" Inherits="Site_frmReport" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PathoXpert Lab - Report</title>
    <style>
        /* Reset margins and padding for printing */
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            font-size: 12px;
            color: #000;
            background: #fff;
        }
        
        .invoice-container {
            width: 210mm; /* A4 width */
            min-height: 297mm; /* A4 height */
            margin: 0 auto;
            padding: 15mm;
            box-sizing: border-box;
        }
        
        .invoice-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #ddd;
        }
        
        .lab-info {
            text-align: center;
            flex-grow: 1;
        }
        
        .lab-title {
            color: #0056b3;
            font-weight: bold;
            font-size: 24px;
            margin: 0;
        }
        
        .lab-tagline {
            color: #666;
            font-size: 14px;
            margin: 5px 0 0 0;
        }
        
        .patient-details {
            display: flex;
            margin-bottom: 20px;
        }
        
        .patient-column {
            flex: 1;
        }
        
        .info-label {
            font-weight: bold;
            display: inline-block;
            width: 120px;
        }
        
        .test-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        .test-table th {
            background-color: #f8f9fa;
            color: #212529;
            padding: 8px;
            text-align: left;
        }
        
        .test-table td {
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }
        
        .amount-summary {
            margin-left: auto;
            width: 300px;
        }
        
        .amount-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }
        
        .total-row {
            border-top: 2px solid #ddd;
            padding-top: 5px;
            margin-top: 5px;
            font-weight: bold;
        }
        
        .footer {
            margin-top: 30px;
            padding-top: 10px;
            border-top: 1px solid #ddd;
            text-align: center;
            font-size: 11px;
        }
        
        @media print {
            body {
                font-size: 10pt;
            }
            
            .invoice-container {
                padding: 10mm;
            }
            
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body>
     <form id="form1" runat="server">
        <div class="invoice-container">
            <!-- Header Section -->
            <div class="invoice-header">
                <div class="logo">
                    <img src="../Images/pathoXpert.png" alt="PathoXpert Lab" width="150" height="150" />
                </div>
                <div class="lab-info">
                    <h1 class="lab-title">PATHOXPERTS LABORATORY</h1>
                    <p class="lab-tagline">YOUR LAB - OUR SOLUTION | Accredited Medical Testing</p>
                </div>
                <div class="qr-code">
                    <asp:Image ID="imgQRCode" runat="server" Width="100" Height="100" />
                </div>
            </div>
            
            <!-- Patient Details -->
            <div class="patient-details">
                <div class="patient-column">
                    <div><span class="info-label">Patient Name:</span> <asp:Label ID="lblPatientName" runat="server" /></div>
                    <div><span class="info-label">Age/Sex:</span> <asp:Label ID="lblAgeSex" runat="server" /></div>
                    <div><span class="info-label">Patient ID:</span> <asp:Label ID="lblPatientID" runat="server" /></div>
                    <div><span class="info-label">Reference:</span> <asp:Label ID="lblReference" runat="server" /></div>
                </div>
                <div class="patient-column">
                    <div><span class="info-label">Reg. Date:</span> <asp:Label ID="lblRegDate" runat="server" /></div>
                    <div><span class="info-label">Consultant:</span> <asp:Label ID="lblConsultant" runat="server" /></div>
                    <div><span class="info-label">Patient No:</span> <asp:Label ID="lblPatientNumber" runat="server" /></div>
                    <div><span class="info-label">Location:</span> <asp:Label ID="lblRegLocation" runat="server" /></div>
                </div>
            </div>
            
            <!-- Test Details -->
          <h3>TEST Reports</h3>
            <asp:PlaceHolder ID="phTestResults" runat="server"></asp:PlaceHolder>
<asp:GridView ID="gvTestResults" runat="server" AutoGenerateColumns="true" OnRowDataBound="GvTestResults_RowDataBound" CssClass="table table-bordered table-sm table-hover common-font" HeaderStyle-CssClass="bg-light font-weight-bold small-font" />
<style>
    #gvTestResults {
    border-collapse: collapse;
    width: 100%;
    border: none; /* Remove outer border */
}

#gvTestResults th, 
#gvTestResults td {
    border: none; /* Remove all other borders */
    padding: 8px;
}

#gvTestResults tr td {
    border-bottom: 2px solid black; /* Apply lower border to each row */
}

</style>



           <%-- <!-- Amount Summary -->
            <div class="amount-summary">
                <div class="amount-row">
                    <span>Subtotal:</span>
                    <span><asp:Label ID="lblTotal" runat="server" /></span>
                </div>
                <div class="amount-row">
                    <span>Discount:</span>
                    <span><asp:Label ID="lblDiscount" runat="server" /></span>
                </div>
                <div class="amount-row total-row">
                    <span>Total Amount:</span>
                    <span><asp:Label ID="lblToBePaid" runat="server" /></span>
                </div>
                <div class="amount-row">
                    <span>Amount Paid:</span>
                    <span><asp:Label ID="lblPaid" runat="server" /></span>
                </div>
            </div>
            
            <!-- Collection Center Details -->
            <div class="collection-center">
                <h3>COLLECTION CENTER</h3>
                <div><span class="info-label">Center Name:</span> <asp:Label ID="lblCenterName" runat="server" /></div>
                <div><span class="info-label">Phone:</span> <asp:Label ID="lblPhoneNumber" runat="server" /></div>
                <div><span class="info-label">Email:</span> <asp:Label ID="lblEmail" runat="server" /></div>
                <div><span class="info-label">Address:</span> <asp:Label ID="lblAddress" runat="server" /></div>
            </div>--%>
            
            <!-- Footer -->
            <div class="footer">
                <p>03464436525 | pathoxpert@gmail.com | www.pathoxpert.com</p>
                <p>M-42 - Ashiyana Center Liberty Main Gulberg-III, Lahore | Quality Diagnostic Services Since 2004</p>
                <p>Thank you for choosing PathoXpert Lab. Please retain this invoice for your records.</p>
            </div>
            
            <!-- Print Button -->
            <div class="no-print" style="text-align: center; margin-top: 20px;">
                <button onclick="window.print()" style="padding: 8px 20px; background: #0056b3; color: white; border: none; cursor: pointer;">
                    Print Report
                </button>
            </div>
        </div>
    </form>
    
    <script>
        // Automatically trigger print dialog when page loads (optional)
        // window.onload = function() {
        //     setTimeout(function() {
        //         window.print();
        //     }, 500);
        // };
    </script>
</body>
</html>