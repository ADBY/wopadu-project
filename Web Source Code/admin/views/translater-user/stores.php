<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Stores';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="Translater-user-index">
	<div class="row">
        <div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
					<?= GridView::widget([
                        'dataProvider' => $dataProvider,
						'tableOptions' =>['class' => 'table'],
						/*'rowOptions' => function ($model, $index, $widget, $grid){
							if($model->action == 0){
								return ['style' => 'background-color:#FFEBEE'];
							} else if($model->action == 1){
								return ['style' => 'background-color:#FFFDE7'];
							} else if($model->action == 2){
								return ['style' => 'background-color:#E8F5E9'];
							} else {
								return [];
							}
						},*/
                        'columns' => [
                            ['class' => 'yii\grid\SerialColumn'],
                            //'id',
							//'login_id',
                            'type',
                            'item_id',
							[
								'attribute' => 'store_name',
								'label' => 'Store Name',
								'value' => 'stores.store_name'
							],
							'action',
							[
								'attribute' => 'action',
								'format'	=> 'html',
								'label' => 'Action',
								'value' => function($data){
									if($data->action == 0)
									{
										//return 'Action Required';
										return '<code style="color:#E91E63">Action Required</code>';
									}
									else if($data->action == 1)
									{
										//return 'Viewed';
										return '<code style="color:#FF9800">Viewed</code>';
									}
									else if($data->action == 2)
									{
										//return 'Updated';
										return '<code style="color:#009688">Updated</code>';
									}
								}
							],
							'added_date',
                            [
								'class' => 'yii\grid\ActionColumn',
								'template' => '{update}',
								'options' => ['style' => 'width:70px;'],
								'buttons' => [
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