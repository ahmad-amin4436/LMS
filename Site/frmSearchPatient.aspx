<%@ Page Title="Lab Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="frmSearchPatient.aspx.cs" Inherits="Site_frmSearchPatient" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Search Criteria Section -->
    <div class="container-fluid">
        <div class="container">
            <div class="row border mb-4 bg-white">
                <!-- Header Section -->
                <div class="col-md-12 bg-blueGradient text-white font-weight-bold">
                    <h6 class="mt-2 common-font">
                        <strong><i class="fa fa-search mr-2" aria-hidden="true"></i> Search Criteria</strong>
                    </h6>
                </div>

                <!-- Form Section -->
                <section class="col-md-12 mt-2">
                    <form role="form">
                        <div class="tab-content py-2">
                            <div class="row common-margin">
                                <!-- Section Header -->
                                <div class="col-md-12 mb-3">
                                    <span class="customGrey-btn rounded-0 text-dark border btn-sm p-2 font-weight-bold">Patient & Case Criteria</span>
                                </div>

                                <!-- Patient Details Inputs -->
                                <!-- Patient ID -->
                                <div class="col-md-3">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label class="small-font font-weight-normal">Patient ID:</label>
                                            </div>
                                       <div class="col-md-8">
                                            <asp:TextBox ID="txtPatientID" runat="server" CssClass="form-control common-font rounded" />
                                        </div>
                                    </div>
                                </div>

                                <!-- Name -->
                                <div class="col-md-3">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label class="small-font font-weight-normal">Name:</label>
                                        </div>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control common-font rounded" />
                                        </div>
                                    </div>
                                </div>

                                <!-- NIC -->
                                <div class="col-md-3">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label class="small-font font-weight-normal">NIC:</label>
                                        </div>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtNIC" runat="server" CssClass="form-control common-font rounded" />
                                        </div>
                                    </div>
                                </div>

                                <!-- Phone/Mobile -->
                                <div class="col-md-3">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label class="small-font font-weight-normal">Phone/Mobile:</label>
                                        </div>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control common-font rounded" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row common-margin">
                                <!-- Additional Details Inputs -->
                                <!-- Sex -->
                                <div class="col-md-3">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label class="small-font font-weight-normal">Gender:</label>
                                        </div>
                                        <div class="col-md-8">
                                        <asp:DropDownList ID="ddlSex" runat="server" CssClass="form-control common-font rounded">
                                            <asp:ListItem Value="" Text="---Select Gender---" />
                                            <asp:ListItem Value="Male" Text="Male" />
                                            <asp:ListItem Value="Female" Text="Female" />
                                            <asp:ListItem Value="Other" Text="Other" />

                                        </asp:DropDownList>

                                        </div>
                                    </div>
                                </div>

                                <!-- Email -->
                                <div class="col-md-3">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label class="small-font font-weight-normal">Email:</label>
                                        </div>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control common-font rounded" />
                                        </div>
                                    </div>
                                </div>

                                <!-- Center -->
<!-- Center Dropdown Section -->
<div class="col-md-3">
    <div class="row">
        <div class="col-md-4">
            <label class="small-font font-weight-normal">Center:</label>
        </div>
        <div class="col-md-8">
            <!-- Modified Dropdown for selecting Center -->
            <div class="dropdown">
                <asp:Button ID="btnCenter" runat="server" CssClass="form-control common-font rounded-0 text-left"
                    Text="Select Centers" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" />
                
                <!-- Dropdown Menu with scrollable content -->
                <asp:Panel ID="pnlCenterDropdown" runat="server" CssClass="dropdown-menu bg-light rounded-0" style="width:350px; max-height:300px; overflow-y:auto;">
                    <!-- Static Header -->
                    <div class="bg-light border-bottom p-1 sticky-top" style="background-color:#f8f9fa!important;">
                        <div class="row">
                            <div class="col-md-2">
                                <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="true" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                            </div>
                            <div class="col-md-3 small-font">ID</div>
                            <div class="col-md-7 small-font">Center Name</div>
                        </div>
                    </div>
                    
                    <!-- Dynamic Item List -->
                    <asp:Repeater ID="rptCenters" runat="server" OnItemDataBound="rptCenters_ItemDataBound">
                        <ItemTemplate>
                            <div class="mt-1 p-1 border-bottom">
                                <div class="row">
                                    <div class="col-md-2">
                                        <asp:CheckBox ID="chkCenter" runat="server" />
                                    </div>
                                    <div class="col-md-3 small-font">
                                        <asp:Literal ID="litCenterCode" runat="server" />
                                    </div>
                                    <div class="col-md-7 small-font">
                                        <asp:Literal ID="litCenterName" runat="server" />
                                    </div>
                                    <asp:HiddenField ID="hdnCenterID" runat="server" Value='<%# Eval("ID") %>' />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
            </div>
        </div>
    </div>
</div>                                <!-- Username -->
                                <div class="col-md-3">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label class="small-font font-weight-normal">Status:</label>
                                        </div>
                                        <div class="col-md-8">
                                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control common-font rounded">
                                            <asp:ListItem Value="" Text="---Select Status---" />
                                            <asp:ListItem Value="0" Text="New Patient" />
                                            <asp:ListItem Value="1" Text="At Laboratory" />
                                            <asp:ListItem Value="2" Text="At Doctor" />
                                            <asp:ListItem Value="3" Text="Conducted" />

                                        </asp:DropDownList>

                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Date Section -->
                            <div class="row common-margin bg-brown">
                                <div class="col-md-12 mb-3 mt-3">
                                </div>
                                <div class="col-md-3">
                                    <label class="small-font text-dark font-weight-normal">From Date:</label>
                                    <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control common-font rounded" TextMode="Date" />
                                </div>
                                <div class="col-md-3">
                                    <label class="small-font text-dark font-weight-normal">To Date:</label>
                                    <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control common-font rounded" TextMode="Date" />
                                </div>
                                <div class="col-md-4"></div>
                                <div class="col-md-2">
                                </div>
                            </div>
                        </div>
                    </form>
                </section>
            </div>
        </div>
    </div>

    <!-- Search Results Section -->
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
<div class="container-fluid">
    <div class="container">
        <div class="row border mb-4 bg-white">
            <div class="col-md-12 bg-blueGradient text-white font-weight-bold">
                <h6 class="mt-2 common-font">
                    <strong><i class="fa fa-bars mr-2" aria-hidden="true"></i> Search Results</strong>
                </h6>
            </div>
            <section class="col-md-12 mt-2">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table class="table table-bordered table-sm table-hover">
                            <thead class="bg-light">
                             <%--   <tr>
                                    <th></th>
                                    <th>Patient ID</th>
                                    <th>Patient Name</th>
                                    <th>Age/Sex</th>
                                    <th>MR #</th>
                                    <th>Nic</th>
                                    <th>Mobile #</th>
                                    <th>Date of Birth</th>
                                    <th>Registration Date</th>
                                    <th>Address</th>
                                </tr>--%>
                            </thead>
                            <tbody>
                                 <asp:Button ID="btnSearch" runat="server" Text="Search"
            CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm float-right move-up"
            OnClick="btnSearch_Click" />
                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm table-hover"
    AllowPaging="True" PageSize="10" 
    PagerSettings-Mode="NextPrevious" PagerSettings-Position="Bottom"
    OnPageIndexChanging="GridView1_PageIndexChanging" OnRowDataBound="GridView1_RowDataBound" >
    <Columns>
        
        <asp:BoundField DataField="ID" HeaderText="ID" />
        <asp:BoundField DataField="PatientNumber" HeaderText="Patient Number" />
        <asp:BoundField DataField="FirstName" HeaderText="Name" />
        <asp:BoundField DataField="Location" HeaderText="Location" />
        <asp:BoundField DataField="DateRegistered" HeaderText="Date Registered" DataFormatString="{0:MM/dd/yyyy}" />
        <asp:BoundField DataField="Sex" HeaderText="Gender" />
        <asp:BoundField DataField="NIC" HeaderText="NIC" />
        <asp:BoundField DataField="Mobile" HeaderText="Mobile #" />
        <asp:BoundField DataField="City" HeaderText="City" />
        <asp:BoundField DataField="StatusDescription" HeaderText="Status" />
       <asp:TemplateField HeaderText="Actions">
    <ItemTemplate>
        <div class="dropdown">
            <button type="button" class="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm dropdown-toggle" 
                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Click for actions">
                <i class="fa fa-ellipsis-v"></i> 
            </button>
            <div class="dropdown-menu dropdown-menu-right rounded-0">
                <asp:LinkButton ID="btnAddTest" runat="server" CssClass="dropdown-item common-font" 
                    CommandName="AddTest" CommandArgument='<%# Eval("ID") %>' OnClick="btnAddTest_Click"
                    title="Add or view tests"><i class="fa fa-flask mr-2"></i>Test</asp:LinkButton>
                <asp:LinkButton ID="btnSaveCase" runat="server" CssClass="dropdown-item common-font" 
                    CommandArgument='<%# Eval("ID") %>' OnClick="btnSaveCase_Click"
                    title="View or create invoice"><i class="fa fa-file-invoice-dollar mr-2"></i>Invoice</asp:LinkButton>
                <div class="dropdown-divider"></div>
                <asp:LinkButton ID="btnApprove" runat="server" CssClass="dropdown-item common-font" 
                    CommandName="Approve" CommandArgument='<%# Eval("ID") %>' OnClick="btnApprove_Click"
                    title="Report Header"><i class="fa fa-file-alt mr-2"></i>Report H</asp:LinkButton>
                <asp:LinkButton ID="btnApproveWH" runat="server" CssClass="dropdown-item common-font" 
                    CommandName="Approve" CommandArgument='<%# Eval("ID") %>' OnClick="btnApproveWH_Click"
                    title="Report With Header"><i class="fa fa-file-alt mr-2"></i>Report WH</asp:LinkButton>
                <asp:LinkButton ID="btnApproveG" runat="server" CssClass="dropdown-item common-font" 
                    CommandName="Approve" CommandArgument='<%# Eval("ID") %>' OnClick="btnApproveG_Click"
                    title="Report G With Header"><i class="fa fa-file-alt mr-2"></i>Report G WH</asp:LinkButton>
                <asp:LinkButton ID="btnApproveWG" runat="server" CssClass="dropdown-item common-font" 
                    CommandName="Approve" CommandArgument='<%# Eval("ID") %>' OnClick="btnApproveWG_Click"
                    title="Report WG"><i class="fa fa-file-alt mr-2"></i>Report WG</asp:LinkButton>
                <div class="dropdown-divider"></div>
                <asp:LinkButton ID="btnPrescription" runat="server" CssClass="dropdown-item common-font" 
                    CommandName="Prescription" CommandArgument='<%# Eval("ID") %>' OnClick="btnPrescription_Click"
                    title="View prescription"><i class="fa fa-prescription-bottle-alt mr-2"></i>Rx</asp:LinkButton>
                <asp:LinkButton ID="btnClearDues" runat="server" CssClass="dropdown-item common-font" 
                    CommandArgument='<%# Eval("ID") %>' OnClick="btnClearDues_Click"
                    title="View or pay dues"><i class="fa fa-money-check-alt mr-2"></i>Dues Remaining</asp:LinkButton>
            </div>
        </div>
    </ItemTemplate>
</asp:TemplateField>


    </Columns>

    <PagerTemplate>
    <div class="pagination-container">
        <div class="pagination-left">
            <span>Page <%= (GridView1.PageIndex + 1) %> of <%= GridView1.PageCount %> </span>
        </div>
        <div class="pagination-right">
            <asp:Button ID="btnPreviousPage" runat="server" Text="Previous Page" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" OnClick="PreviousPageButton_Click" 
                Enabled="<%# GridView1.PageIndex > 0 %>" />
            
            <asp:Button ID="btnNextPage" runat="server" Text="Next Page" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm float-right" OnClick="NextPageButton_Click" 
                Enabled="<%# GridView1.PageIndex < GridView1.PageCount - 1 %>" />
        </div>
        <div class="pagination-bottom">
            <span>Total Rows on Page: <%= GridView1.Rows.Count %></span>
        </div>
    </div>
</PagerTemplate>

</asp:GridView>

                            </tbody>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </section>
        </div>
    </div>
</div>
<!-- include jQuery and Bootstrap scripts/styles before / after as appropriate -->

<div class="modal fade dlc-test-button" id="DuesModal" tabindex="-1" role="dialog" aria-labelledby="DuesModal" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content rounded-0">
      <div class="modal-header bg-light">
        <h4 class="modal-title">Dues Details</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>

      <div class="modal-body">
        <div class="mb-2">
          <button id="btnAddRow" class="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm">+ Add Row</button>
        </div>

        <div class="table-responsive">
          <table id="duesTable" class="table table-bordered table-sm table-hover">
            <thead>
              <tr>
                <th style="width:34%;">Test / Description</th>
                <th style="width:12%;">Rate</th>
                <th style="width:12%;">Qty</th>
                <th style="width:12%;">Total</th>
                <th style="width:12%;">Paid</th>
                <th style="width:12%;">Due</th>
                <th style="width:6%;">Action</th>
              </tr>
            </thead>
            <tbody>
              <!-- rows added by JS -->
            </tbody>
            <tfoot>
              <tr>
                <th colspan="3" class="text-right">Grand Total</th>
                <th id="grandTotal">0.00</th>
                <th id="grandPaid">0.00</th>
                <th id="grandDue">0.00</th>
                <th></th>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>

      <div class="modal-footer">
        <button id="btnSaveDues" class="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm">Save</button>
        <button type="button" class="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" data-dismiss="modal">Cancel</button>
      </div>

    </div>
  </div>
</div>

    <style>
        .pagination-container {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    margin-top: 10px;
}

.pagination-left {
    flex: 1;
}

.pagination-right {
    display: flex;
    justify-content: flex-end;
    flex: 1;
}

.pagination-bottom {
    width: 100%;
    text-align: center;
    margin-top: 5px;
}
.move-up {
    position: relative;
    top: -120px; /* Move it 40px upward */
}

    </style>


</asp:Content>




