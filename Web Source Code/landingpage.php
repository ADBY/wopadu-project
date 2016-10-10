<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Wopadu</title>
    <link rel="shortcut icon" href="favicon.ico" type="image/ico">

    <!-- Bootstrap Core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>

    <link href="dist/lity.css" rel="stylesheet">
    <script src="vendor/jquery.js"></script>
    <script src="dist/lity.js"></script>

    <!-- Plugin CSS -->
    <link href="vendor/magnific-popup/magnific-popup.css" rel="stylesheet">

    <!-- Theme CSS -->
    <link href="css/creative.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <style>
        .navbar-default.affix {
            background-color: rgba(255,255,255,0);
            border-color: rgba(34, 34, 34, 0);
        }
        .navbar-brand {
            padding: 15px 15px;
        }
        .navbar-brand>img {
            height: 40px;
            width: 40px;
            border-radius: 50%;
        }
        .navbar-default {
            border-color: rgba(255, 255, 255, 0);
        }
        header#business {
            padding-top: 0;
        }
        .blackbg {
            padding-top: 90px;
            background-color: rgba(0,0,0,0.5);
        }
        .titlevideo.row {
            margin: auto auto 60px;
            background: rgba(255,255,255,0);
            width: 90% !important;
        }
        .landingpagesections.row {
            margin-right:0;
            margin-left:0;
            background-color: rgba(0,0,0,0.5);
            background-size:cover;
            background-position: center;
        }
        .lpg1, .lpg2, .lpg3 {
            border-right: 1px solid #fff;
        }
        .lpg1, .lpg2, .lpg3, .lpg4 {
            padding: 10px 10px 50px;
        }
        .landingpagesections .col-md-3 img {
            width: 80%;
            margin: auto;
        }
        .modal {
            z-index: 9999;
        }
        .bookingvideocall {
            text-align:center;
        }
        .navlogo {
            font-size: 25px;
            padding: 15px 0;
        }
        .bookbutton {
            margin-top: 70px;
        }
        @media screen and  (max-width: 480px) {
            .navbar-brand>img {
                height: 40px;
                width: 40px;
            }
            .navbar-brand {
                padding: 8px 8px;
            }
            .navbar-default.affix {
                background-color: rgba(255,255,255,1);
            }
            header#business {
                padding-bottom: 0px;
            }
            .lpg1, .lpg2, .lpg3 {
                border-right: none;
                border-bottom: 1px solid #fff;
            }
            #mainNav {
                display: none;
            }
            .bookbutton {
                margin-top: 45px;
            }
        }
        @media screen and  (min-width: 1367px) {
            .bookbutton {
                margin-top: 12%;
            }
        }
    </style>

</head>

<body id="page-top">

    <nav id="mainNav" class="navbar navbar-default navbar-fixed-top">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span> Menu <i class="fa fa-bars"></i>
                </button>
                <a class="navbar-brand page-scroll" href="home"><img src="img/ChnagedLogo.png" class="img-responsive"></a>
                <p class="navlogo">Wopadu</p>
            </div>
        </div>
        <!-- /.container-fluid -->
    </nav>

    <header id = "business">
        <div class="blackbg">
            <div class="titlevideo row">
                <div class="col-md-6 col-xs-12">
                    <iframe width="560" height="315" src="https://www.youtube.com/embed/xooVNn_To5M?rel=0" frameborder="0" allowfullscreen></iframe>
                </div>
                <div class="bookbutton col-md-6 col-xs-12">
                    <h1 style="color:#fff;font-size: 25px;letter-spacing: 1px;font-weight:bold"> Want to make a tonne more money, reduce cost, and give fantastic service? </h1>
                    <!-- Trigger the modal with a button -->
                    <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#myModal" style="margin: 15px 20px 20px;">Book Call</button>
                </div>                
                <!-- Modal -->
                <div id="myModal" class="modal fade" role="dialog">
                  <div class="modal-dialog">

                    <!-- Modal content-->
                    <div class="modal-content">
                      <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title" style="color:#555">Book Call</h4>
                      </div>
                      <div class="modal-body">
                        <div class="businessform row">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label for="fname">First Name:</label>
                                    </div>
                                    <div class="col-md-9">
                                        <input type="text" class="form-control" id="fname" onKeyUp="checkSubBtn()" onBlur="checkSubBtn()">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label for="email">Email:</label>
                                    </div>
                                    <div class="col-md-9">
                                        <input type="email" class="form-control" id="email" onKeyUp="checkSubBtn()" onBlur="checkSubBtn()">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label for="phone">Phone:</label>
                                    </div>
                                    <div class="col-md-9">
                                        <input type="text" class="form-control" id="phone" onKeyUp="checkSubBtn()" onBlur="checkSubBtn()">
                                    </div>
                                </div>
                                <?php /*?><div class="row">
                                    <div class="col-md-12">
                                        <button type="button" class="btn btn-success">Submit</button>
                                    </div>
                                </div><?php */?>
                                <div class="row">
                                    <div class="col-md-offset-3 col-md-9" style="text-align:left">
                                        <button type="button" class="btn btn-dark" onClick="contact()" id="submitBtn" disabled>Submit</button>
                                        <label id="bk_error" style="margin-left:3px; margin-top:7px"></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                      </div>
                      <?php /*?><div class="modal-footer">
                        <button type="button" class="btn btn-success" data-dismiss="modal" style="background-color:#ff4a4a;">Close</button>
                      </div><?php */?>
                    </div>

                  </div>
                </div>
            </div>

            <div class="landingpagesections row">
                <div class="blacklayer">
                    <div class="lpg1 col-md-3">
                        <h3 style="color:#fff">&nbsp;</h3>
                        <a href="https://youtu.be/lLkZ6JHRsvI&rel=0" data-lity style="display: block; position: relative; width: 100%;">
                        	<img class="img-responsive" src="img/youtube-play.png" />
                            <h3 style="position: absolute; color: #cb005b; top: 28%; width: 100%; font-weight: bold;">
                            	No Split Bills
                            </h3>
                        </a>
                    </div>
                    <div class="lpg2 col-md-3">
                    	<h3 style="color:#fff">&nbsp;</h3>
                        <a href="https://youtu.be/osNClhtTwPA&rel=0" data-lity style="display: block; position: relative; width: 100%;">
                        	<img class="img-responsive" src="img/youtube-play.png" />
                            <h3 style="position: absolute; color: #cb005b; top: 28%; width: 100%; font-weight: bold;">
                            	Menu Translation
                            </h3>
                        </a>
                    </div>
                    <div class="lpg3 col-md-3">
                    	<h3 style="color:#fff">&nbsp;</h3>
                        <a href="https://youtu.be/3cjXdgG7e8E&rel=0" data-lity style="display: block; position: relative; width: 100%;">
                        	<img class="img-responsive" src="img/youtube-play.png" />
                            <h3 style="position: absolute; color: #cb005b; top: 28%; width: 100%; font-weight: bold;">
                            	Phone Notification
                            </h3>
                        </a>
                    </div>
                    <div class="lpg4 col-md-3">
                    	<h3 style="color:#fff">&nbsp;</h3>
                        <a href="https://youtu.be/f_CHSK5HOv0&rel=0" data-lity style="display: block; position: relative; width: 100%;">
                        	<img class="img-responsive" src="img/youtube-play.png" />
                            <h3 style="position: absolute; color: #cb005b; top: 20%; width: 100%; font-weight: bold;">
                            	Order Management<br/> System
                            </h3>
                        </a>
                    </div>
                </div>
            </div>
            <div class="text-right" style="background-color:rgba(0,0,0,0.3); padding:10px 20px">
            	<a href="privacypolicy" style="font-size: 13px; color:#fff;">Privacy Policy</a>
            </div>
        </div>
        
            
    </header>

    <!-- jQuery -->
    <script src="vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
    <script src="vendor/scrollreveal/scrollreveal.min.js"></script>
    <script src="vendor/magnific-popup/jquery.magnific-popup.min.js"></script>

    <!-- Theme JavaScript -->
    <script src="js/creative.min.js"></script>
    <script>
	
	function checkSubBtn()
	{
		var f = $("#fname").val();
		var e = $("#email").val();
		var p = $("#phone").val();
		var filter = /^([0-9]{8,})$/;
		var filter_email = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/;		
		
		var display_button = false;
		
		if(f == "")
		{}
		if(e != "")
		{
			if(!filter_email.test(e))
			{
				$("#bk_error").html('<span style="color:#f67a6e">Please enter valid email address</span>');
			}
			else
			{
				$("#bk_error").html('');
				if(p != "")
				{
					if(!filter.test(p))
					{
						$("#bk_error").html('<span style="color:#f67a6e">Please enter valid phone number</span>');
					}
					else
					{
						display_button = true;
					}
				}
			}
		}
		
		if(display_button == true)
		{	
			$("#submitBtn").removeClass("btn-dark").addClass("btn-success");
			$("#submitBtn").prop("disabled", false);
		}
		else
		{
			$("#submitBtn").removeClass("btn-success").addClass("btn-dark");
			$("#submitBtn").prop("disabled", true);
		}
	}
	
    function contact()
	{
		var f = $("#fname").val();
		var e = $("#email").val();
		var p = $("#phone").val();
		var filter = /^([0-9]{8,})$/;
		var filter_email = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/;
		
		if(f == "")
		{
			return $("#bk_error").html('<span style="color:#f67a6e">Please enter first name</span>');
		}
		else if(e == "")
		{
			return $("#bk_error").html('<span style="color:#f67a6e">Please enter email address</span>');
		}
		else if(!filter_email.test(e))
		{
			return $("#bk_error").html('<span style="color:#f67a6e">Please enter valid email address</span>');
		}
		else if(p == "")
		{
			return $("#bk_error").html('<span style="color:#f67a6e">Please enter phone number</span>');
		}
		else if(!filter.test(p))
		{
			return $("#bk_error").html('<span style="color:#f67a6e">Please enter valid phone number</span>');
		}
		else
		{
			$.ajax({
				url: 'book-a-call.php',
				data: 'f='+f+'&e='+e+'&p='+p,
				type: 'POST',
				success: function(d){
					if(d == "1")
					{
						$("#fname").val('');
						$("#email").val('');
						$("#phone").val('');
						
						$("#bk_error").html('<span style="color:#3c763d">We will be back to you soon.</span>');
					}
					else
					{
						$("#bk_error").html('<span style="color:#f67a6e">'+d+'</span>');
					}
				},
				error: function(){
					$("#bk_error").html('<span style="color:#f67a6e">Something went wrong, Please try again</span>');
					alert('Something went wrong, Please try later');
				}
			});
		}
    }
    </script>


</body>

</html>
