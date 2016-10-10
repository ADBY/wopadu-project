<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\WaiterSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Waiters';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="waiter-index">
	<div class="row">
    	<?php if(Yii::$app->session->hasFlash('waiter')) { ?>
        <div class="col-md-12">
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('waiter') ?></strong>
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
                    <span class="pull-right">
                        <?= Html::a('Add Waiter', ['create', 's'=>$_GET['s']], ['class' => 'btn btn-success btn-xs']) ?>
                    </span>
                </header>
                <div class="panel-body">
    
					<?= GridView::widget([
                        'dataProvider' => $dataProvider,
                        //'filterModel' => $searchModel,
						'tableOptions' =>['class' => 'table'],
                        'columns' => [
                            ['class' => 'yii\grid\SerialColumn','options' => ['style' => 'width:60px']],
							//'id',
							//'store_id',
							'name',
							'email:email',
							//'password',
							// 'added_date',
							// 'status',
							//['class' => 'yii\grid\ActionColumn'],
							[
								'class' => 'yii\grid\ActionColumn',
								'template' => '{view} {update}',
								'options' => ['style' => 'width:130px;'],
								'buttons' => [
									'view' => function ($url, $model, $key) {
										return Html::a('<span class="fa fa-eye"></span> View', ['view', 'id'=>$model->id], ['title' => 'View Details' ,'style' => '', 'class' => 'btn btn-xs btn-green-sea']);
									},
									'update' => function ($url, $model, $key) {
										return Html::a('<span class="fa fa-pencil"></span> Edit', ['update', 'id'=>$model->id], ['title' => 'Edit Details' ,'style' => '', 'class' => 'btn btn-xs btn-warning']);
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