<%@ Page Title="Lab Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="frmIndex.aspx.cs" Inherits="Site_frmIndex" %>

<%@ Register Src="~/sysCtrl/msg_Box.ascx" TagPrefix="uc1" TagName="msg_Box" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
     <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div class="container-fluid">
                                    <div class="container">
                                        <div class="row border mb-4 bg-white">
                                            <div class="col-md-12 bg-blueGradient text-white font-weight-bold">
                                                <h6 class="mt-2 common-font"><strong><i class="fa fa-user mr-2" aria-hidden="true"></i>New Patient</strong></h6>
                                            </div>

                                            <section class="col-md-12 mt-2">
                                                <div class="tab-content py-2">
                                                    <div class="tab-pane active" role="tabpanel">
                                                        <div class="row common-margin">
                                                            <div class="col-md-12">
                                                                <div class="row">
                                                                    <div class="col-md-1">
                                                                        <label for="ddlLocation" class="small-font font-weight-normal">Location:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:DropDownList
                                                                                ID="ddlLocation"
                                                                                onchange="updatePatientNo()"
                                                                                CssClass="form-control common-font rounded mySelect2"
                                                                                runat="server"
                                                                                AppendDataBoundItems="true"
                                                                                AutoPostBack="false">
                                                                                <asp:ListItem Text="--- Select Center ---" Value="" />
                                                                            </asp:DropDownList>

                                                                        </div>

                                                                        <script>
                                                                            function updatePatientNo() {
                                                                                var dropdown = document.getElementById('<%= ddlLocation.ClientID %>');
        var selectedValue = dropdown.value; // Get selected value

        if (selectedValue) {
            var id = selectedValue.split('-')[0].trim(); // Extract ID

            // Get current date and month
            var today = new Date();
            var day = ("0" + today.getDate()).slice(-2); // Format 2-digit
            var month = ("0" + (today.getMonth() + 1)).slice(-2); // Format 2-digit

            var patientNo = id + "-" + day + "-" + month;
            document.getElementById('<%= txtPatientNo.ClientID %>').value = patientNo;
        document.getElementById('<%= hfPatientNo.ClientID %>').value = patientNo; // Store in hidden field
    } else {
        document.getElementById('<%= txtPatientNo.ClientID %>').value = ""; // Clear if no selection
        document.getElementById('<%= hfPatientNo.ClientID %>').value = ""; // Clear hidden field
                                                                                }
                                                                            }

                                                                        </script>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtFirstName" class="small-font font-weight-normal">Patient No:</label>
                                                                    </div>

                                                                    <div class="col-md-3">

                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtPatientNo" CssClass="form-control common-font rounded" runat="server" ReadOnly="true" />
                                                                            <asp:HiddenField ID="hfPatientNo" runat="server" />

                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtFirstName" class="small-font font-weight-normal">MRN:</label>
                                                                    </div>

                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtMRNo" CssClass="form-control common-font rounded" runat="server" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtFirstName" class="small-font font-weight-normal">First Name:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtFirstName" CssClass="form-control common-font rounded" runat="server" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtLastName" class="small-font font-weight-normal">Last Name:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtLastName" CssClass="form-control common-font rounded" runat="server" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtFatherHusbandName" class="small-font font-weight-normal">Father/Husband:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtFatherHusbandName" CssClass="form-control common-font rounded" runat="server" />
                                                                        </div>
                                                                    </div>

                                                                    <div class="col-md-1">
                                                                        <label for="txtAge" class="small-font font-weight-normal">Age:</label>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtAge" CssClass="form-control common-font rounded" runat="server" />
                                                                        </div>
                                                                    </div>

                                                                    <div class="col-md-1">
                                                                        <label for="ddlDuration" class="small-font font-weight-normal">Duration:</label>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <div class="form-group">
                                                                            <asp:DropDownList ID="ddlDuration" CssClass="form-control common-font rounded" runat="server">
                                                                                <asp:ListItem Text="--- Select Duration---" Value="" Selected="True" Enabled="False" />
                                                                                <asp:ListItem Text="Years." Value="Years." />
                                                                                <asp:ListItem Text="Months." Value="Months." />
                                                                                <asp:ListItem Text="Days." Value="Days." />
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                    </div>




                                                                    <div class="col-md-1">
                                                                        <label for="ddlDuration" class="small-font font-weight-normal">Marital:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:DropDownList ID="ddlMaritalStatus" CssClass="form-control common-font rounded mySelect2" runat="server">
                                                                                <asp:ListItem Text="--- Select Marital Status---" Value="" Selected="True" Enabled="False" />
                                                                                <asp:ListItem Text="Single" Value="Single." />
                                                                                <asp:ListItem Text="Married" Value="Married" />
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                    </div>
                                                                    <%-- <div class="col-md-4">
                            <label for="txtDob" class="small-font font-weight-normal">DOB:</label>
                            <div class="form-group">
                                <asp:TextBox ID="txtDob" CssClass="form-control common-font rounded" runat="server" />
                            </div>
                        </div>--%>
                                                                    <%--<div class="col-md-4">
                            <label for="ddlBloodGroup" class="small-font font-weight-normal">Blood Group:</label>
                            <div class="form-group">
                                <asp:DropDownList ID="ddlBloodGroup" CssClass="form-control common-font rounded" runat="server">
                                    <asp:ListItem Text="--- Select Blood Group ---" Value="" Selected="True" Enabled="False" />
                                    <asp:ListItem Text="A +ve" Value="A +ve" />
                                    <asp:ListItem Text="A -ve" Value="A -ve" />
                                    <asp:ListItem Text="B +ve" Value="B +ve" />
                                    <asp:ListItem Text="B -ve" Value="B -ve" />
                                    <asp:ListItem Text="AB +ve" Value="AB +ve" />
                                    <asp:ListItem Text="AB -ve" Value="AB -ve" />
                                    <asp:ListItem Text="O +ve" Value="O +ve" />
                                    <asp:ListItem Text="O -ve" Value="O -ve" />
                                </asp:DropDownList>
                            </div>
                        </div>--%>
                                                                    <div class="col-md-1">
                                                                        <label for="txtRegistrationDate" class="small-font font-weight-normal">Reg. Date:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtRegistrationDate" CssClass="form-control common-font rounded" runat="server" TextMode="DateTimeLocal" autocomplete="off" />

                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtPhone" class="small-font font-weight-normal">Phone:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtPhone" CssClass="form-control common-font rounded" MaxLength="11" oninput="enforcePhoneLength(this)" runat="server" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtMobile" class="small-font font-weight-normal">Mobile:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtMobile" CssClass="form-control common-font rounded" MaxLength="11" oninput="enforceMobileLength(this)" runat="server" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtPhone" class="small-font font-weight-normal">CNIC:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtNIC" CssClass="form-control common-font rounded rounded" MaxLength="13"
                                                                                oninput="enforceCNICLength(this)" runat="server" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="ddlGender" class="small-font font-weight-normal">Gender:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:DropDownList ID="ddlGender" CssClass="form-control common-font rounded mySelect2" runat="server">
                                                                                <asp:ListItem Text="--- Select Gender ---" Value="" Selected="True" Enabled="False" />
                                                                                <asp:ListItem Text="Male" Value="1" />
                                                                                <asp:ListItem Text="Female" Value="2" />
                                                                                <asp:ListItem Text="Other" Value="0" />
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="ddlGender" class="small-font font-weight-normal">City:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:DropDownList ID="ddlCity" CssClass="form-control common-font rounded mySelect2" runat="server">
                                                                                <asp:ListItem Text="--- Select City ---" Value="" Selected="True" Enabled="False" />
                                                                                <asp:ListItem Text="Lahore" Value="Lahore" />
                                                                                <asp:ListItem Text="Karachi" Value="Karachi" />
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="ddlGender" class="small-font font-weight-normal">Country:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:DropDownList ID="ddlCountry" CssClass="form-control common-font rounded mySelect2" runat="server">
                                                                                <asp:ListItem Text="--- Select Country ---" Value="" Selected="True" Enabled="False" />
                                                                                <asp:ListItem Text="Pakistan" Value="Pakistan" />
                                                                                <asp:ListItem Text="USA" Value="USA" />
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtEmail" class="small-font font-weight-normal">Email:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtEmail" CssClass="form-control common-font rounded" runat="server" TextMode="Email" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="ddlReference" class="small-font font-weight-normal">Reference:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:DropDownList ID="ddlReference" CssClass="form-control common-font rounded mySelect2" runat="server">
                                                                                <asp:ListItem Text="--- Select Reference ---" Value="" Selected="True" Enabled="False" />
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtAddress" class="small-font font-weight-normal">CABGNo:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtCABGNo" CssClass="form-control common-font rounded" runat="server" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-1">
                                                                        <label for="txtAddress" class="small-font font-weight-normal">Address:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtAddress" CssClass="form-control common-font rounded" runat="server" TextMode="MultiLine" />
                                                                        </div>
                                                                    </div>

                                                                    <div class="col-md-1">
                                                                        <label for="txtConsultant" class="small-font font-weight-normal ">Consultant: </label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtConsultant" runat="server" CssClass="form-control common-font rounded" />
                                                                        </div>
                                                                    </div>

                                                                    <div class="col-md-1">
                                                                        <label for="txtComments" class="small-font font-weight-normal">Comments:</label>
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                            <asp:TextBox ID="txtComments" runat="server" CssClass="form-control common-font rounded" />
                                                                        </div>
                                                                    </div>

                                                                </div>









                                                                <script>
                                                                    function validateForm() {
                                                                        var errors = [];

                                                                        // Get fields
                                                                        var firstName = document.getElementById('<%= txtFirstName.ClientID %>').value.trim();
        var lastName = document.getElementById('<%= txtLastName.ClientID %>').value.trim();
        var fatherHusband = document.getElementById('<%= txtFatherHusbandName.ClientID %>').value.trim();
        var age = document.getElementById('<%= txtAge.ClientID %>').value.trim();
        var phone = document.getElementById('<%= txtPhone.ClientID %>').value.trim();
        var mobile = document.getElementById('<%= txtMobile.ClientID %>').value.trim();
        var cnic = document.getElementById('<%= txtNIC.ClientID %>').value.trim();
        var cabgNo = document.getElementById('<%= txtCABGNo.ClientID %>').value.trim();
        var mrn = document.getElementById('<%= txtMRNo.ClientID %>').value.trim();
        var address = document.getElementById('<%= txtAddress.ClientID %>').value.trim();
        var email = document.getElementById('<%= txtEmail.ClientID %>').value.trim();
        var consultant = document.getElementById('<%= txtConsultant.ClientID %>').value.trim();
        var comments = document.getElementById('<%= txtComments.ClientID %>').value.trim();


        // Required fields
        if (!firstName) errors.push("First Name is required.");
        if (!age) errors.push("Age is required.");
        if (!mobile) errors.push("Mobile is required.");

        // Only numbers
        var numberOnlyRegex = /^\d+$/;
        if (mrn && (!numberOnlyRegex.test(mrn) || mrn.length > 20)) {
            errors.push("MRN must be numeric and not exceed 20 digits.");
        }
        if (age && !numberOnlyRegex.test(age)) errors.push("Age must contain numbers only.");
        if (phone && (!numberOnlyRegex.test(phone) || phone.length !== 11)) {
            errors.push("Phone must be numeric and not exceed 11 digits.");
        }
        if (mobile && (!numberOnlyRegex.test(mobile) || mobile.length !== 11)) {
            errors.push("Mobile must be numeric and exactly 11 digits.");
        }
        if (cnic && (!numberOnlyRegex.test(cnic) || cnic.length !== 13)) {
            errors.push("CNIC must contain numbers only and exactly 13 digits.");
        }
        if (cabgNo && (!numberOnlyRegex.test(cabgNo) || cabgNo.length > 13)) {
            errors.push("CABGNo must be numeric and not exceed 30 digits.");
        }

        // Only letters
        var letterOnlyRegex = /^[a-zA-Z\s]+$/;
        if (firstName && (!letterOnlyRegex.test(firstName) || firstName.split(/\s+/).length > 25)) {
            errors.push("First Name must contain letters only and not exceed 25 words.");
        }
        if (lastName && (!letterOnlyRegex.test(lastName) || lastName.split(/\s+/).length > 25)) {
            errors.push("Last Name must contain letters only and not exceed 25 words.");
        }
        if (fatherHusband && (!letterOnlyRegex.test(fatherHusband) || fatherHusband.split(/\s+/).length > 25)) {
            errors.push("Father/Husband must contain letters only and not exceed 25 words.");
        }

        // Email format
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email && !emailRegex.test(email)) {
            errors.push("Email must be in a valid format.");
        }

        // Address word limit
        if (address && address.split(/\s+/).length > 100) {
            errors.push("Address must not exceed 100 words.");
        }

        // Show errors
        if (errors.length > 0) {
            Swal.fire({
                icon: 'error',
                title: 'Please fix the following errors:',
                html: errors.join('<br>'),
                confirmButtonText: 'OK'
            });
            return false;
        }

        // If no errors, show success and trigger server-side postback manually
        Swal.fire({
            icon: 'success',
            title: 'Patient Registered',

            confirmButtonText: 'OK'
        }).then((result) => {
            if (result.isConfirmed) {
                __doPostBack('<%= btnFinish.UniqueID %>', '');
                                                                                }
                                                                            });
                                                                        return false;



                                                                    }
                                                                </script>
                                                                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


                                                                <ul class="float-right">
                                                                    <li class="list-inline-item">
                                                                        <asp:Button ID="btnFinish" runat="server" Text="Next" CssClass="btn bg-blueGradient text-white" OnClientClick="return validateForm();" OnClick="btnFinish_Click" />
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                            <div class="clearfix"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </section>

                                            <div>
                                                <asp:Panel ID="pnlMSG" runat="server" Visible="false">
                                                    <uc1:msg_Box ID="ctrl_MSG" runat="server" />
                                                </asp:Panel>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>

<%--    <script type="text/javascript">
        function /*validateAndSubmit*/() {
            let isValid = true;

            // Check required fields (add more as needed)
            const location = document.querySelector("select[name='location']").value;
            const medicalRecordNo = document.querySelector("input[name='medicalRecordNo']").value;
            const firstName = document.querySelector("input[name='firstName']").value;
            const lastName = document.querySelector("input[name='lastName']").value;
            const age = document.querySelector("input[name='age']").value;
            const Sex = document.querySelector("input[name='sex']").value;
            const Registration = document.querySelector("input[name='Registration']").value;
            const Email = document.querySelector("input[name='Email']").value;
            const Mobile = document.querySelector("input[name='Mobile']").value;
            const cashonly = document.querySelector("input[name='cashonly']").value;
            const Consultant = document.querySelector("input[name='Consultant']").value;
            const Consultant2 = document.querySelector("input[name='Consultant2']").value;
            const Dob = document.querySelector("input[name='Dob']").value;
            const Blood = document.querySelector("input[name='Blood']").value;
            const Phone = document.querySelector("input[name='Phone']").value;


            const Marital = document.querySelector("input[name='Marital']").value;
            const NIC = document.querySelector("input[name='NIC']").value;
            const Fax = document.querySelector("input[name='Fax']").value;
            const Country = document.querySelector("input[name='Country']").value;
            const District = document.querySelector("input[name='District']").value;
            const Province = document.querySelector("input[name='Province']").value;
            const City = document.querySelector("input[name='City']").value;
            const Address = document.querySelector("input[name='Address']").value;
            const Job = document.querySelector("input[name='Job']").value;
            const Reference = document.querySelector("input[name='Reference']").value;
            const Agency = document.querySelector("input[name='Agency']").value;
            const CABG = document.querySelector("input[name='CABG']").value;

            // Example of checking if fields are empty
            if (!location || !medicalRecordNo || !firstName || !lastName || !age) {
                alert("Please fill out all required fields.");
                isValid = false;
            }

            // Additional custom validation logic can be added here (like regex checks for email, numeric values, etc.)

            // If valid, submit the form
            if (isValid) {
                __doPostBack('btnFinish', ''); // ASP.NET WebForms form submission
            }
        }
    </script>--%>
                                </ContentTemplate>
                        </asp:UpdatePanel>
</asp:Content>
