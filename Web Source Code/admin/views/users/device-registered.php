<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\DeviceRegisteredSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Device Registered';
//$this->params['breadcrumbs'][] = $this->title;

//$this->title = $user->first_name." ".$user->last_name;
$this->params['breadcrumbs'][] = ['label' => 'Users', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $user->first_name." ".$user->last_name, 'url' => ['view', 'id'=>$user->id]];
$this->params['breadcrumbs'][] = $this->title;

?>

<div class="row">
    <div class="col-sm-12">
    	<?php if(Yii::$app->session->hasFlash('device')) { ?>
        <div class="alert alert-warning fade in">
            <button type="button" class="close close-sm" data-dismiss="alert">
            	<i class="fa fa-times"></i>
            </button>
            <strong><?= Yii::$app->session->getFlash('device') ?></strong>
        </div>
        <?php } ?>
        <section class="panel panel-primary">
            <header class="panel-heading">
                <?= Html::encode($this->title) ?>
                <?php /*?><span class="pull-right">
                    <?= Html::a('Add Device', ['create'], ['class' => 'btn btn-primary btn-xs']) ?>
                </span><?php */?>
            </header>
            <div class="panel-body">
                <?= GridView::widget([
					'dataProvider' => $dataProvider,
					'tableOptions' => ['class' => 'table'],
					//'filterModel' => $searchModel,
					'columns' => [
						['class' => 'yii\grid\SerialColumn'],
			
						//'id',
						//'user_id',
						/*[
							'attribute' => 'user_id',
							'label' => 'User Name',
							'value' => 'user.first_name',
						],*/
						//'device_id',
						[
							'attribute' => 'device_id',
							'label' => 'Device id',
							'contentOptions' => ['class' => 'wrapping-text'],
							'options' => ['style' => 'width:120px;'],
						],
						//'notif_id',
						[
							'attribute' => 'notif_id',
							'label' => 'Notification id',
							'contentOptions' => ['class' => 'wrapping-text']
						],
						//'type',
						[
							'attribute' => 'type',
							'filter'	=> ["1"=>"iOs","2"=>"Android"],
							'format'	=> 'text',
							'content'	=> function($data){ if($data->type == 1) { return "iOs"; } else { return "Android"; } },
						],
						//'reg_datetime',
						[
							'attribute' => 'reg_datetime',
							'format' => ['date', 'php:j-n-Y g:i A'],
						],
						//'status',
						[
							'class' => 'yii\grid\ActionColumn',
							'template' => '{delete}',
							'options' => ['style' => 'width:80px;'],
							'buttons' => [
								'delete' => function ($url, $model, $key) {
									return Html::a('<span class="fa fa-trash-o"></span> Delete', ['delete-device', 'id'=>$model->id, 'uid' => $_GET['id']], ['title' => 'View' ,'style' => '', 'class' => 'btn btn-xs btn-danger', 'data-confirm' => 'Are you sure you want to delete this item ?']);
								},
							],
						],
					],
				]); ?>
            </div>
        </section>
    </div>            
</div>