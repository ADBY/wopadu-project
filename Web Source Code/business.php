<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Business - Wopadu</title>
    <link rel="shortcut icon" href="favicon.ico" type="image/ico">

    <!-- Bootstrap Core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>

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

</head>

<body id="page-top">

    <?php require "inc.menu.php"; ?>

    <header id = "business">
        <div class="titlevideo row">
            <h1>Business</h1>
            <iframe width="560" height="315" src="https://www.youtube.com/embed/v5g0q7G0PPE?rel=0" frameborder="0" allowfullscreen></iframe>

            <div class="col-md-12">
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
