<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Items */

$this->title = 'Add Product';
$this->params['breadcrumbs'][] = ['label' => 'Category: '.$category['category_name'], 'url' => ['categories/list', 's'=>$category['store_id']]];
//$this->params['breadcrumbs'][] = ['label' => $category['category_name'], 'url' => ['categories/view', 'id' => $category['id']]];
$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['index', 'c'=>$category['id']]];
$this->params['breadcrumbs'][] = $this->title;

$this->title = 'Add Variety';
$this->params['breadcrumbs'][] = ['label' => 'Category: '.$category->category_name, 'url' => ['categories/list', 's' => $category->store_id]];
$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['items/index', 'c' => $item->category_id]];
$this->params['breadcrumbs'][] = ['label' => $item->item_name, 'url' => ['items/view', 'id' => $item->id, 'c' => $item->category_id]];
//$this->params['breadcrumbs'][] = ['label' => 'Product Variety', 'url' => ['index', 'i'=>$item->id]];
$this->params['breadcrumbs'][] = 'Add Variety';

?>

<div class="items-create">
    <div class="row">
    	<?php $kitchens_check = Yii::$app->db->createCommand("SELECT id from kitchens WHERE store_id = ".$category->store_id)->queryOne(); 
    	if(!$kitchens_check) { ?>
        <div class="col-sm-12">
            <div class="alert alert-danger fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong>No kitchens added. Please add kitchens first to add new products.</strong>
            </div>
        </div>
        <?php } ?>
        
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model' => $model,
						'category' => $category,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>