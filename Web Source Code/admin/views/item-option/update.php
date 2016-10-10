<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\ItemOption */

$this->title = 'Update : ' . ' ' . $model->option_name;

if(isset($_GET['s'])) {
$this->params['breadcrumbs'][] = ['label' => 'Menu', 'url' => ['categories/list', 's' => $_GET['s']]];
$this->params['breadcrumbs'][] = ['label' => 'Item Options', 'url' => ['index', 's' => $_GET['s']]];
} else {
$this->params['breadcrumbs'][] = ['label' => 'Category: '.$category->category_name, 'url' => ['categories/list', 's' => $category->store_id]];
$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['items/index', 'c' => $item->category_id]];
$this->params['breadcrumbs'][] = ['label' => $item->item_name, 'url' => ['items/view', 'id' => $item->id, 'c' => $item->category_id]];
}
$this->params['breadcrumbs'][] = 'Update Option';
?>

<div class="item-option-update">
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
						'store_id' => $store_id,
						//'item' => $item,
						//'category' => $category,
						'gen_error' => $gen_error,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>