<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\StoresSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Stores';
$this->params['breadcrumbs'][] = $this->title;
$session = Yii::$app->session;
?>

<div class="row">
    <div class="col-sm-12">
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
                <?php if($storeCount < $session['allowed_stores']) { ?>
                <span class="pull-right">
                    <?= Html::a('Create Store', ['create'], ['class' => 'btn btn-primary btn-xs']) ?>
                </span>
                <?php } ?>
            </header>
            <div class="panel-body">
                <?= GridView::widget([
					'dataProvider' => $dataProvider,
					//'filterModel' => $searchModel,
					'tableOptions' =>['class' => 'table'],
					'columns' => [
						['class' => 'yii\grid\SerialColumn'],
			
						//'id',
						//'account_id',
						/*[
							'label' => 'Account Name',
							'value' => function ($data){ return $data->accounts->account_name; },
						],*/
						[
							'attribute' => 'account_id',
							'label' => 'Account Name',
							'value' => 'accounts.account_name'
						],
						'store_name',
						'store_branch',
						//'address',
						// 'tax_invoice',
						'abn_number',
						// 'image',
						// 'welcome_notif',
						// 'received_notif',
						// 'ready_notif',
						//'status',
						[
							'attribute'	=> 'status',
							'filter'	=> ['1' => 'Active', '0' => 'Inactive'],
							'value'		=> function($data) { if($data->status == 1) { return "Active"; } else { return "Inactive"; } },
						],
			
						['class' => 'yii\grid\ActionColumn'],
					],
				]); ?>
            </div>
        </section>
    </div>            
</div>
