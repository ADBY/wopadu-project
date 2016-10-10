<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Items */

$this->title = $model->item_name;
$this->params['breadcrumbs'][] = ['label' => 'Category: '.$category['category_name'], 'url' => ['categories/list', 's'=>$category['store_id']]];
//$this->params['breadcrumbs'][] = ['label' => $category['category_name'], 'url' => ['categories/view', 'id' => $category['id']]];
$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['index', 'c' => $category['id']]];
$this->params['breadcrumbs'][] = $this->title;

/*echo "<pre>";
print_r($item_variety);
print_r($item_options);
echo "</pre>";
exit;*/


?>


<div class="items-view">
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

        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <span class="pull-right">
                        <?= Html::a('View Discounts', ['categories/view-discount', 's' => $category['store_id'], 't' => 2, 'i' => $model->id], ['class' => 'btn btn-concrete btn-xs', 'style' => 'margin-right:10px']) ?>
						<?= Html::a('Update Product', ['update', 'id' => $model->id, 'c' => $model->category_id], ['class' => 'btn btn-primary btn-xs', 'style' => 'margin-right:10px']) ?>
                        <?= Html::a('Delete Product', ['delete', 'id' => $model->id], [
                            'class' => 'btn btn-danger btn-xs',
                            'data' => [
                                'confirm' => 'Are you sure you want to delete this item?',
                                'method' => 'post',
                            ],
                        ]) ?>
                    </span>
                </header>
                <div class="panel-body">
                        <?= DetailView::widget([
                            'model' => $model,
							'options' => [
								'class' => 'table_cust_1',
							],
                            'attributes' => [
                                //'id',
                                'item_name',
                                'item_description:ntext',
                                //'item_size',
                                //'category_id',
                                [
                                    'attribute' => 'category_id',
                                    'label'		=> 'Category Name',
                                    'value'		=> $model->categories->category_name,
                                ],
                                [
                                    'attribute' => 'kitchen_id',
                                    'label'		=> 'Area',
                                    'value'		=> $model->kitchens->kitchen_name,
                                ],
                                'price',
								'tax_percentage',
                                //'images',
                                [
                                    'attribute'	=>'images',
                                    //'value'		=> "../../images/items/".$model->images,
                                    //'format' 	=> ['image',['width'=>'100']],
									'format' => 'raw',
									'value' => $model->images == "" ? "No Image" :Html::img("../images/items/".$model->images, ['alt'=>'Product', 'style'=>'width:150px'])
                                ],
                                'no_of_option',
                                /*[
									'attribute' => 'has_variety',
									'value'		=> $model->has_variety == 1 ? 'Yes' : 'No',
								],*/
								//'is_new',
                                /*[
                                    'attribute' => 'is_new',
                                    'value'		=> $model->is_new == 1 ? 'Yes' : 'No',
                                ],*/
                                //'added_datetime',
                                [
                                    'attribute' => 'status',
                                    'value'		=> $model->status == 1? 'Active':'Inactive',
                                ],
                            ],
                        ]) ?>
                </div>
            </section>
        </div>

        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    Product Varieties Available
                    <span class="pull-right">
                        <?= Html::a('Add New', ['item-variety/create', 'i' => $model->id, 'c' => $model->category_id], ['class' => 'btn btn-primary btn-xs']) ?>
                    </span>
                </header>
                <div class="panel-body">
                	<?php if($item_variety) { ?>
                	<table class="table_cust_1">
                		<tr>
                			<td style="width:33%"><strong>Name</strong> </td>
                			<td><strong>Price</strong> </td>
                			<td style="width:150px"></td>
                		</tr>
                		<?php foreach($item_variety as $variety)
						{
							echo '<tr>';
							echo '<td>'.$variety['variety_name'].'</td>';
							echo '<td>$ '.$variety['variety_price'].'</td>';
							echo '<td>';
							
							echo Html::a('<span class="fa fa-pencil"></span> Edit',
										['item-variety/update', 'id' => $variety['id'], 'i'=> $variety['item_id'], 'c'=> $_GET['c']],
										[
											'title' => 'Edit',
											'class' => 'btn btn-xs btn-green-sea'
										]
									);
							echo "&nbsp;&nbsp;&nbsp;";
							echo Html::a('<span class="glyphicon glyphicon-trash"></span> Delete',
										['item-variety/delete', 'id' => $variety['id'], 'i'=> $variety['item_id'], 'c'=> $_GET['c']],
										[
											'title' => 'Delete',
											'data-method' => 'post',
											'data-confirm' => 'Are you sure you want to delete this item?',
											'class' => 'btn btn-xs btn-danger'
										]
									);
							echo '</td>';
							echo '</tr>';
                        } ?>
                	</table>
                    <?php } else { ?>
                    No varieties added..
                    <?php } ?>
                </div>
            </section>
        </div>
       
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    Product Options Available
                    <span class="pull-right">
                        <?= Html::a('Add New', ['item-option/create', 'i' => $model->id, 'c' => $model->category_id], ['class' => 'btn btn-primary btn-xs']) ?>
                    </span>
                </header>
                <div class="panel-body">
                	<?php if($item_options) { ?>
                	<table class="table_cust_1">
                		<tr>
                			<td style="width:33%"><strong>List Name</strong> </td>
                			<td><strong>Options Name / Price</strong> </td>
                			<td style="width:150px"></td>
                		</tr>
                		<?php foreach($item_options as $option)
						{
							echo '<tr>';
							echo '<td style="vertical-align:top">'.$option[0]['option_name'].'</td>';
							echo '<td>';
							echo '<table>';
							foreach($option as $op)
							{
								//echo "<strong>".$op['sub_amount']."</strong> - ";
								//echo $op['sub_name']." <br /> ";
								echo '<tr>';
								echo '<td>'.$op['sub_name'].'</td>';
								echo '<td>$ '.$op['sub_amount'].'</td>';
								echo '</tr>';
							}
							echo '</table>';
							echo '</td>';
							//echo '<td></td>';
							echo '<td style="vertical-align:top">';
							
							echo Html::a('<span class="fa fa-pencil"></span> Edit',
										['item-option/update', 'id' => $option[0]['id'], 'i'=> $_GET['id']],
										[
											'title' => 'Edit',
											'class' => 'btn btn-xs btn-green-sea'
										]
									);
							echo "&nbsp;&nbsp;&nbsp;";
							echo Html::a('<span class="glyphicon glyphicon-trash"></span> Delete',
										['item-option/delete', 'id' => $option[0]['id'], 'i'=> $_GET['id']],
										[
											'title' => 'Delete',
											'data-method' => 'post',
											'data-confirm' => 'Are you sure you want to delete this item?',
											'class' => 'btn btn-xs btn-danger'
										]
									);
							echo '</td>';
							echo '</tr>';
                        } ?>
                	</table>
                    <?php } else { ?>
                    No options added..
                    <?php } ?>
                </div>
            </section>
        </div>
    </div>
</div>