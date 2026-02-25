 <%@ Page Title="Lab Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="frmExpense.aspx.cs" Inherits="Site_frmExpense" %>

<%@ Register Src="~/sysCtrl/msg_Box.ascx" TagPrefix="uc1" TagName="msg_Box" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
    <div class="container">
        <div class="row border mb-2 bg-white">
            <div class="col-md-12 bg-blueGradient text-white font-weight-bold">
                <h6 class="mt-2 common-font"><strong><i class="fa fa-search mr-2" aria-hidden="true"></i> Search Expense</strong></h6>
            </div>

            <section class="col-md-12 mt-2">
                <div class="tab-content py-2">
                    <div class="row common-margin">
                        <div class="col-md-12 mb-3">
                            <span class="customGrey-btn rounded-0 text-dark border btn-sm p-2 border font-weight-bold">Search Expense Criteria </span>
                        </div>
                        <div class="col-md-4">
                            <div class="row">
                                <div class="col-md-4">
                                    <label for="" class="small-font font-weight-normal">Centers:</label>
                                </div>
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <asp:DropDownList ID="ddlCenters" runat="server" CssClass="form-control common-font mySelect2">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="row">
                                <div class="col-md-4">
                                    <label for="" class="small-font font-weight-normal">Expense Type:</label>
                                </div>
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <asp:DropDownList ID="ddlExpenseTypes" runat="server" CssClass="form-control common-font">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="row">
                                <div class="col-md-4">
                                    <label for="" class="small-font font-weight-normal">Search Text:</label>
                                </div>
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <input class="form-control common-font" type="text">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row common-margin">
                        <div class="col-md-4">
                            <div class="row">
                                <div class="col-md-4">
                                    <label for="" class="small-font font-weight-normal">From Date:</label>
                                </div>
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <input class="form-control common-font" type="date">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="row">
                                <div class="col-md-4">
                                    <label for="" class="small-font font-weight-normal">To Date:</label>
                                </div>
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <input class="form-control common-font" type="date">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="row">
                                <div class="col-md-12">
                                    <p class="float-right">
<asp:Button ID="btnSearch" runat="server" 
    CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" 
    Text="Search" OnClick="btnSearch_Click" />

          <button type="button" class="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" data-toggle="modal" data-target="#myModal">
                                            Add New
                                        </button>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <div class="container-fluid">
        <div class="row border mb-4 bg-white">
            <div class="col-md-12 bg-blueGradient text-white font-weight-bold">
                <h6 class="mt-2 common-font"><strong><i class="fa fa-bars mr-2" aria-hidden="true"></i> Expenses </strong></h6>
            </div>

            <section class="col-md-12 mt-2">
                <div class="col-md-12">
                    <p class="float-right">
                        <a onclick="printSection()" class="btn btn-primary float-right  font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" target="_blank">
                            Print <i class="fa fa-print" aria-hidden="true"></i>
                        </a>
                    </p>
                </div>
                    <div id="printArea">

                <table class="table table-bordered table-sm table-hover">
                    <thead class="bg-light">
                        <tr>
                            <th>Created Date</th>
                            <th>Expense Type</th>
                            <th>Employee</th>
                            <th>Amount</th>
                            <th>Description</th>
                            <th>Centers</th>
                            <th>Created By</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptExpenses" runat="server">
                            <ItemTemplate>
                                <tr class="common-font">
                                    <td><%# Eval("CreatedDate")%></td>
                                    <td><%# Eval("ExpenseTypeID") %></td>
                                    <td><%# Eval("EmployeeName") %></td>
                                    <td><%# Eval("Amount") %></td>
                                    <td><%# Eval("Description") %></td>
                                    <td><%# Eval("CenterID") %></td>
                                    <td><%# Eval("ExpenseCreatedBy") %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
                        </div>

            </section>
    </div>

</div>
    <!-- The Modal start -->
    <div class="modal" id="myModal">
        <div class="modal-dialog">
            <div class="modal-content rounded-0">
                <!-- Modal Header -->
                <div class="modal-header bg-light">
                    <h4 class="modal-title">Expense</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Centers:</label>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
<asp:DropDownList ID="ddlModalCenters" runat="server" CssClass="form-control common-font mySelect2">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Expense Type:</label>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
<asp:DropDownList ID="ddlModalExpenseTypes" runat="server" CssClass="form-control common-font">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Employee Name:</label>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
<input type="text" id="txtEmployeeName" class="form-control" name="employeeName" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Amount:</label>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
<input type="text" id="txtAmount" class="form-control small-font" value="0" name="amount" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Description:</label>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
<textarea id="txtDescription" class="form-control" name="description"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal footer -->
                <div class="modal-footer">
                    <asp:Button ID="btnSaveExpense" runat="server" CssClass="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm" Text="Save" OnClick="btnSaveExpense_Click" />
                    <button type="button" class="btn btn-primary float-right  font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    </div>
    <!-- The Modal end -->
    <script>
        function printSection() {
    var printContents = document.getElementById("printArea").innerHTML;
    var printWindow = window.open('', '', 'height=600,width=800');

    printWindow.document.write('<html><head><title>Print</title>');

    // Copy all existing styles
    var styles = document.querySelectorAll("link[rel='stylesheet'], style");
    styles.forEach(function (style) {
        printWindow.document.write(style.outerHTML);
    });

    // Additional print-specific styles
    printWindow.document.write(`<style>
        @media print { 
            @page { size: landscape; size: Tabloid; margin: 10mm; } 
            body { font-size: 12px; }
        }

        /* Logo Styling */
        .print-logo {
            display: block;
            margin: 0 auto 10px; /* Center the logo and add spacing */
            width: 150px; /* Adjust size */
            height: auto;
        }
    </style>`);

    printWindow.document.write('</head><body>');

    // Add the logo BEFORE "Total's Summary"
    printWindow.document.write('<img src="../Images/pathoXpert.png" class="print-logo" alt="Company Logo">')

    // Print the contents
    printWindow.document.write(printContents);
    printWindow.document.write('</body></html>');

    printWindow.document.close();

    // Ensure styles are fully loaded before printing
    printWindow.onload = function () {
        printWindow.focus();
        printWindow.print();
        printWindow.close();
    };
}



</script>
</asp:Content>