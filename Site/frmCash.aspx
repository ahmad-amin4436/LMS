<%@ Page Title="Lab Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="frmCash.aspx.cs" Inherits="Site_frmCash" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager runat="server" />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="container-fluid">
                <div class="container">
                    <div class="row border mb-2 bg-white">
                        <div class="col-md-12 bg-blueGradient text-white font-weight-bold">
                            <h6 class="mt-2 common-font">
                                <strong><i class="fa fa-search mr-2" aria-hidden="true"></i> Search Criteria</strong>
                            </h6>
                        </div>
                        <section class="col-md-12 mt-2">
                            <div class="tab-content py-2">
                                <div class="row common-margin">
                                    <div class="col-md-12 mb-3">
                                        <span class="customGrey-btn rounded-0 text-dark border btn-sm p-2 font-weight-bold">
                                            Cash Summary Criteria
                                        </span>
                                    </div>
                                    <!-- Center -->
                                    <div class="col-md-3">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label class="small-font font-weight-normal">Center:</label>
                                            </div>
                                            <div class="col-md-8">
                                                <asp:DropDownList ID="ddlCenterName" runat="server"
                                                    CssClass="form-control common-font rounded-0 mySelect2"
                                                    AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlCenterName_SelectedIndexChanged" />
                                            </div>
                                        </div>
                                    </div>
                                    <!-- From Date -->
                                    <div class="col-md-4">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label class="small-font font-weight-normal">From Date:</label>
                                            </div>
                                            <div class="col-md-8">
                                                <div class="form-group">
                                                    <asp:TextBox runat="server" ID="txtFromDate" CssClass="form-control common-font" TextMode="DateTimeLocal" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- To Date -->
                                    <div class="col-md-4">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label class="small-font font-weight-normal">To Date:</label>
                                            </div>
                                            <div class="col-md-8">
                                                <div class="form-group">
                                                    <asp:TextBox runat="server" ID="txtToDate" CssClass="form-control common-font" TextMode="DateTimeLocal" />
                                                </div>
                                            </div>
                                            <div class="col-md-12">
                                                <p class="float-right">
                                                    <asp:Button runat="server" ID="btnSearchCashSumary" OnClick="btnSearchCashSumary_Click" Text="Search Summary" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" />
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                        </section>
                    </div>
                </div>
            </div>

            <div class="container-fluid">
                <div class="container">
                    <div class="row border mb-4 bg-white">
                        <div class="col-md-12 bg-blueGradient text-white font-weight-bold">
                            <h6 class="mt-2 common-font">
                                <strong><i class="fa fa-bars mr-2" aria-hidden="true"></i> Summary</strong>
                            </h6>
                        </div>
                        <div id="printArea">
                            <section class="col-md-12 mt-2">
                                <form>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <p class="float-right">
                                                <a onclick="printSection()" class="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" target="_blank">
                                                    Print <i class="fa fa-print" aria-hidden="true"></i>
                                                </a>
                                            </p>
                                        </div>
                                    </div>
                                    <!-- Total's Summary -->
                                    <div class="col-md-12 mb-3 border">
                                        <div class="row">
                                            <div class="col-md-12 mb-3">
                                                <span class="customGrey-btn rounded-0 text-dark border btn-sm p-2 font-weight-bold">Total's Summary</span>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="row p-2">
                                                    <div class="col-md-6"><strong>Total Amount</strong></div>
                                                    <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblTotalAmount" Text="0.00" /></span></div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="row p-2">
                                                    <div class="col-md-6"><strong>Grand Total</strong></div>
                                                    <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblGrandTotal" Text="0.00" /></span></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="row p-2">
                                                    <div class="col-md-6"><strong>Total Less</strong></div>
                                                    <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblLess" Text="0.00" /></span></div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="row p-2">
                                                    <div class="col-md-6"><strong>Total Due</strong></div>
                                                    <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblDue" Text="0.00" /></span></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <!-- Cash Summary -->
                                        <div class="col-md-6 mb-3 border">
                                            <div class="row">
                                                <div class="col-md-12 mb-3">
                                                    <span class="customGrey-btn rounded-0 text-dark border btn-sm p-2 font-weight-bold">Cash Summary</span>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="row p-2">
                                                        <div class="col-md-6"><strong>Total Amount Received:</strong></div>
                                                        <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblTotalAmountReceived" Text="0.00" /></span></div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="row p-2">
                                                        <div class="col-md-6"><strong>Total Due Amount Received:</strong></div>
                                                        <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblDueReceived" Text="0.00" /></span></div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="row p-2">
                                                        <div class="col-md-6"><strong>Total Expense Amount Paid:</strong></div>
                                                        <div class="col-md-6"><span class="float-right">0.00</span></div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="row p-2">
                                                        <div class="col-md-6"><strong>Cash Payment:</strong></div>
                                                        <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblCashTotalAmount" Text="0.00" /></span></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Bank Summary -->
                                        <div class="col-md-6 mb-3 border">
                                            <div class="row">
                                                <div class="col-md-12 mb-3">
                                                    <span class="customGrey-btn rounded-0 text-dark border btn-sm p-2 font-weight-bold">Bank Summary</span>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="row p-2">
                                                        <div class="col-md-6"><strong>Total Bank Amount</strong></div>
                                                        <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblBankPaid" Text="0.00" /></span></div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="row p-2">
                                                        <div class="col-md-6"><strong>Total Bank Due Received:</strong></div>
                                                        <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblBankDueReceived" Text="0.00" /></span></div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="row p-2">
                                                        <div class="col-md-6"><strong>Cheque Payment:</strong></div>
                                                        <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblChequeTotalAmount" Text="0.00" /></span></div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="row p-2">
                                                        <div class="col-md-6"><strong>Card Payment:</strong></div>
                                                        <div class="col-md-6"><span class="float-right"><asp:Label runat="server" ID="lblCardTotalAmount" Text="0.00" /></span></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- GridView -->
                                    <asp:GridView ID="gvCashSummary" runat="server" CssClass="table table-bordered table-sm table-hover common-font" AutoGenerateColumns="false" HeaderStyle-CssClass="bg-light font-weight-bold small-font">
                                        <Columns>
                                            <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                                            <asp:BoundField DataField="Sex" HeaderText="Sex" />
                                            <asp:BoundField DataField="Mobile" HeaderText="Mobile" />
                                            <asp:BoundField DataField="GrandTotal" HeaderText="Grand Total" DataFormatString=" {0:N2}" />
                                            <asp:BoundField DataField="TotalTests" HeaderText="Total Tests" />
                                            <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" />
                                            <asp:BoundField DataField="Due" HeaderText="Due Amount" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Age" HeaderText="Age" />
                                            <asp:BoundField DataField="Less" HeaderText="Less" DataFormatString=" {0:N2}" />
                                            <asp:BoundField DataField="TotalAmount" HeaderText="Total Amount" DataFormatString=" {0:N2}" />
                                            <asp:BoundField DataField="CreatedDate" HeaderText="Created Date" DataFormatString="{0:yyyy-MM-dd}" />
                                            <asp:BoundField DataField="Receiveable" HeaderText="Receiveable"  />
                                        </Columns>
                                    </asp:GridView>

                                    <!-- Alerts -->
                                    <div class="col-md-12">
                                        <div class="alert alert-success text-danger">
                                            <strong>Net Bank & Cash Amount:</strong>
                                            <span class="float-right"><asp:Label runat="server" ID="lblNetbankcashAmount" Text="0.00" /></span>
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="alert alert-warning text-dark">
                                            <strong>Total Adjustment Amount</strong>
                                            <span class="float-right"><asp:Label runat="server" ID="lblTotalAdjustmentAmount" Text="0.00" /></span>
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="alert alert-info text-dark">
                                            <strong>Total Receivables</strong>
                                            <span class="float-right"><asp:Label runat="server" ID="lblTotalReceivables" Text="0.00" /></span>
                                        </div>
                                    </div>
                                </form>
                            </section>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                function printSection() {
                    var printContents = document.getElementById("printArea").innerHTML;
                    var printWindow = window.open('', '', 'height=600,width=800');

                    printWindow.document.write('<html><head><title>Print</title>');

                    var styles = document.querySelectorAll("link[rel='stylesheet'], style");
                    styles.forEach(function (style) {
                        printWindow.document.write(style.outerHTML);
                    });

                    printWindow.document.write(`<style>
                        @media print { 
                            @page { size: landscape; size: Tabloid; margin: 10mm; } 
                            body { font-size: 12px; }
                        }
                        .print-logo {
                            display: block;
                            margin: 0 auto 10px;
                            width: 150px;
                            height: auto;
                        }
                    </style>`);

                    printWindow.document.write('</head><body>');
                    printWindow.document.write('<img src="../Images/pathoXpert.png" class="print-logo" alt="Company Logo">');
                    printWindow.document.write(printContents);
                    printWindow.document.write('</body></html>');
                    printWindow.document.close();
                    printWindow.onload = function () {
                        printWindow.focus();
                        printWindow.print();
                        printWindow.close();
                    };
                }
            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>