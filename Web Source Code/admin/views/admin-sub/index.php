<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Admin Sub';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="admin-sub-index">
	<div class="row">
        <div class="col-sm-12">
        	<?php if(Yii::$app->session->hasFlash('adminsub')) { ?>
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('adminsub') ?></strong>
            </div>
            <?php } ?>
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <span class="pull-right">
                        <?= Html::a('Create Sub Admin', ['create'], ['class' => 'btn btn-success btn-xs']) ?>
                    </span>
                </header>
                <div class="panel-body">
                	<?= GridView::widget([
                        'dataProvider' => $dataProvider,
						'tableOptions' =>['class' => 'table'],
                        'columns' => [
                            ['class' => 'yii\grid\SerialColumn'],
                            //'id',
							//'login_id',
                            [
								'attribute' => 'email',
								'label' => 'Email',
								'value' => 'login.email'
							],
							'first_name',
                            'last_name',
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
	</div>
</div>