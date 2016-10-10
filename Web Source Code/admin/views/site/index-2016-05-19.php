<?php

/* @var $this yii\web\View */

$this->title = 'Welcome to Wopadu';
$this->params['breadcrumbs'][] = $this->title;

$session = Yii::$app->session;
?>

<?php if($session['login_role'] == 2) { $stores_list = $session['stores_list']; ?>
                
<?php 
$store_bar_array = [];

$today_month = date("m");
$today_year = date("Y");

$prev_year = $today_year - 1;
if($today_month == 1) {
	$prev_month = 12;
} else {
	$prev_month = $today_month - 1;
	$prev_month = sprintf("%02d", $prev_month);
	//echo $num_padded; // returns 04
}
$prev_date_for_check = $prev_year."-".$prev_month."-"."01 00:00:00";

foreach($stores_list as $key=>$value) 
{	
	/************* Graph 1 ******************/
	//$countAccount = Yii::$app->db->createCommand("SELECT DATE_FORMAT(`n_datetime`, '%Y-%m')as month,SUM(`total_amount`) AS total_sale FROM `orders` WHERE store_id = $key AND `n_datetime` >= '$prev_date_for_check' AND `status` = 4 GROUP BY DATE_FORMAT(`n_datetime`, '%Y-%m') ")->queryAll();

	$countAccount = Yii::$app->db->createCommand("SELECT DATE_FORMAT(`n_datetime`, '%Y-%m')as month,SUM(`total_amount`) AS total_sale FROM `orders` WHERE store_id = $key AND `status` = 4 GROUP BY DATE_FORMAT(`n_datetime`, '%Y-%m') ")->queryAll();

/*
echo "<pre>";
print_r($countAccount);
echo "</pre>";
exit;*/

	$month_array = [];
	foreach($countAccount as $month)
	{
		$month_array[] = $month['month'];
	}
	
	asort($month_array);
	
	$count_month = count($month_array);
	
	$array = [];
	foreach($countAccount as $month)
	{
		$array[$month['month']] = $month['total_sale'];
	}
	
	$store_bar_array[$key] = [];
	
	if(!empty($month_array))
	{
		$start_key = $month_array[0];
		
		$ex_start_key = explode("-", $start_key);
		$start_month = $ex_start_key[1];
		$start_year = $ex_start_key[0];
			
		$end_key = $month_array[$count_month-1];
		
		$ex_end_key = explode("-", $end_key);
		$end_month = $ex_end_key[1];
		$end_year = $ex_end_key[0];		
		
		$date1  = $start_year.'-'.$start_month.'-15';
		$date2  = $end_year.'-'.$end_month.'-15';
		$bar_month_array = [];
		$time   = strtotime($date1);
		$last   = date('Y-m', strtotime($date2));
		
		do {
			$month = date('Y-m', $time);
			$total = date('t', $time);
			$bar_month_array[] = $month;
		
			$time = strtotime('+1 month', $time);
		} while ($month != $last);
		
		$bar_total_array = [];
		foreach($bar_month_array as $i)
		{
			if(isset($array[$i])) {
				$bar_total_array[] = $array[$i];
			} else {
				$bar_total_array[] = 0;
			}
		}
		
		$store_bar_array[$key] = ['bar_month_array' => $bar_month_array, 'bar_total_array' => $bar_total_array];
	}
	
	/************* Graph 2 and 3 ******************/
	
	
	$categorise_4_store_all = Yii::$app->db->createCommand("SELECT id, parent_id, category_name FROM `categories` WHERE store_id = $key ORDER BY id ASC")->queryAll();
	
	$new_cat_array = [];
	
	foreach($categorise_4_store_all as $c4sa)
	{
		$new_cat_array[$c4sa['id']] = $c4sa;
	}
	
	foreach($categorise_4_store_all as $c4sa)
	{
		if($c4sa['parent_id'] != 0)
		{
			unset($new_cat_array[$c4sa['parent_id']]);
		}
	}
	
	//echo "<pre>";
	//print_r($categorise_4_store_all);
	//print_r($new_cat_array);
	//echo "</pre>";
	//exit;*/

	//$graph_details = Yii::$app->db->createCommand("SELECT SUM(OD.final_amount) as total_sale, I.category_id, C.category_name FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id INNER JOIN items AS I ON OD.item_id = I.id INNER JOIN categories AS C ON C.id = I.category_id WHERE O.store_id = $key AND O.n_datetime >= '$prev_date_for_check' AND OD.status = 4 GROUP BY I.category_id")->queryAll();
	
	//$order_details = Yii::$app->db->createCommand("SELECT SUM(OD.final_amount) as total_sale, I.category_id FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id INNER JOIN items AS I ON OD.item_id = I.id WHERE O.store_id = $key AND O.n_datetime >= '$prev_date_for_check' AND OD.status = 4 GROUP BY I.category_id")->queryAll();
	
	$today_date = date("Y-m-d");
	
	$order_details = Yii::$app->db->createCommand("SELECT SUM(OD.final_amount) as total_sale, I.category_id FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id INNER JOIN items AS I ON OD.item_id = I.id WHERE O.store_id = $key AND DATE(O.n_datetime) = '$today_date' AND OD.status = 4 GROUP BY I.category_id")->queryAll();
	
	$graph_details = [];
	
	foreach($order_details as $od)
	{
		$graph_details[$od['category_id']] = $od;
	}
	
	/*echo "<pre>";
	print_r($graph_details);
	echo "</pre>";*/
	
	$final_array = [];
	
	$zero_sale_flag = TRUE;
	
	foreach($new_cat_array as $nca)
	{
		//echo "<pre>";
		//print_r($nca);
		//print_r($store_bar_array_2);
		//echo "</pre>";	
		
		if(isset($graph_details[$nca['id']]))
		{
			$zero_sale_flag = FALSE;
			$nca['total_sale'] = $graph_details[$nca['id']]['total_sale'];
			$nca['category_id'] = $graph_details[$nca['id']]['category_id'];
		}
		else
		{
			$nca['total_sale'] = 0;
			$nca['category_id'] = $nca['id'];
		}
		$final_array[] = $nca;
	}
	//exit;
	$cat_array  = [];
	$total_sell_array = [];
	
	foreach($final_array as $gd)
	{
		$cat_array[] = $gd['category_name'];
		$total_sell_array[] = $gd['total_sale'];
	}
	
	$store_bar_array_2[$key] = [];
	if($zero_sale_flag == TRUE)
	{
		$store_bar_array_2[$key] = [];
	}
	else
	{
		$store_bar_array_2[$key] = ['category_array' => $cat_array, 'total_sell_array' => $total_sell_array];
	}
	//$store_pie_array[$key] = ['category_array' => $cat_array, 'total_sell_array' => $total_sell_array];
}

/*echo "<pre>";
//print_r($store_bar_array);
print_r($store_bar_array_2);
echo "</pre>";
exit;*/
} 
?>
<div class="site-index">
    <div class="wrapper">
        <div class="row">
            <div class="col-md-12">
                
                
    			<?php if($session['login_role'] == 1) { ?>
                <h4>Hello, <?= $session['login_email'] ?></h4><br />
                <div class="row state-overview" style="color:#607D8B">
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-tasks"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM accounts")->queryScalar(); ?></div>
                                <div class="title">Total Accounts</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-tags"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM stores")->queryScalar(); ?></div>
                                <div class="title">Total Stores</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-user"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM users")->queryScalar(); ?></div>
                                <div class="title">Registered Users</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-star-half-o"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM app_rating")->queryScalar(); ?></div>
                                <div class="title">Total Reviews</div>
                            </div>
                        </div>
                    </div>
                </div>
				<?php } else if($session['login_role'] == 2) { ?>
				
                <?php /*?><section class="panel">
                    <div class="panel-body">
                    	<h4>Hello, <?= $session['account_name'] ?></h4><small><?= $session['login_email'] ?></small>
                    </div>
                </section><?php */?>
                    
				<?php $stores_list = $session['stores_list']; ?>
                                
                <?php foreach($stores_list as $key=>$value) { ?>
                
                <h4><?= $value ?></h4>
                
                <!--- Chart 2 -->
                <div class="row">
                    <div class="col-sm-12">
                        <section class="panel">
                            <header class="panel-heading">
                                Pie Chart
                            </header>
                            <div class="panel-body">
                            	<?php if($store_bar_array[$key]) { ?>
                                <form class="form-inline" role="form" style="margin-bottom:20px;">
                                    <div class="form-group">
                                        <label class="sr-only" for="">Select Type</label>
                                        <select class="form-control" name="criteria_1_<?= $key ?>" id="criteria_1_<?= $key ?>" onChange="sel_crt_1(this.value, <?= $key ?>)">
                                            <option value="1">All Months</option>
                                            <option value="2">One Month</option>
                                            <option value="3">One Day</option>
                                        </select>
                                    </div>
                                    <div class="form-group" id="month_display_m_<?= $key ?>"  style="display:none">
                                        <label class="sr-only" for="">Select Month</label>
                                        <select class="form-control" name="criteria_2_<?= $key ?>" id="criteria_2_<?= $key ?>">
                                            <option value="">Select Month</option>
											<?php
											foreach($store_bar_array[$key]['bar_month_array'] as $mm) {
											$ex_mm = explode("-", $mm);
											echo '<option value="'.$mm.'">'.date('F', mktime(0, 0, 0, $ex_mm[1], 10)).', '.$ex_mm[0].'</option>';
											}
											?>
                                        </select>
                                    </div>
                                    <div class="form-group" id="month_display_d_<?= $key ?>"  style="display:none">
                                        <label class="sr-only" for="">Select Month</label>
                                        <select class="form-control" name="criteria_3_<?= $key ?>" id="criteria_3_<?= $key ?>" onChange="sel_crt_2(this.value, <?= $key ?>)">
                                        	<option value="">Select Month</option>
                                            <?php
											foreach($store_bar_array[$key]['bar_month_array'] as $mm) {
											$ex_mm = explode("-", $mm);
											echo '<option value="'.$mm.'">'.date('F', mktime(0, 0, 0, $ex_mm[1], 10)).', '.$ex_mm[0].'</option>';
											}
											?>
                                        </select>
                                    </div>
                                    <div class="form-group" id="day_display_<?= $key ?>" style="display:none">
                                        <label class="sr-only" for="">Select Day</label>
                                        <select class="form-control" name="criteria_4_<?= $key ?>" id="criteria_4_<?= $key ?>">
                                        </select>
                                    </div>
                                    
                                    <?php /*?><button type="submit" class="btn btn-primary">Generate</button><?php */?>
                                    <a class="btn btn-primary" onClick="generate_graph_1(<?= $key ?>)">Generate</a>
                                </form>
                                
                                <div class="col-md-6">
                               		<div id="chartContainer_2-<?= $key ?>" style="height: 300px; width: 100%;"></div>
                                </div>
                                <div class="col-md-6">
                               		<div id="pieChartContainer-<?= $key ?>" style="height: 300px; width: 100%;"></div>
                                </div>
                                
								<?php } else { ?>
                                No orders
                                <?php } ?>
                            </div>
                        </section>
                    </div>
                </div>
                
                <!--- Chart 1 -->
                <div class="row">
                    <div class="col-sm-12">
                        <section class="panel">
                            <header class="panel-heading">
                                Chart
                            </header>
                            <div class="panel-body">
                            	<?php if($store_bar_array[$key]) { ?>
                                <form class="form-inline" role="form" style="margin-bottom:20px;">
                                    <div class="form-group">
                                        <label class="sr-only" for="">Select Type</label>
                                        <select class="form-control" name="a_criteria_1_<?= $key ?>" id="a_criteria_1_<?= $key ?>" onChange="a_sel_crt_1(this.value, <?= $key ?>)">
                                            <option value="1">All Months</option>
                                            <option value="2">One Month</option>
                                            <option value="3">One Day</option>
                                        </select>
                                    </div>
                                    <div class="form-group" id="a_month_display_m_<?= $key ?>"  style="display:none">
                                        <label class="sr-only" for="">Select Month</label>
                                        <select class="form-control" name="a_criteria_2_<?= $key ?>" id="a_criteria_2_<?= $key ?>">
                                            <option value="">Select Month</option>
											<?php
											foreach($store_bar_array[$key]['bar_month_array'] as $mm) {
											$ex_mm = explode("-", $mm);
											echo '<option value="'.$mm.'">'.date('F', mktime(0, 0, 0, $ex_mm[1], 10)).', '.$ex_mm[0].'</option>';
											}
											?>
                                        </select>
                                    </div>
                                    <div class="form-group" id="a_month_display_d_<?= $key ?>"  style="display:none">
                                        <label class="sr-only" for="">Select Month</label>
                                        <select class="form-control" name="a_criteria_3_<?= $key ?>" id="a_criteria_3_<?= $key ?>" onChange="a_sel_crt_2(this.value, <?= $key ?>)">
                                        	<option value="">Select Month</option>
                                            <?php
											foreach($store_bar_array[$key]['bar_month_array'] as $mm) {
											$ex_mm = explode("-", $mm);
											echo '<option value="'.$mm.'">'.date('F', mktime(0, 0, 0, $ex_mm[1], 10)).', '.$ex_mm[0].'</option>'; }
											?>
                                        </select>
                                    </div>
                                    <div class="form-group" id="a_day_display_<?= $key ?>" style="display:none">
                                        <label class="sr-only" for="">Select Day</label>
                                        <select class="form-control" name="a_criteria_4_<?= $key ?>" id="a_criteria_4_<?= $key ?>">
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="sr-only" for="">Select Type</label>
                                        <select class="form-control" name="a_criteria_5_<?= $key ?>" id="a_criteria_5_<?= $key ?>" onChange="a_sel_crt_5(this.value, <?= $key ?>)">
                                            <option value="1">All</option>
                                            <option value="2">One Category</option>
                                            <option value="3">One Product</option>
                                        </select>
                                    </div>
                                    <div class="form-group" id="a_cat_display_<?= $key ?>">
                                        
                                    </div>
                                    <div class="form-group" id="a_item_display_<?= $key ?>">
                                        
                                    </div>
                                    <?php /*?><button type="submit" class="btn btn-primary">Generate</button><?php */?>
                                    <a class="btn btn-primary" onClick="a_generate_graph_1(<?= $key ?>)">Generate</a>
                                </form>
                                
                                <div id="chartContainer-<?= $key ?>" style="height: 300px; width: 100%;"></div>
                                
								<?php } else { ?>
                                No orders
                                <?php } ?>
                            </div>
                        </section>
                    </div>
                </div>
                
                <!--- Details Blocks --->
                <div class="row state-overview" style="color:#607D8B">
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-cutlery"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(I.id) FROM `items` as I INNER JOIN categories as C ON I.category_id = C.id AND C.store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Products</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-shopping-cart"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM orders  WHERE store_id = $key and payment_status = 1")->queryScalar(); ?></div>
                                <div class="title">Total Orders</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-sitemap"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM kitchens WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Kitchens</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-mobile"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM waiter WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Waiters</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <?php } ?>
                
				<?php if(!$stores_list) { ?>
                <section class="panel">
                    <div class="panel-body"><h4 style="display:inline-block">No Store exists. Please add new store. </h4>
                    <a href="<?php echo Yii::$app->urlManager->createUrl("stores/create"); ?>" class="btn btn-md- btn-green-sea" style="float:right">Add Store</a>
                    </div>
                </section>
                <?php } ?>
                
				<?php /*?><?php foreach($stores_list as $key=>$value) { ?>
                <h4><?= $value ?></h4>
                <div class="row state-overview">
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel purple">
                            <div class="symbol">
                                <i class="fa fa-tasks"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(I.id) FROM `items` as I INNER JOIN categories as C ON I.category_id = C.id AND C.store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Products</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel red">
                            <div class="symbol">
                                <i class="fa fa-tags"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM orders  WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Orders</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel blue">
                            <div class="symbol">
                                <i class="fa fa-user"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM kitchens WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Kitchens</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel green">
                            <div class="symbol">
                                <i class="fa fa-star-half-o"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM waiter WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Waiters</div>
                            </div>
                        </div>
                    </div>
                </div>
                <?php } ?><?php */?>
                
				<?php /*?><?php foreach($stores_list as $key=>$value) { ?>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title"><?= $value ?></h3>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3">
                                <h4><i class="fa fa-cutlery"></i> Total Products: 123</h4>
                            </div>
                            <div class="col-md-3">
                                <h4><i class="fa fa-shopping-cart"></i> Total Orders: 123</h4>
                            </div>
                            <div class="col-md-3">
                                <h4><i class="fa fa-sitemap"></i> Total Kitchens: 123</h4>
                            </div>
                            <div class="col-md-3">
                                <h4><i class="fa fa-mobile"></i> Total Waiters: 123</h4>
                            </div>
                        </div>
                    </div>
                </div>
                <?php } ?><?php */?>
                
                
                <?php } else if($session['login_role'] == 3) { ?>
                <h4>Hello, <?= $session['login_email'] ?></h4><br />
                <div class="row state-overview" style="color:#607D8B">
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-cutlery"></i>
                            </div>
                            <div class="state-value">
                                <?php /*?><div class="value"><?= $totalPendingOrders = Yii::$app->db->createCommand("SELECT COUNT(DISTINCT order_id) FROM `order_details` WHERE kitchen_id = ".$session['kitchen_id']." and status < 4")->queryScalar(); ?></div><?php */?>
                                <div class="value"><?= $totalPendingOrders = Yii::$app->db->createCommand("SELECT COUNT(DISTINCT order_id) FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id WHERE OD.kitchen_id = ".$session['kitchen_id']." and OD.status < 4 and O.payment_status = 1")->queryScalar(); ?></div>
                                <div class="title">Pending Orders</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-user"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><a href="<?= Yii::$app->urlManager->createUrl('cook/index') ?>" style="text-decoration:initial; color:#607D8B">View</a></div>
                                <div class="title"><a href="<?= Yii::$app->urlManager->createUrl('cook/index') ?>" style="text-decoration:initial; color:#607D8B">My Account</a></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-tags"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><a href="<?= Yii::$app->urlManager->createUrl('cook/orders') ?>" style="text-decoration:initial; color:#607D8B">View</a></div>
                                <div class="title"><a href="<?= Yii::$app->urlManager->createUrl('cook/orders') ?>" style="text-decoration:initial; color:#607D8B">Orders</a></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-caret-square-o-right"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><a href="<?= Yii::$app->urlManager->createUrl('cook/resto-screen') ?>" style="text-decoration:initial; color:#607D8B">View</a></div>
                                <div class="title"><a href="<?= Yii::$app->urlManager->createUrl('cook/resto-screen') ?>" style="text-decoration:initial; color:#607D8B">Resto Screen</a></div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                
				<?php } else { ?>
                <div class="jumbotron">
                    <h1>Welcome!</h1>
                    <h3><?= $session['email'] ?></h3>
					<?php
                    /*echo "<pre>";
                    if(Yii::$app->user->isGuest)
                    {
                        echo "Guest User";
                    }
                    else
                    {
                        echo "Super Admin: ".$session['super_admin'];
                        echo "<br />";
                        echo "Login Id: ".$session['login_id'];
                        echo "<br />";
                        echo "Role: ".$session['login_role'];
                        echo "<br />";
                        echo "Email: " .$session['login_email'];
                        
                        if($session['login_role'] == 2)
                        {
                            echo "<br />";
                            echo "Account Id: ".$session['account_id'];
                            echo "<br />";
                            echo "Account Name: " .$session['account_name'];
                            echo "<br />";
                            echo "Allowed Stores: " .$session['allowed_stores'];
                            echo "<br />";
                            echo "Stores List: <br />";
                            print_r($session['stores_list']);
                        }
                    }
                    echo "</pre>";*/
                    ?>
                </div>
                
                <?php } ?>
    
    		</div>
        </div>
    </div>
</div>

<?php if($session['login_role'] == 2 && !empty($store_bar_array)) { ?>
<script src="../js/jquery-1.10.2.min.js"></script>
<script src="../js/canvasjs.min.js"></script>

<script type="text/javascript">

function a_sel_crt_1(a, b)
{
	//alert(a + b);
	if(a == 1)
	{
		$("#a_month_display_m_"+b).css("display", "none");
		$("#a_month_display_d_"+b).css("display", "none");
		$("#a_day_display_"+b).css("display", "none");
	}
	else if(a == 2)
	{
		$("#a_month_display_d_"+b).css("display", "none");
		$("#a_day_display_"+b).css("display", "none");
		$("#a_month_display_m_"+b).css("display", "inline-block");
	}
	else if(a == 3)
	{
		$("#a_month_display_m_"+b).css("display", "none");
		$("#a_day_display_"+b).css("display", "none");
		$("#a_month_display_d_"+b).css("display", "inline-block");
		//$("#month_display_d_"+b).val();
		document.getElementById("a_criteria_3_"+b).value = "";
		//alert(document.getElementById("criteria_3_"+b).value);
	}
}

function a_sel_crt_2(a, b)
{
	var split_str = a.split("-");
	var year = parseInt(split_str[0]);
	var month = parseInt(split_str[1]);
	var days = getDaysInMonth(month, year);
	
	$("#a_day_display_"+b).css("display", "inline-block");
	
	//var ii = 0;
	var html_data = '<option value="">Select Day</option>';
	for(ii=1; ii<= days; ii++) {
		html_data += '<option value="'+ii+'">'+ii+'</option>';
	}
	$("#a_criteria_4_"+b).html(html_data);
	//console.log(days);
}

function a_sel_crt_5(a, b)
{
	if(a == 1)
	{
		//$("#cat_display_c_"+b).css("display", "none");
		//$("#cat_display_p_"+b).css("display", "none");
		$("#a_cat_display_"+b).css("display", "none");
		$("#a_item_display_"+b).css("display", "none");
	}
	else if(a == 2)
	{
		//$("#cat_display_p_"+b).css("display", "none");
		$("#a_item_display_"+b).css("display", "none");
		//$("#cat_display_c_"+b).css("display", "inline-block");
		$("#a_cat_display_"+b).css("display", "inline-block");
		a_getCatList(a, b);
	}
	else if(a == 3)
	{
		//$("#cat_display_c_"+b).css("display", "none");
		$("#a_item_display_"+b).css("display", "none");
		//$("#cat_display_p_"+b).css("display", "inline-block");
		$("#a_cat_display_"+b).css("display", "inline-block");
		a_getCatList(a, b);
	}
}

function a_sel_crt_6(a, b)
{
	var _csrf = yii.getCsrfToken();
	$.ajax({
		url: '<?= Yii::$app->urlManager->createUrl('site/get-item-list') ?>',
		method: 'POST',
		data: 'a='+a+'&b='+b+'&_csrf='+_csrf,
		cache: false,
		success: function(data){
			$("#a_item_display_"+b).css("display", "inline-block");
			$("#a_item_display_"+b).html(data);
		},
		error: function(){
			$("#a_item_display_"+b).css("display", "inline-block");
			$("#a_item_display_"+b).html('<span style="color:#C0392B">Something went wrong, Please try again.</span>');
		}		
	});
}

function a_getCatList(a, b)
{
	//console.log(a+' ' + b);
	var _csrf = yii.getCsrfToken();
	$.ajax({
		url: '<?= Yii::$app->urlManager->createUrl('site/get-cat-list') ?>',
		method: 'POST',
		data: 'a='+a+'&b='+b+'&_csrf='+_csrf,
		cache: false,
		success: function(data){
			$("#a_cat_display_"+b).html(data);
		},
		error: function(){
			$("#a_cat_display_"+b).html('<span style="color:#C0392B">Something went wrong, Please try again.</span>');
		}		
	});
}

function a_generate_graph_1(b)
{
	var crt_1 = $("#a_criteria_1_"+b).val();
	var crt_2 = $("#a_criteria_2_"+b).val();
	var crt_3 = $("#a_criteria_3_"+b).val();
	var crt_4 = $("#a_criteria_4_"+b).val();
	var crt_5 = $("#a_criteria_5_"+b).val();
	var crt_6 = $("#a_criteria_6_"+b).val();
	var crt_7 = $("#a_criteria_7_"+b).val();
	
	//console.log('crt_1: '+crt_1+', crt_2: '+crt_2+', crt_3: '+crt_3+', crt_4: '+crt_4+', crt_5: '+crt_5+', crt_6: '+crt_6+', crt_7: '+crt_7);
	
	var _csrf = yii.getCsrfToken();
	$.ajax({
		url: '<?= Yii::$app->urlManager->createUrl('site/gen-graph') ?>',
		method: 'GET',
		data: 'b='+b+'&crt_1='+crt_1+'&crt_2='+crt_2+'&crt_3='+crt_3+'&crt_4='+crt_4+'&crt_5='+crt_5+'&crt_6='+crt_6+'&crt_7='+crt_7+'&_csrf='+_csrf,
		cache: false,
		success: function(data){
			if(data.charAt(0) == "0")
			{
				$("#chartContainer-"+b).html('<span style="color:#C0392B;font-size: 16px;">'+data.substring(2)+'</span>');
			}
			else
			{
				generate_graph_2(b, crt_1, data)
			}
		},
		error: function(){
			$("#chartContainer-"+b).html('<span style="color:#C0392B;font-size: 16px;">Something went wrong, Please try again.</span>');
		}		
	});
}

<!--  Repeat functions -->

function sel_crt_1(a, b)
{
	//alert(a + b);
	if(a == 1)
	{
		$("#month_display_m_"+b).css("display", "none");
		$("#month_display_d_"+b).css("display", "none");
		$("#day_display_"+b).css("display", "none");
	}
	else if(a == 2)
	{
		$("#month_display_d_"+b).css("display", "none");
		$("#day_display_"+b).css("display", "none");
		$("#month_display_m_"+b).css("display", "inline-block");
	}
	else if(a == 3)
	{
		$("#month_display_m_"+b).css("display", "none");
		$("#day_display_"+b).css("display", "none");
		$("#month_display_d_"+b).css("display", "inline-block");
		//$("#month_display_d_"+b).val();
		document.getElementById("criteria_3_"+b).value = "";
		//alert(document.getElementById("criteria_3_"+b).value);
	}
}

function sel_crt_2(a, b)
{
	var split_str = a.split("-");
	var year = parseInt(split_str[0]);
	var month = parseInt(split_str[1]);
	var days = getDaysInMonth(month, year);
	
	$("#day_display_"+b).css("display", "inline-block");
	
	//var ii = 0;
	var html_data = '<option value="">Select Day</option>';
	for(ii=1; ii<= days; ii++) {
		html_data += '<option value="'+ii+'">'+ii+'</option>';
	}
	$("#criteria_4_"+b).html(html_data);
	//console.log(days);
}

function getDaysInMonth(month, year) {
	 //console.log(year+' '+ month);
	 month = month - 1;
     var date = new Date(year, month, 1);
     var days = [];
     while (date.getMonth() === month) {
        days.push(new Date(date));
        date.setDate(date.getDate() + 1);
     }
	 //console.log(days);
     return days.length;
}

window.onload = function () {
<?php $stores_list = $session['stores_list']; ?>
<?php foreach($stores_list as $key=>$value) { if($store_bar_array[$key]) {  ?>
var chart<?= $key ?> = new CanvasJS.Chart("chartContainer-<?= $key ?>",
{
  title:{
	text: ""    
  },
  animationEnabled: true,
  axisY: {
	title: "Total Sell"
  },
  legend: {
	verticalAlign: "bottom",
	horizontalAlign: "center"
  },
  theme: "theme2",
  data: [

  {        
	type: "column",
	showInLegend: true, 
	legendMarkerColor: "grey",
	legendText: "Months",
	/*dataPoints: [      
	{y: 297571, label: "Venezuela"},
	{y: 267017,  label: "Saudi" },
	{y: 175200,  label: "Canada"},
	{y: 154580,  label: "Iran"},
	{y: 116000,  label: "Russia"},
	{y: 97800, label: "UAE"},
	{y: 20682,  label: "US"},        
	{y: 20350,  label: "China"}        
	]*/
	dataPoints: [
	<?php $kk = 0; foreach($store_bar_array[$key]['bar_month_array'] as $mm)	{ ?>
	{y: <?= $store_bar_array[$key]['bar_total_array'][$kk] ?>, label: "<?= $mm ?>"},
	<?php $kk++; } ?>
	]
  }
  ]
});
chart<?= $key ?>.render();

<?php if(!empty($store_bar_array_2[$key])) { ?>

var barChart_2<?= $key ?> = new CanvasJS.Chart("chartContainer_2-<?= $key ?>",
{
	theme: "theme2",
	title:{
		text: "Todays Orders"
	},
	data: [
		{
			/*dataPoints: [
				{ x: 10, y: 297571, label: "Venezuela"},
				{ x: 20, y: 267017,  label: "Saudi" },
				{ x: 30, y: 175200,  label: "Canada"},
				{ x: 40, y: 154580,  label: "Iran"},
				{ x: 50, y: 116000,  label: "Russia"},
				{ x: 60, y: 97800, label: "UAE"},
				{ x: 70, y: 20682,  label: "US"},
				{ x: 80, y: 20350,  label: "China"}
			]*/
			dataPoints: [
			<?php $kk = 0; foreach($store_bar_array_2[$key]['category_array'] as $mm)	{ ?>
			{y: <?= $store_bar_array_2[$key]['total_sell_array'][$kk] ?>, label: "<?= $mm ?>"},
			<?php $kk++; } ?>
			]
		}
	]
});
barChart_2<?= $key ?>.render();

var pieChart<?= $key ?> = new CanvasJS.Chart("pieChartContainer-<?= $key ?>",
{
	theme: "theme2",
	title:{
		text: "Todays Orders"
	},		
	data: [
	{       
		type: "pie",
		showInLegend: true,
		//toolTipContent: "{y} - #percent %",
		toolTipContent: "#percent %",
		yValueFormatString: "#0.#,,. Million",
		legendText: "{indexLabel}",
		/*dataPoints: [
			{  y: 4181563, indexLabel: "PlayStation 3" },
			{  y: 2175498, indexLabel: "Wii" },
			{  y: 3125844, indexLabel: "Xbox 360" },
			{  y: 1176121, indexLabel: "Nintendo DS"},
			{  y: 1727161, indexLabel: "PSP" },
			{  y: 4303364, indexLabel: "Nintendo 3DS"},
			{  y: 1717786, indexLabel: "PS Vita"}
		]*/
		dataPoints: [
		<?php $kk = 0; foreach($store_bar_array_2[$key]['category_array'] as $mm)	{ ?>
		{y: <?= $store_bar_array_2[$key]['total_sell_array'][$kk] ?>, label: "<?= $mm ?>"},
		<?php $kk++; } ?>
		]
	}
	]
});

pieChart<?= $key ?>.render();

<?php } else {  ?>
$("#chartContainer_2-<?= $key ?>").html('<span style="color:#C0392B;font-size: 16px;">No orders found for today.</span>');
<?php } ?>

<?php } } ?>
}

//function generate_graph(b)
function generate_graph_1(b)
{
	var crt_1 = $("#criteria_1_"+b).val();
	var crt_2 = $("#criteria_2_"+b).val();
	var crt_3 = $("#criteria_3_"+b).val();
	var crt_4 = $("#criteria_4_"+b).val();
	//var crt_5 = $("#criteria_5_"+b).val();
	//var crt_6 = $("#criteria_6_"+b).val();
	//var crt_7 = $("#criteria_7_"+b).val();
	
	//console.log('crt_1: '+crt_1+', crt_2: '+crt_2+', crt_3: '+crt_3+', crt_4: '+crt_4+', crt_5: '+crt_5+', crt_6: '+crt_6+', crt_7: '+crt_7);
	
	var _csrf = yii.getCsrfToken();
	$.ajax({
		url: '<?= Yii::$app->urlManager->createUrl('site/gen-graph-2') ?>',
		method: 'GET',
		//data: 'b='+b+'&crt_1='+crt_1+'&crt_2='+crt_2+'&crt_3='+crt_3+'&crt_4='+crt_4+'&crt_5='+crt_5+'&crt_6='+crt_6+'&crt_7='+crt_7+'&_csrf='+_csrf,
		data: 'b='+b+'&crt_1='+crt_1+'&crt_2='+crt_2+'&crt_3='+crt_3+'&crt_4='+crt_4+'&_csrf='+_csrf,
		cache: false,
		success: function(data){
			if(data.charAt(0) == "0")
			{
				$("#chartContainer_2-"+b).html('<span style="color:#C0392B;font-size: 16px;">'+data.substring(2)+'</span>');
				$("#pieChartContainer-"+b).html('');
			}
			else
			{
				generate_graph_3(b, crt_1, data);
				generate_pie_chart(b, crt_1, data);
			}
		},
		error: function(){
			$("#chartContainer_2-"+b).html('<span style="color:#C0392B;font-size: 16px;">Something went wrong, Please try again.</span>');
			$("#pieChartContainer-"+b).html('');
		}		
	});
}

function generate_graph_2(b, crt_1, data_var)
{
	//alert(data_var);
	//console.log(data_var);
	
	if(crt_1 == 1){
		var subttl = "Months";
	} else if(crt_1 == 2) {
		var subttl = "Days";
	} else if(crt_1 == 3) {
		var subttl = "Hours";
	}
	
	var chart = new CanvasJS.Chart("chartContainer-"+b,
	{
	  title:{
		text: ""    
	  },
	  animationEnabled: true,
	  axisY: {
		title: "Total Sell"
	  },
	  legend: {
		verticalAlign: "bottom",
		horizontalAlign: "center"
	  },
	  theme: "theme2",
	  data: [
	
	  {        
		type: "column",  
		showInLegend: true, 
		legendMarkerColor: "grey",
		legendText: subttl,
		/*dataPoints: [      
		{y: 297571, label: "Venezuela"},
		{y: 267017,  label: "Saudi" },
		{y: 175200,  label: "Canada"},
		{y: 154580,  label: "Iran"},
		{y: 116000,  label: "Russia"},
		{y: 97800, label: "UAE"},
		{y: 20682,  label: "US"},        
		{y: 20350,  label: "China"}        
		]*/
		dataPoints: eval(data_var)
		<?php /*?>dataPoints: [
		<?php $kk = 0; foreach($store_bar_array[$key]['bar_month_array'] as $mm)	{ ?>
		{y: <?= $store_bar_array[$key]['bar_total_array'][$kk] ?>, label: "<?= $mm ?>"},
		<?php $kk++; } ?>
		]<?php */?>
	  }
	  ]
	});

	chart.render();
}

function generate_graph_3(b, crt_1, data_var)
{
	//alert(b);
	//console.log(data_var);
	
	if(crt_1 == 1){
		var subttl = "Categories";
	} else if(crt_1 == 2) {
		var subttl = "Categories";
	} else if(crt_1 == 3) {
		var subttl = "Categories";
	}
	
	var chart = new CanvasJS.Chart("chartContainer_2-"+b,
	{
	  title:{
		text: ""    
	  },
	  animationEnabled: true,
	  axisY: {
		title: "Total Sell"
	  },
	  legend: {
		verticalAlign: "bottom",
		horizontalAlign: "center"
	  },
	  theme: "theme2",
	  data: [
	
	  {        
		type: "column",  
		showInLegend: true, 
		legendMarkerColor: "grey",
		legendText: subttl,
		dataPoints: eval(data_var)
	  }
	  ]
	});

	chart.render();
}

function generate_pie_chart(b, crt_1, data_var)
{
	//alert(b);
	var pieChart = new CanvasJS.Chart("pieChartContainer-"+b,
	{
		theme: "theme2",
		title:{
			text: ""
		},		
		data: [
		{       
			type: "pie",
			showInLegend: true,
			toolTipContent: "#percent %",
			yValueFormatString: "#0.#,,. Million",
			legendText: "{indexLabel}",
			dataPoints: eval(data_var)
		}
		]
	});
	pieChart.render();
}
</script>
<?php } ?>