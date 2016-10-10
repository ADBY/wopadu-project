<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Categories */

$this->title = "View Discount: ".$item['name'];

if($item['type'] == 1) {
	$this->params['breadcrumbs'][] = ['label' => 'Categories', 'url' => ['list', 's'=>$item['store_id']]];
} else if($item['type'] == 2) {
	$this->params['breadcrumbs'][] = ['label' => 'Category: '.$item['category_name'], 'url' => ['list', 's'=>$item['store_id']]];
	$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['items/index', 'c'=>$item['category_id']]];
	$this->params['breadcrumbs'][] = ['label' => $item['name'], 'url' => ['items/view', 'id' => $item['id'], 'c'=>$item['category_id']]];
}
$this->params['breadcrumbs'][] = "View Discount";

function getDayName($day)
{
	if($day == 1)
	{
		return "Monday";
	}
	else if($day == 2)
	{
		return "Tuesday";
	}
	else if($day == 3)
	{
		return "Wednesday";
	}
	else if($day == 4)
	{
		return "Thursday";
	}
	else if($day == 5)
	{
		return "Friday";
	}
	else if($day == 6)
	{
		return "Saturday";
	}
	else if($day == 7)
	{
		return "Sunday";
	}
	else
	{
		return false;
	}
}
?>

<div class="categories-view">
    <div class="row">
        <?php if(Yii::$app->session->hasFlash('discounts')) { ?>
            <div class="col-sm-12">
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('discounts') ?></strong>
            </div>
            </div>
        <?php } ?>
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <span class="pull-right">
                        <?= Html::a('Add Discount', ['add-discount', 's' => $item['store_id'], 't' => $item['type'], 'i' => $item['id']], ['class' => 'btn btn-primary btn-xs']) ?>
                    </span>
                </header>
                <div class="panel-body">
                    <?php if(empty($discounts)) { ?>
                    <p class="lead">No discount applied.</p>
                    <?php } else { ?>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th colspan="2">Discount on</th>
                                <th>Type of discount</th>
                                <th>Value</th>
                                <th style="width:200px">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php $i =1 ;foreach($discounts as $item_disc) 
							{
								echo '<tr>';
								echo '<td>'.$i.'</td>';
								
								if($item_disc['promotion_main_type'] == 1)
								{
									echo '<td colspan="2"><strong>'.date("d-m-Y", strtotime($item_disc['start_date'])).'</strong> to <strong>'.date("d-m-Y", strtotime($item_disc['end_date'])).'</strong></td>';
								}
								else if($item_disc['promotion_main_type'] == 2)
								{
									$days = trim($item_disc['day'], ",");
									$exp_days = explode(",", $days);
									$day_str = "";
									
									foreach($exp_days as $day_num)
									{
										$day_str .= getDayName($day_num).", ";
									}
									
									$day_str = rtrim($day_str, ", ");									
									echo '<td><strong>'.$day_str.'</strong></td>';
									
									echo '<td>';
									if($item_disc['all_day'] == 1)
									{
										echo 'All Day';
									}
									else
									{
										echo $item_disc['time_start'].' to '.$item_disc['time_end'];
									}
									echo '</td>';
								}
								
								if($item_disc['promotion_sub'] == 1)
								{
									echo '<td>Discount %</td>';
								}
								else if($item_disc['promotion_sub'] == 2)
								{
									echo '<td>Fixed price</td>';
								}
								echo '<td>'.$item_disc['promotion_sub_value'].'</td>';

								echo '<th>';
								echo '<a href="'.Yii::$app->urlManager->createUrl(['categories/edit-discount', 's' => $item['store_id'], 't' => $item['type'], 'i' => $item['id'], 'id' => $item_disc['id'], 'p' => $item_disc['promotion_main_type']]).'" class="btn btn-xs btn-green-sea" style="margin-right:20px"><i class="fa fa-edit"></i> Edit</a>';
								echo '<a href="'.Yii::$app->urlManager->createUrl(['categories/delete-discount', 's' => $item['store_id'], 't' => $item['type'], 'i' => $item['id'], 'id' => $item_disc['id'], 'p' => $item_disc['promotion_main_type']]).'" class="btn btn-xs btn-danger" data-confirm="Are you sure you want to delete this item?"><i class="fa fa-trash-o"></i> Delete</a>';
								echo '</th>';
								echo '</tr>';
                            	$i++;
							}
							?>
                        </tbody>
                    </table>
                    <?php } ?>
                </div>
            </section>
        </div>
    </div>
</div>