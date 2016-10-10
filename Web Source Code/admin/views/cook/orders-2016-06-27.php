<?php
$this->title ="Cook Orders";

$odd = array();
$even = array();
foreach ($cook as $key => $value) {
    if ($key % 2 == 0) {
        $even[] = $value;
    }
    else {
        $odd[] = $value;
    }
}

/*echo "<pre>";
print_r($even);
print_r($odd);
echo "</pre>";
exit;*/

?>
<style>
.panel-heading{
	font-size:34px;
}
</style>
<div class="row">
    <div class="col-md-8">
    	<h5 style="margin-top:0; color:#ffffff">
        	<span class="btn-danger">&nbsp;</span> New orders
            <span class="btn-orange" style="margin-left:20px;">&nbsp;</span> Orders in process
            <span class="btn-success" style="margin-left:20px;">&nbsp;</span> Ready to collect
        </h5>
    </div>
    <div class="col-md-4 logout-link">
    	<h4 style="margin-top:0;">
        	<a class="btn btn-sm btn-success" href="<?= Yii::$app->urlManager->createUrl("cook/index") ?>" style="color:#ffffff;margin-right:15px;"><i class="fa fa fa-toggle-left"></i> Go Back</a>
            <a class="btn btn-sm btn-danger" href="<?= Yii::$app->urlManager->createUrl("site/logout") ?>" style="color:#ffffff"><i class="fa fa-sign-out"></i> Logout</a>
        </h4>
    </div>
    
    <?php if(empty($cook) && !$request_water) { ?>
    <div class="col-md-12">
    	<p style="text-align: center;color: #FFFFFF;font-size: 6em; margin-top:2em;">Nothing to cook right now.</p>
   	</div>
    <?php } else { ?>
    
    <?php if($request_water) { ?>
    <div class="col-md-12">
    	<div class="panel">
	        <div class="panel-heading">
	            Water Requested:
                <div class="" style="margin-top:10px;">
                	<?php foreach($request_water as $req) {
						echo '<button type="button" class="btn btn-xs btn-concrete" id="req_water_'.$req['table_number'].'" onClick="reqWater('.$req['table_number'].', '.$req['store_id'].')" style="margin-right:20px">Table #'.$req['table_number'].'</button>';
					} ?>
                </div>
            </div>        
        </div>
    </div>
    <div class="clearfix"></div>
    <?php } ?>
    
    <div class="col-md-6">

        <?php foreach($even as $order) { ?>
        <section class="panel panel-<?php if($order['status'] == 2) { echo "orange"; } else if($order['status'] == 1) { echo "danger"; } else if($order['status'] == 5) { echo "grey"; } else if($order['status'] == 3) { echo "success"; } ?>" id="order_panel_<?= $order['id'] ?>">
            <header class="panel-heading">
                <?php /*?><span class="t-left" style="width:33%"><i class="fa fa-cutlery"></i> Order No. <?= $order['order_number'] ?></span><?php */?>
                <span class="t-left" style="width:50%"><?php if($order['table_location'] == "Takeaway") { echo $order['table_location']; } else { echo $order['table_location']; } ?></span>
                
                <?php /*?><span class="t-right"><i class="fa fa-calendar"></i> <?php if($order['status'] == 5) { echo date("g:i A", strtotime($order['c_datetime'])); }	else { echo date("g:i A", strtotime($order['n_datetime'])); } ?></span><?php */?>
                
                <span class="t-right" style="width:48%">
				<?php 
				if($order['status'] == 5) {
					
					$now = new DateTime();
					$future_date = new DateTime($order['c_datetime']);
					$interval = $future_date->diff($now);
					//print_r($interval);
					
					if($interval->d > 0) {
						//echo $interval->d." days ago";
						echo $interval->format("%a days ago");
					} else {
						//echo $interval->format("%a days, %h hours, %i minutes, %s seconds");
						/*if($interval->h == 0)
						{
							echo $interval->format("%i minutes ago");
						}
						else
						{
							echo $interval->format("%h hours, %i minutes ago");
						}*/
						//echo $interval->format("%h:%i:%s");
						echo sprintf("%02d", $interval->h).":".sprintf("%02d", $interval->i).":".sprintf("%02d", $interval->s);
					}
					//echo "--".$interval->format("%a days, %h hours, %i minutes, %s seconds");
					//echo "--".date("Y-m-d g:i A", strtotime($order['c_datetime'])); 
				} else { 
					$now = new DateTime();
					$future_date = new DateTime($order['n_datetime']);
					$interval = $future_date->diff($now);
					//print_r($interval);
					if($interval->d > 0) {
						//echo $interval->d." days ago";
						echo $interval->format("%a days ago");
					} else {
						//echo $interval->format("%a days, %h hours, %i minutes, %s seconds");
						/*if($interval->h == 0)
						{
							echo $interval->format("%i minutes ago");
						}
						else
						{
							echo $interval->format("%h hours, %i minutes ago");
						}*/
						//echo $interval->format("%h:%i:%s");
						echo sprintf("%02d", $interval->h).":".sprintf("%02d", $interval->i).":".sprintf("%02d", $interval->s);
					}
					//echo "--".$interval->format("%a days, %h hours, %i minutes, %s seconds");
					//echo "--".date("Y-m-d g:i A", strtotime($order['n_datetime'])); 
				} ?></span>
            </header>
            <div class="panel-body">                            
                <div class="col-md-12">
                    <?php if($order['status'] != 5) { ?>
					<?php foreach($order['ordered_items'] as $item) { ?>
                    <div>
                        <h4 class="col-md-4 pad-left-0">
                        	<strong><?= $item['item_name'] ?></strong> 
                            <span style="font-size:13px; margin-left:10px;">x</span> <?= $item['quantity'] ?> 
                            <?php if($item['item_variety_id'] != NULL) { echo '<p><u>'.$item['item_variety_name'].'</u></p>'; } ?>
                        </h4>
                        <div class="col-md-8 text-right" id="status_block_<?= $item['od_id'] ?>">
                           <?php if($item['status'] == 1 || $item['status'] == 2 || $item['status'] == 3) { ?>
                            
                            <?php 
							echo '<input type="hidden" id="item_status_'.$item['od_id'].'" name="item_status_'.$item['od_id'].'" value="'.$item['status'].'">';
							if($item['status'] == 1) {
								echo '<a class="btn btn-danger btn-lg" style="margin-top:-3px" onClick="update_order_status('.$item['od_id'].')" id="od_btn_'.$item['od_id'].'">Start Order</a>';
							} else if($item['status'] == 2) {
								echo '<a class="btn btn-orange btn-lg" style="margin-top:-3px" onClick="update_order_status('.$item['od_id'].')" id="od_btn_'.$item['od_id'].'">Ready to collect</a>';
							} else if($item['status'] == 3) {
								echo '<a class="btn btn-success btn-lg" style="margin-top:-3px" onClick="update_order_status('.$item['od_id'].')" id="od_btn_'.$item['od_id'].'">Completed</a>';								
							}							
							?>
                            <?php } else {?>
                            <span class="complete-2"><i class="fa fa-check-square-o"></i> Order Complete</span>
                            <?php } ?>
                        </div>
                        <div class="clearfix"></div>
                        <?php foreach($item['options'] as $option) {
                        	echo '<p style="font-size:13px; line-height:12px">'.$option['option_name'].' - '.$option['sub_name'].'</p>';
                        } ?>
                        <?php if($item['add_note'] != "") { ?><p><code>Note: <?= $item['add_note'] ?></code></p><?php } ?>
                    </div>
                    <?php } ?>
                    <?php if($order['add_note'] != "") { ?><p class="lead" style="margin-bottom:10px">Note: <?= $order['add_note'] ?></p><?php } ?>
                    <?php if($order['allergies'] != "") { ?><p><code>Allergies: <?= $order['allergies'] ?></code></p><?php } ?>
                    <?php } else { $x = 1;/**** For cancelled Orders **/?>
                    <div class="col-md-12" style="font-size: 17px;font-weight: bold;color: #ff0000;margin-bottom: 15px;">
                    Order Cancelled
                    </div>
                    <?php foreach($order['ordered_items'] as $item) { ?>
                    <div class="col-md-4">
                        <h4 class="col-md-12 pad-left-0">
                        	<strong><?= $item['item_name'] ?></strong> 
                            <span style="font-size:13px; margin-left:10px;">x</span> <?= $item['quantity'] ?> 
                        </h4>

                        <?php foreach($item['options'] as $option) {
                        	echo '<p style="font-size:13px; line-height:12px">'.$option.'</p>';
                        } ?>
                        <?php if($item['add_note'] != "") { ?><p><code>Note: <?= $item['add_note'] ?></code></p><?php } ?>
                    </div>
					<?php if($x % 3 == 0) { echo '<div class="clearfix"></div>'; } ?>
                    <?php $x++; ?>
                    <?php } ?>
                    <?php } ?>
					
                </div>
            </div>
        </section>
        <?php } ?>

    </div>
    
    <div class="col-md-6">

        <?php foreach($odd as $order) { ?>
        <section class="panel panel-<?php if($order['status'] == 2) { echo "orange"; } else if($order['status'] == 1) { echo "danger"; } else if($order['status'] == 5) { echo "grey"; } else if($order['status'] == 3) { echo "success"; } ?>" id="order_panel_<?= $order['id'] ?>">
            <header class="panel-heading">
                <?php /*?><span class="t-left" style="width:33%"><i class="fa fa-cutlery"></i> Order No. <?= $order['order_number'] ?></span><?php */?>
                <span class="t-left" style="width:50%"><?php if($order['table_location'] == "Takeaway") { echo $order['table_location']; } else { echo $order['table_location']; } ?></span>
                <span class="t-right" style="width:48%">
				<?php 
				if($order['status'] == 5) {
					
					$now = new DateTime();
					$future_date = new DateTime($order['c_datetime']);
					$interval = $future_date->diff($now);
					//print_r($interval);
					
					if($interval->d > 0) {
						//echo $interval->d." days ago";
						echo $interval->format("%a days ago");
					} else {
						//echo $interval->format("%a days, %h hours, %i minutes, %s seconds");
						/*if($interval->h == 0)
						{
							echo $interval->format("%i minutes ago");
						}
						else
						{
							echo $interval->format("%h hours, %i minutes ago");
						}*/
						//echo $interval->format("%h:%i:%s");
						echo sprintf("%02d", $interval->h).":".sprintf("%02d", $interval->i).":".sprintf("%02d", $interval->s);
					}
					//echo "--".$interval->format("%a days, %h hours, %i minutes, %s seconds");
					//echo "--".date("Y-m-d g:i A", strtotime($order['c_datetime'])); 
				} else { 
					$now = new DateTime();
					$future_date = new DateTime($order['n_datetime']);
					$interval = $future_date->diff($now);
					//print_r($interval);
					if($interval->d > 0) {
						//echo $interval->d." days ago";
						echo $interval->format("%a days ago");
					} else {
						//echo $interval->format("%a days, %h hours, %i minutes, %s seconds");
						/*if($interval->h == 0)
						{
							echo $interval->format("%i minutes ago");
						}
						else
						{
							echo $interval->format("%h hours, %i minutes ago");
						}*/
						//echo $interval->format("%h:%i:%s");
						echo sprintf("%02d", $interval->h).":".sprintf("%02d", $interval->i).":".sprintf("%02d", $interval->s);
					}
					//echo "--".$interval->format("%a days, %h hours, %i minutes, %s seconds");
					//echo "--".date("Y-m-d g:i A", strtotime($order['n_datetime'])); 
				} ?></span>
                
            </header>
            <div class="panel-body">                            
                <div class="col-md-12">
                    <?php if($order['status'] != 5) { ?>
					<?php foreach($order['ordered_items'] as $item) { ?>
                    <div>
                        <h4 class="col-md-4 pad-left-0">
                        	<strong><?= $item['item_name'] ?></strong> 
                            <span style="font-size:13px; margin-left:10px;">x</span> <?= $item['quantity'] ?> 
                            <?php if($item['item_variety_id'] != NULL) { echo '<p><u>'.$item['item_variety_name'].'</u></p>'; } ?>
                        </h4>
                        <div class="col-md-8 text-right" id="status_block_<?= $item['od_id'] ?>">
                           <?php if($item['status'] == 1 || $item['status'] == 2 || $item['status'] == 3) { ?>
                            
                            <?php 
							echo '<input type="hidden" id="item_status_'.$item['od_id'].'" name="item_status_'.$item['od_id'].'" value="'.$item['status'].'">';
							if($item['status'] == 1) {
								echo '<a class="btn btn-danger btn-lg" style="margin-top:-3px" onClick="update_order_status('.$item['od_id'].')" id="od_btn_'.$item['od_id'].'">Start Order</a>';
							} else if($item['status'] == 2) {
								echo '<a class="btn btn-orange btn-lg" style="margin-top:-3px" onClick="update_order_status('.$item['od_id'].')" id="od_btn_'.$item['od_id'].'">Ready to collect</a>';
							} else if($item['status'] == 3) {
								echo '<a class="btn btn-success btn-lg" style="margin-top:-3px" onClick="update_order_status('.$item['od_id'].')" id="od_btn_'.$item['od_id'].'">Completed</a>';								
							}							
							?>
                            <?php } else {?>
                            <span class="complete-2"><i class="fa fa-check-square-o"></i> Order Complete</span>
                            <?php } ?>
                        </div>
                        <div class="clearfix"></div>
                        <?php foreach($item['options'] as $option) {
                        	echo '<p style="font-size:13px; line-height:12px">'.$option['option_name'].' - '.$option['sub_name'].'</p>';
                        } ?>
                        <?php if($item['add_note'] != "") { ?><p><code>Note: <?= $item['add_note'] ?></code></p><?php } ?>
                    </div>
                    <?php } ?>
                    <?php if($order['add_note'] != "") { ?><p class="lead" style="margin-bottom:10px">Note: <?= $order['add_note'] ?></p><?php } ?>
                    <?php if($order['allergies'] != "") { ?><p><code>Allergies: <?= $order['allergies'] ?></code></p><?php } ?>
                    <?php } else { $x = 1;/**** For cancelled Orders **/?>
                    <div class="col-md-12" style="font-size: 17px;font-weight: bold;color: #ff0000;margin-bottom: 15px;">
                    Order Cancelled
                    </div>
                    <?php foreach($order['ordered_items'] as $item) { ?>
                    <div class="col-md-4">
                        <h4 class="col-md-12 pad-left-0">
                        	<strong><?= $item['item_name'] ?></strong> 
                            <span style="font-size:13px; margin-left:10px;">x</span> <?= $item['quantity'] ?> 
                        </h4>

                        <?php foreach($item['options'] as $option) {
                        	echo '<p style="font-size:13px; line-height:12px">'.$option.'</p>';
                        } ?>
                        <?php if($item['add_note'] != "") { ?><p><code>Note: <?= $item['add_note'] ?></code></p><?php } ?>
                    </div>
					<?php if($x % 3 == 0) { echo '<div class="clearfix"></div>'; } ?>
                    <?php $x++; ?>
                    <?php } ?>
                    <?php } //echo "<pre>";print_r($interval);echo "</pre>"; ?>
					
                </div>
            </div>
        </section>
        <?php } ?>

    </div>
    
    <?php 
	
	// Pagination 
	$limit = 6;
	if($orderCount > $limit) { 
    
	$totalpages = ceil($orderCount/$limit);
	
	echo '<div class="col-md-12" id="">
        <div>
            <ul class="pagination pagination-sm" style="float:right">';
	
	for($i = 1; $i <= $totalpages; $i++)
	{
		$active_class = "";
		
		if((isset($_GET['page']) && $_GET['page'] == $i) || (!isset($_GET['page']) && $i == 1)) {
			$active_class = 'class="active"';
		}
		
    	echo '  <li '.$active_class.'>';
		
		echo '<a href="';
		if($active_class != "") {
			echo "#";
		} else {
			echo Yii::$app->urlManager->createUrl(['cook/orders', 'page' => $i]);
		}
		echo '">'.$i.'</a>';
		
		echo '</li>';
	}
	echo '  </ul>
        </div>
	</div>';
	
	} 
	?>
      
    <?php } ?>
    
</div>


<script>
function update_order_status(od_id)
{
	var status = $("#item_status_"+od_id).val();
	var new_status = parseInt(status) + 1;
	//alert(new_status);
	//return false;
	var _csrf = yii.getCsrfToken();
	$.ajax({
		url: '<?= Yii::$app->urlManager->createUrl('cook/uporderstatus') ?>',
		method: 'POST',
		data: 'od_id='+od_id+'&status='+new_status+'&_csrf='+_csrf,
		cache: false,
		dataType: 'json',
		success: function(data){
			//console.log(data);
			$("#item_status_"+od_id).val(new_status);
			
			var o_id = parseInt(data.o_id);
			var o_status = parseInt(data.o_status);
			var od_status = parseInt(data.od_status);
			//alert(o_status)
			
			if(od_status == 4)
			{
				$("#status_block_"+od_id).html('<span class="complete-2"><i class="fa fa-check-square-o"></i> Order Complete</span>');
			}
			else if(od_status == 3)
			{
				//$("#status_block_"+od_id).html('<span class="complete-1"><i class="fa fa-check-square-o"></i> Ready to collect</span>');
				$("#od_btn_"+od_id).removeClass("btn-orange");
				$("#od_btn_"+od_id).addClass("btn-success");
				$("#od_btn_"+od_id).html("Completed");
			}
			else if(od_status == 2)
			{
				$("#od_btn_"+od_id).removeClass("btn-danger");
				$("#od_btn_"+od_id).addClass("btn-orange");
				$("#od_btn_"+od_id).html("Ready to collect");
			}
			
			if(o_status == 4)
			{
				$("#order_panel_"+o_id).removeClass("panel-success");
				$("#order_panel_"+o_id).addClass("panel-info");
			}
			else if(o_status == 3)
			{
				$("#order_panel_"+o_id).removeClass("panel-danger");
				$("#order_panel_"+o_id).removeClass("panel-orange");
				$("#order_panel_"+o_id).addClass("panel-success");
			}
			else if(o_status == 2)
			{
				$("#order_panel_"+o_id).removeClass("panel-danger");
				$("#order_panel_"+o_id).addClass("panel-orange");
			}
			/*else if(o_status == 1)
			{
				$("#order_panel_"+o_id).removeClass("panel-orange");
				$("#order_panel_"+o_id).addClass("panel-danger");
			}*/
			
		},
		error: function(){
			//alert("Something went wrong, Please try again");
		}		
	});
}

function reqWater(tbl_n, str_id)
{
	var tbl_n = parseInt(tbl_n);
	var str_id = parseInt(str_id);
	var _csrf = yii.getCsrfToken();
	$.ajax({
		url: '<?= Yii::$app->urlManager->createUrl('cook/req-water-del') ?>',
		method: 'POST',
		data: 'tbl_n='+tbl_n+'&str_id='+str_id+'&_csrf='+_csrf,
		cache: false,
		success: function(data){
			if(data == 1) {
				$("#req_water_"+tbl_n).remove();
			} else {
				alert("Something went wrong, Please try again");
			}
		},
		error: function(){
			alert("Something went wrong, Please try again");
		}		
	});
}
/*
setTimeout(function() {
	window.location.reload(true); 
}, 15000);*/
</script>