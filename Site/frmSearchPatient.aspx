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
                <asp:Button ID="btnCenter" runat="server" CssClass="form-control common-font rounded text-left"
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
            CssClass="btn bg-blueGradient text-white float-right move-up"
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
        <div class="d-flex action-buttons">
            <asp:Button 
                ID="btnAddTest" 
                runat="server" 
                CssClass="btn btn-view-test" 
                Text="Test"  
                CommandName="AddTest" 
                CommandArgument='<%# Eval("ID") %>' 
                OnClick="btnAddTest_Click" />

            <asp:Button 
                ID="btnSaveCase"
                runat="server" 
                Text="Invoice"
                OnClick="btnSaveCase_Click"  
                CommandArgument='<%# Eval("ID") %>' 
                CssClass="btn btn-invoice" />

            <asp:Button 
                ID="btnApprove" 
                runat="server" 
                CssClass="btn btn-view-report"
                Text="Report H"  
                CommandName="Approve" 
                CommandArgument='<%# Eval("ID") %>' 
                OnClick="btnApprove_Click" />
            <asp:Button 
                ID="btnApproveWH" 
                runat="server" 
                CssClass="btn btn-view-report"
                Text="Report WH"  
                CommandName="Approve" 
                CommandArgument='<%# Eval("ID") %>' 
                OnClick="btnApproveWH_Click" />
            <asp:Button 
                ID="btnApproveG" 
                runat="server" 
                CssClass="btn btn-view-report"
                Text="Report G WH"  
                CommandName="Approve" 
                CommandArgument='<%# Eval("ID") %>' 
                OnClick="btnApproveG_Click" />
            <asp:Button 
                ID="btnApproveWG" 
                runat="server" 
                CssClass="btn btn-view-report"
                Text="Report WG"  
                CommandName="Approve" 
                CommandArgument='<%# Eval("ID") %>' 
                OnClick="btnApproveWG_Click" />

            <asp:Button 
                ID="btnPrescription" 
                runat="server" 
                CssClass="btn btn-view-prescription"
                Text="Rx"  
                CommandName="Prescription" 
                CommandArgument='<%# Eval("ID") %>' 
                OnClick="btnPrescription_Click" />
            <asp:Button 
                ID="btnClearDues" 
                runat="server" 
                CssClass="btn btn-view-prescription"
                Text="Dues Remaining"  
                CommandName="Prescription" 
                CommandArgument='<%# Eval("ID") %>' 
                OnClick="btnClearDues_Click" />
        </div>
        <style>
    .action-buttons {
        gap: 8px;
        flex-wrap: wrap;
    }
    
    .action-buttons .btn {
        border: none;
        border-radius: 4px;
        padding: 6px 12px;
        font-size: 10px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        min-width: 50px;
        text-align: center;
    }
    
    .btn-view-test {
        background: linear-gradient(135deg, #4a6cf7 0%, #2541b2 100%);
        color: white;
    }
    
    .btn-view-test:hover {
        background: linear-gradient(135deg, #2541b2 0%, #4a6cf7 100%);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    
    .btn-invoice {
        background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);
        color: white;
    }
    
    .btn-invoice:hover {
        background: linear-gradient(135deg, #1e7e34 0%, #28a745 100%);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    
    .btn-view-report {
        background: linear-gradient(135deg, #ff7b00 0%, #ff5500 100%);
        color: white;
    }
    
    .btn-view-report:hover {
        background: linear-gradient(135deg, #ff5500 0%, #ff7b00 100%);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    .btn-view-prescription {
        background: linear-gradient(135deg, #ff4d4d 0%, #cc0000 100%);
        color: white;
    }
    
    .btn-view-prescription:hover {
        background: linear-gradient(135deg, #ff4d4d 0%, #cc0000 100%);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    
    .btn:active {
        transform: translateY(1px);
        box-shadow: 0 1px 2px rgba(0,0,0,0.1);
    }
</style>
    </ItemTemplate>
</asp:TemplateField>


    </Columns>

    <PagerTemplate>
    <div class="pagination-container">
        <div class="pagination-left">
            <span>Page <%= (GridView1.PageIndex + 1) %> of <%= GridView1.PageCount %> </span>
        </div>
        <div class="pagination-right">
            <asp:Button ID="btnPreviousPage" runat="server" Text="Previous Page" CssClass="btn bg-blueGradient text-white" OnClick="PreviousPageButton_Click" 
                Enabled="<%# GridView1.PageIndex > 0 %>" />
            
            <asp:Button ID="btnNextPage" runat="server" Text="Next Page" CssClass="btn bg-blueGradient text-white float-right" OnClick="NextPageButton_Click" 
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
          <button id="btnAddRow" class="btn btn-sm btn-success">+ Add Row</button>
        </div>

        <div class="table-responsive">
          <table id="duesTable" class="table table-bordered table-striped">
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
        <button id="btnSaveDues" class="btn btn-primary">Save</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
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




