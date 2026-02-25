<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmLoginNew.aspx.cs" Inherits="frmLoginNew" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lab Management System</title>
<link rel="shortcut icon" href="~/Images/Final Logo-2.png" type="image/x-icon" />
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <style>
        :root {
            --lab-blue: #1a73e8;
            --lab-teal: #17a2b8;
            --lab-dark: #2c3e50;
            --lab-light: #e0f7fa;
        }
        
        body {
            background: linear-gradient(135deg, #e0f7fa 0%, #f5f5f5 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }
        
        .lab-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .lab-header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 15px 0;
        }
        
        .lab-logo {
            height: 100px;
            transition: transform 0.3s;
        }
        
        .lab-logo:hover {
            transform: scale(1.05);
        }
        
        .login-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin: 30px auto;
        }
        
        .login-banner {
            background: linear-gradient(135deg, var(--lab-blue) 0%, var(--lab-teal) 100%);
            color: white;
            padding: 40px 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            position: relative;
            overflow: hidden;
            min-height: 500px;
        }
        
        .slideshow-container {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }
        
        .slideshow-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
            z-index: 2;
        }
        
        .banner-content {
            position: relative;
            z-index: 3;
            text-align: center;
            max-width: 80%;
        }
        
        .login-form {
            padding: 40px 30px;
        }
        
        .form-icon {
            position: absolute;
            left: 15px;
            top: 12px;
            color: var(--lab-teal);
            font-size: 1.2rem;
        }
        
        .form-control {
            padding-left: 40px;
            border-radius: 50px;
            border: 1px solid #e0e0e0;
            height: 45px;
        }
        
        .form-control:focus {
            border-color: var(--lab-teal);
            box-shadow: 0 0 0 0.2rem rgba(23, 162, 184, 0.25);
        }
        
        .btn-login {
            background: linear-gradient(to right, var(--lab-blue), var(--lab-teal));
            border: none;
            border-radius: 50px;
            padding: 10px 25px;
            font-weight: 600;
            transition: all 0.3s;
            width: 100%;
            height: 45px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(23, 162, 184, 0.4);
        }
        
        .lab-features {
            display: flex;
            justify-content: space-around;
            text-align: center;
            padding: 20px 0;
        }
        
        .feature-item {
            padding: 15px;
            max-width: 250px;
        }
        
        .feature-icon {
            font-size: 2.5rem;
            color: var(--lab-blue);
            margin-bottom: 15px;
        }
        
        .lab-footer {
            background-color: var(--lab-dark);
            color: white;
            padding: 20px 0;
            margin-top: 40px;
        }
        
        .system-info {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
        }
        
        .system-info i {
            margin-right: 10px;
            color: var(--lab-teal);
        }
        
        .slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 1s ease-in-out;
            background-size: cover;
            background-position: center;
        }
        
        .slide.active {
            opacity: 1;
        }
        
        @media (max-width: 768px) {
            .login-banner {
                padding: 30px 15px;
            }
            
            .login-form {
                padding: 30px 20px;
            }
            
            .lab-features {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
    
    <!-- JavaScript -->
    <script type="text/javascript" src="<%= ResolveUrl("~/Site/Login/script/jquery.min.js") %>"></script>
    <script>
        $(document).ready(function() {
            // Set current date
            var now = new Date();
            var options = { year: 'numeric', month: 'long', day: 'numeric' };
            $('#currentDate').text(now.toLocaleDateString('en-US', options));
            
            // Focus on username field
            $('#<%= txtUserID.ClientID %>').focus();
            
            // Slideshow functionality
            let currentSlide = 0;
            const slides = $('.slide');
            const totalSlides = slides.length;
            
            function showSlide(index) {
                slides.removeClass('active');
                slides.eq(index).addClass('active');
            }
            
            function nextSlide() {
                currentSlide = (currentSlide + 1) % totalSlides;
                showSlide(currentSlide);
            }
            
            // Initialize slideshow
            showSlide(0);
            setInterval(nextSlide, 4000);
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!-- Header -->
            <div class="lab-header">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="d-flex align-items-center">
                                <img src="<%= ResolveUrl("~/Images/Final Logo-1.png") %>" alt="Apollo Lab" class="lab-logo">
<%--                                <h4 class="ms-3 mb-0 text-primary">LMS</h4>--%>
                            </div>
                        </div>
                        <div class="col-md-6 text-end">
                            <span class="text-muted"><i class="fas fa-calendar-alt me-2"></i><span id="currentDate">June 22, 2025</span></span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-10">
                        <div class="login-container">
                            <div class="row">
                                <!-- Banner Side with Slideshow -->
                                <div class="col-md-5 login-banner p-0">
                                    <div class="slideshow-container">
                                        <div class="slide active" style="background-image: url('<%= ResolveUrl("~/Site/Login/images/Login_img1.jpg") %>');"></div>
                                        <div class="slide" style="background-image: url('<%= ResolveUrl("~/Site/Login/images/Login_img2.jpg") %>');"></div>
                                        <div class="slide" style="background-image: url('<%= ResolveUrl("~/Site/Login/images/Login_img3.jpg") %>');"></div>
                                    </div>
                                    <div class="slideshow-overlay"></div>
                                    <div class="banner-content">
                                        <h3 class="mb-4">EXPERTISE EMPOWERING YOU</h3>
                                        <p class="text-center">Accredited Medical Testing & Analysis</p>
                                        <div class="mt-4">
                                            <div class="system-info">
                                                <i class="fas fa-flask"></i> Advanced Diagnostic Tools
                                            </div>
                                            <div class="system-info">
                                                <i class="fas fa-shield-alt"></i> Compliant Security
                                            </div>
                                            <div class="system-info">
                                                <i class="fas fa-chart-line"></i> Real-time Analytics
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Form Side -->
                                <div class="col-md-7 login-form">
                                    <h2 class="mb-4 text-center">Lab Management Account</h2>
                                    <p class="text-muted text-center mb-4">To access the lab portal, please enter your credentials</p>
                                    
                                    <div class="mb-4">
                                        <div class="position-relative mb-3">
                                            <i class="fas fa-user form-icon"></i>
                                            <asp:TextBox ID="txtUserID" runat="server" CssClass="form-control" 
                                                placeholder="Enter User ID" AutoCompleteType="None"></asp:TextBox>
                                        </div>
                                        
                                        <div class="position-relative mb-3">
                                            <i class="fas fa-lock form-icon"></i>
                                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                                                CssClass="form-control" placeholder="Enter Password" AutoCompleteType="None"></asp:TextBox>
                                        </div>
                                        
                                        <div class="d-grid gap-2 mt-4">
                                            <asp:Button ID="btnLogin" runat="server" Text="Sign In" 
                                                CssClass="btn-login btn-primary" OnClick="btnLogin_Click" />
                                        </div>
                                        
                                        <div class="text-center mt-3">
                                            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" CssClass="fw-bold"></asp:Label>
                                        </div>
                                        
                                        <div class="text-center mt-3">
                                            <a href="#" class="text-decoration-none">Forgot Password?</a>
                                        </div>
                                    </div>
                                    
                                    <div class="mt-5">
                                        <div class="lab-features">
                                            <div class="feature-item">
                                                <i class="fas fa-vial feature-icon"></i>
                                                <h6>Sample Tracking</h6>
                                                <p class="small text-muted">Track specimens from collection to analysis</p>
                                            </div>
                                            <div class="feature-item">
                                                <i class="fas fa-file-medical feature-icon"></i>
                                                <h6>Report Management</h6>
                                                <p class="small text-muted">Generate and distribute reports securely</p>
                                            </div>
                                            <div class="feature-item">
                                                <i class="fas fa-chart-bar feature-icon"></i>
                                                <h6>Operation Analytics</h6>
                                                <p class="small text-muted">Real-time insights into lab operations</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer -->
            <div class="lab-footer">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6 text-center text-md-start">
                            <p class="mb-0">Pathoxperts &reg; Lab Management. &copy; 2019-<%= DateTime.Now.Year %>. All Rights Reserved.</p>
                        </div>
                        <div class="col-md-6 text-center text-md-end">
                            <div class="d-flex justify-content-center justify-content-md-end">
                             <%--   <a href="#" class="text-white me-3"><i class="fab fa-facebook-f"></i></a>
                                <a href="#" class="text-white me-3"><i class="fab fa-twitter"></i></a>
                                <a href="#" class="text-white me-3"><i class="fab fa-linkedin-in"></i></a>
                                <a href="#" class="text-white"><i class="fab fa-instagram"></i></a>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>