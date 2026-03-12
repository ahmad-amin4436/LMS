<%@ Page Title="Lab Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="frmDoctorApproval.aspx.cs" Inherits="Site_frmDoctorApproval" %>

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
                                            <asp:TextBox ID="txtPatientID" runat="server" CssClass="form-control common-font rounded-0" />
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
                                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control common-font rounded-0" />
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
                                            <asp:TextBox ID="txtNIC" runat="server" CssClass="form-control common-font rounded-0" />
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
                                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control common-font rounded-0" />
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
                                        <asp:DropDownList ID="ddlSex" runat="server" CssClass="form-control common-font rounded-0">
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
                                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control common-font rounded-0" />
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
            <asp:Button ID="btnCenter" runat="server" CssClass="btn btn-sm dropdown-toggle form-control common-font rounded-0-0 customGrey-btn text-dark border"
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
                                            <input class="form-control common-font rounded-0" type="text">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Date Section -->
                            <div class="row common-margin bg-brown">
                                <div class="col-md-12 mb-3 mt-3">
                                    <span class="customGrey-btn rounded-0 text-dark border btn-sm p-2 font-weight-bold">
                                        Include Date: <input type="checkbox"/>
                                    </span>
                                </div>
                                <div class="col-md-3">
                                    <label class="small-font text-dark font-weight-normal">From Date:</label>
                                    <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control common-font rounded-0" TextMode="Date" />
                                </div>
                                <div class="col-md-3">
                                    <label class="small-font text-dark font-weight-normal">To Date:</label>
                                    <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control common-font rounded-0" TextMode="Date" />
                                </div>
                                <div class="col-md-4"></div>
                                <div class="col-md-2">
<asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm float-right" OnClick="btnSearch_Click" />
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
                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-sm table-hover"
    AllowPaging="True" PageSize="5" 
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
        <div class="d-flex">
          <asp:LinkButton 
    ID="btnViewTest"
    runat="server"
    CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm mr-2"
    CommandName="ViewTest"
    CommandArgument='<%# Eval("ID") %>'
    OnClick="btnViewTest_Click">

    <i class="fa fa-flask mr-2"></i> 

</asp:LinkButton>
          <asp:LinkButton 
    ID="btnApprove"
    runat="server"
    CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm"
    CommandName="Approve"
    CommandArgument='<%# Eval("ID") %>'
    OnClick="btnApprove_Click">

    <i class="fa fa-file-alt mr-2"></i>

</asp:LinkButton>

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
            
            <asp:Button ID="btnNextPage" runat="server" Text="Next Page" CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" OnClick="NextPageButton_Click" 
                Enabled="<%# GridView1.PageIndex < GridView1.PageCount - 1 %>" />
        </div>
        <div class="pagination-bottom">
            <span>Total Rows on Page: <%= GridView1.Rows.Count %></span>
        </div>
    </div>
</PagerTemplate>

</asp:GridView>
            <asp:Panel ID="pnlTestResults" runat="server" Visible="false" CssClass="mt-3">
                            <asp:GridView ID="gvTestResults" runat="server" CssClass="table table-bordered table-sm table-hover common-font" AutoGenerateColumns="False" HeaderStyle-CssClass="bg-light font-weight-bold small-font">
                                <Columns>
                                    <asp:BoundField DataField="ID" HeaderText="ID" />
                                    <asp:BoundField DataField="Code" HeaderText="Code" />
                                    <asp:BoundField DataField="TestID" HeaderText="Test ID" />
                                    <asp:BoundField DataField="TestName" HeaderText="Test Name" />
                                    <asp:BoundField DataField="TemplateID" HeaderText="Template ID" />
                                    <asp:BoundField DataField="Sex" HeaderText="Gender" />
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <%--<asp:Button
                                                ID="btnAddTestResult"
                                                runat="server"
                                                CssClass="btn bg-blueGradient text-white"
                                                Text="View Test Result"
                                                CommandName="AddResult"
                                                CommandArgument='<%# Eval("ID") + "," + Eval("Sex") + "," + Eval("TestID") + "," + Eval("TemplateID") + "," + Eval("Code") %>'
                                                OnClick="btnAddTestResult_Click" />--%>
                                             <asp:LinkButton 
    ID="btnRetake"
    runat="server"
    CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm"
    CommandName="Retake"
    CommandArgument='<%# Eval("ID") %>'
    OnClick="btnRetake_Click">

    <i class="fa fa-undo mr-2"></i> 

</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </asp:Panel>

                                <asp:GridView ID="gvAddResult" runat="server" AutoGenerateColumns="False" 
                                        ShowEditButton="true" OnRowEditing="gvAddResult_RowEditing" 
                                        OnRowCancelingEdit="gvAddResult_RowCancelingEdit" 
                                        OnRowUpdating="gvAddResult_RowUpdating" 
                                        CssClass="table table-bordered table-sm table-hover common-font" HeaderStyle-CssClass="bg-light font-weight-bold small-font">
                                        <Columns>
                                            <asp:BoundField DataField="TestID" HeaderText="Test ID" ReadOnly="true"  />
                                            <asp:BoundField DataField="Name" HeaderText="Test Name" ReadOnly="true" Visible="false"/>
                                            <asp:BoundField DataField="CutoffValue"  ApplyFormatInEditMode="true" HeaderText="Cut off Value" Visible="false" />

                                            
                                            <asp:BoundField DataField="Result" HeaderText="Result" ReadOnly="true" Visible="false" />
                                            <asp:BoundField DataField="PatientValue" HeaderText="Patient Value" ReadOnly="true" Visible="false" />

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
                                            <asp:CommandField ShowEditButton="True" Visible="false" />
                                            <asp:TemplateField HeaderText="Actions">
                                                <ItemTemplate>
                                                        <asp:Button 
                                                            ID="btnApprove" 
                                                            runat="server" 
                                                            CssClass="btn btn-primary font-weight-bold customGrey-btn rounded-0 text-dark border btn-sm" 
                                                            Text="Approve"  
                                                            CommandName="Approve" 
                                                            CommandArgument='<%# Eval("TestID") %>' 
                                                            OnClick="btnApprove_Click" />
                                                    
            
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>

                                    

                            </tbody>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </section>
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

    </style>


</asp:Content>




