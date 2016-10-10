<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\ItemOption */

/*$this->title = 'Create Item Option';
$this->params['breadcrumbs'][] = ['label' => 'Item Options', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;*/

$this->title = 'Add Item Option';
$this->params['breadcrumbs'][] = ['label' => 'Category: '.$category->category_name, 'url' => ['categories/list', 's' => $category->store_id]];
$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['items/index', 'c' => $item->category_id]];
$this->params['breadcrumbs'][] = ['label' => $item->item_name, 'url' => ['items/view', 'id' => $item->id, 'c' => $item->category_id]];
$this->params['breadcrumbs'][] = 'Add Option';
?>

<div class="item-option-create">
    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model' => $model,
						'options_data' => $options_data,
						'item' => $item,
						'category' => $category,
						'item_options_store' => $item_options_store,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>