<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\Categories */

$this->title = 'Edit Discount: '.$item['name'];
//$this->params['breadcrumbs'][] = ['label' => 'Categories', 'url' => ['list', 's'=>$item['store_id']]];
if($item['type'] == 1) {
	$this->params['breadcrumbs'][] = ['label' => 'Categories', 'url' => ['list', 's'=>$item['store_id']]];
} else if($item['type'] == 2) {
	$this->params['breadcrumbs'][] = ['label' => 'Category: '.$item['category_name'], 'url' => ['list', 's'=>$item['store_id']]];
	$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['items/index', 'c'=>$item['category_id']]];
	$this->params['breadcrumbs'][] = ['label' => $item['name'], 'url' => ['items/view', 'id' => $item['id'], 'c'=>$item['category_id']]];
}
$this->params['breadcrumbs'][] = 'Edit Discount';
?>

<div class="add-discount">
    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <form class="form-horizontal" role="form" method="post" action="" onSubmit="return check_form()">
                        <div class="form-group">
                            <label class="col-sm-3 control-label col-md-3" for="inputSuccess">Discount on</label>
                            <div class="col-md-6">
                                <p class="form-control-static"><strong>
								<?php 
                                if($discount['promotion_main_type'] == 1) { echo "Date Range"; }
                                else if($discount['promotion_main_type'] == 2) { echo "Days"; }
                                ?></strong></p>
                            </div>
                        </div>
                        <?php if($discount['promotion_main_type'] == 1) { ?>

                        <div class="form-group">
                            <label class="col-md-3 col-sm-3 control-label">Start Date</label>
                            <div class="col-md-6">
                                <input class="form-control form-control-inline input-medium default-date-picker"  size="16" type="text" name="type1_start_date" id="type1_start_date" value="<?= $discount['type1_start_date'] ?>" placeholder="Please select stating date">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 col-sm-3 control-label">End Date</label>
                            <div class="col-md-6">
                                <input class="form-control form-control-inline input-medium default-date-picker"  size="16" type="text" name="type1_end_date" id="type1_end_date" value="<?= $discount['type1_end_date'] ?>" placeholder="Please select ending date">
                            </div>
                        </div>
                        
                        <?php } else if($discount['promotion_main_type'] == 2) { ?>

                        <div class="form-group">
                            <label class="col-sm-3 control-label col-md-3" for="inputSuccess">Select Days</label>
                            <div class="col-md-6">
                                <div>
                                    <label class="checkbox-inline">
                                        <input type="checkbox" name="type2_day[]" value="1" <?php if(in_array(1, $discount['type2_day'])) { echo "checked"; } ?>> Monday
                                    </label>
                                    <label class="checkbox-inline">
                                        <input type="checkbox" name="type2_day[]" value="2" <?php if(in_array(2, $discount['type2_day'])) { echo "checked"; } ?>> Tuesday
                                    </label>
                                    <label class="checkbox-inline">
                                        <input type="checkbox" name="type2_day[]" value="3" <?php if(in_array(3, $discount['type2_day'])) { echo "checked"; } ?>> Wednesday
                                    </label>
                                    <label class="checkbox-inline">
                                        <input type="checkbox" name="type2_day[]" value="4" <?php if(in_array(4, $discount['type2_day'])) { echo "checked"; } ?>> Thursday
                                    </label>
                                </div>
                                <div>
                                    <label class="checkbox-inline">
                                        <input type="checkbox" name="type2_day[]" value="5" <?php if(in_array(5, $discount['type2_day'])) { echo "checked"; } ?>> Friday
                                    </label>
                                    <label class="checkbox-inline">
                                        <input type="checkbox" name="type2_day[]" value="6" <?php if(in_array(6, $discount['type2_day'])) { echo "checked"; } ?>> Saturday
                                    </label>
                                    <label class="checkbox-inline">
                                        <input type="checkbox" name="type2_day[]" value="7" <?php if(in_array(7, $discount['type2_day'])) { echo "checked"; } ?>> Sunday
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label col-md-3" for="inputSuccess">All Day Event</label>
                            <div class="col-md-6">
                                <div class="checkbox" style="padding-left:0">
                                    <label>
                                        <input type="checkbox" name="type2_all_day" id="type2_all_day" value="1" <?php if($discount['type2_all_day'] == 1) { echo "checked"; } ?> onChange="set_all_day_event()">
                                        Discount applicable to whole day
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div id="all_day_event_div" <?php if($discount['type2_all_day'] == 1) { echo 'style="display:none"'; } ?>>
                            <div class="form-group">
                                <label class="col-md-3 col-sm-3 control-label">Time from</label>
                                <div class="col-md-6">
                                    <div class="input-group bootstrap-timepicker">
                                        <input type="text" class="form-control timepicker-24" name="type2_time_start" id="type2_time_start" value="<?= $discount['type2_time_start'] ?>" placeholder="Please select start time">
                                        <span class="input-group-btn">
                                        <button class="btn btn-default" type="button"><i class="fa fa-clock-o"></i></button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 col-sm-3 control-label">Time to</label>
                                <div class="col-md-6">
                                    <div class="input-group bootstrap-timepicker">
                                        <input type="text" class="form-control timepicker-24" name="type2_time_end" id="type2_time_end" value="<?= $discount['type2_time_end'] ?>" placeholder="Please select end time">
                                        <span class="input-group-btn">
                                        <button class="btn btn-default" type="button"><i class="fa fa-clock-o"></i></button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                            
                        <?php } ?>
                        <div class="form-group">
                            <label class="col-sm-3 control-label col-md-3" for="inputSuccess">Discount Type</label>
                            <div class="col-md-6">
                                <label class="checkbox-inline" style="padding-left:0">
                                    <input type="radio" name="promotion_sub" id="promotion_sub_1" value="1" <?php if($discount['promotion_sub'] == 1) { echo "checked"; } ?>>
                                    <div style="float:right; margin-left:10px;">Discount Percentage</div>
                                </label>
                                <label class="checkbox-inline">
                                    <input type="radio" name="promotion_sub" id="promotion_sub_2" value="2" <?php if($discount['promotion_sub'] == 2) { echo "checked"; } ?>>
                                    <div style="float:right; margin-left:10px;">Fixed Price</div>
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 col-sm-3 control-label">Value</label>
                            <div class="col-md-6">
                            	<input type="text" class="form-control" name="promotion_sub_value" id="promotion_sub_value" value="<?= $discount['promotion_sub_value'] ?>" placeholder="Fixed Price or Discount Percentage">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-md-offset-3 col-md-6">
                            	<input type="hidden" name="_csrf" value="<?=Yii::$app->request->getCsrfToken()?>" />
                                <?php /*?><input type="hidden" name="s" value="<?= $_GET['s'] ?>" />
                                <input type="hidden" name="t" value="<?= $_GET['t'] ?>" />
                                <input type="hidden" name="i" value="<?= $_GET['i'] ?>" /><?php */?>
                                <button type="submit" class="btn btn-success" name="submit">Update Promotion</button>
                                <br /><br />
                                <span id="error-form-submit" class="text-danger" style=""><?php if(isset($discount['error']) && $discount['error'] != "") { echo $discount['error']; } ?></span>
                            </div>
                        </div>
                    </form>
                </div>
            </section>
        </div>
    </div>
</div>
<script>
function set_promotion_main_type(x)
{
	var pro_main_type = x.value;
	if(pro_main_type == 1)
	{
		$("#pro_main_type_2").css('display', 'none');
		$("#pro_main_type_1").css('display', 'block');
	}
	else if(pro_main_type == 2)
	{
		$("#pro_main_type_1").css('display', 'none');
		$("#pro_main_type_2").css('display', 'block');
	}
}
function set_all_day_event()
{
	if($('#type2_all_day').prop('checked')) {
		$("#all_day_event_div").css("display", "none");
	} else {
		$("#all_day_event_div").css("display", "block");
	}
}

function checkDateIsValid(s)
{
	var text = s;
	var comp = text.split('-');
	var y = parseInt(comp[0], 10);
	var m = parseInt(comp[1], 10);
	var d = parseInt(comp[2], 10);
	var date = new Date(y,m-1,d);
	//console.log(date);
	if (date.getFullYear() == y && date.getMonth() + 1 == m && date.getDate() == d) {
		return true;
	} else {
		return false;
	}
}
	
function check_form() {
	$("#error-form-submit").html('');
	var promotion_sub_value = $("#promotion_sub_value").val();
	
	<?php if($discount['promotion_main_type'] == 1) { ?>
	//if($("input[name=promotion_main_type]:checked").val() == 1) {

		var type1_start_date = $("#type1_start_date").val();
		var type1_end_date = $("#type1_end_date").val();

		if(checkDateIsValid(type1_start_date) == false) {
			//alert("Promotion start date is not valid");
			$("#error-form-submit").html('Discount start date is not valid');
		} else if(checkDateIsValid(type1_end_date) == false) {
			//alert("Promotion end date is not valid");
			$("#error-form-submit").html('Discount end date is not valid');
		} else if(type1_start_date > type1_end_date) {
			//alert("Promotion end date should not be less than start date");
			$("#error-form-submit").html('Discount end date should not be less than start date');
		} else if($.isNumeric(promotion_sub_value) == false) {
			//alert("Promotion value is invalid");
			$("#error-form-submit").html('Discount value is invalid');
		} else {
			//alert("ok");
			return true;
			// Everything is ok
		}
	<?php } else if($discount['promotion_main_type'] == 2) { ?>
	//} else if($("input[name=promotion_main_type]:checked").val() == 2) {
		var len_days = $("input[name='type2_day[]']:checked").length;
		var type2_time_start = $("#type2_time_start").val();
		var type2_time_end = $("#type2_time_end").val();

		var str_time_start = type2_time_start.replace(/:/g, "");
		var str_time_end = type2_time_end.replace(/:/g, "");
		
		var parts_start_time = type2_time_start.split(':');
		var parts_end_time = type2_time_end.split(':');

		if(len_days == 0) {
			//alert("Please select days for discount");
			$("#error-form-submit").html('Please select days for discount');
		} else if (!$("#type2_all_day").prop('checked') && !/^\d{2}:\d{2}:\d{2}$/.test(type2_time_start)) {
			//alert("Please enter correct start time format");
			$("#error-form-submit").html('Please enter correct start time format');
		} else if (!$("#type2_all_day").prop('checked') && (parts_start_time[0] > 23 || parts_start_time[1] > 59 || parts_start_time[2] > 59)) {
			//alert("Please enter correct start time format");
			$("#error-form-submit").html('Please enter correct start time format');
		} else if (!$("#type2_all_day").prop('checked') && !/^\d{2}:\d{2}:\d{2}$/.test(type2_time_end)) {
			//alert("Please enter correct end time format");
			$("#error-form-submit").html('Please enter correct end time format');
		} else if (!$("#type2_all_day").prop('checked') && (parts_end_time[0] > 23 || parts_end_time[1] > 59 || parts_end_time[2] > 59)) {
			//alert("Please enter correct end time format");
			$("#error-form-submit").html('Please enter correct end time format');
		} else if(!$("#type2_all_day").prop('checked') && parseInt(str_time_start) >= parseInt(str_time_end)) {
			//alert("Please enter correct time for discount");
			$("#error-form-submit").html('Please enter correct time for discount');
		} else if($.isNumeric(promotion_sub_value) == false) {
			//alert("Promotion value is invalid");
			$("#error-form-submit").html('Discount value is invalid');
		} else {
			//alert("ok");
			return true;
			// Everything is ok
		}
	//}
	return false;
	<?php } ?>	
}
</script>