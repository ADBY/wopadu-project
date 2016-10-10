<?php

use yii\helpers\Html;
use yii\grid\GridView;
use yii\models\Stores;

/* @var $this yii\web\View */
/* @var $searchModel app\models\BeaconsSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Beacons';
$this->params['breadcrumbs'][] = $this->title;
$session = Yii::$app->session;
?>

<div class="beacons-index">
	<div class="row">
        <?php if(Yii::$app->session->hasFlash('beacons')) { ?>
        <div class="col-sm-12">
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('beacons') ?></strong>
            </div>
        </div>
        <?php } ?>
        
		<?php if(empty($stores_list)) { ?>
		<div class="col-sm-12">
            <div class="alert alert-danger fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong>No Store exists. Please add new store.</strong>
            </div>
        </div>
		<?php } else { ?>
        <div class="col-md-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <form class="form-horizontal adminex-form" method="get">
                        <div class="form-group">
                            <label class="col-sm-2 col-sm-2 control-label">Select Store</label>
                            <div class="col-sm-8">
                                <select name="store_id" id="store_id" class="form-control" onChange="javascript:window.location='index?s='+this.value">
                                    <?php
									foreach($stores_list as $key=>$store)
									{
										$selected = "";
										if(isset($_GET['s']) && $_GET['s'] == $key)
										{
											$selected = ' selected="selected"';
										}
										echo '<option value="'.$key.'" '.$selected.'>'.$store.'</option>';
									}
									?>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                    <?php if(isset($_GET['s'])) { ?>    
                    <span class="pull-right">
                        <?= Html::a('Create Beacons', ['create', 's'=> $_GET['s']], ['class' => 'btn btn-primary btn-xs']) ?>
                    </span>
                    <?php } ?>
                </header>
                <div class="panel-body">
                    <?= GridView::widget([
                        'dataProvider' => $dataProvider,
                        //'filterModel' => $searchModel,
                        'tableOptions' => ['class' => 'table'],
                        'columns' => [
                            ['class' => 'yii\grid\SerialColumn'],    
                            //'id',
                            //'store_id',
                            'beacon_major',
                            'beacon_minor',
							'table_id',
                            //'added_datetime',
                            //['class' => 'yii\grid\ActionColumn', 'template' => '{delete}'],
							[
								'class' => 'yii\grid\ActionColumn',
								'template' => '{update} {delete}',
								'options' => ['style' => 'width:180px;'],
								'buttons' => [
									'update' => function ($url, $model, $key) {
									return Html::a('<span class="fa fa-pencil"></span> Update', ['update', 'id'=>$model->id], ['title' => 'Update' ,'style' => '', 'class' => 'btn btn-xs btn-warning']);
									},
									'delete' => function ($url, $model, $key) {
										return Html::a('<span class="fa fa-trash-o"></span> Delete', ['delete', 'id'=>$model->id], ['title' => 'View' ,'style' => '', 'class' => 'btn btn-xs btn-danger', 'data-method' => 'post', 'data-confirm' => 'Are you sure you want to delete this item?']);
									},
								],
							],
                        ],
                    ]); ?>
                </div>
            </section>
        </div>
        
        <?php } ?>
    </div>
</div>