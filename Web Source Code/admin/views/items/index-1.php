<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\ItemsSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Products';
$this->params['breadcrumbs'][] = ['label' => 'Category: '.$category['category_name'], 'url' => ['categories/list', 's'=>$category['store_id']]];
//$this->params['breadcrumbs'][] = ['label' => $category['category_name'], 'url' => ['categories/view', 'id'=>$category['id']]];
$this->params['breadcrumbs'][] = $this->title;

$store_id = $category['store_id'];
?>

<div class="items-index">
	<div class="row">
    <?php if(Yii::$app->session->hasFlash('items')) { ?>
    <div class="col-sm-12">
        <div class="alert alert-warning fade in">
            <button type="button" class="close close-sm" data-dismiss="alert">
                <i class="fa fa-times"></i>
            </button>
            <strong><?= Yii::$app->session->getFlash('items') ?></strong>
        </div>
    </div>
    <?php } ?>
        
    <div class="col-sm-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
				<?= Html::encode($this->title) ?>
		            <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                <span class="pull-right">
                	<?= Html::a('Add Product', ['create', 'c'=> $category['id']], ['class' => 'btn btn-success btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">

	        <?= GridView::widget([
            	'dataProvider' => $dataProvider,
            	//'filterModel' => $searchModel,
        		'columns' => [
                	[
						'class' => 'yii\grid\SerialColumn',
						'options' 	=> ['style' => 'width:50px'],
					],
    
					//'id',
					//'category_id',
					/*[
						'attribute' => 'category_id',
						'label' => 'Category Name',
						'value' => 'categories.category_name',
					],*/
					'item_name',
					[
						'attribute' => 'price',
						'options' 	=> ['style' => 'width:130px'],
					],
					//'images',
					//'no_of_option',
					/*[
						'attribute' => 'no_of_option',
						'format'	=> 'text',
						'content'	=> function($data){ if($data->no_of_option == 0) { return "-"; } else { return $data->no_of_option; } },
					],*/
					//'is_new',
					[
						'attribute' => 'is_new',
						'options' 	=> ['style' => 'width:130px'],
						'filter'	=> ['1' => 'Yes', '0' => 'No'],
						'format'	=> 'text',
						'content'	=> function($data){ if($data->is_new == 0) { return "-"; } else { return "Yes"; } },
					],
					
					// 'added_datetime',
					// 'status',
					/*[
						'label' => 'Variety',
						'format' => 'html',
						'options' => ['style' => 'width:80px;'],
						'value' => function ($data) use ($category) {
									return Html::a(
										'<span class="fa fa-bars"></span> Variety',
										['item-variety/item-variety', 's' => $category['store_id'], 'c'=> $category['id'], 'i'=> $data->id],
										[
											'title' => 'Product Varieties',
											'class' => 'btn btn-xs btn-green-sea'
										]
									);
								},
					],*/
					/*[
						'label' => 'Discounts',
						'format' => 'html',
						'options' => ['style' => 'width:80px;'],
						'value' => function ($data) use ($category) {
									return Html::a(
										'<span class="fa fa-tags"></span> Discounts',
										['categories/view-discount', 's' => $category['store_id'], 't'=> '2', 'i'=> $data->id],
										[
											'title' => 'Product Discounts',
											'class' => 'btn btn-xs btn-green-sea'
										]
									);
								},
					],*/
					/*[
						'label' => 'Options',
						'format' => 'html',
						'options' => ['style' => 'width:80px;'],
						'value' => function ($data) {
									return Html::a(
										'<span class="fa fa-tasks"></span> Options',
										['item-options/index', 'i'=> $data->id], 
										[
											'title' => 'Product Options',
											'class' => 'btn btn-xs btn-green-sea'
										]
									);
								},
					],*/
                    [
						'class' => 'yii\grid\ActionColumn',
						'template' => '{view} {update}',
						'options' => ['style' => 'width:160px;'],
						'buttons' => [
							'view' => function ($url, $model, $key) {
								return Html::a('<span class="fa fa-eye"></span> View', ['view', 'id'=>$model->id, 'c'=>$model->category_id], ['title' => 'View' ,'style' => 'margin-right:5px', 'class' => 'btn btn-xs btn-green-sea']);
							},
							'update' => function ($url, $model, $key) {
								return Html::a('<span class="fa fa-pencil"></span> Update', ['update', 'id'=>$model->id, 'c'=>$model->category_id], ['title' => 'Update' ,'style' => 'margin-right:5px', 'class' => 'btn btn-xs btn-warning']);
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