<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\OrderDetailsSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Ordered Items';
$this->params['breadcrumbs'][] = ['label' => 'Orders', 'url' => ['orders/index', 's' => $order->store_id]];
$this->params['breadcrumbs'][] = ['label' => 'Order Number: '.$order->order_number, 'url' => ['orders/view', 'id' => $order->id]];
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
    
    <?php /*?><div class="col-sm-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
				<?= Html::encode($this->title) ?>
		            <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                <span class="pull-right">
                	<?= Html::a('Add New Item', ['create'], ['class' => 'btn btn-primary btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">

	        <?= GridView::widget([
            	'dataProvider' => $dataProvider,
            	//'filterModel' => $searchModel,
        		'columns' => [
                	['class' => 'yii\grid\SerialColumn'],
					//'id',
					//'order_id',
					//'item_id',
					[
						'attribute' => 'item_id',
						'value' => 'item.item_name'
					],
					'item_options_id',
					'quantity',
					// 'amount',
					// 'add_note',
                    ['class' => 'yii\grid\ActionColumn'],
                ],
            ]); ?>
                 </div>
        </section>
    </div><?php */?>
    
    <div class="row">
        <section class=" col-md-12">
            <div class="panel-body invoice">
                <table class="table table-bordered table-invoice" style="background-color:#FFFFFF">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th colspan="2">Item Description</th>
                            <th class="text-center">Quantity</th>
                            <th class="text-center">Total</th>
                            <th class="text-center">Option</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $i = 1;
                        foreach($order_details as $ord) { ?>
                        <tr>
                            <td><?= $i ?></td>
                            <td colspan="2">
                                <div style="float:left">
                                <h4>
                                    <?php echo $ord['item_name']; ?>
                                </h4>
                                <p><?php if($ord['add_note'] != "") { echo $ord['add_note']; } ?></p>
                                </div>
                                
                                <?php if(!empty($ord['options'])){
                                    echo '<div style="float:right">';
                                    echo '<p style="text-align:right; ">';
                                    foreach($ord['options'] as $opt)
                                    {
                                        echo $opt['option_name'].' x $ '.$opt['amount'].'<br>';
                                    }
                                    echo '</p>';
                                    echo '</div>';
                                }
                                ?>
                                
                            </td>
                            <td class="text-center"><strong><?= $ord['quantity'] ?></strong></td>
                            <td class="text-center"><strong>$ <?= $ord['final_amount'] ?></strong></td>
                            <td class="text-center">                            
                                <?php /*?><a class="btn-xs text-primary" href="<?= Yii::$app->urlManager->createUrl(['order-details/view', 'id' => $ord['id']]) ?>"><i class="fa fa-eye"></i></a><?php */?>
                                <a class="btn-xs text-primary" href="<?= Yii::$app->urlManager->createUrl(['order-details/update', 'id' => $ord['id']]) ?>"><i class="fa fa-edit"></i></a>
                                <a class="btn-xs text-primary" href="<?= Yii::$app->urlManager->createUrl(['order-details/delete', 'id' => $ord['id']]) ?>" data-method="post"><i class="fa fa-trash-o"></i></a>
                            </td>
                        </tr>
                        <?php 
                            $i++;
                        }
                        ?>
                        <tr>
                            <td colspan="2">
                                <?php if($order->add_note != "") { echo '<strong>Note:</strong> '.$order->add_note; } ?>
                            </td>
                            <td class="text-right" colspan="2">
                                <p>Sub Total</p>
                                <?php /*?><p>Tax (VAT 10%)</p>
                                <p>Discount (5%)</p><?php */?>
                                <p><strong>GRAND TOTAL</strong></p>
                            </td>
                            <td class="text-center">
                                <p>$ <?php echo $order['total_amount']; ?></p>
                                <?php /*?><p>$ 120.00</p>
                                <p>$ 60.00</p><?php */?>
                                <p><strong>$ <?= $order->total_amount ?></strong></p>
                            </td>
                        </tr>
                    </tbody>
                </table>
                
            </div>

        </section>
    </div>
</div>
