<?php
$this->title = "Restaurant Screen";
?>

<div class="row" style="height:100%">

	<?php if(empty($resto)) { ?>
    
    <div class="col-md-12 logout-link">
    	<a class="btn btn-sm btn-success" href="<?= Yii::$app->urlManager->createUrl("site/index") ?>" style="color:#ffffff;margin-right:15px;"><i class="fa fa fa-toggle-left"></i> Go Back</a>
    	<?php /*?><a class="btn btn-sm btn-danger" href="#" style="color:#ffffff"><i class="fa fa-sign-out"></i> Logout</a><?php */?>
    </div>
    
    <div class="col-md-12">
    	<p style="text-align: center;color: #FFFFFF;font-size: 6em; margin-top:2em;">All orders have been served.</p>
   	</div>
    <?php } else { ?>
	
	<div class="col-md-12 logout-link">
    	<a class="btn btn-sm btn-success" href="<?= Yii::$app->urlManager->createUrl("site/index") ?>" style="color:#ffffff;margin-right:15px;"><i class="fa fa fa-toggle-left"></i> Go Back</a>
    	<?php /*?><a class="btn btn-sm btn-danger" href="#" style="color:#ffffff"><i class="fa fa-sign-out"></i> Logout</a><?php */?>
    </div>
    <?php if(isset($resto[1])) { ?>
    <div class="col-md-4 order_upcome" style="position:relative; width:30%">
        <div class="table_style" style="position: relative;top: 50%;transform: translateY(-50%);">
            <?php /*?><section class="panel panel-info">
                <header class="panel-heading">
                Upcoming orders
                </header>
            </section><?php */?>
            <h4 style="color:#ffffff">Upcoming orders</h4>
            <?php 
			for($i=1; $i<6; $i++) {
				
				if(isset($resto[$i]['order_number'])) {
				echo '<section class="panel">
					<div class="panel-body">
						Order Number: '.$resto[$i]['order_number'].'<br />
						Table Number: '.$resto[$i]['table_location'].'
					</div>
				</section>';
				}
			}
			?>
        </div>
    </div>
    <?php } ?>
    <div class="<?php if(!isset($resto[1])) { echo 'col-md-offset-2 '; } ?>col-md-8 comp_order" style="position:relative; width:70%">
        <div class="col-md-6" style="position: relative;top: 50%;transform: translateY(-50%);">
            <div class="panel panel-danger">
                <div class="panel-heading">
                    <h3 class="panel-title" style="font-size: 60px;font-weight: bold;">Order Number</h3>
                </div>
                <div class="panel-body" style="text-align: center; <?php if($resto[0]['table_location'] == "Takeaway") { echo "font-size: 70px"; } else { echo "font-size: 100px"; } ?>;line-height: normal;font-weight: bold;">
                    <?= $resto[0]['order_number'] ?>
                </div>
            </div>
        </div>
        <div class="col-md-6" style="position: relative;top: 50%;transform: translateY(-50%);">
            <div class="panel panel-success">
                <div class="panel-heading">
                    <h3 class="panel-title" style="font-size: 60px;font-weight: bold;">Table Number</h3>
                </div>
                <div class="panel-body" style="text-align: center; <?php if($resto[0]['table_location'] == "Takeaway") { echo "font-size: 70px"; } else { echo "font-size: 100px"; } ?>;line-height: normal;font-weight: bold;">
                    <?= $resto[0]['table_location'] ?>
                </div>
            </div>
        </div>
    </div>
    
    <?php } ?>
</div>

<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
$(document).ready(function() {
	var sheight = $(window).height();
	sheight = sheight - 70;
	kheight = sheight + 10;
	//alert(sheight);
	$(".comp_order").css('height', sheight);
	$(".order_upcome").css('height', kheight);
});
setTimeout(function() {
	window.location.reload(true); 
}, 10000);
</script>