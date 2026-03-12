<%@ Page Title="Lab Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="frmLaboratory.aspx.cs" Inherits="Site_frmLaboratory" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<!-- Include Quill CSS -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Include Quill JS -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>    
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
                              <div class="col-md-3">
                                  <div class="row">
        <div class="col-md-4">
            <label class="small-font font-weight-normal">Center:</label>
        </div>
        <div class="col-md-8">
            <!-- Dropdown for selecting Center -->
            <asp:Button ID="btnCenter" runat="server" CssClass="btn btn-default btn-sm dropdown-toggle form-control common-font rounded"
                        Text="801,1001,1401,1501,2301" data-toggle="dropdown" />

            <!-- Dropdown Menu -->
            <ul class="dropdown-menu bg-light rounded-0" style="width:350px;">
                <!-- Static Header -->
                <li class="bg-light border-bottom p-1">
                    <div class="row">
                        <div class="col-md-2"><input type="checkbox" /></div>
                        <div class="col-md-3 small-font">Code</div>
                        <div class="col-md-7 small-font">Center Name</div>
                    </div>
                </li>

                <!-- Dynamic Item List (Populated Dynamically from Code-Behind or JavaScript) -->
                <asp:Repeater ID="rptCenters" runat="server">
                    <ItemTemplate>
                        <li class="mt-1 p-1">
                            <div class="row">
                                <div class="col-md-1"><input type="checkbox" /></div>
                                <div class="col-md-3"><input class="form-control small-font" type="text" value="" /></div>
                                <div class="col-md-8"><input class="form-control small-font" type="text" value=""/></div>
                            </div>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>

                <!-- Example of Static Item -->
                <li class="bg-white border-bottom border-top p-1">
                    <div class="row">
                        <div class="col-md-1"><input type="checkbox" /></div>
                        <input class="col-md-2 small-font"></br>
                        <input class="col-md-8 small-font">
                    </div>
                </li>
                 <li class="bg-white border-bottom border-top p-1">
                    <div class="row">
                        <div class="col-md-1"><input type="checkbox" /></div>
                        <div class="col-md-1 small-font">801</div>
                        <div class="col-md-10 small-font">Lahore: CC:01:Jinnah Center Faisal Town</div>
                    </div>
                </li>

                <!-- Example of Another Static Item -->
                <li class="bg-white border-bottom p-1">
                    <div class="row">
                        <div class="col-md-1"><input type="checkbox" /></div>
                        <div class="col-md-1 small-font">1001</div>
                        <div class="col-md-10 small-font">Lahore: CC:02:Garden Mall</div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>

                                <!-- Username -->
                                <div class="col-md-3">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label class="small-font font-weight-normal">Username:</label>
                                        </div>
                                        <div class="col-md-8">
                                            <input class="form-control common-font rounded" type="text">
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
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"/>
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
                                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn bg-blueGradient text-white float-right move-up" OnClick="btnSearch_Click" />

                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm table-hover"
                                    AllowPaging="True" PageSize="10"
                                    PagerSettings-Mode="NextPrevious" PagerSettings-Position="Bottom"
                                    OnPageIndexChanging="GridView1_PageIndexChanging">
                                    <Columns>
                                        <asp:BoundField DataField="ID" HeaderText="ID" />
                                        <asp:BoundField DataField="PatientNumber" HeaderText="Patient Number" />
                                        <asp:BoundField DataField="FirstName" HeaderText="Name" />
                                        <asp:BoundField DataField="Location" HeaderText="Location" />
                                        <asp:BoundField DataField="DateRegistered" HeaderText="Date Registered" DataFormatString="{0:MM/dd/yyyy}" />
                                        <asp:BoundField DataField="Sex" HeaderText="Gender" />
                                        <asp:BoundField DataField="NIC" HeaderText="NIC" />
                                        <asp:BoundField DataField="Mobile" HeaderText="Mobile #" />
                                        <asp:BoundField DataField="DateOfBirth" HeaderText="Date of Birth" />
                                        <asp:BoundField DataField="City" HeaderText="City" />
                                        <asp:BoundField DataField="BloodGroup" HeaderText="Blood Group" />

                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <div class="dropdown">
                                                    <button type="button" class="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm dropdown-toggle" 
                                                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Actions">
                                                        <i class="fa fa-ellipsis-v"></i> 
                                                    </button>
                                                    <div class="dropdown-menu dropdown-menu-right rounded-0">
                                                        <asp:LinkButton ID="lnkTests" runat="server" CssClass="dropdown-item common-font"
                                                            CommandArgument='<%# Eval("ID") %>' OnClick="btnViewTest_Click" Text="Tests"><i class="fa fa-flask mr-2"></i>Tests</asp:LinkButton>
                                                        <%-- Additional actions can be added here --%>
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
                                                <asp:Button ID="btnPreviousPage" runat="server" Text="Previous Page" CssClass="btn btn-primary btn-sm" OnClick="PreviousPageButton_Click" 
                                                    Enabled="<%# GridView1.PageIndex > 0 %>" />
                                                <asp:Button ID="btnNextPage" runat="server" Text="Next Page" CssClass="btn btn-primary btn-sm" OnClick="NextPageButton_Click" 
                                                    Enabled="<%# GridView1.PageIndex < GridView1.PageCount - 1 %>" />
                                            </div>
                                            <div class="pagination-bottom">
                                                <span>Total Rows on Page: <%= GridView1.Rows.Count %></span>
                                            </div>
                                        </div>
                                    </PagerTemplate>
                                </asp:GridView>
            <asp:Panel ID="pnlTestResults" runat="server" Visible="false" CssClass="mt-3">
                            <asp:GridView ID="gvTestResults" runat="server" CssClass="table table-bordered table-hover" AutoGenerateColumns="False">
                                <Columns>
                                    <asp:BoundField DataField="ID" HeaderText="ID" />
                                    <asp:BoundField DataField="Code" HeaderText="Code" />
                                    <asp:BoundField DataField="TestID" HeaderText="Test ID" />
                                    <asp:BoundField DataField="TestName" HeaderText="Test Name" />
                                    <asp:BoundField DataField="TemplateID" HeaderText="Template ID" />
                                    <asp:BoundField DataField="Sex" HeaderText="Gender" />
                                    <asp:BoundField DataField="Type" HeaderText="Type" />
                                     <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:PlaceHolder runat="server" ID="phActions">
                                                <%# Convert.ToString(Eval("TemplateID")) == "27" ? 
                                                    "<button type='button' class='btn btn-white' data-toggle='modal' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-target='#urineTestModal'>" +
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />" +
                                                    "</button>" 
                                                    : "" %>
                                                <%# (Convert.ToString(Eval("TemplateID")) == "4" && Convert.ToString(Eval("Type")) == "1" && Convert.ToString(Eval("Code")) != "3440") 
                                                    ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#DLCTestModal'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                    : "" %>
                                                <%# (Convert.ToString(Eval("TemplateID")) == "4" && Convert.ToString(Eval("Type")) == "2") 
                                                    ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#DLCTestModal'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                    : "" %>
                                                <%# Convert.ToString(Eval("TemplateID")) == "33" ? 
                                                    "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#PUS_FOR_AFB'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" : 
                                                    "" %>
                                                                                                 
                                                <%# Convert.ToString(Eval("TemplateID")) == "32" ? 
                                                "<button type='button' class='btn btn-white' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#PUS_FOR_AFB_SMEAR'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" : 
                                                "" %>

                                                 <%# (Convert.ToString(Eval("Code")) == "1208") 
                                                    ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#SemenCSModal'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                    : "" %>

                                                 <%# Convert.ToString(Eval("Code")) == "5011" 
                                                    ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#HBElectroModal'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                    : "" %>
                                                <%# (Convert.ToString(Eval("Code")) == "1200") 
                                                    ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#StoolforCE'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                    : "" %>
                                                 <%# (Convert.ToString(Eval("Code")) == "4610") 
                                                    ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#hcvPCRModal'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                    : "" %>

                                                    <%# (Convert.ToString(Eval("Code")) == "1101") 
                                                        ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#urineTestModalForCS'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                        : "" %> 

                                                      <%# (Convert.ToString(Eval("Code")) == "1201") 
                                                        ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#stoolTestModalForCS'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                        : "" %>
                                                    <%# (Convert.ToString(Eval("Code")) == "1207") 
                                                        ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#semenAnalysisModal'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                        : "" %> 
                                                      <%# (Convert.ToString(Eval("Code")) == "2801") 
                                                        ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#bloodGroupCrossmatchModal'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                        : "" %> 
                                                     <%# (Convert.ToString(Eval("Code")) == "4617") 
                                                        ? "<button type='button' class='btn btn-white dlc-test-button' onclick=\"OpenDLC('" + Eval("ID") + "','" + Eval("Sex") + "','" + Eval("TestID") + "','" + Eval("TemplateID") + "','" + Eval("Code") + "','" + Eval("Type") + "');\" data-toggle='modal' data-target='#hbvPcrModal'>"+ 
                                                    "<img src='../../Site/WebTemplate/images/plus.png' class='img-fluid' />"
                                                    +"</button>" 
                                                        : "" %> 


                                               <asp:LinkButton 
    ID="btnAddTestResult"
    runat="server"
    CssClass="btn btn-white"
    CommandName="AddResult"
    CommandArgument='<%# Eval("ID") + "," + Eval("Sex") + "," + Eval("TestID") + "," + Eval("TemplateID") + "," + Eval("Code") + "," + Eval("Type") %>'
    OnClick="btnAddTestResult_Click"
    Visible='<%# Convert.ToString(Eval("TemplateID")) == "3" 
            || Convert.ToString(Eval("TemplateID")) == "6" 
            || (Convert.ToString(Eval("TemplateID")) == "4" && Convert.ToString(Eval("Type")) == "0") 
            || Convert.ToString(Eval("TemplateID")) == "5" 
            || Convert.ToString(Eval("Code")) == "3440" %>'>

    <img src="../../Site/WebTemplate/images/plus.png" class="img-fluid" />

</asp:LinkButton> </asp:PlaceHolder>
                                        </ItemTemplate>
                                    </asp:TemplateField>


                                </Columns>
                            </asp:GridView>
                        </asp:Panel>

                                <asp:GridView ID="gvAddResult" runat="server" AutoGenerateColumns="False" 
                                        ShowEditButton="true" OnRowEditing="gvAddResult_RowEditing" 
                                        OnRowCancelingEdit="gvAddResult_RowCancelingEdit" 
                                        OnRowUpdating="gvAddResult_RowUpdating" 
                                        CssClass="table table-bordered table-sm table-hover" HeaderStyle-CssClass="header-style">
                                        <Columns>
                                            <asp:BoundField DataField="TestID" HeaderText="Test ID" ReadOnly="true"  />
                                            <asp:BoundField DataField="Name" HeaderText="Test Name" ReadOnly="true" />
                                            <asp:BoundField DataField="CutoffValue"  ApplyFormatInEditMode="true" HeaderText="Cut off Value" Visible="false" />

                                            <asp:TemplateField HeaderText="Patient Value" Visible="false">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtPatientValue" runat="server" Text=""></asp:TextBox>
                                                    
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="lblPatientValue" runat="server" Text=""></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Result" Visible="false">
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtResult" runat="server" Text=""></asp:TextBox>
                                                    
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="lblResult" runat="server" Text=""></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                               <asp:TemplateField HeaderText="Blood Group" Visible="false">
                                                <EditItemTemplate>
                                                    <asp:DropDownList ID="ddlResultBloodGroup" runat="server"  >
                                                         <asp:ListItem Value="" Text="---Select Blood Group---" />
                                                            <asp:ListItem Value="A+" Text="A+" />
                                                            <asp:ListItem Value="B+" Text="B+" />
                                                            <asp:ListItem Value="O+" Text="O+" />
                                                            <asp:ListItem Value="AB+" Text="AB+" />
                                                            <asp:ListItem Value="A-" Text="A-" />
                                                            <asp:ListItem Value="B-" Text="B-" />
                                                            <asp:ListItem Value="O-" Text="O-" />
                                                            <asp:ListItem Value="AB-" Text="AB-" />
                                                    </asp:DropDownList>                                                    
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="ddlResultBloodGroup" runat="server" Text=""></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Result P-N" Visible="false">
                                                <EditItemTemplate>
                                                    <asp:DropDownList ID="ddlResult" runat="server"  >
                                                         <asp:ListItem Value="" Text="---Select Result---" />
                                                            <asp:ListItem Value="Negative" Text="Negative" />
                                                            <asp:ListItem Value="Positive" Text="Positive" />
                                                    </asp:DropDownList>                                                    
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="ddl_lblResult" runat="server" Text=""></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                           
                                            
                                            <asp:BoundField DataField="Unit" HeaderText="Unit" ReadOnly="true" Visible="false" />
                                            <asp:BoundField DataField="FromValue" HeaderText="From Value" ReadOnly="true" Visible="false" />
                                            <asp:BoundField DataField="ToValue" HeaderText="To Value" ReadOnly="true" Visible="false" />
                                            <asp:CommandField ShowEditButton="True" HeaderText="Action" />
                                        </Columns>
                                    </asp:GridView>

                                    

                            </tbody>
                        </table>
                         <!-- Modal Structure -->
<div class="modal fade" id="PUS_FOR_AFB" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalLabel" style="font-size: 14px;">PUS FOR AFB C/S (First Report after three weeks)</h5>
                <button type="button" class="close btn-sm p-1" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true" style="font-size: 14px;">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Tabs -->
                <ul class="nav nav-tabs" id="testTabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="test-result-tab" data-toggle="tab" href="#test-result" role="tab" aria-controls="test-result" aria-selected="true">Test Result</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="test-images-tab" data-toggle="tab" href="#test-images" role="tab" aria-controls="test-images" aria-selected="false">Test Images</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="test-detail-tab" data-toggle="tab" href="#test-detail" role="tab" aria-controls="test-detail" aria-selected="false">Test Result Detail</a>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content mt-3">
                    <!-- Test Result Tab -->
                    <div class="tab-pane fade show active" id="test-result" role="tabpanel" aria-labelledby="test-result-tab">
                        <div class="form-group d-flex align-items-center">
                            <label for="testResultCode" class="mr-2 mb-0" style="font-size: 12px;">Code:</label>
                <select id="testDropdown" class="form-control form-control-sm" style="width: 100px; font-size: 12px; padding: 2px 5px;">
            </select>                            <button type="button" class="btn btn-sm btn-secondary ml-2 p-1" data-toggle="modal" data-target="#commentModal">+</button>
                        </div>
<textarea id="resultText" name="resultText" class="form-control" rows="6" style="font-size: 12px;" placeholder="Write test results..."></textarea>
                    </div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>




<div class="tab-pane fade" id="test-images" role="tabpanel" aria-labelledby="test-images-tab">
    <p style="font-size: 12px; text-align: left;">Upload test images here.</p>
   
    <!-- Add UpdatePanel here -->
   <asp:UpdatePanel ID="UpdatePanel2" runat="server">
    <ContentTemplate>
        <!-- File Upload Input -->
        <input type="file" id="fileUpload" class="form-control-file" multiple accept="image/*" onchange="previewImages(event)" />

        <!-- Add Upload Button -->

        <!-- Image Previews Centered -->
        <div id="imagePreviewWrapper" style="display: flex; justify-content: center; align-items: center; gap: 20px; margin-top: 10px;">
            <!-- Image 1 Preview -->
            <div id="imagePreviewContainer1" style="display: none; text-align: center;">
                <p style="font-size: 12px;">Image Preview 1:</p>
                <img id="imagePreview1" src="" alt="Uploaded Image 1" style="max-width: 230px; height: 150px; border: 1px solid #ccc; padding: 5px;">
            </div>

            <!-- Image 2 Preview -->
            <div id="imagePreviewContainer2" style="display: none; text-align: center;">
                <p style="font-size: 12px;">Image Preview 2:</p>
                <img id="imagePreview2" src="" alt="Uploaded Image 2" style="max-width: 230px; height: 150px; border: 1px solid #ccc; padding: 5px;">
            </div>
        </div>

        <!-- Message Label -->
        <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
    </ContentTemplate>
</asp:UpdatePanel>
</div>
<!-- JavaScript for Image Preview -->
<script>
    function previewImages(event) {
    var files = event.target.files;

    // Hide preview containers before showing new images
    document.getElementById("imagePreviewContainer1").style.display = "none";
    document.getElementById("imagePreviewContainer2").style.display = "none";

    if (files.length > 0) {
        // First image preview
        let reader1 = new FileReader();
        reader1.onload = function (e) {
            document.getElementById("imagePreview1").src = e.target.result;
            document.getElementById("imagePreviewContainer1").style.display = "block";
            uploadImage(e.target.result, "Image1");
        };
        reader1.readAsDataURL(files[0]);

        // Second image preview (if exists)
        if (files.length > 1) {
            let reader2 = new FileReader();
            reader2.onload = function (e) {
                document.getElementById("imagePreview2").src = e.target.result;
                document.getElementById("imagePreviewContainer2").style.display = "block";
                uploadImage(e.target.result, "Image2");
            };
            reader2.readAsDataURL(files[1]);
        }
    }
}

// Function to send image data to server using AJAX
function uploadImage(imageData, imageKey) {
    $.ajax({
        type: "POST",
        url: "frmLaboratory.aspx/SaveImageToViewState",  // Update with your actual page name
        data: JSON.stringify({ base64Image: imageData, key: imageKey }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            console.log(imageKey + " uploaded successfully!");
        },
        error: function (xhr, status, error) {
            console.error("Error uploading " + imageKey + ": " + error);
        }
    });
}


</script>
                    <!-- Test Result Detail Tab -->
                  <div class="tab-pane fade" id="test-detail" role="tabpanel" aria-labelledby="test-detail-tab">
    <div class="form-group d-flex align-items-center">
        <label for="testDetailCode" class="mr-2 mb-0" style="font-size: 12px;">Code:</label>
        
        <select id="testDropdown2" class="form-control form-control-sm" style="width: 100px; font-size: 12px; padding: 2px 5px;">
            </select> 
        <button type="button" class="btn btn-sm btn-secondary ml-2 p-1" data-toggle="modal" data-target="#commentModal2">+</button>
    </div>
<textarea id="resultText2" name="resultText2" class="form-control" rows="8" style="font-size: 12px;" placeholder="Write test results..."></textarea>
    <!-- ASP.NET Button to Save Data -->
    <div class="mt-3">
        <asp:Button ID="btnSaveTestDetail" runat="server" Text="Save" CssClass="btn btn-primary btn-sm" OnClick="btnSaveTestDetail_Click" />
    </div>
</div>
                </div>
            </div>

            
        </div>
    </div>
</div>


 <!-- PUS FOR AFB C/S (First Report After three weeks  // Starting Code-->

<!-- Comment Popup Modal -->
<div class="modal fade" id="commentModal" tabindex="-1" role="dialog" aria-labelledby="commentModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="commentModalLabel" style="font-size: 16px;">Add Comment</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Added Code Field -->
                <div class="form-group mb-3">
                    <label for="testResultCode" class="mr-2 mb-0" style="font-size: 12px;">Code:</label>
                    <asp:TextBox ID="txtTestResultCode" runat="server" CssClass="form-control form-control-sm" placeholder="Enter code" style="width: 100px; font-size: 12px; padding: 2px 5px;" TextMode="Number"></asp:TextBox>                </div>

                <!-- Custom Toolbar -->
                <div class="toolbar mb-2">
                    <button type="button" class="btn btn-sm btn-light" onclick="formatText('bold')"><strong>B</strong></button>
                    <button type="button" class="btn btn-sm btn-light" onclick="formatText('italic')"><em>I</em></button>
                    <button type="button" class="btn btn-sm btn-light" onclick="formatText('underline')"><u>U</u></button>
                    <button type="button" class="btn btn-sm btn-light" onclick="formatText('strikethrough')"><s>S</s></button>
                    <select onchange="changeFontSize(this.value)">
                        <option value="">Font Size</option>
                        <option value="12px">Small</option>
                        <option value="16px">Medium</option>
                        <option value="24px">Large</option>
                    </select>
                </div>

                <!-- Editable Div for Comment -->
<asp:TextBox ID="commentText" runat="server" TextMode="MultiLine" CssClass="form-control" style="height: 150px; overflow-y: auto; border: 1px solid #ccc; padding: 8px;" ></asp:TextBox>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="commentModal2" tabindex="-1" role="dialog" aria-labelledby="commentModalLabel2" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="commentModalLabel2" style="font-size: 16px;">Add Another Comment</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Added Code Field -->
                <div class="form-group mb-3">
                    <label for="testResultCode2" class="mr-2 mb-0" style="font-size: 12px;">Code:</label>

                    <asp:TextBox ID="txtTestResultCode2" runat="server" CssClass="form-control form-control-sm" placeholder="Enter code" style="width: 100px; font-size: 12px; padding: 2px 5px;" TextMode="Number"></asp:TextBox>

                </div>

                <!-- Custom Toolbar -->
                <div class="toolbar mb-2">
                    <button type="button" class="btn btn-sm btn-light" onclick="formatText('bold')"><strong>B</strong></button>
                    <button type="button" class="btn btn-sm btn-light" onclick="formatText('italic')"><em>I</em></button>
                    <button type="button" class="btn btn-sm btn-light" onclick="formatText('underline')"><u>U</u></button>
                    <button type="button" class="btn btn-sm btn-light" onclick="formatText('strikethrough')"><s>S</s></button>
                    <select onchange="changeFontSize(this.value)">
                        <option value="">Font Size</option>
                        <option value="12px">Small</option>
                        <option value="16px">Medium</option>
                        <option value="24px">Large</option>
                    </select>
                </div>

                <!-- Editable Div for Comment -->
<asp:TextBox ID="commentText2" runat="server" TextMode="MultiLine" CssClass="form-control" style="height: 150px; overflow-y: auto; border: 1px solid #ccc; padding: 8px;"></asp:TextBox>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<!-- JavaScript for Text Formatting -->
<script>
    function formatText(command) {
        const commentDiv = document.getElementById('commentText');
        document.execCommand(command, false, null);
        commentDiv.focus();
    }

    function changeFontSize(size) {
        if (size) {
            const commentDiv = document.getElementById('commentText');
            document.execCommand('fontSize', false, 7); // Hack to enable font size changes
            const selectedText = window.getSelection().toString();
            if (selectedText) {
                // Wrap the selected text in a span with the specified font size
                const newText = `<span style="font-size: ${size};">${selectedText}</span>`;
                document.execCommand('insertHTML', false, newText);
            }
        }
    }

    function saveComment() {
        const commentContent = document.getElementById('commentText').innerHTML;
        console.log(commentContent); // Do something with the content (e.g., save it)
        alert('Comment saved!'); // Example action
    }
</script>

<!-- Optional: Add Some Basic Styling -->
<style>
    .toolbar .btn {
        margin-right: 5px;
    }
    .toolbar select {
        margin-left: 10px;
        padding: 3px;
    }
</style>

<!-- PUS FOR AFB C/S (First Report After three weeks  // Ending Code-->


                       <%-- BELOW MODEL --%>
<!-- Modal -->
<div class="modal fade" id="PUS_FOR_AFB_SMEAR" tabindex="-1" role="dialog" aria-labelledby="modalTitle" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Add Test Result</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" style="max-height: 60vh; overflow-y: auto;">
                <!-- Nav Tabs -->
                <ul class="nav nav-tabs" id="testTabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="culture-tab" data-toggle="tab" href="#culture" role="tab">Culture</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="sensitivity-tab" data-toggle="tab" href="#sensitivity" role="tab">Sensitivity</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="comments-tab" data-toggle="tab" href="#comments" role="tab">Comments</a>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content mt-3">
                    <div class="tab-pane fade show active" id="culture" role="tabpanel">
                            <!-- Specimen -->
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label small-font">SPECIMEN:</label>
                                <div class="col-sm-8">
   <select id="ddlCommentCode" class="form-control small-font">
    <option value="">Select Comment Code</option>
</select>
<%--awais--%>
<!-- Hidden Textbox to Show Comments -->
<input type="text" id="txtComments" class="form-control" placeholder="Comments will appear here" readonly>

</div>
                                <div class="col-sm-2">
                                    <button type="button" class="btn btn-secondary small-font" data-toggle="modal" data-target="#specimenCommentModal">...</button>
                                </div>
                            </div>

                            <!-- Microscopy -->
                            <div class="row">
                                <label class="col-sm-2 col-form-label small-font">MICROSCOPY:</label>
                            </div>

                            <!-- Direct -->
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label small-font">DIRECT:</label>
                                <div class="col-sm-10">
                                    <textarea class="form-control small-font"></textarea>
                                </div>
                            </div>

                            <!-- Z.N. Staining -->
                           <div class="form-group">
    <label class="small-font">Z.N. STAINING:</label>
    <div class="row no-gutters">
        <div class="col-sm-3">
            <select class="form-control small-font" id="znStainingDropdown">
                <option value="">Select an option</option>
                <option value="Option 1">Option 1</option>
                <option value="Option 2">Option 2</option>
                <option value="Option 3">Option 3</option>
            </select>
        </div>
        <div class="col-sm-7">
            <!-- Toolbar for formatting buttons -->
            <div class="btn-toolbar mb-2" role="toolbar">
                <div class="btn-group mr-2" role="group">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="formatText('bold')"><b>B</b></button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="formatText('italic')"><i>I</i></button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="formatText('underline')"><u>U</u></button>
                </div>
                <div class="btn-group" role="group">
                    <select class="form-control form-control-sm" onchange="changeFontSize(this.value)">
                        <option value="12px">12px</option>
                        <option value="14px">14px</option>
                        <option value="16px">16px</option>
                        <option value="18px">18px</option>
                    </select>
                </div>
            </div>
            <!-- Replace textarea with contenteditable div -->
<%--            <div class="form-control small-font" id="znStainingTextarea" contenteditable="true" style="height: 100px; overflow-y: auto; border: 1px solid #ced4da; padding: 5px;"></div>--%>
            <textarea class="form-control small-font" id="txtZnComments" rows="4" ></textarea>

        </div>
        <div class="col-sm-2">
            <button type="button" class="btn btn-secondary small-font" data-toggle="modal" data-target="#znCommentModal">...</button>
        </div>
    </div>
</div>

                            <!-- Gram Stain -->


                          <div class="form-group">
    <label class="small-font">GRAM STAIN:</label>
    <div class="row no-gutters">
        <div class="col-sm-3">
            <select class="form-control small-font" id="gramStainDropdown">
                <option value="">Select an option</option>
                <option value="Option 1">Option 1</option>
                <option value="Option 2">Option 2</option>
                <option value="Option 3">Option 3</option>
            </select>
        </div>
        <div class="col-sm-7">
            <!-- Toolbar for formatting buttons -->
            <div class="btn-toolbar mb-2" role="toolbar">
                <div class="btn-group mr-2" role="group">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="formatText('bold', 'gramStainTextarea')"><b>B</b></button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="formatText('italic', 'gramStainTextarea')"><i>I</i></button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="formatText('underline', 'gramStainTextarea')"><u>U</u></button>
                </div>
                <div class="btn-group" role="group">
                    <select class="form-control form-control-sm" onchange="changeFontSize(this.value, 'gramStainTextarea')">
                        <option value="12px">12px</option>
                        <option value="14px">14px</option>
                        <option value="16px">16px</option>
                        <option value="18px">18px</option>
                    </select>
                </div>
            </div>
            <!-- Replace textarea with contenteditable div -->
<%--            <div class="form-control small-font" id="gramStainTextarea" contenteditable="true" style="height: 100px; overflow-y: auto; border: 1px solid #ced4da; padding: 5px;"></div>--%>
            <textarea class="form-control small-font" id="txtGramComments" rows="4" ></textarea>

        </div>
        <div class="col-sm-2">
            <button type="button" class="btn btn-secondary small-font" data-toggle="modal" data-target="#gramCommentModal">...</button>
        </div>
    </div>
</div>

                            <!-- Culture -->
                           <div class="form-group">
    <label class="small-font">CULTURE:</label>
    <div class="row no-gutters">
        <div class="col-sm-3">
            <select class="form-control small-font" id="cultureDropdown">
                <option value="">Select an option</option>
                <option value="Option 1">Option 1</option>
                <option value="Option 2">Option 2</option>
                <option value="Option 3">Option 3</option>
            </select>
        </div>
        <div class="col-sm-7">
            <!-- Toolbar for formatting buttons -->
            <div class="btn-toolbar mb-2" role="toolbar">
                <div class="btn-group mr-2" role="group">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="formatText('bold', 'cultureTextarea')"><b>B</b></button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="formatText('italic', 'cultureTextarea')"><i>I</i></button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="formatText('underline', 'cultureTextarea')"><u>U</u></button>
                </div>
                <div class="btn-group" role="group">
                    <select class="form-control form-control-sm" onchange="changeFontSize(this.value, 'cultureTextarea')">
                        <option value="12px">12px</option>
                        <option value="14px">14px</option>
                        <option value="16px">16px</option>
                        <option value="18px">18px</option>
                    </select>
                </div>
            </div>
            <!-- Replace textarea with contenteditable div -->
<%--            <div class="form-control small-font" id="cultureTextarea" contenteditable="true" style="height: 100px; overflow-y: auto; border: 1px solid #ced4da; padding: 5px;"></div>--%>
                        <textarea class="form-control small-font" id="txtCultureComments" rows="4" ></textarea>


        </div>
        <div class="col-sm-2">
            <button type="button" class="btn btn-secondary small-font" data-toggle="modal" data-target="#cultureCommentModal">...</button>
        </div>
    </div>
</div>

                            <!-- Colony Count -->
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label small-font">COLONY COUNT:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control small-font">
                                </div>
                            </div>
                    </div>
                                        <div class="tab-pane fade" id="sensitivity" role="tabpanel">
<asp:Repeater ID="rptAntimicrobialGroups" runat="server">
    <ItemTemplate>
        <div class="group-container">
            <button type="button" class="btnExpand" data-target="group_<%# Eval("Code") %>">+</button>
            <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' CssClass="group-name"></asp:Label>

            <div id="group_<%# Eval("Code") %>" class="nested-group">
                <table class="antimicrobial-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>S1</th>
                            <th>S2</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptAntimicrobials" runat="server" DataSource='<%# Eval("Children") %>'>
                            <ItemTemplate>
                                <tr>
                                    <!-- Hidden Field to Store Antimicrobial ID -->
                                    <asp:HiddenField ID="hfAntimicrobialID" runat="server" Value='<%# Eval("AntimicrobialID") %>' />

                                    <!-- Name -->
                                    <td>
                                        <asp:Label ID="lblAntimicrobial" runat="server" Text='<%# Eval("Name") %>' CssClass="antimicrobial-label" />
                                    </td>
                                    <!-- First TextBox -->
                                    <td>
                                        <asp:TextBox ID="txtValue1" runat="server" CssClass="input-box"></asp:TextBox>
                                    </td>
                                    <!-- Second TextBox -->
                                    <td>
                                        <asp:TextBox ID="txtValue2" runat="server" CssClass="input-box"></asp:TextBox>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>

<!-- Save Button -->
<asp:Button ID="Button1" runat="server" Text="Save" CssClass="btn-save" OnClick="btnSave_Click" />



                                           <script>
    if (typeof jQuery == 'undefined') {
        console.error("jQuery is not loaded!");
    } else {
        $(document).ready(function () {
            console.log("jQuery is loaded and script is running!");

            // Event delegation for dynamically generated elements
            $(document).on("click", ".btnExpand", function () {
                console.log("Button Clicked!"); // Debugging Click Event

                var target = $(this).attr("data-target");
                console.log("Target ID:", target); // Debugging Target ID

                var targetElement = $("#" + target);

                if (targetElement.length) {
                    targetElement.slideToggle(); // Expand/Collapse

                    // Toggle button text (+ to -)
                    var currentText = $(this).text();
                    $(this).text(currentText === "+" ? "−" : "+");
                } else {
                    console.error("Target element not found:", target);
                }
            });
        });
    }
</script>

<style>
   
    .group-container {
    padding: 8px; /* Keep padding small */
    border: 1px solid #ccc;
    background-color: #f9f9f9;
    border-radius: 5px;
}

.btnExpand {
    cursor: pointer;
    margin-right: 5px;
    background-color: #007bff;
    color: white;
    border: none;
    padding: 3px 6px;  /* Reduced padding */
    font-size: 12px;    /* Smaller font size */
    border-radius: 3px;
    width: 20px;        /* Fixed width */
    height: 20px;       /* Fixed height */
    text-align: center;
    line-height: 14px;  /* Centers text inside */
}

.btnExpand:hover {
    background-color: #0056b3;
}

.group-name {
    font-size: 14px; /* Reduced font size */
    font-weight: bold;
}

.nested-group {
    margin-top: 8px;
    display: none;
}

.antimicrobial-table {
    width: 100%;
    border-collapse: collapse;
}

.antimicrobial-table th,
.antimicrobial-table td {
    border: 1px solid #ccc;
    padding: 8px;
    text-align: center; /* Centers content horizontally */
    vertical-align: middle; /* Centers content vertically */
}

.antimicrobial-table th {
    background-color: #f2f2f2;
    font-weight: bold;
}
.antimicrobial-label {
    font-size: 12px; /* Smaller text for labels */
}
.input-box {
    width: 100%;
    padding: 3px;
    border: 1px solid #ccc;
    border-radius: 3px;
    font-size: 12px; /* Smaller text inside textboxes */
}

.move-up {
    position: relative;
    top: -120px; /* Move it 40px upward */
}

</style>


     </div>
                   <!-- Main Comments Tab -->
<div class="tab-pane fade" id="comments" role="tabpanel">
    <!-- Comment Code Field -->
    <div class="form-group">
        <label for="commentCode" class="small-font">Comment Code</label>
        <div class="input-group">

<select class="form-control small-font" id="commentCode">
    <option value="">Select a Comment Code</option>
</select>


            <div class="input-group-append">
                <button type="button" class="btn btn-secondary small-font" data-toggle="modal" data-target="#firstModal">...</button>
            </div>
        </div>
    </div>

    <!-- Rich Text Editor for Comments -->
    <div class="form-group">
        <label for="richComment" class="small-font">Write a Comment</label>
<textarea id="richComment" class="form-control small-font" style="height: 150px; border: 1px solid #ccc; padding: 10px;"></textarea>
        <div class="mt-2">
            <button type="button" class="btn btn-sm btn-outline-secondary small-font" onclick="formatText('bold')"><strong>B</strong></button>
            <button type="button" class="btn btn-sm btn-outline-secondary small-font" onclick="formatText('italic')"><em>I</em></button>
            <button type="button" class="btn btn-sm btn-outline-secondary small-font" onclick="formatText('underline')"><u>U</u></button>
        </div>
    </div>
</div>

<!-- 🛑 First Modal -->
<div class="modal fade" id="firstModal" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title small-font">Add or Select a Comment</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <!-- Rich Text Editor in First Modal -->
                <div class="form-group">
                    <label for="firstModalComment" class="small-font">Write a Comment</label>
                    <div id="firstModalComment" class="form-control small-font" contenteditable="true" style="height: 150px; border: 1px solid #ccc; padding: 10px;"></div>
                    <div class="mt-2">
                        <button type="button" class="btn btn-sm btn-outline-secondary small-font" onclick="formatText('bold', 'firstModalComment')"><strong>B</strong></button>
                        <button type="button" class="btn btn-sm btn-outline-secondary small-font" onclick="formatText('italic', 'firstModalComment')"><em>I</em></button>
                        <button type="button" class="btn btn-sm btn-outline-secondary small-font" onclick="formatText('underline', 'firstModalComment')"><u>U</u></button>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary small-font" onclick="openSecondModal()">Next</button>
            </div>
        </div>
    </div>
</div>

<!-- 🛑 Second Modal -->
<div class="modal fade" id="secondModal" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title small-font">Confirm Comment</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p class="small-font">Your comment will be added to the main text area.</p>
                <div id="previewComment" class="small-font"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary small-font" onclick="closeSecondModal()">Close</button>
                <button type="button" class="btn btn-primary small-font" onclick="saveComment()">Save</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Function to format text in a contenteditable div
    function formatText(format, elementId = 'richComment') {
        const element = document.getElementById(elementId);
        const selection = window.getSelection();
        if (selection.rangeCount > 0) {
            const range = selection.getRangeAt(0);
            const selectedText = range.toString();
            if (selectedText) {
                let formattedText;
                switch (format) {
                    case 'bold':
                        formattedText = `<strong>${selectedText}</strong>`;
                        break;
                    case 'italic':
                        formattedText = `<em>${selectedText}</em>`;
                        break;
                    case 'underline':
                        formattedText = `<u>${selectedText}</u>`;
                        break;
                    default:
                        formattedText = selectedText;
                }
                const newNode = document.createElement('span');
                newNode.innerHTML = formattedText;
                range.deleteContents();
                range.insertNode(newNode);
            }
        }
    }

    // Function to open the second modal
    function openSecondModal() {
        const comment = document.getElementById('firstModalComment').innerHTML;
        document.getElementById('previewComment').innerHTML = comment;
        $('#firstModal').modal('hide'); // Close the first modal
        $('#secondModal').modal('show'); // Open the second modal
    }

    // Function to close the second modal
    function closeSecondModal() {
        $('#secondModal').modal('hide'); // Close only the second modal
    }

    // Function to save the comment and close the second modal
    function saveComment() {
        const comment = document.getElementById('firstModalComment').innerHTML;
        const mainTextarea = document.getElementById('richComment');
        if (comment.trim() !== "") {
            mainTextarea.innerHTML += comment + '<br>';
        }
        closeSecondModal(); // Close the second modal after saving
    }
</script>
                </div>
            </div>
            <div class="modal-footer">
                <%--awais--%>
<button id="btnSave" class="btn btn-primary">Save</button>
            </div>
        </div>
    </div>
</div>

<!-- Comment Modals -->
<!-- Specimen Comment Modal -->
<div class="modal fade" id="specimenCommentModal" tabindex="-1" role="dialog" aria-labelledby="specimenCommentModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="specimenCommentModalLabel">Add Comment for Specimen</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <!-- Example for Specimen Comment Modal -->
<div class="modal-body">
    <div class="btn-toolbar" role="toolbar">
        <div class="btn-group mr-2" role="group">
            <button type="button" class="btn btn-secondary" onclick="formatText('bold')"><b>B</b></button>
            <button type="button" class="btn btn-secondary" onclick="formatText('italic')"><i>I</i></button>
            <button type="button" class="btn btn-secondary" onclick="formatText('underline')"><u>U</u></button>
        </div>
        <div class="btn-group" role="group">
            <select class="form-control" onchange="changeFontSize(this.value)">
                <option value="12px">12px</option>
                <option value="14px">14px</option>
                <option value="16px">16px</option>
                <option value="18px">18px</option>
            </select>
        </div>
    </div>
    <!-- Replace textarea with contenteditable div -->
    <div class="form-control small-font" id="specimenComment" contenteditable="true" style="height: 100px; overflow-y: auto; border: 1px solid #ced4da; padding: 5px;" placeholder="Enter your comment here..."></div>
</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary small-font" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary small-font" id="saveSpecimenComment">Save Comment</button>
            </div>
        </div>
    </div>
</div>

<!-- Z.N. Staining Comment Modal -->
<div class="modal fade" id="znCommentModal" tabindex="-1" role="dialog" aria-labelledby="znCommentModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="znCommentModalLabel">Add Comment for Z.N. Staining</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
<!-- Example for Specimen Comment Modal -->
<div class="modal-body">
    <div class="btn-toolbar" role="toolbar">
        <div class="btn-group mr-2" role="group">
            <button type="button" class="btn btn-secondary" onclick="formatText('bold')"><b>B</b></button>
            <button type="button" class="btn btn-secondary" onclick="formatText('italic')"><i>I</i></button>
            <button type="button" class="btn btn-secondary" onclick="formatText('underline')"><u>U</u></button>
        </div>
        <div class="btn-group" role="group">
            <select class="form-control" onchange="changeFontSize(this.value)">
                <option value="12px">12px</option>
                <option value="14px">14px</option>
                <option value="16px">16px</option>
                <option value="18px">18px</option>
            </select>
        </div>
    </div>
    <!-- Replace textarea with contenteditable div -->
    <div class="form-control small-font" id="specimenComment" contenteditable="true" style="height: 100px; overflow-y: auto; border: 1px solid #ced4da; padding: 5px;" placeholder="Enter your comment here..."></div>
</div>            <div class="modal-footer">
                <button type="button" class="btn btn-secondary small-font" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary small-font" id="saveZnComment">Save Comment</button>
            </div>
        </div>
    </div>
</div>

<!-- Gram Stain Comment Modal -->
<div class="modal fade" id="gramCommentModal" tabindex="-1" role="dialog" aria-labelledby="gramCommentModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="gramCommentModalLabel">Add Comment for Gram Stain</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
           <!-- Example for Specimen Comment Modal -->
<div class="modal-body">
    <div class="btn-toolbar" role="toolbar">
        <div class="btn-group mr-2" role="group">
            <button type="button" class="btn btn-secondary" onclick="formatText('bold')"><b>B</b></button>
            <button type="button" class="btn btn-secondary" onclick="formatText('italic')"><i>I</i></button>
            <button type="button" class="btn btn-secondary" onclick="formatText('underline')"><u>U</u></button>
        </div>
        <div class="btn-group" role="group">
            <select class="form-control" onchange="changeFontSize(this.value)">
                <option value="12px">12px</option>
                <option value="14px">14px</option>
                <option value="16px">16px</option>
                <option value="18px">18px</option>
            </select>
        </div>
    </div>
    <!-- Replace textarea with contenteditable div -->
    <div class="form-control small-font" id="specimenComment" contenteditable="true" style="height: 100px; overflow-y: auto; border: 1px solid #ced4da; padding: 5px;" placeholder="Enter your comment here..."></div>
</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary small-font" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary small-font" id="saveGramComment">Save Comment</button>
            </div>
        </div>
    </div>
</div>

<!-- Culture Comment Modal -->
<div class="modal fade" id="cultureCommentModal" tabindex="-1" role="dialog" aria-labelledby="cultureCommentModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="cultureCommentModalLabel">Add Comment for Culture</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
           <!-- Example for Specimen Comment Modal -->
<div class="modal-body">
    <div class="btn-toolbar" role="toolbar">
        <div class="btn-group mr-2" role="group">
            <button type="button" class="btn btn-secondary" onclick="formatText('bold')"><b>B</b></button>
            <button type="button" class="btn btn-secondary" onclick="formatText('italic')"><i>I</i></button>
            <button type="button" class="btn btn-secondary" onclick="formatText('underline')"><u>U</u></button>
        </div>
        <div class="btn-group" role="group">
            <select class="form-control" onchange="changeFontSize(this.value)">
                <option value="12px">12px</option>
                <option value="14px">14px</option>
                <option value="16px">16px</option>
                <option value="18px">18px</option>
            </select>
        </div>
    </div>
    <!-- Replace textarea with contenteditable div -->
    <div class="form-control small-font" id="specimenComment" contenteditable="true" style="height: 100px; overflow-y: auto; border: 1px solid #ced4da; padding: 5px;" placeholder="Enter your comment here..."></div>
</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary small-font" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary small-font" id="saveCultureComment">Save Comment</button>
            </div>
        </div>
    </div>
</div>

<style>
    .small-font {
        font-size: 12px !important; /* Adjust the font size as needed */
    }

    .no-gutters {
        margin-right: 0;
        margin-left: 0;
    }

    .no-gutters > .col,
    .no-gutters > [class*="col-"] {
        padding-right: 0;
        padding-left: 0;
    }

    /* Remove left margin for textareas */
    .form-group textarea {
        margin-left: 0;
    }
</style>

<script>
    
    function formatText(command) {
        document.execCommand(command, false, null);
    }

    function changeFontSize(size) {
        document.execCommand('fontSize', false, size);
    }

    //$(document).ready(function() {
    //    // Save Specimen Comment
    //    $('#saveSpecimenComment').on('click', function() {
    //        var comment = $('#specimenComment').val();
    //        console.log('Specimen Comment:', comment);
    //        $('#specimenCommentModal').modal('hide');
    //    });

    //    // Save Z.N. Staining Comment
    //    $('#saveZnComment').on('click', function() {
    //        var comment = $('#znComment').val();
    //        console.log('Z.N. Staining Comment:', comment);
    //        $('#znCommentModal').modal('hide');
    //    });

    //    // Save Gram Stain Comment
    //    $('#saveGramComment').on('click', function() {
    //        var comment = $('#gramComment').val();
    //        console.log('Gram Stain Comment:', comment);
    //        $('#gramCommentModal').modal('hide');
    //    });

    //    // Save Culture Comment
    //    $('#saveCultureComment').on('click', function() {
    //        var comment = $('#cultureComment').val();
    //        console.log('Culture Comment:', comment);
    //        $('#cultureCommentModal').modal('hide');
    //    });

    //    // Update Z.N. Staining Textarea
    //    $('#znStainingDropdown').on('change', function() {
    //        var selectedValue = $(this).val();
    //        $('#znStainingTextarea').val(selectedValue);
    //    });

    //    // Update Gram Stain Textarea
    //    $('#gramStainDropdown').on('change', function() {
    //        var selectedValue = $(this).val();
    //        $('#gramStainTextarea').val(selectedValue);
    //    });

    //    // Update Culture Textarea
    //    $('#cultureDropdown').on('change', function() {
    //        var selectedValue = $(this).val();
    //        $('#cultureTextarea').val(selectedValue);
    //    });
    //});
</script>                             <%-- BELOW MODEL --%>

                        <!-- Urine Test Modal -->
                        <div class="modal fade" id="urineTestModal" tabindex="-1" role="dialog" aria-labelledby="urineTestModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg" role="document">
                                <div class="modal-content rounded-0">
                                    <div class="modal-header bg-light">
                                        <h4 class="modal-title">Urine Test Examination</h4>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="container">
                                            <div class="row">
                                                <!-- Physical Examination -->
                                                <div class="col-md-12">
                                                    <fieldset class="border p-2">
                                                        <legend class="w-auto">Physical Examination</legend>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label>Colour:</label>
                                                                    <asp:DropDownList ID="ddlColour" runat="server" CssClass="form-control mySelect2" AppendDataBoundItems="true">
                                                                        <asp:ListItem Text="Select Colour" Value="" />
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </div>
                                                            <script>
                                                                $(document).ready(function () {
                                                                    $('.mySelect2').select2({
                                                                        placeholder: "Select Colour",
                                                                        allowClear: true
                                                                    });
                                                                });
                                                            </script>


                                                            <div class="col-md-6">
                                                                <label>SP Gravity:</label>
                                                                <asp:DropDownList ID="ddlSpecificGravity" runat="server" CssClass="form-control">
                                                                    <asp:ListItem Text="Select Gravity" Value="" />
                                                                </asp:DropDownList>
                                                            </div>

                                                            <div class="col-md-6">
                                                                <label>Turbidity:</label><asp:TextBox ID="txtTurbidity" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-6">
                                                                <label>Deposit:</label><asp:TextBox ID="txtDeposit" CssClass="form-control" runat="server" /></div>
                                                        </div>
                                                    </fieldset>
                                                </div>

                                                <!-- Chemical Examination -->
                                                <div class="col-md-12 mt-3">
                                                    <fieldset class="border p-2">
                                                        <legend class="w-auto">Chemical Examination</legend>
                                                        <div class="row">
                                                            <div class="col-md-4">
                                                                <label>PH:</label><asp:TextBox ID="txtPH" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Sugar:</label><asp:TextBox ID="txtSugar" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Ketones:</label><asp:TextBox ID="txtKetones" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Proteins:</label><asp:TextBox ID="txtProteins" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Blood:</label><asp:TextBox ID="txtBlood" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Haemoglobin:</label><asp:TextBox ID="txtHaemoglobin" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Urobilinogen:</label><asp:TextBox ID="txtUrobilinogen" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Bilirubin:</label><asp:TextBox ID="txtBilirubin" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Nitrite:</label><asp:TextBox ID="txtNitrite" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Spot Urinary Protein:</label><asp:TextBox ID="txtSpotUrinaryProtein" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Leukocyte Esterases:</label><asp:TextBox ID="txtLeukocyteEsterases" CssClass="form-control" runat="server" /></div>
                                                        </div>
                                                    </fieldset>
                                                </div>

                                                <!-- Microscopic Examination -->
                                                <div class="col-md-12 mt-3">
                                                    <fieldset class="border p-2">
                                                        <legend class="w-auto">Microscopic Examination</legend>
                                                        <div class="row">
                                                            <div class="col-md-4">
                                                                <label>Pus Cells:</label><asp:TextBox ID="txtPusCells" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Red Blood Cells:</label><asp:TextBox ID="txtRBC" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>WBC:</label><asp:TextBox ID="txtWBC" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Epithelial Cells:</label><asp:TextBox ID="txtEpithelialCells" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Casts Granular:</label><asp:TextBox ID="txtCastsGranular" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Casts WBC:</label><asp:TextBox ID="txtCastsWBC" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Casts Cellular:</label><asp:TextBox ID="txtCastsCellular" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Casts RBC:</label><asp:TextBox ID="txtCastsRBC" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Casts Hyaline:</label><asp:TextBox ID="txtCastsHyaline" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Casts Other:</label><asp:TextBox ID="txtCastsOther" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Crystals Calcium Oxalate:</label><asp:TextBox ID="txtCrystalsCalciumOxalate" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Crystals Triple Phosphate:</label><asp:TextBox ID="txtCrystalsTriplePhosphate" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Crystals Uric Acid:</label><asp:TextBox ID="txtCrystalsUricAcid" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Crystals Other:</label><asp:TextBox ID="txtCrystalsOther" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Organisms:</label><asp:TextBox ID="txtOrganisms" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Amorphous:</label><asp:TextBox ID="txtAmorphous" CssClass="form-control" runat="server" /></div>
                                                            <div class="col-md-4">
                                                                <label>Misc:</label><asp:TextBox ID="txtMisc" CssClass="form-control" runat="server" /></div>
                                                        </div>
                                                    </fieldset>
                                                </div>

                                                <!-- Notes -->
                                                <div class="col-md-12 mt-3">
                                                    <fieldset class="border p-2">
                                                        <legend class="w-auto">Notes</legend>
                                                        <asp:TextBox ID="txtNotes" CssClass="form-control" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                                    </fieldset>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <asp:Button ID="btnSaveUrineResult" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btnSaveUrineResult_Click" />
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div  class="modal fade dlc-test-button" id="DLCTestModal" tabindex="-1" role="dialog" aria-labelledby="DLCTestModalLabel" aria-hidden="true" >
                           <div class="modal-dialog modal-lg" role="document">
                                <div class="modal-content rounded-0">
                                    <div class="modal-header bg-light">
                                        <h4 class="modal-title">Test Examination</h4>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    </div>
                                        <div class="modal-body">
                                            <div class="container" id="CBCContainor">
                                              
                                            </div>
                                            <div class="container" id="DLCContainor">
                                              
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button id="btnDLC" class="btn btn-primary" onclick="SubmitDLC()" >Save</button>
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                        </div>
                                </div>
                            </div>
                        </div>
                      

                        <div class="modal fade" id="SemenCSModal" tabindex="-1"
                            role="dialog" aria-labelledby="semenTestModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg" role="document">
                                <div class="modal-content rounded-0">

                                    <!--‑‑ Header ‑‑-->
                                    <div class="modal-header bg-light">
                                        <h4 class="modal-title" id="semenTestModalLabel">Semen Culture&nbsp;&amp;&nbsp;Sensitivity&nbsp;/&nbsp;Analysis
                                        </h4>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    </div>
                                    <!-- ►►►   TABBED MICROSCOPIC SECTIONS   ◄◄◄ -->
                                    <ul class="nav nav-tabs mt-3" id="semenTab" role="tablist">
                                        <li class="nav-item">
                                            <a class="nav-link active" id="motility-tab" data-toggle="tab"
                                                href="#motility" role="tab">Sperm&nbsp;Motility</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" id="morphology-tab" data-toggle="tab"
                                                href="#morphology" role="tab">Morphology&nbsp;(%)</a>
                                        </li>
                                    </ul>
                                    <!--‑‑ Body ‑‑-->
                                    <div class="modal-body">
                                        <div class="container-fluid">
                                            <div class="tab-content border-left border-right border-bottom p-3"
                                                id="semenTabContent">

                                                <!-- MOTILITY -->
                                                <div class="tab-pane fade show active" id="motility" role="tabpanel"
                                                    aria-labelledby="motility-tab">
                                                    <!-- Specimen meta -->
                                                    <div class="row">
                                                        <div class="col-md-6 form-group">
                                                            <label>Collection&nbsp;Date&nbsp;/&nbsp;Time:</label>
                                                            <asp:TextBox ID="txtCollectionDateTime" CssClass="form-control"
                                                                TextMode="DateTimeLocal" runat="server" />
                                                        </div>
                                                        <div class="col-md-6 form-group">
                                                            <label>Sample&nbsp;ID:</label>
                                                            <asp:TextBox ID="txtSampleID" CssClass="form-control" runat="server" />
                                                        </div>
                                                    </div>

                                                    <!-- ►►►   PHYSICAL / MACROSCOPIC EXAM   ◄◄◄ -->
                                                    <fieldset class="border p-2">
                                                        <legend class="w-auto mb-0">Physical Examination</legend>

                                                        <div class="row">
                                                            <div class="col-md-3 form-group">
                                                                <label>Duration&nbsp;of&nbsp;Abstinence (days):</label>
                                                                <asp:TextBox ID="txtAbstinence" CssClass="form-control" runat="server" />
                                                            </div>
                                                            <div class="col-md-3 form-group">
                                                                <label>Interval Between Ejaculation of Analysis:</label>
                                                                <asp:TextBox ID="txtIntervalEA" CssClass="form-control" runat="server" />
                                                            </div>
                                                            <div class="col-md-3 form-group">
                                                                <label>Volume&nbsp;(mL):</label>
                                                                <asp:TextBox ID="txtVolume" CssClass="form-control" runat="server" />
                                                            </div>
                                                            <div class="col-md-3 form-group">
                                                                <label>pH:</label>
                                                                <asp:TextBox ID="TextBox3" CssClass="form-control" runat="server" />
                                                            </div>
                                                        </div>

                                                        <div class="row">
                                                            <div class="col-md-3 form-group">
                                                                <label>Appearance:</label>
                                                                <asp:DropDownList ID="ddlAppearance" CssClass="form-control" runat="server">
                                                                    <asp:ListItem Text="Select" Value="" />
                                                                    <asp:ListItem>Creamy&nbsp;White</asp:ListItem>
                                                                    <asp:ListItem>Grey&nbsp;White</asp:ListItem>
                                                                    <asp:ListItem>Yellowish</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div class="col-md-3 form-group">
                                                                <label>Liquefaction:</label>
                                                                <asp:DropDownList ID="ddlLiquefaction" CssClass="form-control" runat="server">
                                                                    <asp:ListItem Text="Select" Value="" />
                                                                    <asp:ListItem>Normal</asp:ListItem>
                                                                    <asp:ListItem>Delayed</asp:ListItem>
                                                                    <asp:ListItem>Incomplete</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div class="col-md-3 form-group">
                                                                <label>Consistency:</label>
                                                                <asp:DropDownList ID="DropDownList1" CssClass="form-control" runat="server">
                                                                    <asp:ListItem Text="Select" Value="" />
                                                                    <asp:ListItem>Normal</asp:ListItem>
                                                                    <asp:ListItem>Viscous</asp:ListItem>
                                                                    <asp:ListItem>Watery</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                        </div>
                                                    </fieldset>





                                                    <h6 class="font-weight-bold mb-2">Sperm Motility&nbsp;(100&nbsp;spermatozoa)
                                                    </h6>

                                                    <div class="row">
                                                        <div class="col-md-4 form-group">
                                                            <label>a) Rapid&nbsp;Progression&nbsp;(%):</label>
                                                            <asp:TextBox ID="txtRapidProg" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-4 form-group">
                                                            <label>b) Non‑Progressive&nbsp;Motility&nbsp;(%):</label>
                                                            <asp:TextBox ID="txtNonProg" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-4 form-group">
                                                            <label>c) Slow&nbsp;Progression&nbsp;(%):</label>
                                                            <asp:TextBox ID="txtSlowProg" CssClass="form-control" runat="server" />
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-4 form-group">
                                                            <label>d) Dead&nbsp;(%):</label>
                                                            <asp:TextBox ID="txtDead" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-4 form-group">
                                                            <label>Agglutination&nbsp;(%):</label>
                                                            <asp:TextBox ID="txtAgglutination" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-4 form-group">
                                                            <label>Vitality&nbsp;(%&nbsp;live):</label>
                                                            <asp:TextBox ID="txtVitality" CssClass="form-control" runat="server" />
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-4 form-group">
                                                            <label>Concentration&nbsp;(10<sup>6</sup>/mL):</label>
                                                            <asp:TextBox ID="txtConcentration" CssClass="form-control" runat="server" />
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- /motility -->

                                                <!-- MORPHOLOGY -->
                                                <div class="tab-pane fade" id="morphology" role="tabpanel"
                                                    aria-labelledby="morphology-tab">

                                                    <h6 class="font-weight-bold mb-2">Sperm Morphology (WHO %)</h6>

                                                    <!-- MORPHOLOGY -->


                                                    <div class="row">
                                                        <div class="col-md-4 form-group">
                                                            <label>Normal (%):</label>
                                                            <asp:TextBox ID="txtNormal" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-4 form-group">
                                                            <label>Abnormal (%):</label>
                                                            <asp:TextBox ID="txtAbnormal" CssClass="form-control" runat="server" />
                                                        </div>
                                                    </div>

                                                    <h6 class="font-weight-bold mb-2 mt-3">Types of Abnormalities</h6>

                                                    <div class="row">
                                                        <div class="col-md-3 form-group">
                                                            <label>Head Defects (%):</label>
                                                            <asp:TextBox ID="txtHeadDefects" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-3 form-group">
                                                            <label>Tail Defects (%):</label>
                                                            <asp:TextBox ID="txtTailDefects" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-3 form-group">
                                                            <label>Neck & Midpiece Defects (%):</label>
                                                            <asp:TextBox ID="txtNeckMidpieceDefects" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-3 form-group">
                                                            <label>Cytoplasmic Droplets (%):</label>
                                                            <asp:TextBox ID="txtCytoplasmicDroplets" CssClass="form-control" runat="server" />
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-3 form-group">
                                                            <label>Headless "Pinhead" (%):</label>
                                                            <asp:TextBox ID="txtPinhead" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-3 form-group">
                                                            <label>Pus Cells:</label>
                                                            <asp:TextBox ID="TextBox4" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-3 form-group">
                                                            <label>Red Blood Cells:</label>
                                                            <asp:TextBox ID="txtRedBloodCells" CssClass="form-control" runat="server" />
                                                        </div>
                                                        <div class="col-md-3 form-group">
                                                            <label>Epithelial Cells:</label>
                                                            <asp:TextBox ID="TextBox5" CssClass="form-control" runat="server" />
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-3 form-group">
                                                            <label>Miscellaneous:</label>
                                                            <asp:TextBox ID="txtMiscellaneous" CssClass="form-control" runat="server" />
                                                        </div>
                                                    </div>

                                                    <!-- ✅ Note Section Based on the Image -->
                                                    <div class="row">
                                                        <div class="col-md-6 form-group">
                                                            <label>Note:</label>
                                                            <asp:TextBox ID="txtNoteShort" CssClass="form-control" runat="server" />
                                                        </div>

                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-12 form-group">
                                                            <label>Detailed Notes / Editor:</label>
                                                            <div class="form-group">
                                                                <button type="button" onclick="format('bold')">Bold</button>
                                                                <button type="button" onclick="format('italic')">Italic</button>
                                                                <button type="button" onclick="format('underline')">Underline</button>
                                                            </div>
                                                            <asp:TextBox ID="txtNoteEditor" ClientIDMode="Static" CssClass="form-control"
                                                                TextMode="MultiLine" Rows="10" runat="server" Style="display: none;" />
                                                            <div id="richTextEditor" contenteditable="true" style="border: 1px solid #ccc; padding: 10px; min-height: 150px;"></div>

                                                        </div>
                                                    </div>

                                                    <script>
                                                        // Apply formatting to selected text
                                                        function format(command) {
                                                            document.execCommand(command, false, null);
                                                        }

                                                        // On page load, initialize editor with server value (if needed)
                                                        window.onload = function () {
                                                            document.getElementById('richTextEditor').innerHTML = document.getElementById('txtNoteEditor').value;
                                                        };

                                                        // Before form submit, sync rich editor content back to ASP.NET TextBox
                                                        document.forms[0].onsubmit = function () {
                                                            document.getElementById('txtNoteEditor').value = document.getElementById('richTextEditor').innerHTML;
                                                        };
                                                    </script>


                                                    <!-- Sample Source -->
                                                    <div class="row mt-3">
                                                        <div class="col-md-4">
                                                            <label class="form-label">Sample:</label><br />
                                                            <div class="form-check form-check-inline">
                                                                <asp:RadioButton ID="rdoSampleTaken" GroupName="SampleSource" CssClass="form-check-input" runat="server" />
                                                                <label class="form-check-label" for="rdoSampleTaken">Taken at the Lab</label>
                                                            </div>
                                                            <div class="form-check form-check-inline">
                                                                <asp:RadioButton ID="rdoSampleBrought" GroupName="SampleSource" CssClass="form-check-input" runat="server" />
                                                                <label class="form-check-label" for="rdoSampleBrought">Brought to the Lab</label>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- MAR Test -->
                                                    <div class="row mt-3">
                                                        <div class="col-md-6 form-group">
                                                            <label>SpermMAR Test (% with Adherent Particles):</label>
                                                            <asp:TextBox ID="txtSpermMAR" CssClass="form-control" runat="server" />
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <asp:Button ID="btnSaveSemen" CssClass="btn btn-primary"
                                                            Text="Save" runat="server" OnClick="btnSaveSemen_Click" />
                                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                                            Cancel
                                                        </button>
                                                    </div>
                                                </div>
                                                <!-- /tab‑content -->





                                            </div>
                                            <!-- /.container -->
                                        </div>
                                        <!-- /.modal‑body -->

                                        <!--‑‑ Footer/Actions ‑‑-->


                                    </div>
                                    <!-- /.modal‑content -->
                                </div>
                            </div>

                        </div><!-- /.modal-content -->


                        <div class="modal fade" id="HBElectroModal" tabindex="-1" role="dialog"
                            aria-labelledby="HBElectroModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg" role="document">
                                <div class="modal-content rounded-0">


                                    <!-- Header -->
                                    <div class="modal-header bg-light">
                                        <h4 class="modal-title">HB Electrophoresis Report</h4>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    </div>

                                    <!-- Body -->
                                    <div class="modal-body">
                                        <div class="container">

                                            <!-- Specimen details (mirrors the Urine modal) -->
                                            <div class="row">
                                                <div class="col-md-6 form-group">
                                                    <label>Collection Date / Time:</label>
                                                    <asp:TextBox ID="txtHBECollectionDate" runat="server"
                                                        CssClass="form-control" TextMode="DateTimeLocal" />
                                                </div>
                                                <div class="col-md-6 form-group">
                                                    <label>Sample ID:</label>
                                                    <asp:TextBox ID="txtHBESampleID" runat="server"
                                                        CssClass="form-control" />
                                                </div>
                                            </div>

                                            <!-- Electrophoresis results -->
                                            <fieldset class="border p-2 mt-3">
                                                <legend class="w-auto">Electrophoresis Fractions</legend>

                                                <div class="row">
                                                    <!-- Left column -->
                                                    <div class="col-md-6">
                                                        <div class="mb-3">
                                                            <label class="form-label">HB A (%)</label>
                                                            <asp:TextBox ID="txtHBA" runat="server" CssClass="form-control"
                                                                Placeholder="e.g., 97.0" />
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">HB F (%)</label>
                                                            <asp:TextBox ID="txtHBF" runat="server" CssClass="form-control"
                                                                Placeholder="e.g., 0.5" />
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">HB S (%)</label>
                                                            <asp:TextBox ID="txtHBS" runat="server" CssClass="form-control"
                                                                Placeholder="e.g., 0.0" />
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">HB A₂ (%)</label>
                                                            <asp:TextBox ID="txtHBA2" runat="server" CssClass="form-control"
                                                                Placeholder="1.5 – 3.5 %" />
                                                        </div>
                                                    </div>

                                                    <!-- Right column -->
                                                    <div class="col-md-6">
                                                        <div class="mb-3">
                                                            <label class="form-label">HB A₁ (%)</label>
                                                            <asp:TextBox ID="txtHBA1" runat="server" CssClass="form-control" />
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">HB D (%)</label>
                                                            <asp:TextBox ID="txtHBD" runat="server" CssClass="form-control" />
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">HB E (%)</label>
                                                            <asp:TextBox ID="txtHBE" runat="server" CssClass="form-control" />
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">HB D/S/E (%)</label>
                                                            <asp:TextBox ID="txtHBCombined" runat="server" CssClass="form-control"
                                                                Placeholder="Combined value" />
                                                        </div>
                                                        <div class="mb-1">
                                                            <label class="form-label">Others (%)</label>
                                                            <asp:TextBox ID="txtOthers" runat="server" CssClass="form-control" />
                                                        </div>

                                                    </div>
                                                </div>
                                            </fieldset>

                                            <!-- Comments -->
                                            <fieldset class="border p-2 mt-3">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <legend class="w-auto mb-0">Comments</legend>
                                                </div>
                                                <div class="comment-group mt-2">
                                                    <asp:TextBox ID="txtComment" runat="server" CssClass="form-control"
                                                        TextMode="MultiLine" Rows="2"
                                                        Placeholder="Enter comments here…" />
                                                </div>
                                            </fieldset>


                                            <!-- WYSIWYG detailed editor -->
                                            <fieldset class="border p-2 mt-3">
                                                <legend class="w-auto">Detailed Comment Editor</legend>
                                                <div class="wysiwyg-toolbar mb-2">
                                                    <button type="button" onclick="execCmd('bold')"><b>B</b></button>
                                                    <button type="button" onclick="execCmd('italic')"><i>I</i></button>
                                                    <button type="button" onclick="execCmd('underline')"><u>U</u></button>
                                                    <button type="button" onclick="execCmd('insertUnorderedList')">• List</button>
                                                </div>
                                                <div class="wysiwyg-editor" contenteditable="true" id="richEditor"
                                                    style="height: 250px; border: 1px solid #ccc; padding: 10px; overflow-y: auto;">
                                                </div>
                                            </fieldset>






                                        </div>
                                        <!-- /.container -->
                                    </div>
                                    <!-- /.modal-body -->

                                    <!-- Footer -->
                                    <div class="modal-footer">
                                        <asp:Button ID="btnSaveReport" runat="server"
                                            Text="Save Report" CssClass="btn btn-primary"
                                            OnClick="btnSaveReport_Click" />
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    </div>


                                </div>
                            </div>
                        </div>
                                                <asp:HiddenField ID="txtDetailedComment" runat="server" />

                        <script>
                          function copyRichEditorContent() {
                            const richHtml = document.getElementById("richEditor").innerHTML;
                            document.getElementById("<%= txtDetailedComment.ClientID %>").value = richHtml;
                          }

                          // Call this before postback
                          document.getElementById("<%= btnSaveReport.ClientID %>").addEventListener("click", copyRichEditorContent);
                        </script>
                        
                                    <!-- Urine C/S Modal -->
    <div class="modal fade" id="urineTestModalForCS" tabindex="-1" role="dialog" aria-labelledby="urineTestModalCSLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content rounded-0">
      
          <div class="modal-header bg-light">
            <h4 class="modal-title">Urine Culture &amp; Sensitivity</h4>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
      
          <div class="modal-body">
            <div class="container">

              <!-- Specimen Details -->
              <div class="row">
                <div class="col-md-6 form-group">
                  <label>Collection Date/Time:</label>
<asp:TextBox ID="txtCSCollectionDate" CssClass="form-control" runat="server" TextMode="DateTimeLocal" />
                </div>
                <div class="col-md-6 form-group">
                  <label>Sample ID:</label>
                  <asp:TextBox ID="txtCSSampleID" CssClass="form-control" runat="server" />
                </div>
              </div>

              <!-- Culture Details -->
              <fieldset class="border p-2 mt-3">
                <legend class="w-auto">Culture Details</legend>
                <div class="row">
                  <div class="col-md-4 form-group">
                    <label>Media Used:</label>
                    <asp:TextBox ID="txtMediaUsed" CssClass="form-control" runat="server" />
                  </div>
                  <div class="col-md-4 form-group">
                    <label>Incubation Conditions:</label>
                    <asp:TextBox ID="txtIncubation" CssClass="form-control" runat="server" />
                  </div>
                  <div class="col-md-4 form-group">
                    <label>Colony Count (CFU/mL):</label>
                    <asp:TextBox ID="txtColonyCount" CssClass="form-control" runat="server" />
                  </div>
                </div>
              </fieldset>

              <!-- Organism Identification -->
              <fieldset class="border p-2 mt-3">
                <legend class="w-auto">Organism Identification</legend>
                <div class="row">
                  <div class="col-md-6 form-group">
                    <label>Organism Name:</label>
                    <asp:DropDownList ID="ddlOrganism" runat="server" CssClass="form-control">
                      <asp:ListItem Text="Select Organism" Value="" />
                      <asp:ListItem Text="E. coli" Value="Ecoli" />
                
                    </asp:DropDownList>
                  </div>
                  <div class="col-md-6 form-group">
                    <label>Mixed Growth:</label><br />
                    <asp:CheckBox ID="chkMixedGrowth" runat="server" />
                  </div>
                </div>
              </fieldset>

              <!-- Antibiotic Sensitivity Panel -->
              <fieldset class="border p-2 mt-3">
                <legend class="w-auto">Antibiotic Sensitivity</legend>
                <div id="antibioticPanel">

                  <!-- Example antibiotic row -->
                  <div class="row antibiotic-row mb-2">
                    <div class="col-md-4 form-group">
                      <label>Antibiotic:</label>
                      <asp:DropDownList ID="ddlAntibiotic_0" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Select Antibiotic" Value="" />
                        <asp:ListItem Text="Ampicillin" Value="Ampicillin" />
                
                      </asp:DropDownList>
                    </div>
                    <div class="col-md-4 form-group">
                      <label>Zone (mm) / MIC:</label>
                      <asp:TextBox ID="txtZoneOrMIC_0" CssClass="form-control" runat="server" />
                    </div>
                    <div class="col-md-4 form-group">
                      <label>Interpretation:</label>
                      <asp:DropDownList ID="ddlInterpretation_0" runat="server" CssClass="form-control">
                        <asp:ListItem Text="S" Value="S" />
                        <asp:ListItem Text="I" Value="I" />
                        <asp:ListItem Text="R" Value="R" />
                      </asp:DropDownList>
                    </div>
                  </div>

               
                 

                </div>
              </fieldset>

              <!-- Remarks -->
              <fieldset class="border p-2 mt-3">
                <legend class="w-auto">Remarks</legend>
                <asp:TextBox ID="txtCSRemarks" CssClass="form-control" runat="server" 
                             TextMode="MultiLine" Rows="3" />
              </fieldset>

            </div>
          </div>

          <div class="modal-footer">
                                <asp:Button ID="Button2" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btnSaveUrineCsResult_Click" />
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            </div>

        </div>
      </div>
    </div>

                        <!-- Stool for C/E -->
                        <div class="modal fade" id="StoolforCE" tabindex="-1" role="dialog"
                            aria-labelledby="stoolTestModalCSLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg" role="document">
                                <div class="modal-content rounded-0">

                                    <!-- ────── Header ────── -->
                                    <div class="modal-header bg-light">
                                        <h4 class="modal-title">Stool Examination (Culture & Sensitivity)</h4>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    </div>

                                    <!-- ────── Body ────── -->
                                    <div class="modal-body">
                                        <div class="container">

                                            <!-- ░░░ PHYSICAL EXAMINATION ░░░ -->
                                            <fieldset class="border p-2">
                                                <legend class="w-auto">Physical Examination</legend>
                                                <div class="row">

                                                    <!-- Color -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Color:</label>
                                                        <asp:DropDownList ID="ddlColor" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Brown" Value="Brown" />
                                                            <asp:ListItem Text="Dark Brown" Value="Dark Brown" />
                                                            <asp:ListItem Text="Light Brown" Value="Light Brown" />
                                                            <asp:ListItem Text="Green" Value="Green" />
                                                            <asp:ListItem Text="Black / Tarry" Value="Black" />
                                                            <asp:ListItem Text="Clay / Pale" Value="Clay" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Odour -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Odour:</label>
                                                        <asp:DropDownList ID="ddlOdour" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Fecal (Normal)" Value="Fecal" />
                                                            <asp:ListItem Text="Offensive" Value="Offensive" />
                                                            <asp:ListItem Text="Sour" Value="Sour" />
                                                            <asp:ListItem Text="Putrid" Value="Putrid" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Consistency -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Consistency:</label>
                                                        <asp:DropDownList ID="ddlConsistency" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Formed" Value="Formed" />
                                                            <asp:ListItem Text="Semiformed" Value="Semiformed" />
                                                            <asp:ListItem Text="Loose" Value="Loose" />
                                                            <asp:ListItem Text="Liquid" Value="Liquid" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Reaction -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Reaction:</label>
                                                        <asp:DropDownList ID="ddlReaction" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Acidic" Value="Acidic" />
                                                            <asp:ListItem Text="Neutral" Value="Neutral" />
                                                            <asp:ListItem Text="Alkaline" Value="Alkaline" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Parasite (free text – requires organism name) -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Parasite:</label>
                                                        <asp:TextBox ID="txtParasite" runat="server" CssClass="form-control" />
                                                    </div>

                                                    <!-- Mucus -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Mucus:</label>
                                                        <asp:DropDownList ID="ddlMucus" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Nil" Value="Nil" />
                                                            <asp:ListItem Text="Present" Value="Present" />
                                                            <asp:ListItem Text="Moderate" Value="Moderate" />
                                                            <asp:ListItem Text="Plenty" Value="Plenty" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Frank Blood -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Frank Blood:</label>
                                                        <asp:DropDownList ID="ddlFrankBlood" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Nil" Value="Nil" />
                                                            <asp:ListItem Text="Present" Value="Present" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Occult Blood -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Occult Blood:</label>
                                                        <asp:DropDownList ID="ddlOccultBlood" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Negative" Value="Negative" />
                                                            <asp:ListItem Text="Positive" Value="Positive" />
                                                        </asp:DropDownList>
                                                    </div>

                                                </div>
                                            </fieldset>

                                            <!-- ░░░ MICROSCOPIC EXAMINATION ░░░ -->
                                            <fieldset class="border p-2 mt-3">
                                                <legend class="w-auto">Microscopic Examination</legend>
                                                <div class="row">

                                                    <!-- Ova -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Ova:</label>
                                                        <asp:DropDownList ID="ddlOva" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Not Seen" Value="Not Seen" />
                                                            <asp:ListItem Text="Hookworm" Value="Hookworm" />
                                                            <asp:ListItem Text="Ascaris" Value="Ascaris" />
                                                            <asp:ListItem Text="Taenia" Value="Taenia" />
                                                            <asp:ListItem Text="Trichuris" Value="Trichuris" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Cysts of Protozoa -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Cysts of Protozoa:</label>
                                                        <asp:DropDownList ID="ddlCysts" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Not Seen" Value="Not Seen" />
                                                            <asp:ListItem Text="Giardia lamblia" Value="Giardia" />
                                                            <asp:ListItem Text="Entamoeba histolytica" Value="E.histolytica" />
                                                            <asp:ListItem Text="Balantidium coli" Value="Balantidium" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Vegetative Forms -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Vegetative Forms:</label>
                                                        <asp:DropDownList ID="ddlVegetative" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Not Seen" Value="Not Seen" />
                                                            <asp:ListItem Text="Giardia trophozoites" Value="GiardiaTrop" />
                                                            <asp:ListItem Text="Entamoeba trophozoites" Value="EHTrop" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Pus Cells (count) -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Pus Cells (per HPF):</label>
                                                        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" />
                                                    </div>

                                                    <!-- Red Blood Cells (count) -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Red Blood Cells (per HPF):</label>
                                                        <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" />
                                                    </div>

                                                    <!-- Macrophages -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Macrophages:</label>
                                                        <asp:DropDownList ID="ddlMacrophages" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Nil" Value="Nil" />
                                                            <asp:ListItem Text="Few" Value="Few" />
                                                            <asp:ListItem Text="Moderate" Value="Moderate" />
                                                            <asp:ListItem Text="Many" Value="Many" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Epithelial Cells -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Epithelial Cells:</label>
                                                        <asp:DropDownList ID="ddlEpithelial" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Nil" Value="Nil" />
                                                            <asp:ListItem Text="Few" Value="Few" />
                                                            <asp:ListItem Text="Moderate" Value="Moderate" />
                                                            <asp:ListItem Text="Many" Value="Many" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Yeast Cells -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Yeast Cells:</label>
                                                        <asp:DropDownList ID="ddlYeast" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Nil" Value="Nil" />
                                                            <asp:ListItem Text="Present" Value="Present" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Fat -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Fat:</label>
                                                        <asp:DropDownList ID="ddlFat" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Nil" Value="Nil" />
                                                            <asp:ListItem Text="Present" Value="Present" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Muscle Cells -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Muscle Cells:</label>
                                                        <asp:DropDownList ID="ddlMuscleCells" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Nil" Value="Nil" />
                                                            <asp:ListItem Text="Present" Value="Present" />
                                                        </asp:DropDownList>
                                                    </div>

                                                    <!-- Starch -->
                                                    <div class="col-md-4 form-group">
                                                        <label>Starch:</label>
                                                        <asp:DropDownList ID="ddlStarch" runat="server" CssClass="form-control">
                                                            <asp:ListItem Text="Select" Value="" />
                                                            <asp:ListItem Text="Nil" Value="Nil" />
                                                            <asp:ListItem Text="Present" Value="Present" />
                                                        </asp:DropDownList>
                                                    </div>

                                                </div>
                                            </fieldset>

                                            <!-- ░░░ Remarks ░░░ -->
                                            <fieldset class="border p-2 mt-3">
                                                <legend class="w-auto">Remarks</legend>
                                                <asp:TextBox ID="txtRemarks" runat="server"
                                                    CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                            </fieldset>

                                        </div>
                                    </div>

                                    <!-- ────── Footer ────── -->
                                    <div class="modal-footer">
                                        <asp:Button ID="btnSaveStoolCS" runat="server" Text="Save"
                                            CssClass="btn btn-primary" OnClick="btnSaveStoolCS_Click" />
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    </div>

                                </div>
                            </div>
                        </div>


                                        <!-- HCV PCR Quantitation Modal -->
                        <div class="modal fade" id="hcvPCRModal" tabindex="-1" role="dialog" aria-labelledby="hcvPCRModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg" role="document">
                                <div class="modal-content rounded-0">
      
                                  <div class="modal-header bg-light">
                                    <h4 class="modal-title">HCV PCR (Quantitative)</h4>
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                  </div>
      
                                  <div class="modal-body">
                                    <div class="container">
 
   

                            <!-- Editor -->
                            <div class="editor-container">
                              <label class="form-label"><strong>Custom Notes / Editor:</strong></label>

                            <!-- Add this inside your .aspx file -->
                            <style>
                              .editor-toolbar button {
                                margin-right: 5px;
                              }

                              .rich-editor {
                                border: 1px solid #ccc;
                                padding: 8px;
                                min-height: 150px;
                                border-radius: 4px;
                                background-color: #fff;
                              }
                            </style>

                            <!-- Toolbar -->
                            <div class="editor-toolbar mb-2">
                              <button type="button" onclick="formatText('bold')"><b>B</b></button>
                              <button type="button" onclick="formatText('italic')"><i>I</i></button>
                              <button type="button" onclick="formatText('underline')"><u>U</u></button>
                              <button type="button" onclick="formatText('insertUnorderedList')">• Bullets</button>
                            </div>

                            <!-- Rich Text Editable Div -->
                            <div id="editor" class="rich-editor" contenteditable="true">
 
                            </div>

                            <!-- Hidden field to store content for server-side -->
                            <asp:HiddenField ID="HiddenEditorContent" runat="server" />

                            <!-- On form submit, move HTML content to hidden field -->
                            <script>
                              function formatText(command) {
                                document.execCommand(command, false, null);
                              }

                              // Optional: copy content to HiddenField before postback
                              function saveEditorContent() {
                                var editorHtml = document.getElementById("editor").innerHTML;
                                document.getElementById('<%= HiddenEditorContent.ClientID %>').value = editorHtml;
                              }

                              // Attach to any save button or form submission
                              document.addEventListener("DOMContentLoaded", function () {
                                var btn = document.querySelector("[type=submit]");
                                if (btn) {
                                  btn.addEventListener("click", saveEditorContent);
                                }
                              });
                            </script>


                                <div class="modal-footer">
                                <!-- Save: triggers JS then server -->
                                <asp:Button ID="btnSaveHcvPcrResult"
                                            Text="Save"
                                            CssClass="btn btn-primary"
                                            runat="server"
                                            OnClientClick="saveEditorContent()"
                                            OnClick="btnSaveHcvPcrResult_Click" />

                                <!-- Cancel -->
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                    Cancel
                                </button>
                                    <asp:Label ID="lblStatus" runat="server" CssClass="text-danger ml-3" />
                            </div>

                                </div> 
                                </div>
                              </div>





                                 <script>
                                function toggleEditor() {
                                  const editor = document.getElementById("editorBox");
                                  editor.style.display = editor.style.display === "none" ? "block" : "none";
                                }

                                function execCmd(command) {
                                  document.execCommand(command, false, null);
                                }
                             
                                      function formatText(command) {
                                        document.execCommand(command, false, null);
                                      }

                                      // Optional: copy content to HiddenField before postback
                                      function saveEditorContent() {
                                        var editorHtml = document.getElementById("editor").innerHTML;
                                        document.getElementById('<%= HiddenEditorContent.ClientID %>').value = editorHtml;
                                      }

                                      // Attach to any save button or form submission
                                      document.addEventListener("DOMContentLoaded", function () {
                                        var btn = document.querySelector("[type=submit]");
                                        if (btn) {
                                          btn.addEventListener("click", saveEditorContent);
                                        }
                                      });
                                    </script>










                    </ContentTemplate>
                </asp:UpdatePanel>
            </section>
        </div>
    </div>
</div>
    <asp:TextBox Visible="false" ID="hdnTestID" Text="" runat="server"/>
    <input type="hidden" id="txtNewValue" name="txtNewValue" />
    <input type="hidden" id="txtNewValueCBC" name="txtNewValueCBC" />

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

    </style>
                        <script>
                           

                            function OpenDLC(ID, Sex, TestID, TemplateID, Code, Type) {
                                debugger;
                                $("#<%= hdnTestID.ClientID %>").val(ID);
                                $.ajax({
                                    url: 'frmLaboratory.aspx/LoadDLCData',
                                    type: 'POST',
                                    contentType: 'application/json; charset=utf-8',
                                    dataType: 'json',
                                    data: JSON.stringify({
                                        TestID: TestID,    // Pass actual values dynamically
                                        Type: 1,
                                        TemplateID: TemplateID,
                                        PatientTestID : ID
                                    }),
                                    success: function (response) {
                                        try {
                                            var result = JSON.parse(response.d);
                                            console.table(result);

                                            if (Array.isArray(result) && result.length > 0) {
                                                var tableHtml = `<table class='table table-bordered' style='font-size: 12px;'>
                                                                <thead><tr>`;

                                                // Get column headers, excluding "SortOrder"
                                                var headers = Object.keys(result[0]).filter(key => key.toLowerCase() !== "sortorder");

                                                // Create table headers
                                                headers.forEach(function (key) {
                                                    tableHtml += `<th style='padding: 5px; white-space: nowrap;'>${key}</th>`;
                                                });

                                                tableHtml += `</tr></thead><tbody>`;

                                                // Populate table rows
                                                result.forEach(function (item, rowIndex) {
                                                    tableHtml += "<tr data-id='" + item.ID + "'>";
                                                    headers.forEach(function (key) {
                                                        if (key.toLowerCase() === "result") {
                                                            tableHtml += `<td style='padding: 3px 5px; white-space: nowrap;'>
                                                                <input type="text" class="editable-result" 
                                                                       value="${item[key] || ''}" 
                                                                       data-row="${rowIndex}" 
                                                                       data-id="${item.ID}" 
                                                                       style="width: 100%; padding: 2px; border: 1px solid #ddd;">
                                                            </td>`;
                                                        } else {
                                                            tableHtml += `<td style='padding: 3px 5px; white-space: nowrap;'>${item[key]}</td>`;
                                                        }
                                                    });
                                                    debugger;
                                                    tableHtml += "</tr>";

                                                    // 👉 Insert extra row below Creatinine (ID 187)
                                                    if (item.ID == 187) {
                                                        tableHtml += `<tr data-id="188">
                                                            <td>188</td>
                                                            <td>BUN/CREATININE RATIO</td>
                                                            <td>Ratio</td>
                                                            <td></td>
                                                            <td></td>
                                                            <td>
                                                                <input type="text" class="editable-result" 
                                                                       data-id="188" 
                                                                       value="" 
                                                                       readonly 
                                                                       style="width: 100%; padding: 2px; background-color: #f0f0f0; border: 1px solid #ddd; cursor: not-allowed;">
                                                            </td>
                                                        </tr>`;
                                                    }
                                                });


                                                tableHtml += "</tbody></table>";

                                                $('#DLCContainor').html(tableHtml);

                                                // Use event delegation for dynamically created elements
                                                $('#DLCContainor').on('input', '.editable-result', function () {
                                                    var rowIndex = $(this).data('row');
                                                    var itemId = $(this).data('id');
                                                    var newValue = $(this).val();

                                                    // Update the result array
                                                    result[rowIndex].Result = newValue;

                                                    // Optional: Add visual feedback
                                                    $(this).toggleClass('changed', newValue !== result[rowIndex].originalResult);

                                                    console.log("Updated Item ID:", itemId, "New Value:", newValue);

                                                    // Store the updated result array in the hidden input field
                                                    $('#txtNewValue').val(JSON.stringify(result));
                                                });
                                                $('#DLCContainor').on('input', '.editable-result', function () {
                                                        var rowIndex = $(this).data('row');
                                                        var itemId = $(this).data('id');
                                                        var newValue = $(this).val().trim();

                                                        // Update the result array
                                                        result[rowIndex].Result = newValue;

                                                        // Optional: Add visual feedback
                                                        $(this).toggleClass('changed', newValue !== result[rowIndex].originalResult);

                                                        // Store updated values
                                                        $('#txtNewValue').val(JSON.stringify(result));

                                                        // Helper functions
                                                        const getResultById = (id) => {
                                                            let row = result.find(r => r.ID == id);
                                                            return row && row.Result ? parseFloat(row.Result) : null;
                                                        };

                                                        const setResultById = (id, value) => {
                                                         // update your data model

                                                            let row = result.find(r => r.ID == id);
                                                            if (row) {
                                                                row.Result = value.toFixed(2);

                                                                // find the input in either container
                                                                $(`#DLCContainor .editable-result[data-id='${id}'], #CBCContainor .editable-result[data-id='${id}']`)
                                                                    .val(value.toFixed(2))
                                                                    .prop('readonly', true)
                                                                    .css({ backgroundColor: '#f0f0f0', cursor: 'not-allowed' });
                                                            }
                                                        };


                                                        // === Auto-calculation logic ===

                                                        // 1. Bilirubin Unconjugated = Total - Conjugated
                                                        let totalBilirubin = getResultById(72);
                                                        let conjugatedBilirubin = getResultById(108300005);
                                                        if (totalBilirubin !== null && conjugatedBilirubin !== null) {
                                                            let unconjugated = totalBilirubin - conjugatedBilirubin;
                                                            setResultById(108300006, unconjugated);
                                                        }

                                                        // 2. Globulins = Total Protein - Albumin
                                                        let totalProtein = getResultById(78);
                                                        let albumin = getResultById(79);
                                                        if (totalProtein !== null && albumin !== null) {
                                                            let globulins = totalProtein - albumin;
                                                            setResultById(80, globulins);
                                                        }

                                                        // 3. A/G Ratio = Albumin / Globulins
                                                        let globulins = getResultById(80);
                                                        if (albumin !== null && globulins !== null && globulins !== 0) {
                                                            let agRatio = albumin / globulins;
                                                            setResultById(81, agRatio);
                                                    }
                                                    // 4. INR = (PT / MeanNormalPT)^ISI
                                                    let pt = getResultById(39);
                                                    let ptRow = result.find(r => r.ID == 39);
                                                    let inrRow = result.find(r => r.ID == 40);
                                                    if (pt !== null && ptRow && inrRow) {
                                                        let fromVal = parseFloat(ptRow.FromValue);
                                                        let toVal = parseFloat(ptRow.ToValue);
                                                        if (!isNaN(fromVal) && !isNaN(toVal)) {
                                                            let meanNormalPT = (fromVal + toVal) / 2;
                                                            let ISI = 1.0; // Or fetch dynamically if stored elsewhere
                                                            let inr = Math.pow(pt / meanNormalPT, ISI);
                                                            setResultById(40, inr);
                                                        }
                                                    }
                                                    // 4. VLDL = Triglycerides / 5
                                                    let triglycerides = getResultById(147);
                                                    if (triglycerides !== null && triglycerides !== 0) {
                                                        let vldl = triglycerides / 5;
                                                        setResultById(150, vldl);
                                                    }

                                                    // 5. LDL = Cholesterol - HDL - VLDL
                                                    let cholesterol = getResultById(146);
                                                    let hdl = getResultById(148);
                                                    let vldl = getResultById(150); // already calculated
                                                    if (cholesterol !== null && hdl !== null && vldl !== null) {
                                                        let ldl = cholesterol - hdl - vldl;
                                                        setResultById(149, ldl);
                                                    }

                                                    // 6. Cholesterol / HDL Ratio
                                                    if (cholesterol !== null && hdl !== null && hdl !== 0) {
                                                        let ratio = cholesterol / hdl;
                                                        setResultById(151, ratio);
                                                    }
                                                   

                                                    });


                                            } else {
                                                $('#DLCContainor').html("<p class='text-muted'>No data available</p>");
                                            }

                                        } catch (e) {
                                            console.error("Parsing Error:", e);
                                            $('#DLCContainor').html(`<div class="alert alert-danger">Error: ${e.message}</div>`);
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("AJAX Error:", error);
                                        alert("Error: " + error);
                                    }


                                    

                                });
                                if (Type === "2") {
                                $.ajax({
                                    url: 'frmLaboratory.aspx/LoadCBCData',
                                    type: 'POST',
                                    contentType: 'application/json; charset=utf-8',
                                    dataType: 'json',
                                    data: JSON.stringify({
                                        TestID: TestID,
                                        Gender: Sex
                                    }),
                                    success: function (response) {
                                        try {
                                            var result = JSON.parse(response.d);
                                            console.table(result);

                                            if (Array.isArray(result) && result.length > 0) {
                                                var tableHtml = `<table class='table table-bordered' style='font-size: 12px;'>
                                                                    <thead><tr>`;

                                                // Get column headers, excluding "SortOrder"
                                                var headers = Object.keys(result[0]).filter(key => key.toLowerCase() !== "sortorder");

                                                // Ensure "Result" column is included
                                                if (!headers.includes("Result")) {
                                                    headers.push("Result");
                                                }

                                                // Create table headers
                                                headers.forEach(function (key) {
                                                    tableHtml += `<th style='padding: 5px; white-space: nowrap;'>${key}</th>`;
                                                });

                                                tableHtml += `</tr></thead><tbody>`;

                                                // Populate table rows
                                                result.forEach(function (item, rowIndex) {
                                                    tableHtml += "<tr>";
                                                    headers.forEach(function (key) {
                                                        if (key.toLowerCase() === "result") {
                                                            // Ensure original result exists
                                                            let originalResult = item[key] || "";
                                                           
                                                            // Use HTML input instead of ASP.NET control
                                                            tableHtml += `<td style='padding: 3px 5px; white-space: nowrap;'>
                                                                <input type="text" class="editable-result" 
                                                                       value="${originalResult}" 
                                                                       data-row="${rowIndex}"
                                                                       data-id="${item.ID}"
                                                                       data-original="${originalResult}" 
                                                                       style="width: 100%; padding: 2px; border: 1px solid #ddd;">
                                                            </td>`;
                                                        } else {
                                                            tableHtml += `<td style='padding: 3px 5px; white-space: nowrap;'>${item[key]}</td>`;
                                                        }
                                                        
                                                    });
                                                    tableHtml += "</tr>";
                                                });

                                                tableHtml += "</tbody></table>";

                                                $('#CBCContainor').html(tableHtml);

                                                // Use event delegation for dynamically created elements
                                                $('#CBCContainor').on('input', '.editable-result', function () {
                                                    var rowIndex = $(this).data('row');
                                                    var itemId = $(this).data('id');
                                                    var newValue = $(this).val();
                                                    var originalValue = $(this).data('original');

                                                    // Update the result array
                                                    result[rowIndex].Result = newValue;

                                                    // Add visual feedback if value has changed
                                                    $(this).toggleClass('changed', newValue !== originalValue);

                                                    console.log("Updated Item ID:", itemId, "New Value:", newValue);

                                                    // Store the updated result array in the hidden input field
                                                    $('#txtNewValueCBC').val(JSON.stringify(result));


                                                    
                                                    
                                                });
                                                // listen for edits on any result field inside the CBC container
                                                $('#CBCContainor').on('change input', '.editable-result[data-id]', function() {
                                                    const editedId = +$(this).data('id');
                                                    if (editedId === 185 || editedId === 187) {
                                                        const ureaVal   = parseFloat($('#CBCContainor .editable-result[data-id="185"]').val());
                                                        const creatVal  = parseFloat($('#CBCContainor .editable-result[data-id="187"]').val());

                                                        if (!isNaN(ureaVal) && !isNaN(creatVal) && creatVal !== 0) {
                                                            const ratio = ureaVal / creatVal;
                                                            const fixed = ratio.toFixed(2);

                                                            // ——— inline what setResultById would do ———

                                                            // 1) Update your JS data model
                                                            const row186 = result.find(r => r.ID === 186);
                                                            if (row186) {
                                                                row186.Result = fixed;
                                                            }

                                                            // 2) Update the UI (in both containers, if needed)
                                                            $(`#DLCContainor .editable-result[data-id="186"],
                                                               #CBCContainor .editable-result[data-id="186"]`)
                                                              .val(fixed)
                                                              .prop('readonly', true)
                                                              .css({ backgroundColor: '#f0f0f0', cursor: 'not-allowed' });
                                                        } else {
                                                            // clear out the ratio field if inputs invalid
                                                            $('#CBCContainor .editable-result[data-id="186"]')
                                                              .val('')
                                                              .prop('readonly', false)
                                                              .css({ backgroundColor: '', cursor: '' });

                                                            const row186 = result.find(r => r.ID === 186);
                                                            if (row186) row186.Result = null;
                                                        }
                                                                $('#txtNewValueCBC').val(JSON.stringify(result));

                                                    }
                                                });


                                            } else {
                                                $('#CBCContainor').html("<p class='text-muted'>No data available</p>");
                                            }

                                        } catch (e) {
                                            console.error("Parsing Error:", e);
                                            $('#CBCContainor').html(`<div class="alert alert-danger">Error: ${e.message}</div>`);
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("AJAX Error:", error);
                                        alert("Error: " + error);
                                    }
                                    });
                                     $.ajax({
                                    url: 'frmLaboratory.aspx/LoadDLCData',
                                    type: 'POST',
                                    contentType: 'application/json; charset=utf-8',
                                    dataType: 'json',
                                    data: JSON.stringify({
                                        TestID: 85,    // Pass actual values dynamically
                                        Type: 1,
                                        TemplateID: TemplateID,
                                        PatientTestID : ID
                                    }),
                                    success: function (response) {
                                        try {
                                            var result = JSON.parse(response.d);
                                            console.table(result);

                                            if (Array.isArray(result) && result.length > 0) {
                                                var tableHtml = `<table class='table table-bordered' style='font-size: 12px;'>
                                                                <thead><tr>`;

                                                // Get column headers, excluding "SortOrder"
                                                var headers = Object.keys(result[0]).filter(key => key.toLowerCase() !== "sortorder");

                                                // Create table headers
                                                headers.forEach(function (key) {
                                                    tableHtml += `<th style='padding: 5px; white-space: nowrap;'>${key}</th>`;
                                                });

                                                tableHtml += `</tr></thead><tbody>`;

                                                // Populate table rows
                                                result.forEach(function (item, rowIndex) {
                                                    tableHtml += "<tr>";
                                                    headers.forEach(function (key) {
                                                        if (key.toLowerCase() === "result") {
                                                            // Use HTML input instead of ASP.NET control
                                                            tableHtml += `<td style='padding: 3px 5px; white-space: nowrap;'>
                                                                <input type="text" class="editable-result" 
                                                                       value="${item[key] || ''}" 
                                                                       data-row="${rowIndex}"
                                                                       data-id="${item.ID}"
                                                                       style="width: 100%; padding: 2px; border: 1px solid #ddd;">
                                                            </td>`;
                                                        } else {
                                                            tableHtml += `<td style='padding: 3px 5px; white-space: nowrap;'>${item[key]}</td>`;
                                                        }
                                                    });
                                                    tableHtml += "</tr>";
                                                });

                                                tableHtml += "</tbody></table>";

                                                $('#DLCContainor').html(tableHtml);

                                                // Use event delegation for dynamically created elements
                                                $('#DLCContainor').on('input', '.editable-result', function () {
                                                    var rowIndex = $(this).data('row');
                                                    var itemId = $(this).data('id');
                                                    var newValue = $(this).val();

                                                    // Update the result array
                                                    result[rowIndex].Result = newValue;

                                                    // Optional: Add visual feedback
                                                    $(this).toggleClass('changed', newValue !== result[rowIndex].originalResult);

                                                    console.log("Updated Item ID:", itemId, "New Value:", newValue);

                                                    // Store the updated result array in the hidden input field
                                                    $('#txtNewValue').val(JSON.stringify(result));
                                                });


                                            } else {
                                                $('#DLCContainor').html("<p class='text-muted'>No data available</p>");
                                            }

                                        } catch (e) {
                                            console.error("Parsing Error:", e);
                                            $('#DLCContainor').html(`<div class="alert alert-danger">Error: ${e.message}</div>`);
                                        }
                                    },                                    error: function (xhr, status, error) {
                                        console.error("AJAX Error:", error);
                                        alert("Error: " + error);
                                    }


                                    

                                });

                            }

    // Load dropdown data on page load
    $.ajax({
        type: "POST",
        url: "frmLaboratory.aspx/GetTestResults", // Replace with your actual ASPX page name
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var dropdown = $("#testDropdown");
            dropdown.empty();
            dropdown.append('<option value="">Select Test</option>');

            $.each(data, function (index, item) {
                dropdown.append($('<option></option>').val(item.TestID).text(item.Code));
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching data: " + error);
        }
    });

    // Fetch result when dropdown value changes
    $("#testDropdown").change(function () {
        var selectedTestId = $(this).val();
        
        if (selectedTestId) {
            $.ajax({
                type: "POST",
                url: "frmLaboratory.aspx/GetTestResultById", // Replace with your actual ASPX page name
                data: JSON.stringify({ testId: selectedTestId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $("#resultText").val(response.d); // Fill textarea with result
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching result: " + error);
                }
            });
        } else {
            $("#resultText").val(""); // Clear textarea if no selection
        }
    });


    // Load dropdown data on page load
    $.ajax({
        type: "POST",
        url: "frmLaboratory.aspx/GetTestResultsForDropdown2", // Fetch data for testDropdown2
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var dropdown = $("#testDropdown2"); // Targeting testDropdown2
            dropdown.empty();
            dropdown.append('<option value="">Select Test</option>');

            $.each(data, function (index, item) {
dropdown.append($('<option></option>').val(item.TestID).text(item.Code2));
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching data: " + error);
        }
    });

    // Fetch test result when dropdown value changes
    $("#testDropdown2").change(function () { // Targeting testDropdown2
        var selectedTestId = $(this).val();
        
        if (selectedTestId) {
            $.ajax({
                type: "POST",
                url: "frmLaboratory.aspx/GetTestResultByIdForDropdown2", // Fetch test result for selected ID
                data: JSON.stringify({ testId: selectedTestId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $("#resultText2").val(response.d); // Set value in resultText2
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching result: " + error);
                }
            });
        } else {
            $("#resultText2").val(""); // Clear textarea if no test is selected
        }
    });

           $(document).ready(function () {
    $.ajax({
        type: "POST",
        url: "frmLaboratory.aspx/GetTestComments",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var dropdown = $("#commentCode");
            dropdown.empty();
            dropdown.append('<option value="">Select a Comment Code</option>');

            $.each(data, function (index, item) {
                dropdown.append($('<option></option>').val(item.CommentCode).text(item.CommentCode));
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching data: " + error);
        }
    });
});


$("#commentCode").change(function () {
    var selectedCommentCode = $(this).val();
    console.log("Selected Comment Code:", selectedCommentCode); // Debugging

    if (selectedCommentCode) {
        $.ajax({
            type: "POST",
            url: "frmLaboratory.aspx/GetCommentByCommentCode",
            data: JSON.stringify({ commentCode: selectedCommentCode }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                console.log("Response:", response); // Debugging
                $("#richComment").val(response.d);
            },
            error: function (xhr, status, error) {
                console.error("Error fetching comment:", error);
            }
        });
    } else {
        $("#richComment").val("");
    }
});

             $(document).ready(function () {
    $.ajax({
        type: "POST",
        url: "frmLaboratory.aspx/GetTestResults2", 
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var dropdown = $("#ddlCommentCode"); // Target your select dropdown
            dropdown.empty();
            dropdown.append('<option value="">Select Comment Code</option>');

            $.each(data, function (index, item) {
                dropdown.append($('<option></option>').val(item.CommentCode).text(item.CommentCode));
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching data: " + error);
        }
    });
});

$(document).ready(function () {
    $("#ddlCommentCode").change(function () {
        var selectedCode = $(this).val(); // Get selected CommentCode

        if (selectedCode) {
            $.ajax({
                type: "POST",
                url: "frmLaboratory.aspx/GetCommentDetails", 
                data: JSON.stringify({ commentCode: selectedCode }), 
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $("#txtComments").val(response.d); // Set Comments in the textbox
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching comment details: " + error);
                }
            });
        } else {
            $("#txtComments").val(""); // Clear the textbox if nothing is selected
        }
    });
});

$(document).ready(function () {
    // Populate dropdown dynamically
    $.ajax({
        type: "POST",
        url: "frmLaboratory.aspx/GetZnStainingOptions",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var dropdown = $("#znStainingDropdown");
            dropdown.empty();
            dropdown.append('<option value="">Select an option</option>');

            $.each(data, function (index, item) {
                dropdown.append($('<option></option>').val(item.CommentCode).text(item.CommentCode));
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching data: " + error);
        }
    });

    // Fetch and display comment when dropdown value changes
    $("#znStainingDropdown").change(function () {
        var selectedCode = $(this).val();

        if (selectedCode) {
            $.ajax({
                type: "POST",
                url: "frmLaboratory.aspx/GetZnCommentDetails",
                data: JSON.stringify({ commentCode: selectedCode }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $("#txtZnComments").val(response.d);
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching comment details: " + error);
                }
            });
        } else {
            $("#txtZnComments").val("");
        }
    });
});

$(document).ready(function () {
    $.ajax({
        type: "POST",
        url: "frmLaboratory.aspx/GetZnStainingOptions", // Call the updated method
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var dropdown = $("#znStainingDropdown"); // Target your dropdown
            dropdown.empty();
            dropdown.append('<option value="">Select an option</option>');

            $.each(data, function (index, item) {
                dropdown.append($('<option></option>').val(item.CommentCode).text(item.CommentCode));
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching data: " + error);
        }
    });
});
$(document).ready(function () {
    // Populate Gram Staining Dropdown
    $.ajax({
        type: "POST",
        url: "frmLaboratory.aspx/GetGramStainingOptions",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var dropdown = $("#gramStainDropdown");
            dropdown.empty();
            dropdown.append('<option value="">Select an option</option>');

            $.each(data, function (index, item) {
                dropdown.append($('<option></option>').val(item.CommentCode).text(item.CommentCode));
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching Gram Staining data: " + error);
        }
    });

    // Fetch and display comment when dropdown value changes
    $("#gramStainDropdown").change(function () {
        var selectedCode = $(this).val();

        if (selectedCode) {
            $.ajax({
                type: "POST",
                url: "frmLaboratory.aspx/GetGramCommentDetails",
                data: JSON.stringify({ commentCode: selectedCode }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $("#txtGramComments").val(response.d);
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching comment details: " + error);
                }
            });
        } else {
            $("#txtGramComments").val("");
        }
    });
});

$(document).ready(function () {
    // Populate Culture Dropdown
    $.ajax({
        type: "POST",
        url: "frmLaboratory.aspx/GetCultureOptions",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var dropdown = $("#cultureDropdown");
            dropdown.empty();
            dropdown.append('<option value="">Select an option</option>');

            $.each(data, function (index, item) {
                dropdown.append($('<option></option>').val(item.CommentCode).text(item.CommentCode));
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching Culture data: " + error);
        }
    });

    // Fetch and display comment when dropdown value changes
    $("#cultureDropdown").change(function () {
        var selectedCode = $(this).val();

        if (selectedCode) {
            $.ajax({
                type: "POST",
                url: "frmLaboratory.aspx/GetCultureCommentDetails",
                data: JSON.stringify({ commentCode: selectedCode }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $("#txtCultureComments").val(response.d);
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching culture comment details: " + error);
                }
            });
        } else {
            $("#txtCultureComments").val("");
        }
    });

});

$(document).ready(function () {
    $("#btnSave").click(function () {
        var specimen = $("#txtComments").val();
        var direct = $(".form-control.small-font:eq(0)").val(); // First textarea
        var znStain = $("#txtZnComments").val();
        var gramStain = $("#txtGramComments").val();
        var culture = $("#txtCultureComments").val();
        var comments = $("#richComment").val();
        var createdBy = "Admin"; // Replace with dynamic user data if needed
        var createdDate = new Date().toISOString().split('T')[0]; // Format YYYY-MM-DD

        $.ajax({
            type: "POST",
            url: "frmLaboratory.aspx/SaveCultureSensitivity",
            data: JSON.stringify({ 
                Specimen: specimen, 
                Direct: direct, 
                ZnStain: znStain, 
                GramStain: gramStain, 
                Culture: culture, 
                Comments: comments, 
                CreatedBy: createdBy, 
                CreatedDate: createdDate 
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d === "Success") {
                    alert("Data saved successfully!");
                    window.location.href = "frmLaboratory.aspx"; // Redirect after success
                } else {
                    alert("Error saving data.");
                }
            },
            error: function (xhr, status, error) {
                console.error("Error saving data: " + error);
            }
        });
    });
});



                            }
                            
                            function SubmitDLC() {
                                var updatedValues = $("#txtNewValue").val(); // Get the stored JSON array
                                var updatedValuesCBC = $("#txtNewValueCBC").val(); // Get the stored JSON array

                                if (!updatedValues && !updatedValuesCBC) {
                                    alert("No changes detected.");
                                    return;
                                }

                                $.ajax({
                                    type: "POST",
                                    url: "frmLaboratory.aspx/UpdateItems",
                                    data: JSON.stringify({ updatedData: updatedValues }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (response) {
                                        alert("Update successful!");
                                        console.log("Server Response:", response.d);
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("Error:", error);
                                    }
                                });

                                if (updatedValuesCBC!== null || updatedValuesCBC!== "") {
                                    $.ajax({
                                    type: "POST",
                                    url: "frmLaboratory.aspx/UpdateItemsCBC",
                                    data: JSON.stringify({ updatedData: updatedValuesCBC }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (response) {
                                        alert("Update successful!");
                                        console.log("Server Response:", response.d);
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("Error:", error);
                                    }
                                });
                                }
                                window.location.href = "frmLaboratory.aspx"; // Redirect after success

                            }
                            
                        </script>

</asp:Content>




