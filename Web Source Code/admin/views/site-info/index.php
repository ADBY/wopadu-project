<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\SiteInfoSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Site information';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="row">
	<?php if(Yii::$app->session->hasFlash('site_info')) { ?>
    <div class="col-sm-12">
        <div class="alert alert-warning fade in">
            <button type="button" class="close close-sm" data-dismiss="alert">
                <i class="fa fa-times"></i>
            </button>
            <strong><?= Yii::$app->session->getFlash('site_info') ?></strong>
        </div>
    </div>
    <?php } ?>
    <div class="col-sm-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
				<?= Html::encode($this->title) ?>
		            <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                <span class="pull-right">
                </span>
            </header>
            <div class="panel-body">
	        <?= GridView::widget([
            	'dataProvider' => $dataProvider,
            	//'filterModel' => $searchModel,
				'tableOptions' =>['class' => 'table'],
        		'columns' => [
                	['class' => 'yii\grid\SerialColumn'],
		            //'id',
					'name',
					'value:ntext',  
                    [
						'class' => 'yii\grid\ActionColumn',
						'template' => '{update}',
						'options' => ['style' => 'width:66px;'],
						'buttons' => [
							'update' => function ($url, $model, $key) {
								return Html::a('<span class="fa fa-pencil"></span> Edit', ['update', 'id'=>$model->id], ['title' => 'Edit' ,'style' => '', 'class' => 'btn btn-xs btn-warning']);
							},
						],
					],
                ],
            ]); ?>
            </div>
        </section>
    </div>
</div>


