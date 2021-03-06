<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\stores */

$this->title = $model->store_name;
$this->params['breadcrumbs'][] = ['label' => 'Stores', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="row">
    <div class="col-md-12">
    	<?php if(Yii::$app->session->hasFlash('stores')) { ?>
        <div class="alert alert-warning fade in">
            <button type="button" class="close close-sm" data-dismiss="alert">
            	<i class="fa fa-times"></i>
            </button>
            <strong><?= Yii::$app->session->getFlash('stores') ?></strong>
        </div>
        <?php } ?>
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
            	<?php /*?><?= DetailView::widget([
					'model' => $model,
					'attributes' => [
						//'id',
						//'account_id',
						[
							'attribute' => 'Account Name',
							'value' => $model->accounts->account_name,
						],
						'store_name',
						'store_branch',
						'address',
						'tax_invoice',
						'abn_number',
						//'image',
						[
							'attribute'	=>'image',
							'value' 	=> "../../images/stores/".$model->image,
							//'value' 	=> Yii::$app->urlManager->baseUrl.'/../images/stores/'.$model->image,
							'format' 	=> ['image',['width'=>'100','height'=>'100']],
						],
						'welcome_notif',
						'received_notif',
						'ready_notif',
						//'status',
						[
							'attribute' => 'status',
							'value'		=> $model->status == 1 ? 'Active':'Inactive',
						],
					],
				]) ?><?php */?>
                
                <table class="table_cust_1" style="width:100%">
                	<tr>
                		<td style="width:30%"><strong>Account Name</strong></td>
                		<td><?php echo $model->accounts->account_name ?></td>
                	</tr>
                    <tr>
                		<td><strong>Store Name</strong></td>
                		<td><?= $model['store_name'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Store Branch</strong></td>
                		<td><?= $model['store_branch'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Address</strong></td>
                		<td><?= $model['address'] ?></td>
                	</tr>
                    <tr>
                		<td><strong>Description</strong></td>
                		<td><?= $model['description'] ?></td>
                	</tr>
                    <tr>
                		<td><strong>Tax Invoice</strong></td>
                		<td><?= $model['tax_invoice'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Abn Number</strong></td>
                		<td><?= $model['abn_number'] ?></td>
                	</tr>
                    <tr>
                		<td><strong>Image</strong></td>
                		<td><?php if($model['image'] != "" && file_exists("images/stores/".$model['image'])) { echo '<img src="../images/stores/'.$model['image'].'" title="Store Image" alt="Store Image" style="width:150px"/>'; } else { echo "No image"; } ?>
                        </td>
                	</tr>
                	<tr>
                		<td><strong>Welcome Notification</strong></td>
                		<td><?= $model['welcome_notif'] ?></td>
                	</tr>
                    <tr>
                		<td><strong>Received Notification</strong></td>
                		<td><?= $model['received_notif'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Ready Notification</strong></td>
                		<td><?= $model['ready_notif'] ?></td>
                	</tr>
                    <tr>
                		<td><strong>Dislay Note Option</strong></td>
                		<td><?php if($model['display_note'] == 1) { echo "Yes"; } else { echo "No"; } ?></td>
                	</tr>
                    <tr>
                		<td><strong>Secret Key (For Payment)</strong></td>
                		<td><?= $model['secret_key'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Publishable Key (For Payment)</strong></td>
                		<td><?= $model['publishable_key'] ?></td>
                	</tr>
                    <tr>
                		<td><strong>Map Latitude</strong></td>
                		<td><?= $model['map_latitude'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Map Longitude</strong></td>
                		<td><?= $model['map_longitude'] ?></td>
                	</tr>
                    
                    <tr>
                		<td><strong>Status</strong></td>
                		<td><?php if($model['status'] == 1) { echo "Active"; } else { echo "Inactive"; } ?></td>
                	</tr>
                </table>
                
            </div>
        </section>
    </div>
</div>
