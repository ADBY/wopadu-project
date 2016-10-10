<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Tax Option';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="tax-index">
	<div class="row">
        <div class="col-sm-12">
        	<?php if(Yii::$app->session->hasFlash('tax')) { ?>
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('tax') ?></strong>
            </div>
            <?php } ?>
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <span class="pull-right">
                        <?= Html::a('Add New Tax', ['create'], ['class' => 'btn btn-success btn-xs']) ?>
                    </span>
                </header>
                <div class="panel-body">
                <?= GridView::widget([
                    'dataProvider' => $dataProvider,
					'tableOptions' => ['class' => 'table'],
                    'columns' => [
                        ['class' => 'yii\grid\SerialColumn'],
                        //'id',
                        'tax_percentage',
                        //['class' => 'yii\grid\ActionColumn'],
						[
							'class' => 'yii\grid\ActionColumn',
							'template' => '{update} {delete}',
							'options' => ['style' => 'width:150px;'],
							'buttons' => [
								'update' => function ($url, $model, $key) {
									return Html::a('<span class="fa fa-pencil"></span> Edit', ['update', 'id'=>$model->id], ['title' => 'Update' ,'style' => '', 'class' => 'btn btn-xs btn-warning']);
								},
								'delete' => function ($url, $model, $key) {
									return Html::a('<span class="fa fa-trash-o"></span> Delete', ['delete', 'id'=>$model->id], ['title' => 'Delete' ,'style' => '', 'class' => 'btn btn-xs btn-danger', 'data-method' => 'post', 'data-confirm' => 'Are you sure you want to delete this item ?']);
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