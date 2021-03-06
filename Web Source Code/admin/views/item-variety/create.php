<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\ItemVariety */

//$this->title = 'Add Variety';
//$this->params['breadcrumbs'][] = ['label' => 'Item Varieties', 'url' => ['index']];
//$this->params['breadcrumbs'][] = $this->title;

$this->title = 'Add Variety';
$this->params['breadcrumbs'][] = ['label' => 'Category: '.$category->category_name, 'url' => ['categories/list', 's' => $category->store_id]];
$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['items/index', 'c' => $item->category_id]];
$this->params['breadcrumbs'][] = ['label' => $item->item_name, 'url' => ['items/view', 'id' => $item->id, 'c' => $item->category_id]];
//$this->params['breadcrumbs'][] = ['label' => 'Product Variety', 'url' => ['index', 'i'=>$item->id]];
$this->params['breadcrumbs'][] = 'Add Variety';
?>

<div class="item-variety-create">
    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model' => $model,
						'item' => $item,
						'category' => $category,
						'gen_error' => $gen_error,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>