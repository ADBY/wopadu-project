<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Kitchens */

$this->title = 'Update Area: ' . ' ' . $model_k->kitchen_name;
$this->params['breadcrumbs'][] = ['label' => 'Area', 'url' => ['index', 's' => $model_k->store_id]];
$this->params['breadcrumbs'][] = ['label' => $model_k->kitchen_name, 'url' => ['view', 'id' => $model_k->id]];
$this->params['breadcrumbs'][] = 'Update';
?>

<div class="kitchens-update">
    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        //'model_l' => $model_l,
						'model_k' => $model_k,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>