<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\StoresSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Stores';
$this->params['breadcrumbs'][] = $this->title;

$panel_classes = array('primary', 'success', 'info', 'warning', 'danger');

$session = Yii::$app->session;
?>
<hr/>
<div class="row">
	<div class="col-md-12">
        <?php /*?><h3><?php echo Html::encode($this->title) ?></h3><?php */?>
        <?php if($storeCount > $session['allowed_stores']) { ?>
        <span class="pull-right">
            <?= Html::a('Create Store', ['create'], ['class' => 'btn btn-primary btn-xs']) ?>
        </span>
        <?php } ?>
        <p>You can have maximum <?= $session['allowed_stores'] ?> store. You have total <?= $storeCount ?> stores as of now.</p>
        
        
		<?php if(Yii::$app->session->hasFlash('stores')) { ?>
        <div class="alert alert-warning fade in">
            <button type="button" class="close close-sm" data-dismiss="alert">
            	<i class="fa fa-times"></i>
            </button>
            <strong><?= Yii::$app->session->getFlash('stores') ?></strong>
        </div>
        <?php } ?>
       
    </div> 
        <?php 
		$i = 0;
		foreach($model as $store) {
		
        echo '<div class="col-md-6"><div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">'.$store['store_name'].'</h3>
            </div>
            <div class="panel-body">
                <table class="table table-striped">
					<tr>
						<td>Store Name</td>
						<td>'.$store['store_name'].'</td>
					</tr>
					<tr>
						<td>Branch</td>
						<td>'.$store['store_branch'].'</td>
					</tr>
					<tr>
						<td>ABN Number</td>
						<td>'.$store['abn_number'].'</td>
					</tr>
					<tr>
						<td>Tax Invoice</td>
						<td>'.$store['tax_invoice'].'</td>
					</tr>';
				/*	<tr>
						<td>Status</td>
						<td>'.$store['status'].'</td>
					</tr>*/
		echo '		<tr>
						<td colspan="2">
							<a class="btn btn-success btn-xs" style="margin-bottom: 10px;" href="'.Yii::$app->urlManager->createUrl('beacons/store?id='.$store['id']).'">Manage Beacons</a>
							<a class="btn btn-success btn-xs" style="margin-bottom: 10px;">Manage Categories</a>
							<a class="btn btn-success btn-xs" style="margin-bottom: 10px;">Manage Items</a>
							<a class="btn btn-success btn-xs" style="margin-bottom: 10px;">Manage Orders</a>
							<a class="btn btn-success btn-xs" style="margin-bottom: 10px;">Manage Employees</a>
							<a class="btn btn-success btn-xs" style="margin-bottom: 10px;">View Reviews</a>
							<a class="btn btn-success btn-xs" style="margin-bottom: 10px;">Faqs</a>
							<a class="btn btn-success btn-xs" style="margin-bottom: 10px;">About Store</a>
							<a class="btn btn-success btn-xs" style="margin-bottom: 10px;">Terms</a>
						</td>
					</tr>';			
		echo '	</table>
            </div>
        </div></div>';
		$i++;	
		} ?>
    
</div>