<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Orders */

$this->title = "Invoice";
$this->params['breadcrumbs'][] = ['label' => 'Orders', 'url' => ['orders/index', 's' => $orders ->store_id]];
$this->params['breadcrumbs'][] = ['label' => 'Order Number: '.$orders->order_number , 'url' => ['orders/view', 'id' => $orders->id, 's' => $orders->store_id]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="panel">
    <div class="panel-body invoice">
        <div class="row">
            <div class="col-md-4">
                <img class="inv-logo" src="<?= Yii::$app->homeUrl ?>images/invoice-logo.jpg" alt=""/>
            </div>
            <div class="col-md-4 col-md-offset-4" style="font-size: 17px;margin-top: 12px;">
                Order Status: <strong>
                <?php 
	/*
	*	Order Status
	*	1 = New   – Red color
	*	2 = Processing – Orange color
	*	3 = Ready to be collected – Green color
	*	4 = Completed – Blue color
	*	5 = Cancelled – Grey color
	*/
	if($orders->status == 1)
	{
		echo '<span style="color:#C0392B">Received</span>';
	}
	else if($orders->status == 2)
	{
		echo '<span style="color:#FF7F00">Processing</span>';
	}
	else if($orders->status == 3)
	{
		echo '<span style="color:#2ECC71">Ready to be collected</span>';
	}
	else if($orders->status == 4)
	{
		echo '<span style="color:#3498DB">Completed</span>';
	}
	else
	{
		echo '<span style="color:#808080">Cancelled</span>';
	}
?></strong>
            </div>
            <div class="clearfix"></div>
            <div class="col-md-4 col-sm-4">
                <p>
					<?php echo $store->store_name; ?><br/>
                    <?php echo $store->store_branch; ?><br/>
                    <?php echo str_replace(",", ",<br/>", $store->address); ?><br/>
                </p>
            </div>
            <div class="col-md-4 col-sm-4">
                <h4 class="inv-to">Invoice To</h4>
                    <h2 class="corporate-id"><?= $user->first_name.' '.$user->last_name ?></h2>
                    <p>
                        Phone: <?= $user->mobile ?>,<br>
                        Email : <?= $user->email ?>
                    </p>
            </div>
            <div class="col-md-4 col-sm-4">
                <div class="inv-col"><span>Invoice#</span> <?= $orders->invoice_number ?></div>
                <div class="inv-col"><span>Invoice Date: </span> <?= date('j-n-Y g:i A', strtotime($orders->n_datetime)) ?></div>
                <div class="inv-col"><span>Order type: </span> <?php if($orders->order_type == 1) { echo "Online"; } else { echo "Offline"; } ?></div>
                <div class="inv-col"><span>Table No: </span> <?= $orders->table_location ?></div>  
            </div>
        </div>
        <table class="table table-bordered table-invoice">
            <thead>
                <tr>
                    <th>#</th>
                    <th colspan="2">Item Description</th>
                    <th class="text-center">Quantity</th>
                    <th class="text-center">Total</th>
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
                        <?php if($ord['item_variety_id'] != NULL) { echo '<p><u>'.$ord['item_variety_name'].'</u></p>'; } ?>
                        <p><?php if($ord['add_note'] != "") { echo $ord['add_note']; } ?></p>
                        </div>
                        
                        <?php if(!empty($ord['options'])){
                            echo '<div style="float:right">';
                            echo '<p style="text-align:right; ">';
                            foreach($ord['options'] as $opt)
                            {
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
                </tr>
                <?php 
                    $i++;
                }
                ?>
                <tr>
                    <td colspan="2">
                    	<?php if($orders->add_note != "") { echo '<strong>Note:</strong> '.$orders->add_note; } ?>
                    </td>
                    <td class="text-right" colspan="2">
                        <p>Sub Total</p>
                        <?php /*?><p>Tax (VAT 10%)</p>
                        <p>Discount (5%)</p><?php */?>
                        <p><strong>GRAND TOTAL</strong></p>
                    </td>
                    <td class="text-center">
                        <p>$ <?php echo $orders['total_amount']; ?></p>
                        <?php /*?><p>$ 120.00</p>
                        <p>$ 60.00</p><?php */?>
                        <p><strong>$ <?= $orders->total_amount ?></strong></p>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="row">
            <div class="col-md-12">
            	<h4>Thank You.</h4>
            </div>
        </div>
    </div>
</div>