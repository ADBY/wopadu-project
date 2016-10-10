<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\OrderDetails */
/*
$this->title = 'Update Order Details: ' . ' ' . $model->id;
//$this->params['breadcrumbs'][] = ['label' => 'Orders', 'url' => ['orders/index', 's' => $model->store_id]];
$this->params['breadcrumbs'][] = ['label' => 'Order Details', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->id, 'url' => ['view', 'id' => $model->id]];
$this->params['breadcrumbs'][] = 'Update';
*/
$this->title = "Update Ordered Item";
$this->params['breadcrumbs'][] = ['label' => 'Orders', 'url' => ['orders/index', 's'=> $order->store_id]];
$this->params['breadcrumbs'][] = ['label' => 'Order Number: '.$order->order_number, 'url' => ['orders/view', 'id'=> $order->id]];
//$this->params['breadcrumbs'][] = ['label' => 'Order Details', 'url' => ['index', 'o' => $order->id]];
$this->params['breadcrumbs'][] = 'Update Item';

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
						//'item_option' => $item_option,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
