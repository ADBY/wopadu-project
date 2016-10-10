<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Orders */

$this->title = "Order Number: ".$model->order_number;
$this->params['breadcrumbs'][] = ['label' => 'Orders', 'url' => ['index', 's' => $model->store_id]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="orders-view">
    <div class="row">
        <?php if(Yii::$app->session->hasFlash('orders')) { ?>
            <div class="col-sm-12">
                <div class="alert alert-warning fade in">
                    <button type="button" class="close close-sm" data-dismiss="alert">
                        <i class="fa fa-times"></i>
                    </button>
                    <strong><?= Yii::$app->session->getFlash('orders') ?></strong>
                </div>
            </div>
        <?php } ?>
        
        <div class="col-md-12">
            <section class="panel panel-danger">
                <header class="panel-heading">
                    Order Status
                </header>
                <div class="panel-body">
                    <div class="row">
                    
                        <div class="col-md-4" style="margin-top:8px;">
                            Order Status: <strong>
                        <?php 
                            /*
                            *	Order Status
                            *	1 = New   – Red color
                            *	2 = Processing – Orange color
                            *	3 = Ready to collect – Green color
                            *	4 = Completed – Blue color
                            *	5 = Cancelled – Grey color
                            */
                            if($model->status == 1)
                            {
                                echo '<span style="color:#C0392B">New</span>';
                            }
                            else if($model->status == 2)
                            {
                                echo '<span style="color:#FF7F00">Processing</span>';
                            }
                            else if($model->status == 3)
                            {
                                echo '<span style="color:#2ECC71">Ready to collect</span>';
                            }
                            else if($model->status == 4)
                            {
                                echo '<span style="color:#3498DB">Completed</span>';
                            }
                            else
                            {
                                echo '<span style="color:#808080">Cancelled</span>';
                            }
                        ?></strong>
                        </div>
                        <?php if($model->status == 1 || $model->status == 2 || $model->status == 3) { ?>
                        <div class="col-md-8">
                            <form class="form-inline" role="form" method="get" action="upstatus">
                                <div class="form-group">
                                    <label class="" for="" style="margin-right:20px;">Update Status</label>
                                    
                                    <select class="form-control" name="order_status" style="margin-right:20px;">
                                        <?php /*?><option value="1" <?php if($model->status == 1) { echo 'selected=""'; } ?>>New</option><?php */?>
                                        <?php if($model->status == 1) { ?>
                                        <option value="2">Start Order</option>
                                        <option value="3">Ready to collect</option>
                                        <option value="4">Completed</option>
                                        <option value="5">Cancelled</option>
                                        <?php } else if($model->status == 2) { ?>
                                        <option value="3">Ready to collect</option>
                                        <option value="4">Completed</option>
                                        <option value="5">Cancelled</option>
                                        <?php } else if($model->status == 3) { ?>
                                        <option value="4">Completed</option>
                                        <option value="5">Cancelled</option>
                                        <?php } ?>
                                    </select>
                                    
                                    <input type="hidden" name="order_id" value="<?php echo $_GET['id']; ?>" />
                                    <button type="submit" name="submit" class="btn btn-success">Update</button>
                                </div>
                            </form>
                        </div>
                        <?php } ?>
                    </div>
                </div>
            </section>
        </div>
                
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <span class="pull-right">
                        <?= Html::a('Invoice', ['order-details/details', 'id' => $model->id], ['class' => 'btn btn-success btn-xs']) ?>
                        <?php /*?><?= Html::a('Update', ['update', 'id' => $model->id], ['class' => 'btn btn-primary btn-xs']) ?><?php */?>
                        <?php /*?><?= Html::a('Delete', ['delete', 'id' => $model->id], [
                            'class' => 'btn btn-danger btn-xs',
                            'data' => [
                                'confirm' => 'Are you sure you want to delete this item?',
                                'method' => 'post',
                            ],
                        ]) ?><?php */?>
                    </span>
                </header>
                <div class="panel-body">
    
                        <?php /*?><?= DetailView::widget([
                            'model' => $model,
                            'attributes' => [
                                //'id',
                                //'user_id',
                                'user.first_name',
                                'user.last_name',
                                //'store_id',
                                'order_number',
                                'invoice_number',
                                //'order_type',
                                [
                                    'attribute' => 'order_type',
                                    'value'		=> $model->order_type == 1 ? 'Online':'Offline',
                                ],
                                'table_location',
                                'total_amount',
                                'add_note',
                                //'added_datetime',
                                [
                                    'attribute' => 'n_datetime',
                                    'format'	=> ['date', 'php:j-n-Y g:i A'],
                                ],
                                [
                                    'attribute' => 'p_datetime',
                                    'format'	=> ['date', 'php:j-n-Y g:i A'],
                                ],
                                [
                                    'attribute' => 'r_datetime',
                                    'format'	=> ['date', 'php:j-n-Y g:i A'],
                                ],
                                [
                                    'attribute' => 'c_datetime',
                                    'format'	=> ['date', 'php:j-n-Y g:i A'],
                                ],
                                //'status',
                                [
                                    'attribute' => 'status',
                                    'value'		=> $model->orderStatusName($model->status),
                                ],
                            ],
                        ]) ?><?php */?>
                        
                    <table class="table_cust_1" style="width:100%">
                        <?php if($model->user_id == NULL) { ?>
                        <tr>
                            <td style="width:30%"><strong>Waiter Name</strong></td>
                            <td><?= $model->waiter->emp_name ?></td>
                        </tr>
                        <?php } else { ?>
                        
                        <?php $session = Yii::$app->session; if($session['super_admin'] == 'YES') { ?>
                        <tr>
                            <td style="width:30%"><strong>First Name</strong></td>
                            <td><?= $model->user->first_name ?></td>
                        </tr>
                        <tr>
                            <td><strong>Last Name</strong></td>
                            <td><?= $model->user->last_name ?></td>
                        </tr>
                        <?php } else { ?>
                        <tr>
                            <td style="width:30%"><strong>Name</strong></td>
                            <td><?= $model->user->first_name ?></td>
                        </tr>
                        <?php } ?>
                        <?php } ?>
                        <tr>
                            <td><strong>Order Number</strong></td>
                            <td><?= $model->order_number ?></td>
                        </tr>
                        <tr>
                            <td><strong>Invoice Number</strong></td>
                            <td><?= $model->invoice_number ?></td>
                        </tr>
                        <tr>
                            <td><strong>Order Type</strong></td>
                            <td><?php if($model['order_type'] == 1) { echo "Online"; } else { echo "Offline"; } ?></td>
                        </tr>
                        <?php /*?><tr>
                            <td><strong>Table Location</strong></td>
                            <td><?= $model->table_location ?></td>
                        </tr><?php */?>
                        <?php 
						if($model->table_location == "Takeaway")
						{
							//echo $order['table_location'];
							echo '<tr>
								<td><strong>Type</strong></td>
								<td>'.$model->table_location.'</td>
							</tr>';
						}
						else
						{
							//echo 'Table Number - '.$order['table_location'];
							echo '<tr>
								<td><strong>Table Number</strong></td>
								<td>'.$model->table_location.'</td>
							</tr>';
						}
						?>
                        
                        
                        <tr>
                            <td><strong>Total Amount</strong></td>
                            <td><?= $model['total_amount'] ?></td>
                        </tr>
                        <tr>
                            <td><strong>Add Note</strong></td>
                            <td><?= $model['add_note'] ?></td>
                        </tr>
                        <tr>
                            <td><strong>Order Placed Datetime</strong></td>
                            <td><?php echo date('j-n-Y g:i A', strtotime($model['n_datetime'])) ?></td>
                        </tr>
                        <tr>
                            <td><strong>Order in Processig Datetime</strong></td>
                            <td><?php if($model['p_datetime'] != NULL) { echo date('j-n-Y g:i A', strtotime($model['p_datetime'])); } else { echo "(not set)"; } ?></td>
                        </tr>
                        <tr>
                            <td><strong>Order Ready Datetime</strong></td>
                            <td><?php if($model['r_datetime'] != NULL) { echo date('j-n-Y g:i A', strtotime($model['r_datetime'])); } else { echo "(not set)"; } ?></td>
                        </tr>
                        <tr>
                            <td><strong>Status</strong></td>
                            <td><?= $model->orderStatusName($model->status) ?></td>
                        </tr>
                        <tr>
                            <td><strong>Complete/Cancel Datetime</strong></td>
                            <td><?php if($model['c_datetime'] != NULL) { echo date('j-n-Y g:i A', strtotime($model['c_datetime'])); } else { echo "(not set)"; } ?></td>
                        </tr>
                    </table>
                    
                </div>
            </section>
        </div>
        
        <div class="row">
            <section class=" col-md-12">
                <div class="panel-body invoice">
                    <table class="table table-bordered table-invoice" style="background-color:#FFFFFF">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th colspan="2">Product Description</th>
                                <th class="text-center">Quantity</th>
                                <th class="text-center">Price</th>
                                <th class="text-center">Status</th>
                                <th class="text-center" style="width:150px">Option</th>
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
                                    <h4><?php echo $ord['item_name']; ?></h4>
                                    <?php if($ord['item_variety_id'] != NULL) { echo '<p><u>'.$ord['item_variety_name'].'</u></p>'; } ?>
                                    <p><?php if($ord['add_note'] != "") { echo $ord['add_note']; } ?></p>
                                    </div>
                                    
                                    <?php if(!empty($ord['options'])) {
                                        echo '<div style="float:right">';
                                        echo '<p style="text-align:right; ">';
                                        foreach($ord['options'] as $opt) {
                                            //echo $opt['option_name'].' x $ '.$opt['amount'].'<br>';
                                            echo $opt['sub_name'].' <small>('.$opt['option_name'].')</small> x $ '.$opt['sub_amount'].'<br>';
                                        }
                                        echo '</p>';
                                        echo '</div>';
                                    }
                                    ?>
                                </td>
                                <td class="text-center"><strong><?= $ord['quantity'] ?></strong></td>
                                <td class="text-center"><strong>$ <?= $ord['final_amount'] ?></strong></td>
                                <td class="text-center">
                                
                                    <strong><?php 
                                        /*
                                        *	Order Status
                                        *	1 = New   – Red color
                                        *	2 = Processing – Orange color
                                        *	3 = Ready to be collected – Green color
                                        *	4 = Completed – Blue color
                                        *	5 = Cancelled – Grey color
                                        */
                                        if($ord['status'] == 1)
                                        {
                                            echo '<span style="color:#C0392B">New</span>';
                                        }
                                        else if($ord['status'] == 2)
                                        {
                                            echo '<span style="color:#FF7F00">Processing</span>';
                                        }
                                        else if($ord['status'] == 3)
                                        {
                                            echo '<span style="color:#2ECC71">Ready to collect</span>';
                                        }
                                        else if($ord['status'] == 4)
                                        {
                                            echo '<span style="color:#3498DB">Completed</span>';
                                        }
                                        else
                                        {
                                            echo '<span style="color:#808080">Cancelled</span>';
                                        }
                                    ?></strong>
                                </td>
                                <td class="text-center" style="font-weight:bold">                            
                                    <?php /*?><a class="btn-xs text-primary" href="<?= Yii::$app->urlManager->createUrl(['order-details/view', 'id' => $ord['id']]) ?>"><i class="fa fa-eye"></i></a><?php */?>
                                    <a class="btn btn-xs btn-primary" href="<?= Yii::$app->urlManager->createUrl(['order-details/update', 'id' => $ord['id']]) ?>"><i class="fa fa-edit"></i> Edit</a>
									<?php if($ord['status'] != 5) { ?>
                                    <a class="btn btn-xs btn-danger" href="<?= Yii::$app->urlManager->createUrl(['order-details/cancelod', 'id' => $ord['id']]) ?>" data-method="post"><i class="fa fa-times"></i> Cancel</a>
                                    <?php } ?>
                                </td>
                            </tr>
                            <?php 
                                $i++;
                            }
                            ?>
                            <tr>
                                <td colspan="2">
                                    <?php if($model->add_note != "") { echo '<strong>Note:</strong> '.$model->add_note; } ?>
                                </td>
                                <td class="text-right" colspan="2">
                                    <p>Sub Total</p>
                                    <?php /*?><p>Tax (VAT 10%)</p>
                                    <p>Discount (5%)</p><?php */?>
                                    <p><strong>GRAND TOTAL</strong></p>
                                </td>
                                <td class="text-center">
                                    <p>$ <?php echo $model->total_amount; ?></p>
                                    <?php /*?><p>$ 120.00</p>
                                    <p>$ 60.00</p><?php */?>
                                    <p><strong>$ <?= $model->total_amount ?></strong></p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </div>
</div>
