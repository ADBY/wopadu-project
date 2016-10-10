<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\OrderDetails */

$this->title = "Ordered items";
$this->params['breadcrumbs'][] = ['label' => 'Orders', 'url' => ['orders/index', 's'=> $order->store_id]];
$this->params['breadcrumbs'][] = ['label' => 'Order Number: '.$order->order_number, 'url' => ['orders/view', 'id'=> $order->id]];
$this->params['breadcrumbs'][] = ['label' => 'Order Details', 'url' => ['index', 'o' => $order->id]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="row">
	<?php if(Yii::$app->session->hasFlash('order_details')) { ?>
        <div class="col-sm-12">
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('order_details') ?></strong>
            </div>
        </div>
    <?php } ?>
    <div class="col-md-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
            	<?= Html::encode($this->title) ?>
                <span class="pull-right">
                	<?= Html::a('Update', ['update', 'id' => $model->id], ['class' => 'btn btn-primary btn-xs']) ?>
                    <?= Html::a('Delete', ['delete', 'id' => $model->id], [
                        'class' => 'btn btn-danger btn-xs',
                        'data' => [
                            'confirm' => 'Are you sure you want to delete this item?',
                            'method' => 'post',
                        ],
                    ]) ?>
                </span>
            </header>
            <div class="panel-body">
                <table class="table">
                        <tbody>
                            <tr>
                                <td><strong>Item Name</strong></td>
                                <td><?= $model->item->item_name ?></td>
                            </tr>
                            <tr>
                                <td><strong>Item Options</strong></td>
                                <td>
								<?php 
								if($item_options)
								{
									echo "<table>";
									foreach($item_options as $optn)
									{
										echo '<tr><td style="padding-top:0; padding-bottom:0; padding-left:0">';
										echo $optn['option_name'];
										//echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; x ";
										echo '</td><td style="padding-top:0; padding-bottom:0">';
										echo "$ ".$optn['amount'];
										echo "</td></tr>";
									}
									echo "</table>";
								}
								?>
								</td>
                            </tr>
                            <tr>
                                <td><strong>Quantity</strong></td>
                                <td><?= $model->quantity ?></td>
                            </tr>
                            <tr>
                                <td><strong>Amount</strong></td>
                                <td><?= $model->final_amount ?></td>
                            </tr>
                            <tr>
                                <td><strong>Notes</strong></td>
                                <td><?= $model->add_note ?></td>
                            </tr>
                        </tbody>
                    </table>
			</div>
        </section>
    </div>
</div>
