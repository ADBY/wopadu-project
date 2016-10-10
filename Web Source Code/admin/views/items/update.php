<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Items */

$this->title = 'Update Product: ' . ' ' . $model->item_name;
$this->params['breadcrumbs'][] = ['label' => 'Category: '.$category['category_name'], 'url' => ['categories/list', 's'=>$category['store_id']]];
//$this->params['breadcrumbs'][] = ['label' => $category['category_name'], 'url' => ['categories/view', 'id' => $model->category_id]];
$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['index', 'c' => $model->category_id]];
$this->params['breadcrumbs'][] = ['label' => $model->item_name, 'url' => ['view', 'id' => $model->id, 'c' => $model->category_id]];
$this->params['breadcrumbs'][] = 'Update';
?>

<div class="items-update">
    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model' => $model,
						'category' => $category,
						'gen_error' => $gen_error,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>