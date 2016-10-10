<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\AppRatingSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'App Ratings';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="app-rating-index">
	<div class="row">
    	<?php if(Yii::$app->session->hasFlash('app_rating')) { ?>
        <div class="col-sm-12">
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('app_rating') ?></strong>
            </div>
        </div>
        <?php } ?>
        <div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    
                        <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                            
                    <?php /*?><span class="pull-right">
                        <?= Html::a('Create App Rating', ['create'], ['class' => 'btn btn-success btn-xs']) ?>
                    </span><?php */?>
                </header>
                <div class="panel-body">
    
                <?= GridView::widget([
                    'dataProvider' => $dataProvider,
                    //'filterModel' => $searchModel,
					'tableOptions' =>['class' => 'table'],
                    'columns' => [
                        ['class' => 'yii\grid\SerialColumn'],
        
                        //'id',
                        //'user_id',
						[
							'attribute' => 'User name',
							'label' => 'User Name',
							'value' => 'user.first_name',
						],
                        'rating',
                        'review',
                        //'added_date',
						[
							'attribute' => 'added_date',
							'format' => ['date', 'php:j/n/Y g:i A']
						],
                        /*[
                            'class' => 'yii\grid\ActionColumn',
                            'template' => '{view} {delete}',
                        ],*/
						[
							'class' => 'yii\grid\ActionColumn',
							'template' => '{view} {delete}',
							'options' => ['style' => 'width:160px;'],
							'buttons' => [
								'view' => function ($url, $model, $key) {
									return Html::a('<span class="fa fa-eye"></span> View', ['view', 'id'=>$model->id], ['title' => 'View' ,'style' => '', 'class' => 'btn btn-xs btn-green-sea']);
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
    </div>
</div>