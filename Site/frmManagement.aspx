<%@ Page Title="Lab Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="frmManagement.aspx.cs" Inherits="Site_frmManagement" %>

<%@ Register Src="~/sysCtrl/msg_Box.ascx" TagPrefix="uc1" TagName="msg_Box" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

 
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
                        <asp:HiddenField ID="hfActiveTab" runat="server" Value="step1" />

    <div class="container-fluid">
        <div class="container">
            <div class="row border mb-4 bg-white">
                <div class="col-md-12 bg-blueGradient text-white font-weight-bold">
                    <h6 class="mt-2 common-font"><strong><i class="fa fa-user mr-2" aria-hidden="true"></i>MANAGEMENT</strong></h6>
                </div>

                <section class="col-md-12 mt-2">
                    <ul class="nav nav-tabs customGrey-btn flex-nowrap" role="tablist">

                        <li role="presentation" class="nav-item border-right border-bottom ">
                            <a href="#step1" class="nav-link active text-dark font-weight-bold" data-toggle="tab" aria-controls="step1" role="tab" title="ADD TEST">ADD TEST</a>
                        </li>
                        <li role="presentation" class="nav-item">
                            <a href="#step2" class="nav-link text-dark font-weight-bold" data-toggle="tab" aria-controls="step2" role="tab" title="CREATE CENTER">CREATE CENTER</a>
                        </li>
                         <li role="presentation" class="nav-item">
                            <a href="#step3" class="nav-link text-dark font-weight-bold" data-toggle="tab" aria-controls="step3" role="tab" title="REFERENCE">REFERENCE</a>
                        </li>
                          <li role="presentation" class="nav-item">
                            <a href="#step5" class="nav-link text-dark font-weight-bold" data-toggle="tab" aria-controls="step5" role="tab" title="RateTypes">RateTypes</a>
                        </li>
                         <li role="presentation" class="nav-item">
                            <a href="#step6" class="nav-link text-dark font-weight-bold" data-toggle="tab" aria-controls="step6" role="tab" title="Department">Department</a>
                        </li>
                          <li role="presentation" class="nav-item">
                            <a href="#step7" class="nav-link text-dark font-weight-bold" data-toggle="tab" aria-controls="step7" role="tab" title="Create User">Create User</a>
                        </li>
                        <li role="presentation" class="nav-item">
                            <a href="#step8" class="nav-link text-dark font-weight-bold" data-toggle="tab" aria-controls="step8" role="tab" title="Create User">Custom Rate Type</a>
                        </li>
                    </ul>
                        <div class="tab-content py-2">
                            <div class="tab-pane active" role="tabpanel" id="step1">
                                <div class="row common-margin">
                                    <div class="col-md-12">
                                        <div class="row">
                                             <div class="col-md-1">
                                                <label for="" class="small-font font-weight-normal">Code:</label>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <asp:TextBox ID="txtCode" runat="server" CssClass="form-control common-font rounded-0" />
                                                </div>
                                            </div>
                                            <div class="col-md-1">
                                                <label for="" class="small-font font-weight-normal">Name:</label>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control common-font rounded-0" />
                                                </div>
                                            </div>
                                            <div class="col-md-1">
                                                <label for="" class="small-font font-weight-normal">Group:</label>
                                            </div>

                                            <div class="col-md-3">               
                                                <div class="form-group">
                                                    <asp:DropDownList ID="ddlGroup" runat="server" CssClass="form-control common-font mySelect2">
                                                        
                                                    </asp:DropDownList>

                                                </div>
                                            </div>
                                            <div class="col-md-1">
                                                <label for="" class="small-font font-weight-normal">Type:</label>
                                            </div>

                                            <div class="col-md-3">   
                                                <div class="form-group">
                                                    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control common-font mySelect2" AutoPostBack="true" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                                                        <asp:ListItem Text="--Select Type--" Value="" />
                                                        <asp:ListItem Text="Normal" Value="0" />
                                                        <asp:ListItem Text="Parameterized" Value="1" />
                                                        <asp:ListItem Text="Profile" Value="2" />
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-1">
                                                <label for="" class="small-font font-weight-normal">Synonyms:</label>
                                            </div>

                                            <div class="col-md-3">   
                                                <div class="form-group">
                                                     <asp:TextBox ID="txtSynonyms" runat="server" CssClass="form-control common-font rounded-0" />
                                                </div>
                                            </div> 
                                            <div class="col-md-4" style="">
<%--                                                <label for="" class="small-font font-weight-normal">InActive:</label>--%>
                                                <div class="col-md-6">
                                                    <div class="form-group ml-3">
                                                        <asp:CheckBox ID="chkStatus1" runat="server" Text="" CssClass="form-check-input" />
                                                      <label class="small-font font-weight-normal" for="">In-active</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-1">
                                                <label for="" class="small-font font-weight-normal">Test ID:</label>
                                            </div>

                                            <div class="col-md-3">   

                                                <div class="form-group">
                                                     <asp:TextBox ID="txtTestID" runat="server" ReadOnly="true"  CssClass="form-control common-font rounded-0" />
                                                </div>
                                            </div> 
                                                                                        <div class="col-md-1">
                                                <label for="" class="small-font font-weight-normal">Template ID:</label>
                                            </div>

                                            <div class="col-md-3">   
                                                <div class="form-group">
                                                     <asp:TextBox ID="txtTemplateID" runat="server" ReadOnly="true"  CssClass="form-control common-font rounded-0" />
                                                </div>
                                            </div> 
                                        </div>
                                         <ul class="nav nav-tabs customGrey-btn flex-nowrap" role="tablist">
                                            <li role="presentation" class="nav-item border-right border-bottom">
                                                <asp:LinkButton ID="LinkDetails" OnClick="LinkDetails_Click" runat="server" CssClass="nav-link text-dark font-weight-bold" CausesValidation="false" >Details</asp:LinkButton>
                                            </li>
                                            <li role="presentation" class="nav-item" id="lnkParameters" runat="server" style="display: none;">
                                                <asp:LinkButton ID="linkParameters" OnClick="linkParameters_Click" runat="server" CssClass="nav-link text-dark font-weight-bold" CausesValidation="false" >Parameters</asp:LinkButton>
                                            </li>
                                            <li role="presentation" class="nav-item" id="lnkProfile" runat="server" style="display: none;">
                                                <asp:LinkButton ID="LinkProfile" OnClick="LinkProfile_Click" runat="server" CssClass="nav-link text-dark font-weight-bold" CausesValidation="false" >Profile</asp:LinkButton>
                                            </li>
                                            <li role="presentation" class="nav-item" id="lnkSettings" runat="server"  style="display: none;">
                                                <asp:LinkButton ID="linkSetting" OnClick="lnkSettingss_Click" runat="server" CssClass="nav-link text-dark font-weight-bold" CausesValidation="false" >Settings</asp:LinkButton>
                                            </li>   
                                        </ul>
                                   
                                
                                           <div class="tab-content">
                                                <div class="tab-pane active" role="tabpanel" id="Detail" runat="server">
                                                    <div class="col-md-12">
                                                        <div class="row">
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Report Name:</label>
                                                                <div class="form-group">
                                                                    <asp:TextBox ID="txtReportName" runat="server" CssClass="form-control common-font rounded-0" />
                                                                </div>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Test Heading:</label>
                                                                <div class="form-group">
                                                                    <asp:TextBox ID="txtHeading" runat="server" CssClass="form-control common-font rounded-0" />
                                                                </div>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Report Group:</label>
                                                                <div class="form-group">
                                                                    <asp:TextBox ID="txtReportGroup" runat="server" CssClass="form-control common-font rounded-0"/>
                                          
                                                                </div>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Test Days:</label>
                                                                <div class="form-group">
                                                                    <asp:DropDownList ID="ddlTestDays" runat="server" CssClass="form-control common-font mySelect2">
                                                                       
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Reporting Days:</label>
                                                                <div class="form-group">
                                                                    <asp:DropDownList ID="ddlReportingDays" runat="server" CssClass="form-control common-font mySelect2">
                                                                        <asp:ListItem Value="Daily" Text="Daily" />
                                                                        <asp:ListItem Value="Weekly" Text="Weekly" />
                                                                        <asp:ListItem Value="Monthly" Text="Monthly" />
                                                                        <asp:ListItem Value="Yearly" Text="Yearly" />
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Specimen:</label>
                                                                <div class="form-group">
                                                                    <asp:DropDownList ID="ddlSpecimen" runat="server" CssClass="form-control common-font mySelect2">
                                                                      
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </div>
                                                           
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Specimen Req. Qty.:</label>
                                                                <div class="form-group">
                                                                     <asp:TextBox ID="txtSpecimenReqQty" runat="server" CssClass="form-control common-font rounded-0" />
                                                                </div>
                                                            </div> 
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Sort Order:</label>
                                                                <div class="form-group">
                                                                     <asp:TextBox ID="txtSortOrder" runat="server" CssClass="form-control common-font rounded-0" />
                                                                </div>
                                                            </div> 
                                                            <div class="col-md-4" style="margin-top:20px">
                                                                <div class="col-md-6">
                                                                    <div class="form-group ml-3">
                                                                        <asp:CheckBox ID="chkIsSpecial" runat="server" Text="" CssClass="form-check-input" />
                                                                        <label class="small-font font-weight-normal" for="">Is Special</label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-12">
                                                        <div class="row">
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Template:</label>
                                                                <div class="form-group">
                                                                    <asp:DropDownList ID="ddlTestTemplate" runat="server" CssClass="form-control common-font mySelect2" ></asp:DropDownList>
                                                                </div>
                                                            </div>
                                                          
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Unit:</label>
                                                                <div class="form-group">
                                                                    <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control common-font rounded-0"/>
                                          
                                                                </div>
                                                            </div>
                                                           <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Test Type:</label>
                                                                <div class="form-group">
                                                                    <asp:DropDownList ID="ddlTestTypeSettings" runat="server" CssClass="form-control common-font mySelect2">
                                                                       
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </div>
                                                           
                                                            
                                                        </div>

                                                    </div>
                                                            <div class="col-md-4">
    <label for="" class="small-font font-weight-normal">Gender:</label>
    <div class="form-group">
        <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control common-font mySelect2">
            <asp:ListItem Text="--Select Gender--" Value="" />
            <asp:ListItem Text="Male" Value="0" />
            <asp:ListItem Text="Female" Value="1" />
            <asp:ListItem Text="Transgender" Value="2" />
        </asp:DropDownList>
    </div>
</div>
<div class="col-md-4">
    <label for="" class="small-font font-weight-normal">From Age:</label>
    <div class="form-group">
        <asp:TextBox ID="txtFromAge" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
    </div>
</div>
<div class="col-md-4">
    <label for="" class="small-font font-weight-normal">To Age:</label>
    <div class="form-group">
        <asp:TextBox ID="txtToAge" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
    </div>
</div>
<div class="col-md-4">
    <label for="" class="small-font font-weight-normal">From Value:</label>
    <div class="form-group">
        <asp:TextBox ID="txtFromValue" runat="server" CssClass="form-control common-font rounded-0" />
    </div>
</div>
<div class="col-md-4">
    <label for="" class="small-font font-weight-normal">To Value:</label>
    <div class="form-group">
        <asp:TextBox ID="txtToValue" runat="server" CssClass="form-control common-font rounded-0" />
    </div>
</div>
<div class="col-md-4">
    <label for="" class="small-font font-weight-normal">Remarks:</label>
    <div class="form-group">
        <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control common-font rounded-0" TextMode="MultiLine" Rows="2" />
    </div>
</div>
                                                            <div class="col-md-4">
                                                                <label for="" class="small-font font-weight-normal">Rate:</label>
                                                                <div class="form-group">
                                                                     <asp:TextBox ID="txtRate" runat="server" CssClass="form-control common-font rounded-0" />
                                                                </div>
                                                            </div> 
                                                        </div>
                                                    </div>
<asp:Button ID="btnSaveTest" runat="server" Text="Save Test" 
                CssClass="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" 
                OnClick="btnSaveTest_Click" ValidationGroup="TestValidation"  />

                                                    <!-- Success message popup -->
            <div id="successModal" class="modal fade" role="dialog">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title">Success</h4>
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <p>Data is saved successfully!</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
  


                                                    <script type="text/javascript">
    // Allow only numbers in code field
    function isNumber(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }
    
    // Allow only alphabets and spaces in name field
    function isAlpha(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if ((charCode < 65 || charCode > 90) && (charCode < 97 || charCode > 122) && charCode != 32) {
            return false;
        }
        return true;
    }
    
    // Enhanced client-side validation
  
    // Show success message
    function showSuccessMessage() {
        $('#successModal').modal('show');
    }
    
    // Scroll to top after postback
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function() {
        scrollToTop();
        
        // Show success message if flag is set
        if (typeof successSaved !== 'undefined' && successSaved) {
            showSuccessMessage();
            successSaved = false; // Reset flag
        }
    });
    
    function scrollToTop() {
        window.scrollTo(0, 0);
    }
    
    // Global flag for successful save
    var successSaved = false;
</script>
                                                  


                                                    <br/>
                                                    <br/>
                                                     <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" OnTextChanged="txtSearch_TextChanged" Placeholder="Search Code or Name"></asp:TextBox>
                                                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" Text="Search" OnClick="btnSearch_Click" CausesValidation="false" />
                                                    <div class="container d-flex justify-content-center align-items-center" style="margin-top:10px">
                                                       
<asp:GridView ID="GridView1" runat="server" 
    AutoGenerateColumns="False" 
    AllowPaging="True" 
    PageSize="5" 
    OnPageIndexChanging="GridView1_PageIndexChanging"
    PagerSettings-Mode="NumericFirstLast"
    PagerSettings-Position="Bottom"
    CssClass="table table-bordered table-sm table-hover common-font" HeaderStyle-CssClass="bg-light font-weight-bold small-font">
                                            <Columns>
        
                                                <asp:BoundField DataField="ID" HeaderText="ID" />
                                                <asp:BoundField DataField="Code" HeaderText="Code" />
                                                <asp:BoundField DataField="Name" HeaderText="Name" />
                                                <asp:BoundField DataField="Synonyms" HeaderText="Synonyms" />
                                                <asp:BoundField DataField="Type" HeaderText="Type" />
                                                <asp:BoundField DataField="ReportName" HeaderText="Report Name" />
                                                <asp:BoundField DataField="TestHeading" HeaderText="Test Heading" />
                                                <asp:BoundField DataField="ReportGroup" HeaderText="Report Group" />
                                                <asp:BoundField DataField="TestDays" HeaderText="Test Days" />
                                                <asp:BoundField DataField="ReportDays" HeaderText="Reporting Days" />
                                                <asp:BoundField DataField="SpecimenReqQuantity" HeaderText="Specimen Req. Quantity" />
                                                <asp:BoundField DataField="SortOrder" HeaderText="Sort Order" />
                                                <asp:BoundField DataField="Rate" HeaderText="Rate" />
                                                <asp:TemplateField HeaderText="Actions">
                                                    <ItemTemplate>
                                                            <asp:Button 
                                                                ID="btnEditTest" 
                                                                runat="server" 
                                                                CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" 
                                                                Text="Edit Test"  
                                                                CommandName="EditTest" 
                                                                CommandArgument='<%# Eval("ID") %>' 
                                                                OnClick="btnEditTest_Click" CausesValidation="false" />
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
                                                        Enabled="<%# GridView1.PageIndex > 0 %>" CausesValidation="false" />
            
                                                    <asp:Button ID="btnNextPage" runat="server" Text="Next Page" CssClass="btn btn-primary" OnClick="NextPageButton_Click" 
                                                        Enabled="<%# GridView1.PageIndex < GridView1.PageCount - 1 %>" CausesValidation="false" />
                                                </div>
                                                <div class="pagination-bottom">
                                                    <span>Total Rows on Page: <%= GridView1.Rows.Count %></span>
                                                </div>
                                            </div>
                                        </PagerTemplate>
                                    </asp:GridView>
                                    </div>
                                                </div>
                                                <div class="tab-pane" role="tabpanel" style="margin-top:20px" id="Parameters" runat="server">
                                                    <div class="row common-margin">
                                                         <div class="col-md-12">
                                                             <div class="row">
                                                                     <div class="col-md-1">
                                                                        <label for="" class="small-font font-weight-normal">Name:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtParameterName" runat="server" CssClass="form-control common-font rounded-0" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="" class="small-font font-weight-normal">Report Name:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtParameterReportName" runat="server" CssClass="form-control common-font rounded-0" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="" class="small-font font-weight-normal">Template:</label>
                                                                    </div>

                                                                    <div class="col-md-3">               
                                                                        <div class="form-group">
                                                                            <asp:DropDownList ID="ddlParameterTemplates" runat="server" CssClass="form-control common-font mySelect2">
                                                        
                                                                            </asp:DropDownList>

                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="" class="small-font font-weight-normal">Sort Order:</label>
                                                                    </div>

                                                                    <div class="col-md-3">   
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtParameterSortOrder" runat="server" CssClass="form-control common-font rounded-0" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="" class="small-font font-weight-normal">Format:</label>
                                                                    </div>

                                                                    <div class="col-md-3">   
                                                                        <div class="form-group">
                                                                             <asp:TextBox ID="txtParameterFormat" runat="server" CssClass="form-control common-font rounded-0" />
                                                                        </div>
                                                                    </div> 
                                                                   <div class="col-md-1">
                                                                            <label for="" class="small-font font-weight-normal">Unit:</label>
                                                                        </div>

                                                                        <div class="col-md-3">   
                                                                            <div class="form-group">
                                                                                 <asp:TextBox ID="txtParameterUnit" runat="server" CssClass="form-control common-font rounded-0" />
                                                                            </div>
                                                                        </div> 
                                                               
                                                                </div>

                                                          </div>  

                                                     </div>
                                                        <asp:Button ID="btnSaveParameter" runat="server" Text="Save Parameter" class="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" OnClick="btnSaveParameter_Click" CausesValidation="false" />

                                                             <asp:GridView ID="GridViewParameter" runat="server" AutoGenerateColumns="False"
                                                    OnRowEditing="GridViewParameter_RowEditing" 
                                                    OnRowCancelingEdit="GridViewParameter_RowCancelingEdit" 
                                                    OnRowUpdating="GridViewParameter_RowUpdating"
                                                    OnPageIndexChanging="GridViewParameter_PageIndexChanging"
                                                    AllowPaging="True" PageSize="5" 
                                                    CssClass="table table-bordered table-sm table-hover" HeaderStyle-CssClass="bg-light font-weight-bold small-font">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="ID">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtID" ReadOnly="true" runat="server" Width="100%" Text='<%# Bind("ID") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="CreatedDate">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtCreatedDate" runat="server" Width="100%" Text='<%# Bind("CreatedDate") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblCreatedDate" runat="server" Text='<%# Eval("CreatedDate") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Format">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtFormat" runat="server" Width="100%" Text='<%# Bind("Format") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblFormat" runat="server" Width="100%" Text='<%# Eval("Format") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="SortOrder">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtSortOrder" runat="server" Width="100%" Text='<%# Bind("SortOrder") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSortOrders" runat="server" Text='<%# Eval("SortOrder") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="TemplateID">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtTemplateID" runat="server" Width="100%" Text='<%# Bind("TemplateID") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblTemplateID" runat="server" Text='<%# Eval("TemplateID") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Unit">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtUnit" runat="server" Width="100%" Text='<%# Bind("Unit") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUnit" runat="server" Text='<%# Eval("Unit") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="ReportName">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtReportName" runat="server" Width="100%" Text='<%# Bind("ReportName") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblReportName" runat="server" Text='<%# Eval("ReportName") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Name">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtName" runat="server" Width="100%" Text='<%# Bind("Name") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="TestID">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="txtTestID" runat="server" Width="100%" Text='<%# Bind("TestID") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblTestID" runat="server" Text='<%# Eval("TestID") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:CommandField ShowEditButton="True" />
                                                    </Columns>
                                                    <PagerSettings Mode="NumericFirstLast" Position="Bottom" PageButtonCount="5" />
                                                    <PagerStyle CssClass="pagination-style" />
                                                </asp:GridView>

                                                 <asp:GridView ID="gvNormalValues2" runat="server" AutoGenerateColumns="False"
                                                        OnRowEditing="gvNormalValues2_RowEditing" 
                                                        OnRowCancelingEdit="gvNormalValues2_RowCancelingEdit" 
                                                        OnRowUpdating="gvNormalValues2_RowUpdating"
                                                        CssClass="table table-bordered table-sm table-hover" HeaderStyle-CssClass="bg-light font-weight-bold small-font">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="Gender">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtGender" runat="server" Width="100%" Text='<%# Bind("Gender") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblGender" runat="server" Text='<%# Eval("Gender") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="From Age">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtFromAge" runat="server" Width="100%" Text='<%# Bind("FromAge") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblFromAge" runat="server" Text='<%# Eval("FromAge") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="To Age">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtToAge" runat="server" Width="100%" Text='<%# Bind("ToAge") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblToAge" runat="server" Width="100%" Text='<%# Eval("ToAge") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="From Value">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtFromValue" runat="server" Width="100%" Text='<%# Bind("FromValue") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblFromValue" runat="server" Text='<%# Eval("FromValue") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="To Value">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtToValue" runat="server" Width="100%" Text='<%# Bind("ToValue") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblToValue" runat="server" Text='<%# Eval("ToValue") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            
                                                            <asp:TemplateField HeaderText="Remarks">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtRemarks" runat="server" Width="100%" Text='<%# Bind("Remarks") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblRemarks" runat="server" Text='<%# Eval("Remarks") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Status">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtStatus" runat="server" Width="100%" Text='<%# Bind("Status") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:CommandField ShowEditButton="True" />
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                                <div class="tab-pane" role="tabpanel" id="Profiles" runat="server">
                                                    <div class="col-md-4">
                                                        <label for="" class="small-font font-weight-normal">Select Profile Tests:</label>
                                                        <div class="form-group">
                                                            <asp:ListBox ID="ddlTest" runat="server" CssClass="form-control common-font mySelect2" SelectionMode="Multiple" AutoPostBack="true" OnTextChanged="ddlTest_TextChanged"></asp:ListBox>

                                                            <asp:Button runat="server" Text="Save Profile" ID="btnSaveProfile" OnClick="btnSaveProfie_Click" CssClass="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" CausesValidation="false" />
                                                            <asp:HiddenField ID="hdnSelectedOrder" runat="server" />

                                                        </div>
                                                    </div>
                                                    <asp:GridView ID="gvProfileTest" runat="server" 
                                                            AutoGenerateColumns="False"
                                                            AutoGenerateEditButton="True"
                                                            DataKeyNames="ID" 
                                                            OnRowEditing="gvProfileTest_RowEditing"
                                                            OnRowCancelingEdit="gvProfileTest_RowCancelingEdit"
                                                            OnRowUpdating="gvProfileTest_RowUpdating"
                                                        CssClass="table table-bordered table-sm table-hover common-font" HeaderStyle-CssClass="bg-light font-weight-bold small-font">
    
                                                            <Columns>
                                                                <asp:BoundField DataField="ID" HeaderText="ID" ReadOnly="True" />
                                                                <asp:BoundField DataField="Name" HeaderText="Name" />
                                                                <asp:BoundField DataField="SortOrder" HeaderText="SortOrder" />
                                                            </Columns>
                                                        </asp:GridView>

                                                </div>

                                                


                                                
                                                <div class="tab-pane" role="tabpanel" id="Settings" runat="server">
                                                    
                                                    
                                                                <asp:GridView ID="gvNormalValues" runat="server" AutoGenerateColumns="False"
                                                        OnRowEditing="gvNormalValues_RowEditing" 
                                                        OnRowCancelingEdit="gvNormalValues_RowCancelingEdit" 
                                                        OnRowUpdating="gvNormalValues_RowUpdating"
                                                        CssClass="table table-bordered table-sm table-hover" HeaderStyle-CssClass="bg-light font-weight-bold small-font">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="Gender">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtGender" runat="server" Width="100%" Text='<%# Bind("Gender") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblGender" runat="server" Text='<%# Eval("Gender") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="From Age">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtFromAge" runat="server" Width="100%" Text='<%# Bind("FromAge") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblFromAge" runat="server" Text='<%# Eval("FromAge") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="To Age">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtToAge" runat="server" Width="100%" Text='<%# Bind("ToAge") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblToAge" runat="server" Width="100%" Text='<%# Eval("ToAge") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="From Value">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtFromValue" runat="server" Width="100%" Text='<%# Bind("FromValue") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblFromValue" runat="server" Text='<%# Eval("FromValue") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="To Value">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtToValue" runat="server" Width="100%" Text='<%# Bind("ToValue") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblToValue" runat="server" Text='<%# Eval("ToValue") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            
                                                            <asp:TemplateField HeaderText="Remarks">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtRemarks" runat="server" Width="100%" Text='<%# Bind("Remarks") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
    <asp:Label ID="lblRemarks" runat="server" Text='<%# QuickCleanRtf(Eval("Remarks").ToString()) %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Status">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtStatus" runat="server" Width="100%" Text='<%# Bind("Status") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:CommandField ShowEditButton="True" />
                                                        </Columns>
                                                    </asp:GridView>


                                                                <asp:GridView ID="gvCuttOffValues" runat="server" AutoGenerateColumns="False"
                                                        OnRowEditing="gvCuttOffValues_RowEditing" 
                                                        OnRowCancelingEdit="gvCuttOffValues_RowCancelingEdit" 
                                                        OnRowUpdating="gvCuttOffValues_RowUpdating"
                                                        CssClass="table table-bordered table-sm table-hover" HeaderStyle-CssClass="bg-light font-weight-bold small-font">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="Test Code">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtTestCode" ReadOnly="true" runat="server" Width="100%" Text='<%# Bind("TestCode") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblTestCode" runat="server" Text='<%# Eval("TestCode") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Parameter">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtParameter" runat="server" Width="100%" Text='<%# Bind("Parameter") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblParameter" runat="server" Text='<%# Eval("Parameter") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Cut off Value">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtCutoffValue" runat="server" Width="100%" Text='<%# Bind("CutoffValue") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblCutoffValue" runat="server" Width="100%" Text='<%# Eval("CutoffValue") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Remarks">
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtRemarks" runat="server" Width="100%" Text='<%# Bind("Remarks") %>'></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblRemarks" runat="server" Text='<%# Eval("Remarks") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            
                                                            <asp:CommandField ShowEditButton="True" />
                                                        </Columns>
                                                    </asp:GridView>
                                                            
                                                </div>
                                               

                                           </div>


                             </div>
                                    <script type="text/javascript">
    function scrollToTop() {
        window.scrollTo(0, 0);
    }
    
    // Call this function after postback
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function() {
        scrollToTop();
    });
</script>
                                </div>
                            </div>
                
                            <div class="tab-pane" role="tabpanel" id="step2">

<div class="row common-margin">
    <div class="col-md-12">
        <div class="row">
            <div class="col-md-2">
                <label for="" class="small-font font-weight-normal">Code:</label>
                <div class="form-group">
                    <asp:TextBox ID="txtID" runat="server" CssClass="form-control common-font rounded-0" />
                </div>
            </div>
            <div class="col-md-4">
                <label for="" class="small-font font-weight-normal">Name:</label>
                <div class="form-group">
                    <asp:TextBox ID="txtCenterName" runat="server" CssClass="form-control common-font rounded-0" />
                </div>
            </div>
            <div class="col-md-4">
                <label for="" class="small-font font-weight-normal">Type:</label>
                <div class="form-group">
                    <asp:DropDownList ID="ddlCenterType" runat="server" CssClass="form-control common-font rounded-0">
                        <asp:ListItem Value="Company" Text="Company" />
                        <asp:ListItem Value="Franchise" Text="Franchise" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="col-md-4">
                <label for="" class="small-font font-weight-normal">RateTypeID:</label>
                <div class="form-group">
                    <asp:DropDownList ID="ddlRateTypeID" runat="server" CssClass="form-control common-font rounded-0 mySelect2">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="col-md-4" style="margin-top:20px">
                <div class="col-md-6">
                    <div class="form-group ml-3">
                        <asp:CheckBox ID="chkIsLab" runat="server" Text="" CssClass="form-check-input" />
                        <label class="small-font font-weight-normal" for="">Is Lab</label>
                    </div>
                </div>
            </div>
            <div class="col-md-4" style="margin-top:20px">
                <div class="col-md-6">
                    <div class="form-group ml-3">
                        <asp:CheckBox ID="chkStatus" runat="server" Text="" CssClass="form-check-input" />
                        <label class="small-font font-weight-normal" for="">Status</label>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <label for="" class="small-font font-weight-normal">Description:</label>
                <div class="form-group">
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control common-font rounded-0" />
                </div>
            </div>
        </div>
        <ul class="nav nav-tabs customGrey-btn flex-nowrap" role="tablist">
            <li role="presentation" class="nav-item border-right border-bottom">
                <a href="#Address" class="nav-link active text-dark font-weight-bold" data-toggle="tab" aria-controls="Detail" role="tab" title="Address">Address</a>
            </li>
            <li role="presentation" class="nav-item">
            </li>
        </ul>
        
        <div class="tab-content">
            <!-- Detail Tab -->
            <div class="tab-pane active" role="tabpanel" id="Address">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-md-8">
                            <label for="" class="small-font font-weight-normal">Addresss:</label>
                            <div class="form-group">
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control common-font rounded-0" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label for="" class="small-font font-weight-normal">Country:</label>
                            <div class="form-group">
                                <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-control common-font rounded-0">
                                    <asp:ListItem Value="Pakistan" Text="Pakistan" />
                                    <asp:ListItem Value="USA" Text="USA" />
                                    <asp:ListItem Value="UK" Text="UK" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label for="" class="small-font font-weight-normal">City:</label>
                            <div class="form-group">
                                <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control common-font rounded-0">
                                    <asp:ListItem Value="Lahore" Text="Lahore" />
                                    <asp:ListItem Value="Multan" Text="Multan" />
                                    <asp:ListItem Value="Karachi" Text="Karachi" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label for="" class="small-font font-weight-normal">Phone:</label>
                            <div class="form-group">
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control common-font rounded-0"/>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <label for="" class="small-font font-weight-normal">Email:</label>
                            <div class="form-group">
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control common-font rounded-0"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" role="tabpanel" id="CenterSettings">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-4" style="margin-top:20px">
                                <div class="col-md-6">
                                    <div class="form-group ml-3">
                                        <asp:CheckBox ID="chkCenterDiscountLimit" runat="server" Text="" CssClass="form-check-input" />
                                        <label class="small-font font-weight-normal" for="">Center Discount Limit</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label for="" class="small-font font-weight-normal">Max Discount Limit:</label>
                                <div class="form-group">
                                    <asp:TextBox ID="txtMaxDiscLimit" runat="server" CssClass="form-control common-font rounded-0"/>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <label for="" class="small-font font-weight-normal">Daily Case No. Range Setting:</label>
                            </div>
                            <div class="col-md-2">
                                <label for="" class="small-font font-weight-normal">Start From:</label>
                                <div class="form-group">
                                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" Min="1" Max="1000000000" ReadOnly="true" />
                                </div>
                            </div>
                            <div class="col-md-2">
                                <label for="" class="small-font font-weight-normal">End At:</label>
                                <div class="form-group">
                                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" Min="1" Max="1000000000" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <asp:Button ID="btnSaveCenter" runat="server" Text="Save" class="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" OnClick="btnSaveCenter_Click" />

                </div>
            </div>
        </div>
        
    </div>
</div>
                       
                              <div class="table-responsive">
                            <table id="centersTable" class="table table-hover" style="width:100%">
                                <thead>
                                    <tr>
                                       
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Data will be populated by DataTables -->
                                </tbody>
                            </table>
                        </div>

 <script>
  $(document).ready(function () {
    GenerateCenterTable();
});

function GenerateCenterTable() {
    if ($.fn.DataTable.isDataTable('#centersTable')) {
        $('#centersTable').DataTable().destroy();
        $('#centersTable').empty();
    }

    const table = $('#centersTable').DataTable({
        autoWidth: true,
        processing: true,
        serverSide: true,
        ajax: {
            url: "frmManagement.aspx/Centers",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: function (d) {
                return JSON.stringify({
                    draw: d.draw,
                    start: d.start,
                    length: d.length,
                    search: d.search.value,
                    sortColumn: d.columns[d.order[0].column].data,
                    sortDirection: d.order[0].dir
                });
            },
            dataSrc: function (json) {
                if (json && json.d) {
                    json.recordsTotal = json.d.recordsTotal;
                    json.recordsFiltered = json.d.recordsFiltered;
                    json.draw = json.d.draw;
                    return json.d.data;
                }
                return [];
            },
            error: function () {
                $('.dataTables_processing').html('<div class="alert alert-danger">Failed to load data. Please try again.</div>');
            }
        },
        columns: [
            { data: "id", title: "ID" },
            { data: "code", title: "Code" },
            {
                data: "name",
                title: "Name",
                render: data => `<span class="fw-bold">${data}</span>`
            },
            {
                data: "type",
                title: "Type",
                render: data => {
                    const typeClass = data === 'Lab' ? 'badge bg-info' : 'badge bg-secondary';
                    return `<span class="${typeClass}">${data}</span>`;
                }
            },
            { data: "city", title: "City" },
            {
                data: "createdDate",
                title: "Created Date",
                render: data => {
                    try {
                        return new Date(parseInt(data.substr(6))).toLocaleDateString();
                    } catch {
                        return data;
                    }
                }
            },
            {
                data: "status",
                title: "Status",
                render: data => {
                    const statusClass = data ? 'status-active status-badge' : 'status-inactive status-badge';
                    return `<span class="${statusClass}">${data ? 'Active' : 'Inactive'}</span>`;
                }
            },
            {
                data: "id",
                title: "Actions",
                orderable: false,
                searchable: false,
                render: id => `
                    <button type="button" class="btn btn-sm btn-outline-success edit-btn" data-id="${id}" title="Edit">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-danger delete-btn" data-id="${id}" title="Delete">
                        <i class="fas fa-trash-alt"></i>
                    </button>`
            },

            // 🔒 Hidden columns
            { data: "description", visible: false },
            { data: "rateTypeId", visible: false },
            { data: "address", visible: false },
            { data: "country", visible: false },
            { data: "phone", visible: false },
            { data: "email", visible: false },
            { data: "isLab", visible: false },
            { data: "SpecialDiscount", visible: false },
            { data: "CreditLimit", visible: false }
        ],
        order: [[0, 'desc']],
        lengthMenu: [10, 25, 50, 100],
        pageLength: 10,
        language: {
            search: "",
            searchPlaceholder: "Search within results...",
            lengthMenu: "Show _MENU_ entries",
            info: "Showing _START_ to _END_ of _TOTAL_ centers",
            infoEmpty: "No centers found",
            infoFiltered: "(filtered from _MAX_ total centers)",
            paginate: {
                first: '<i class="fas fa-angle-double-left"></i>',
                last: '<i class="fas fa-angle-double-right"></i>',
                next: '<i class="fas fa-angle-right"></i>',
                previous: '<i class="fas fa-angle-left"></i>'
            }
        },
        initComplete: function () {
            $('.dataTables_filter input').addClass('form-control form-control-sm');
        },
        drawCallback: function () {
            // 🔁 Bind Edit
            $('.edit-btn').off('click').on('click', function () {
                const row = table.row($(this).closest('tr')).data();
                debugger;
                $('#<%= hfID.ClientID %>').val(row.id);
                $('#<%= txtCenterName.ClientID %>').val(row.name);
                $('#<%= txtDescription.ClientID %>').val(row.description);
                $('#<%= ddlType.ClientID %>').val(row.type);
                $('#<%= ddlRateTypeID.ClientID %>').val(row.rateTypeId);
                $('#<%= txtAddress.ClientID %>').val(row.address);
                $('#<%= ddlCountry.ClientID %>').val(row.country);
                $('#<%= ddlCity.ClientID %>').val(row.city);
                $('#<%= txtPhone.ClientID %>').val(row.phone);
                $('#<%= txtEmail.ClientID %>').val(row.email);
                $('#<%= chkIsLab.ClientID %>').prop('checked', row.isLab);
                $('#<%= chkStatus.ClientID %>').prop('checked', row.status);
                $('#<%= txtMaxDiscLimit.ClientID %>').val(row.SpecialDiscount);
                $('#<%= txtEndDate.ClientID %>').val(row.CreditLimit);

                $('#<%= btnSaveCenter.ClientID %>').val("Update Center");
            });

            // 🔁 Bind Delete
            $('.delete-btn').off('click').on('click', function () {
                const id = $(this).data('id');

                if (confirm("Are you sure you want to delete this center?")) {
                    $.ajax({
                        type: "POST",
                        url: "frmManagement.aspx/DeleteCenter",
                        data: JSON.stringify({ id: id }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d.success) {
                                alert("Deleted successfully!");
                            } else {
                                alert("Error deleting center: " + response.d.message);
                            }
                            table.ajax.reload(null, false); // soft reload
                        },
                        error: function (xhr, status, error) {
                            alert("AJAX error: " + error);
                            table.ajax.reload(null, false);
                        }
                    });
                }
            });
        }
    });

    $('#searchCenters').on('keyup', function () {
        table.search(this.value).draw();
    });

    table.on('processing.dt', function (e, settings, processing) {
        $('.loader').fadeToggle(200, processing);
    });

    $('#btnExport').on('click', function () {
        const search = encodeURIComponent(table.search());
        window.location = `frmManagement.aspx/ExportCenters?search=${search}`;
    });
}




    </script>

                                <style>
                                    /* Fix pagination button alignment */
.dataTables_wrapper .dataTables_paginate .paginate_button {
    margin: 0 3px;
    padding: 5px 10px;
    border: 1px solid #dee2e6;
    border-radius: 4px;
}

/* Active page button styling */
.dataTables_wrapper .dataTables_paginate .paginate_button.current {
    background: #0d6efd;
    color: white !important;
    border-color: #0d6efd;
}

/* Hover effects */
.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
    background: #e9ecef;
    border-color: #dee2e6;
}
                                </style>

<!-- Hidden Field to Store CenterID for Updates -->
<asp:HiddenField ID="hfID" runat="server" />
</div>

                           
<div class="tab-pane" role="tabpanel" id="step3">
    <div class="row common-margin">
        <div class="col-md-12">
            <div class="row">
                <!-- Code Field -->
                <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Code:</label>
                    <div class="form-group">
                        <asp:TextBox ID="txtReferenceCode" runat="server" CssClass="form-control common-font rounded-0" onkeypress="return isNumber(event)" />
                       <%-- <asp:RequiredFieldValidator ID="rfvCode" runat="server" ControlToValidate="txtReferenceCode" 
                            ErrorMessage="Code is required" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RequiredFieldValidator>--%>
                    </div>
                </div>
                <!-- Name Field -->
                <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Name:</label>
                    <div class="form-group">
                        <asp:TextBox ID="txtReferenceName" runat="server" CssClass="form-control common-font rounded-0" onkeypress="return isAlpha(event)" />
                        <%--<asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtReferenceName" 
                            ErrorMessage="Name is required" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RequiredFieldValidator>--%>
                    </div>
                </div>
                <!-- Address Field -->
                <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Address:</label>
                    <div class="form-group">
                        <asp:TextBox ID="txtReferenceAddress" runat="server" CssClass="form-control common-font rounded-0" />
                        <%--<asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtReferenceAddress" 
                            ErrorMessage="Address is required" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RequiredFieldValidator>--%>
                    </div>
                </div>
                <!-- City Field -->
                <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">City:</label>
                    <div class="form-group">
                        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control common-font rounded-0" />
                       <%-- <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" 
                            ErrorMessage="City is required" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RequiredFieldValidator>--%>
                    </div>
                </div>
                <!-- Phone Field -->
                <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Phone:</label>
                    <div class="form-group">
                        <asp:TextBox ID="txtReferencePhone" runat="server" CssClass="form-control common-font rounded-0" />
                        <%--<asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtReferencePhone" 
                            ErrorMessage="Phone is required" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtReferencePhone"
                            ValidationExpression="^[0-9]{10,15}$" ErrorMessage="Invalid phone number" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RegularExpressionValidator>--%>
                    </div>
                </div>
                <!-- Email Field -->
                <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Email:</label>
                    <div class="form-group">
                        <asp:TextBox ID="txtReferenceEmail" runat="server" CssClass="form-control common-font rounded-0" />
<%--                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtReferenceEmail" 
                            ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtReferenceEmail"
                            ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RegularExpressionValidator>--%>
                    </div>
                </div>
                <!-- In-Active Checkbox -->
                <div class="col-md-4" style="margin-top:20px">
                    <div class="col-md-6">
                        <div class="form-group ml-3">
                            <asp:CheckBox ID="chkReferenceInActive" runat="server" Text="" CssClass="form-check-input" />
                            <label class="small-font font-weight-normal" for="">In-active</label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Settings Tab -->
            <ul class="nav nav-tabs customGrey-btn flex-nowrap" role="tablist">
                <li role="presentation" class="nav-item border-right border-bottom">
                    <a href="#ReferenceSettings" class="nav-link active text-dark font-weight-bold" data-toggle="tab" aria-controls="Settings" role="tab" title="Settings">Settings</a>
                </li>
            </ul>

            <!-- Settings Tab Content -->
            <div class="tab-content">
                <div class="tab-pane active" role="tabpanel" id="ReferenceSettings">
                    <div class="col-md-12">
                        <div class="row">
                            <!-- Payment Mode Dropdown -->
                            <div class="col-md-4">
                                <label for="" class="small-font font-weight-normal">Payment Mode:</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlPaymentMode" runat="server" CssClass="form-control common-font rounded-0">
                                        <asp:ListItem Value="Cash" Text="Cash" />
                                        <asp:ListItem Value="Credit" Text="Credit" />
                                        <asp:ListItem Value="Online" Text="Online" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <!-- Credit Limit Field -->
                            <div class="col-md-4">
                                <label for="" class="small-font font-weight-normal">Credit Limit:</label>
                                <div class="form-group">
                                    <asp:TextBox ID="txtCreditLimit" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                    <%--<asp:RequiredFieldValidator ID="rfvCreditLimit" runat="server" ControlToValidate="txtCreditLimit" 
                                        ErrorMessage="Credit Limit is required" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RequiredFieldValidator>--%>
                                </div>
                            </div>
                            <!-- Credit Days Field -->
                            <div class="col-md-4">
                                <label for="" class="small-font font-weight-normal">Credit Days:</label>
                                <div class="form-group">
                                    <asp:TextBox ID="txtCreditDays" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                  <%--  <asp:RequiredFieldValidator ID="rfvCreditDays" runat="server" ControlToValidate="txtCreditDays" 
                                        ErrorMessage="Credit Days is required" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RequiredFieldValidator>--%>
                                </div>
                            </div>
                            <!-- Current Balance Field -->
                            <div class="col-md-4">
                                <label for="" class="small-font font-weight-normal">Current Balance:</label>
                                <div class="form-group">
                                    <asp:TextBox ID="txtCurrentBalance" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                 <%--   <asp:RequiredFieldValidator ID="rfvCurrentBalance" runat="server" ControlToValidate="txtCurrentBalance" 
                                        ErrorMessage="Current Balance is required" ForeColor="Red" Display="Dynamic" CssClass="small-font"></asp:RequiredFieldValidator>--%>
                                </div>
                            </div>
                            <!-- Rate Type Dropdown -->
                            <div class="col-md-4">
                                <label for="" class="small-font font-weight-normal">Rate Type:</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlRateTypeReferemce" runat="server" CssClass="form-control common-font rounded-0">
                                        <asp:ListItem Value="1" Text="Fixed" />
                                        <asp:ListItem Value="2" Text="Variable" />
                                        <asp:ListItem Value="3" Text="Custom" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Validation Summary -->
            <asp:ValidationSummary ID="valSummary" runat="server" ShowMessageBox="True" ShowSummary="False" 
                HeaderText="Please fill all the required fields:" CssClass="alert alert-danger" />

            <!-- Save Button -->
            <asp:Button ID="btnSaveReference" runat="server" Text="Save" class="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" OnClick="btnSaveReference_Click"  />
        </div>
    </div>

    <!-- GridView for Displaying Reference Data -->
    <asp:GridView ID="GridViewReference" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm table-hover"
        AllowPaging="True" PageSize="10">
        <Columns>
            <asp:BoundField DataField="Code" HeaderText="Code" />
            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="Address" HeaderText="Address" />
            <asp:BoundField DataField="City" HeaderText="City" />
            <asp:BoundField DataField="Phone" HeaderText="Phone" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="RateTypeID" HeaderText="Rate Type ID" />
            <asp:BoundField DataField="PaymentMode" HeaderText="Payment Mode" />
            <asp:BoundField DataField="CreditLimit" HeaderText="Credit Limit" />
            <asp:BoundField DataField="CreditDays" HeaderText="Credit Days" />
            <asp:BoundField DataField="CurrentBalance" HeaderText="Current Balance" />
        </Columns>
        <PagerSettings Mode="NextPrevious" Position="Bottom" />
        <PagerStyle CssClass="pagination-style" />
    </asp:GridView>
</div>



<div class="tab-pane" role="tabpanel" id="step5">
    <div class="row common-margin">
        <div class="col-md-12">
            <div class="row">
                <!-- Name Field -->
                <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Name:</label>
                    <div class="form-group">
                        <asp:TextBox ID="txtRateTypesName" runat="server" CssClass="form-control common-font rounded-0" />
                    </div>
                </div>
                <!-- Description Field -->
                <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Description:</label>
                    <div class="form-group">
                        <asp:TextBox ID="txtRateTypesDescription" runat="server" CssClass="form-control common-font rounded-0" />
                    </div>
                </div>
                <!-- Status Checkbox -->
                <div class="col-md-4" style="margin-top:20px">
                    <div class="col-md-6">
                        <div class="form-group ml-3">
                            <asp:CheckBox ID="chkRateTypesStatus" runat="server" Text="" CssClass="form-check-input" />
                            <label class="small-font font-weight-normal" for="">Status</label>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Save Button -->
            <asp:Button ID="btnSaveRateTypes" runat="server" Text="Save" CssClass="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" OnClick="btnSaveRateTypes_Click" />
        </div>
    </div>
    <!-- GridView for Displaying RateTypes Data with Edit Button -->
   <asp:GridView ID="GridViewRateTypes" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm table-hover"
    AllowPaging="True" PageSize="5" OnPageIndexChanging="GridViewRateTypes_PageIndexChanging" OnRowCommand="GridViewRateTypes_RowCommand">
    <Columns>
        <asp:BoundField DataField="ID" HeaderText="ID" SortExpression="RateTypeID" />
        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
        <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
        <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="EditRateType" CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-dark btn-sm" CausesValidation="false" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <PagerTemplate>
        <div class="pagination-container">
            <div class="pagination-left">
                <span>Page <%= (GridViewRateTypes.PageIndex + 1) %> of <%= GridViewRateTypes.PageCount %> </span>
            </div>
            <div class="pagination-right">
                <asp:Button ID="btnPreviousPage" runat="server" Text="Previous Page" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" OnClick="RateTypesPreviousPageButton_Click" 
                    Enabled="<%# GridViewRateTypes.PageIndex > 0 %>" CausesValidation="false" />
                <asp:Button ID="btnNextPage" runat="server" Text="Next Page" CssClass="btn btn-primary" OnClick="RateTypesNextPageButton_Click" 
                    Enabled="<%# GridViewRateTypes.PageIndex < GridViewRateTypes.PageCount - 1 %>" CausesValidation="false" />
            </div>
            <div class="pagination-bottom">
                <span>Total Rows on Page: <%= GridViewRateTypes.Rows.Count %></span>
            </div>
        </div>
    </PagerTemplate>
</asp:GridView>
</div>


                            <div class="tab-pane" role="tabpanel" id="step6">
    <div class="row common-margin">
        <div class="col-md-12">
            <div class="row">
                <!-- Name Field -->
                <div class="col-md-4">
                    <label for="" class="small-font font-weight-normal">Name:</label>
                    <div class="form-group">
                        <asp:TextBox ID="txtDepartmentName" runat="server" CssClass="form-control common-font rounded-0" />
                    </div>
                </div>
                <!-- Status Checkbox -->
                <div class="col-md-4" style="margin-top:20px">
                    <div class="col-md-6">
                        <div class="form-group ml-3">
                            <asp:CheckBox ID="chkDepartmentStatus" runat="server" Text="" CssClass="form-check-input" />
                            <label class="small-font font-weight-normal" for="">Status</label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Save Button -->
            <asp:Button ID="btnSaveDepartment" runat="server" Text="Save" class="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" OnClick="btnSaveDepartment_Click" />
        </div>
    </div>

    <!-- GridView for Displaying TestDepartment Data -->
<asp:GridView ID="GridViewTestDepartment" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm table-hover"
    AllowPaging="True" PageSize="5" OnPageIndexChanging="GridViewTestDepartment_PageIndexChanging" OnRowCommand="GridViewTestDepartment_RowCommand">
    <Columns>
        <asp:BoundField DataField="ID" HeaderText="ID" />
        <asp:BoundField DataField="Name" HeaderText="Name" />
        <asp:CheckBoxField DataField="Status" HeaderText="Status" />
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="EditRow" CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-dark btn-sm" CausesValidation="false" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <PagerTemplate>
        <div class="pagination-container">
            <div class="pagination-left">
                <span>Page <%= (GridViewTestDepartment.PageIndex + 1) %> of <%= GridViewTestDepartment.PageCount %> </span>
            </div>
            <div class="pagination-right">
                <asp:Button ID="btnPreviousPage" runat="server" Text="Previous Page" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" OnClick="TestDepartmentPreviousPageButton_Click" 
                    Enabled="<%# GridViewTestDepartment.PageIndex > 0 %>" CausesValidation="false" />
                <asp:Button ID="btnNextPage" runat="server" Text="Next Page" CssClass="btn btn-primary" OnClick="TestDepartmentNextPageButton_Click" 
                    Enabled="<%# GridViewTestDepartment.PageIndex < GridViewTestDepartment.PageCount - 1 %>" CausesValidation="false" />
            </div>
            <div class="pagination-bottom">
                <span>Total Rows on Page: <%= GridViewTestDepartment.Rows.Count %></span>
            </div>
        </div>
    </PagerTemplate>
</asp:GridView>

                            </div>

<div class="tab-pane" role="tabpanel" id="step7">
    <div class="row common-margin">
        <div class="col-md-12">
            <!-- Add User Button -->
            <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" OnClick="btnAddUser_Click" CausesValidation="false" />
<asp:Button ID="btnAddRoles" runat="server" Text="Add Roles" CssClass="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" OnClientClick="openModal(); return false;" />

        </div>
    </div>
    <div class="modal fade" id="roleModal" tabindex="-1" role="dialog" aria-labelledby="roleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="roleModalLabel">Add Role</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <asp:Label runat="server" Text="Select Access Pages:" />
                <asp:ListBox ID="ddlAccessPages" runat="server" CssClass="form-control" SelectionMode="Multiple"></asp:ListBox>

                <asp:Label runat="server" Text="Role Name:" CssClass="mt-3" />
                <asp:TextBox ID="txtRoleName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnSaveRole" runat="server" Text="Save Role" CssClass="btn btn-success" OnClick="btnSaveRole_Click" CausesValidation="false" />
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
    <script>
    function openModal() {
        $('#roleModal').modal('show');
    }
</script>
    <!-- GridView for Displaying iLock_User Data -->
    <asp:HiddenField ID="HiddenField1" runat="server" />
    <asp:GridView ID="GridViewiLockUser" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm table-hover"
    AllowPaging="True" PageSize="5" OnPageIndexChanging="GridViewiLockUser_PageIndexChanging" OnRowCommand="GridViewiLockUser_RowCommand">
    <Columns>
        <asp:BoundField DataField="UserName" HeaderText="Username" />
        <asp:BoundField DataField="FirstName" HeaderText="First Name" />
        <asp:BoundField DataField="LastName" HeaderText="Last Name" />
        <asp:BoundField DataField="Email" HeaderText="Email" />
        <asp:BoundField DataField="Mobile" HeaderText="Mobile" />
        <asp:BoundField DataField="City" HeaderText="City" />
        <asp:CheckBoxField DataField="Disabled" HeaderText="Disabled" />
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="EditRow" CommandArgument='<%# Eval("UserId") %>' CssClass="btn btn-dark btn-sm" CausesValidation="false" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <PagerTemplate>
        <div class="pagination-container">
            <div class="pagination-left">
                <span>Page <%= (GridViewiLockUser.PageIndex + 1) %> of <%= GridViewiLockUser.PageCount %> </span>
            </div>
            <div class="pagination-right">
                <asp:Button ID="btnPreviousPage" runat="server" Text="Previous Page" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" OnClick="iLockUserPreviousPageButton_Click" 
                    Enabled="<%# GridViewiLockUser.PageIndex > 0 %>" CausesValidation="false" />
                <asp:Button ID="btnNextPage" runat="server" Text="Next Page" CssClass="btn btn-primary" OnClick="iLockUserNextPageButton_Click" 
                    Enabled="<%# GridViewiLockUser.PageIndex < GridViewiLockUser.PageCount - 1 %>" CausesValidation="false" />
            </div>
            <div class="pagination-bottom">
                <span>Total Rows on Page: <%= GridViewiLockUser.Rows.Count %></span>
            </div>
        </div>
    </PagerTemplate>
</asp:GridView>
</div>
<div class="tab-pane" role="tabpanel" id="step8">
    
    <!-- GridView for Displaying iLock_User Data -->
    <asp:HiddenField ID="HiddenField2" runat="server" />
    <asp:GridView 
    ID="gvCustomRateType" 
    runat="server" 
    AutoGenerateColumns="False" 
    CssClass="table table-bordered table-sm table-hover"
    OnRowCommand="gvCustomRateType_RowCommand"
    OnRowEditing="gvCustomRateType_RowEditing"
    OnRowCancelingEdit="gvCustomRateType_RowCancelingEdit"
    OnRowUpdating="gvCustomRateType_RowUpdating"
    DataKeyNames="ID">

    <Columns>
        <asp:BoundField DataField="ID" HeaderText="ID" />
        <asp:BoundField DataField="Code" HeaderText="Code" />
        <asp:BoundField DataField="Name" HeaderText="Name" />
        <asp:TemplateField HeaderText="R3">
            <ItemTemplate>
                <%# Eval("Discount") %>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtDiscount" runat="server" Text='<%# Bind("Discount") %>' CssClass="form-control form-control-sm" />
            </EditItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="R4">
            <ItemTemplate>
                <%# Eval("DiscountR4") %>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtDiscountR4" runat="server" Text='<%# Bind("DiscountR4") %>' CssClass="form-control form-control-sm" />
            </EditItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" Text="Edit" CssClass="btn btn-sm btn-dark" />
            </ItemTemplate>
            <EditItemTemplate>
                <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" Text="Update" CssClass="btn btn-sm btn-success" />
                <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" Text="Cancel" CssClass="btn btn-sm btn-secondary" />
            </EditItemTemplate>
</asp:TemplateField>

    </Columns>
    
</asp:GridView>
</div>
<!-- Add User Popup Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUserModalLabel">Add User</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Tab Navigation -->
                <ul class="nav nav-tabs" id="userTabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="userDetails-tab" data-toggle="tab" href="#userDetails" role="tab" aria-controls="userDetails" aria-selected="true">User Details</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="department-tab" data-toggle="tab" href="#department" role="tab" aria-controls="department" aria-selected="false">Department</a>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content" id="userTabsContent">
                    <!-- User Details Tab -->
                    <div class="tab-pane fade show active" id="userDetails" role="tabpanel" aria-labelledby="userDetails-tab">
                        <div class="row"> 
                           <!-- Username -->
                            <div class="col-md-4">
                                <label for="txtUserName" class="small-font font-weight-normal">Username:</label>
                                <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control common-font rounded-0" />
                            </div>
                            <!-- First Name -->
                            <div class="col-md-4">
                                <label for="txtFirstName" class="small-font font-weight-normal">First Name:</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control common-font rounded-0" />
                            </div>
                            <!-- Last Name -->
                            <div class="col-md-4">
                                <label for="txtLastName" class="small-font font-weight-normal">Last Name:</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control common-font rounded-0" />
                            </div>
                            <!-- Disabled -->
                            <div class="col-md-4" style="margin-top:20px">
                                <div class="col-md-6">
                                    <div class="form-group ml-3">
                                        <asp:CheckBox ID="chkDisabled" runat="server" Text="" CssClass="form-check-input" />
                                        <label class="small-font font-weight-normal" for="">Disabled</label>
                                    </div>
                                </div>
                            </div>
                            <!-- Password -->
                            <div class="col-md-4">
                                <label for="txtPassword" class="small-font font-weight-normal">Password:</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control common-font rounded-0" TextMode="Password" />
                            </div>
                            <!-- Email -->
                            <div class="col-md-4">
                                <label for="txtEmail" class="small-font font-weight-normal">Email:</label>
                                <asp:TextBox ID="txtuserEmail" runat="server" CssClass="form-control common-font rounded-0" />
                            </div>
                            <!-- Mobile -->
                            <div class="col-md-4">
                                <label for="txtMobile" class="small-font font-weight-normal">Mobile:</label>
                                <asp:TextBox ID="txtuserMobile" runat="server" CssClass="form-control common-font rounded-0" />
                            </div>
                            <!-- City -->
                            <div class="col-md-4">
                                <label for="txtCity" class="small-font font-weight-normal">City:</label>
                                <asp:TextBox ID="txtuserCity" runat="server" CssClass="form-control common-font rounded-0" />
                            </div>
                            <div class="col-md-4">
    <label for="ddlCenter" class="small-font font-weight-normal">Center:</label>
    <asp:DropDownList ID="ddlCenter" runat="server" CssClass="form-control common-font rounded-0" SelectionMode="Multiple" multiple="multiple">
    </asp:DropDownList>
</div>
                            <div class="col-md-4">
    <label for="ddlRoles" class="small-font font-weight-normal">Roles:</label>
    <asp:DropDownList ID="ddlRoles" runat="server" CssClass="form-control common-font rounded-0">
    </asp:DropDownList>
</div>
                        </div>
                    </div>

                    <!-- Department Tab -->
                    <div class="tab-pane fade" id="department" role="tabpanel" aria-labelledby="department-tab">

    <div class="row">
        <div class="col-md-12">
            <div class="table-responsive">
                <table class="table table-hover table-striped table-bordered">
                    
                    <tbody>
                        <asp:CheckBoxList ID="chkDepartments" runat="server" CssClass="form-check" RepeatLayout="UnorderedList">
                        </asp:CheckBoxList>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <asp:Button ID="btnSaveUser" runat="server" Text="Save User" CssClass="btn btn-primary" OnClick="btnSaveUser_Click" CausesValidation="false" />
            </div>
        </div>
    </div>
</div>


<!-- Popup Modal -->
<div class="modal fade" id="popupModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Edit Rate Type</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                    <div class="tab-pane" role="tabpanel" id="step4">
                        <div class="row common-margin">
                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label for="" class="small-font font-weight-normal">Name:</label>
                                        <div class="form-group">
                                            <asp:TextBox ID="txtRateTypeName" runat="server" CssClass="form-control common-font rounded-0" />
                                        </div>
                                    </div>
                                    <div class="col-md-1">
                                        <label for="" class="small-font font-weight-normal">Special:</label>
                                        <div class="form-group">
                                            <asp:TextBox ID="txtSpecial" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                        </div>
                                    </div>
                                    <div class="col-md-1">
                                        <label for="" class="small-font font-weight-normal">Routine:</label>
                                        <div class="form-group">
                                            <asp:TextBox ID="txtRoutine" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                        </div>
                                    </div>
                                    <div class="col-md-1">
                                        <label for="" class="small-font font-weight-normal">Rebate:</label>
                                        <div class="form-group">
                                            <asp:TextBox ID="txtRebate" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                        </div>
                                    </div>
                                    <div class="col-md-1">
                                        <label for="" class="small-font font-weight-normal">Biopsy:</label>
                                        <div class="form-group">
                                            <asp:TextBox ID="txtBiopsy" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                        </div>
                                    </div>
                                    <div class="col-md-1">
                                        <label for="" class="small-font font-weight-normal">PCR:</label>
                                        <div class="form-group">
                                            <asp:TextBox ID="txtPCR" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                        </div>
                                    </div>
                                    <div class="col-md-1">
                                        <label for="" class="small-font font-weight-normal">Others:</label>
                                        <div class="form-group">
                                            <asp:TextBox ID="txtOthers" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                        </div>
                                    </div>
                                    <div class="col-md-1">
                                        <label for="" class="small-font font-weight-normal">Radiology:</label>
                                        <div class="form-group">
                                            <asp:TextBox ID="txtRadiology" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                        </div>
                                    </div>
                                    <div class="col-md-1">
                                        <label for="" class="small-font font-weight-normal">Outside:</label>
                                        <div class="form-group">
                                            <asp:TextBox ID="txtOutside" runat="server" CssClass="form-control common-font rounded-0" TextMode="Number" />
                                        </div>
                                    </div>
                     <div class="col-md-6" style="margin-top:20px">
                                        <div class="form-group ml-3">
                                            <asp:CheckBox ID="chkRateTypeInActive" runat="server" Text="" CssClass="form-check-input" />
                                            <label class="small-font font-weight-normal" for="">In-active</label>
                                        </div>
                                    </div>
                                     <div class="col-md-6" style="margin-top:20px">
                                        <div class="form-group ml-3">
                                            <asp:CheckBox ID="chkIsFixedPrice" runat="server" Text="" CssClass="form-check-input" />
                                            <label class="small-font font-weight-normal" for="">Is Fixed Price</label>
                                        </div>
                                    </div>
                                    <asp:GridView ID="GridViewRateType" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm table-hover"
                                AllowPaging="True" PageSize="50" OnPageIndexChanging="GridViewRateType_PageIndexChanging">
                                <Columns>
                                    <asp:BoundField DataField="ID" HeaderText="ID" />
                                    <asp:BoundField DataField="Name" HeaderText="Name" />
                                    <asp:BoundField DataField="RateTypeID" HeaderText="RateTypeID" />
                                    <asp:BoundField DataField="Code" HeaderText="Code" />
                                    <asp:BoundField DataField="Rate" HeaderText="Rate" />
                                    <asp:BoundField DataField="Discount" HeaderText="Discount" />
                                </Columns>
                              <%--  <PagerSettings Mode="NextPrevious" Position="Bottom" />
                                <PagerStyle CssClass="pagination-style" />--%>
                            </asp:GridView>
                
                                </div>
                                <asp:Button ID="btnSaveRateType" runat="server" Text="Save Rate Type" class="btn btn-primary customGrey-btn rounded-0 text-dark border btn-sm next-step float-right" OnClick="btnSaveRateType_Click" CausesValidation="false" />
                            </div>
                        </div>
                        </div>
                </div>
            </div>
        </div>
    </div>

                            <div class="clearfix"></div>
                        
                </section>

                <div>
                    <asp:Panel ID="pnlMSG" runat="server" Visible="false">
                        <uc1:msg_Box ID="ctrl_MSG" runat="server" />
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
    <style>
    .pagination-style {
    text-align: center;
    padding: 15px 0;
    font-family: Arial, sans-serif;
}
    .pagination-container {
    display: flex;
    flex-direction: column;
    width: 100%;
    margin-top: 10px;
}

.pagination-left {
    text-align: left;
    font-size: 14px;
    color: #666;
}

.pagination-right {
    text-align: right;
    margin-top: 5px;
}

.pagination-bottom {
    text-align: left;
    font-size: 12px;
    color: #999;
    margin-top: 5px;
}

.pagination-style a {
    margin: 0 4px;
    padding: 8px 12px;
    text-decoration: none;
    color: #333;
    border: 1px solid #ddd;
    border-radius: 4px;
    transition: all 0.3s ease;
    background-color: #ffc107;
    font-size: 14px;
}

.pagination-style a:hover {
    background-color: #007bff;
    color: #fff;
    border-color: #007bff;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.pagination-style .active {
    background-color: #0056b3;
    color: #fff;
    border-color: #007bff;
    font-weight: bold;
    font-size: 16px; /* Larger font size */
    padding: 10px 16px; /* Larger padding */
    transform: translateY(-2px); /* Slight lift */
    box-shadow: 0 6px 12px rgba(0, 123, 255, 0.3); /* Stronger shadow */
    border-radius: 6px; /* Slightly larger border radius */
}

.pagination-style .disabled {
    color: #ccc;
    pointer-events: none;
    background-color: #f9f9f9;
    border-color: #ddd;
}

.pagination-style a:first-child,
.pagination-style a:last-child {
    padding: 8px 16px;
    font-weight: bold;
}

.pagination-style a:first-child:hover,
.pagination-style a:last-child:hover {
    background-color: #0056b3;
    border-color: #0056b3;
}
    </style>


<script type="text/javascript">
    function setActiveTab(tabId) {
        document.getElementById('<%= hfActiveTab.ClientID %>').value = tabId;
    }

    function restoreActiveTab() {
        var activeTabId = document.getElementById('<%= hfActiveTab.ClientID %>').value;
        if (activeTabId) {
            $('.nav-tabs a[href="#' + activeTabId + '"]').tab('show');
        }
    }

    $(document).ready(function () {
        restoreActiveTab();
        
        // Update hidden field when a tab is clicked
        $('.nav-tabs a').on('shown.bs.tab', function (e) {
            var tabId = $(e.target).attr('href').substring(1); // Get tab ID without #
            setActiveTab(tabId);
        });
    });
</script>
 </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>