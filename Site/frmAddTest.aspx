<%@ Page Title="Lab Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="frmAddTest.aspx.cs" Inherits="Site_frmAddTest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">     
    <asp:ScriptManager ID="ScriptManager2" runat="server" EnablePartialRendering="true" />
    
    <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>  
<div class="container-fluid">
  <div class="container">

    <div class="row border mb-1 bg-light">
      <div class="col-md-12 bg-blueGradient text-white font-weight-bold">
        <h6 class="mt-2 common-font"><strong><i class="fa fa-address-card mr-2" aria-hidden="true"></i> Case Registration </strong></h6>
      </div>

      <section class="col-md-12 mt-2 mb-2">
          <div class="tab-content py-2">

            <div class="row common-margin">
              <div class="col-md-12 mb-3">
                <span class="customGrey-btn rounded-0 text-dark border btn-sm p-2 border font-weight-bold">
                  Patient Information  
                </span>
              </div>
              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Patient ID:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtPatientID" runat="server" />
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Registration Date:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtRegistrationDate" runat="server" />
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Medical Record #:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtMRNumber" runat="server" />
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="row common-margin">
              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">First Name:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtFirstName" runat="server" />
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Last Name:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtLastName" runat="server" />
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">CABG No:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtCABG" runat="server" />
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="row common-margin">
              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Phone:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtPhone" runat="server" />
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Mobile:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtMobile" runat="server" />
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Age/Sex:</label>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtAgeSex" runat="server" />
                    </div>
                  </div>
                  <div class="col-md-2">
                    <asp:Label class="form-control common-font" ID="txtGender" runat="server" />
                  </div>
                </div>
              </div>
            </div>

            <div class="row common-margin">
              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">NIC:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtNic" runat="server" />
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">E-Mail:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtEmail" runat="server" />
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-4">
                <div class="row">
                  <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Address:</label>
                  </div>
                  <div class="col-md-8">
                    <div class="form-group">
                      <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtAddress" runat="server" />
                    </div>
                  </div>
                </div>
              </div>
            </div>

          </div>
          <div class="clearfix"></div>
      </section>
    </div>
  </div>
</div>
<div class="container-fluid">
  <div class="container">
    <div class="row border mb-2 bg-white">
      <section class="col-md-12 mt-2 mb-2">
          <div class="tab-content py-2">
            <div class="row common-margin">
              <div class="col-md-12 mb-3">
                <span class="customGrey-btn rounded-0 text-dark border btn-sm p-2 border font-weight-bold">
                  Case Information
                </span>
              </div>
              

              <div class="col-md-12">
                <div class="row">
                  <div class="col-md-3">
                    <label for="" class="small-font font-weight-normal">Registration Date:</label>
                    <div class="form-group">
                      <asp:TextBox ID="txtRegDate" runat="server" class="form-control common-font" ReadOnly="true" />
                    </div>
                  </div>
                    <div class="col-md-3">
                      <label for="" class="small-font font-weight-normal">Reg. Location:</label>
                        <div class="form-group">
                         <asp:TextBox ID="txtRegLocation" runat="server" class="form-control common-font" ReadOnly="true" />
                        </div>
                    </div>
                 
                    <div class="col-md-3">
                     <label for="" class="small-font font-weight-normal">Consultant:</label>
                        <div class="form-group">
                            <asp:TextBox ID="txtConsultant" runat="server" class="form-control common-font" ReadOnly="true" />
                        </div>
                    </div>
                    <div class="col-md-3">
                    <label for="" class="small-font font-weight-normal">Comments:</label>
                        <div class="form-group">
                                <asp:TextBox ID="txtComments" runat="server" class="form-control common-font" ReadOnly="true" />
                        </div>
                    </div>
                </div>
              </div>
          </div>
           </div>
          <div class="clearfix"></div>
      </section>
    </div>
  </div>
</div>
            <div class="container-fluid">
                <div class="container">
                    <div class="row mb-2 SkyBG pt-2 pb-2">
                        <section class="col-md-12 mt-2 mb-2">
                            <div class="tabs bg-white">
                                <div class="tab-button-outer bg-tabgrey">
                                    <ul id="tab-button">
                                        <li><a href="#tab01" class="font-weight-bold">Test</a></li>
                                        <li><a href="#tab02" class="font-weight-bold">Prescription Images</a></li>
                                    </ul>
                                </div>
                                <div id="tab01" class="tab-contents">
                                    <div class="form-group">
                                        <asp:DropDownList
                                            runat="server"
                                            ID="ddlTestName"
                                            CssClass="form-control common-font mySelect2"
                                            AutoPostBack="true"
                                            OnSelectedIndexChanged="ddlTestName_SelectedIndexChanged">
                                            <asp:ListItem Text="Please select the test" Value="" Selected="False" Enabled="False" />

                                        </asp:DropDownList>
                                    </div>

                                    <table class="table table-bordered table-sm table-hover">
                                        <thead class="font-weight-bold small-font bg-light">
                                            <tr>
                                                <th>Test ID</th>
                                                <th>Test Name</th>
                                                <th>Test Rate</th>
                                                <th>Template ID</th>
                                                <th>Reporting Date</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody id="test-table-body">
                                            <tr>
                                                <td>
                                                    <asp:TextBox runat="server" ID="ID" CssClass="form-control common-font" ReadOnly="true" /></td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="TestName" CssClass="form-control common-font" ReadOnly="true" /></td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="TestRate" CssClass="form-control common-font" ReadOnly="true" /></td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="TemplateID" CssClass="form-control common-font" ReadOnly="true" /></td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="RepDate" CssClass="form-control common-font" TextMode="DateTimeLocal" /></td>
                                                <td>
                                                    <asp:Button runat="server" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" ID="btnAddTest" Text="+" OnClick="btnAddTest_Click" /></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                        <ContentTemplate>
                                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm table-hover common-font" HeaderStyle-CssClass="bg-light font-weight-bold small-font"
                                                AllowPaging="True" PageSize="5" PagerSettings-Mode="NextPrevious" PagerSettings-Position="Bottom"
                                                OnPageIndexChanging="GridView1_PageIndexChanging">
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <a class="btn btn-white" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">
                                                                <img src="images/plus.png" class="img-fluid" alt="" />
                                                            </a>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="ID" HeaderText="ID" />
                                                    <asp:BoundField DataField="TestID" HeaderText="Test ID" />
                                                    <asp:BoundField DataField="ConductedAt" HeaderText="Conducted At" />
                                                    <asp:BoundField DataField="TestName" HeaderText="Test Name" />
                                                    <asp:BoundField DataField="Rate" HeaderText="Test Rate" />
                                                    <asp:BoundField DataField="ReportingDate" HeaderText="Reporting Date" />

                                                    <asp:TemplateField HeaderText="Action">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="Delete" CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-danger btn-sm" OnCommand="Delete_Command" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>


                                                <PagerTemplate>
                                                    <div class="pager-wrapper" style="text-align: center; padding: 10px;">

                                                        <div class="pagination-container">
                                                            <div class="pagination-left">
                                                                <span>Page <%= (GridView1.PageIndex + 1) %> of <%= GridView1.PageCount %> </span>
                                                            </div>
                                                            <div class="pagination-right">
                                                                <asp:Button ID="btnPreviousPage" runat="server" Text="Previous Page" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" OnClick="PreviousPageButton_Click"
                                                                    Enabled="<%# GridView1.PageIndex > 0 %>" />
                                                                <asp:Button ID="btnNextPage" runat="server" Text="Next Page" CssClass="btn btn-primary" OnClick="NextPageButton_Click"
                                                                    Enabled="<%# GridView1.PageIndex < GridView1.PageCount - 1 %>" />
                                                            </div>
                                                            <div class="pagination-bottom">
                                                                <span>Total Rows on Page: <%= GridView1.Rows.Count %></span>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </PagerTemplate>
                                            </asp:GridView>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div id="tab02" class="tab-contents">
                                    <h6 class="font-weight-bold mt-3 mb-3">Add & Upload Prescription(s)</h6>
                                    <div class="row common-margin">
                                        <!-- Description Input -->
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label for="txtDescription" class="small-font font-weight-normal">Description:</label>
                                                <asp:TextBox runat="server" ID="txtDescription" CssClass="form-control common-font" />
                                            </div>
                                        </div>

                                        <!-- File Upload -->
                                        <div class="col-md-12 mb-4">
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <asp:FileUpload ID="FilePrescription" runat="server" CssClass="form-control-file common-font" />
                                                    </div>
                                                    <asp:Button ID="btnUpload" runat="server" CssClass="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step"
                                                        Text="Upload File(s)" OnClick="btnUpload_Click" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
<div class="container-fluid">
    <div class="container">
        <div class="row border mb-2 bg-white">
            <section class="col-md-12 mb-2">
                    <div class="tab-content py-2">
                        <div class="row common-margin">
                            <div class="col-md-5">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label for="" class="small-font font-weight-normal">Total Tests:</label>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtTotalTests" runat="server" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2"></div>
                            <div class="col-md-5">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label for="" class="small-font font-weight-normal">Total Amount:</label>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtTotalAmount" runat="server" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row common-margin">
                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Reporting Date:</label>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <asp:TextBox class="form-control common-font" ID="CaseRepoDate" runat="server" TextMode="DateTimeLocal" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Discount(%):</label>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <asp:TextBox 
                                                CssClass="form-control common-font" 
                                                MaxLength="2" 
                                                ID="txtDiscount" 
                                                runat="server" 
                                                Text="0" 
                                                AutoPostBack="true" 
                                                OnTextChanged="txtDiscount_TextChanged" 
                                                onkeypress="return validateInput(event);" 
                                                oninput="restrictDecimals(this, 2);" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Grand Total:</label>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtGrandTotal" runat="server" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row common-margin">
                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Payment By:</label>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <asp:DropDownList CssClass="form-control common-font" runat="server" ID="PaymentMethod">
                                                <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                                <asp:ListItem Value="Card">Card</asp:ListItem>
                                                <asp:ListItem Value="Cheque">Cheque</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Less Amount:</label>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtLessAmount" runat="server" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Total Paid:</label>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <asp:TextBox 
                                                CssClass="form-control common-font" 
                                                ID="txtTotalPaid" 
                                                runat="server" 
                                                Text="0" 
                                                AutoPostBack="true" 
                                                OnTextChanged="txtTotalPaid_TextChanged" 
                                                onkeypress="return validateInput(event);" 
                                                oninput="restrictDecimals(this, 2);" />

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row common-margin">
                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group ml-3">
                                            <asp:CheckBox CssClass="form-check-input" runat="server" ID="BankPaid"/>
                                            <label class="small-font font-weight-normal" for="">Bank Paid</label>
                                        </div>
                                    </div>
                                    <div class="col-md-8"></div>
                                </div>
                            </div>

                            <div class="col-md-4"></div>

                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Balance:</label>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <asp:TextBox class="form-control common-font" ReadOnly="true" ID="txtBalance" runat="server" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="clearfix"></div>
            </section>
        </div>
    </div>
</div>
<div class="container-fluid">
    <div class="container">
        <div class="row border mb-4 bg-white">
            <section class="col-md-12 mb-2">
                <div class="tab-content py-2">
                    <div class="row common-margin pt-3">
                        <div class="col-md-6">
                            <div class="row">
                                <div class="col-md-4 small-font">Paid Amount: <asp:Label ID="PaidAmount" runat="server" /></div>
                                <div class="col-md-4 small-font">Bank Paid: 0</div>
                                <div class="col-md-4 small-font">Due Received: <asp:Label ID="DueReceived" runat="server" /></div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="row">
                                <div class="col-md-4 small-font">
                                    <div class="form-group ml-3">
                                        <asp:CheckBox CssClass="form-check-input" runat="server" ID="PatientBill"/>
                                        <label class="small-font font-weight-normal mt-1">Patient Bill:</label>
                                    </div>
                                </div>
                                <div class="col-md-4 small-font">
                                    <div class="form-group ml-3">
                                        <asp:CheckBox CssClass="form-check-input" runat="server" ID="LabCopy"/>
                                        <label class="small-font font-weight-normal mt-1">Lab Copy:</label>
                                    </div>
                                </div>
                                <div class="col-md-4 small-font">
                                    <div class="form-group ml-3">
                                        <asp:CheckBox CssClass="form-check-input" runat="server" ID="SampleLabel"/>
                                        <label class="small-font font-weight-normal mt-1">Sample Label:</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <p class="float-right">
                        <asp:Button ID="btnSaveCase" runat="server" Text="Save Case" OnClick="btnSaveCase_Click" CssClass="btn btn-primary float-right font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" />
                    </p>
                </div>
                <div class="clearfix"></div>    
            </section>
        </div>
    </div>
</div>

            

      
    <style>/* Button with green background and icon */
.btn-green-plus {
    background-color: #28a745;  /* Green color */
    color: white;  /* Text color */
    padding: 0px 20px;  /* Padding for the button */
    border: none;
    border-radius: 5px;  /* Rounded corners */
    font-size: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
}

.btn-green-plus .fa {
    margin-right: 8px;  /* Space between icon and text */
}

.btn-green-plus:hover {
    background-color: #218838;  /* Darker green on hover */
}
 .select2-container {
            width: 100% !important;
        }
 .select2-container--default .select2-search--dropdown {
    display: block !important;
}

</style>
                    
    <%--<script>

   
        $(document).ready(function () {
        $('#tab-button a').on('click', function (e) {
            e.preventDefault();
            $(this).tab('show');
        });
    });
     
        function validateInput(event) {
    var char = String.fromCharCode(event.which);
    if (!/[0-9.]/.test(char)) {
        return false;
    }
    // Prevent more than one decimal point
    var input = event.target.value;
    if (char === '.' && input.includes('.')) {
        return false;
    }
    return true;
}

// Restrict input to two decimal places
function restrictDecimals(input, decimals) {
    var value = input.value;
    var regex = new RegExp("^\\d+(\\.\\d{0," + decimals + "})?$");
    if (!regex.test(value)) {
        input.value = value.slice(0, -1); // Remove last invalid character
    }
}
    

                           
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        // Reinitialize Select2
        $(".mySelect2").select2();
        
        // Reinitialize tab functionality
        $("#tab-button a").off("click").on("click", function (e) {
            e.preventDefault();
            $(".tab-contents").hide();
            $($(this).attr("href")).show();
            $("#tab-button a").removeClass("active");
            $(this).addClass("active");
        });
    });

    // Initial setup when the page loads
    $(document).ready(function () {
        $(".mySelect2").select2();

        // Tab switching functionality
        $("#tab-button a").on("click", function (e) {
            e.preventDefault();
            $(".tab-contents").hide();
            $($(this).attr("href")).show();
            $("#tab-button a").removeClass("active");
            $(this).addClass("active");
        });
             });

    $(document).ready(function () {
        // Initially hide all tab content except the first
        $('.tab-contents').hide();
        $('.tab-contents:first').show();
        $('#tab-button li:first a').addClass('active');

        $('#tab-button li a').click(function (e) {
            e.preventDefault();

            // Remove 'active' class from all tabs and add to current
            $('#tab-button li a').removeClass('active');
            $(this).addClass('active');

            // Hide all tab contents and show the clicked one
            var target = $(this).attr('href');
            $('.tab-contents').hide();
            $(target).show();
        });
    });

</script>--%>

            </ContentTemplate>
        <Triggers>
    <asp:AsyncPostBackTrigger ControlID="ddlTestName" EventName="SelectedIndexChanged" />
    <asp:AsyncPostBackTrigger ControlID="btnAddTest" EventName="Click" />
    <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="PageIndexChanging" />
</Triggers>
        <Triggers>
        <asp:PostBackTrigger ControlID="btnUpload" />
    </Triggers>
         </asp:UpdatePanel> 
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>


