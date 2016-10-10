<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Orders */

$this->title = 'Update Orders: ' . ' ' . $model->order_number;
$this->params['breadcrumbs'][] = ['label' => 'Orders', 'url' => ['index', 's' => $model->store_id]];
$this->params['breadcrumbs'][] = ['label' => "Order Number: ".$model->order_number, 'url' => ['view', 'id' => $model->id]];
$this->params['breadcrumbs'][] = 'Update';



?>


    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model' => $model,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>