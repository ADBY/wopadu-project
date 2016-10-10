<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$type = $_GET['type'];

if($type == 1) {
	$this->title = 'Stores';
	$specific_array = ['attribute' => 'store_name', 'label' => 'Store Name', 'value' => 'stores.store_name'];
} else if($type == 2) {
	$this->title = 'Categories';
	$specific_array = ['attribute' => 'category_name', 'label' => 'Category Name', 'value' => 'categories.category_name'];
} else if($type == 3) {
	$this->title = 'Products';
	$specific_array = ['attribute' => 'item_name', 'label' => 'Item Name', 'value' => 'items.item_name'];
} else if($type == 4) {
	$this->title = 'Product Varieties';
	$specific_array = ['attribute' => 'variety_name', 'label' => 'Variety Name', 'value' => 'item_variety.variety_name'];
} else if($type == 5) {
	$this->title = 'Product Option Main';
	$specific_array = ['attribute' => 'option_name', 'label' => 'Option Name', 'value' => 'item_option_main.option_name'];
} else if($type == 6) {
	$this->title = 'Product Option Sub';
	$specific_array = ['attribute' => 'sub_name', 'label' => 'Option Sub Name', 'value' => 'item_option_sub.sub_name'];
} else {
	$this->title = 'Translate';
	$specific_array = [];
}

$this->params['breadcrumbs'][] = $this->title;
?>

<div class="Translater-user-index">
	<div class="row">
        <div class="col-sm-12">
        	<?php if(Yii::$app->session->hasFlash('translateritem')) { ?>
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('translateritem') ?></strong>
            </div>
            <?php } ?>
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
                            //'type',
                            //'item_id',
							$specific_array,
							//'action',
							[
								'attribute' => 'action',
								'format'	=> 'html',
								'label' => 'Action',
								'value' => function($data){
									if($data->action == 0) {
										return '<code style="color:#E91E63">Action Required</code>';
									} else if($data->action == 1) {
										return '<code style="color:#FF9800">Viewed</code>';
									} else if($data->action == 2) {
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
										return Html::a('<span class="fa fa-pencil"></span> Edit', ['translate-item-update', 'id'=>$model->id, 'type' => $model->type], ['title' => 'Edit Details' ,'style' => '', 'class' => 'btn btn-xs btn-warning']);
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