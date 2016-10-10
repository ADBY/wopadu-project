<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Beacons */

$this->title = 'Update Beacons: ' . ' ' . $model->table_id;
$this->params['breadcrumbs'][] = ['label' => 'Beacons', 'url' => ['index', 's' => $model->store_id]];
//$this->params['breadcrumbs'][] = ['label' => $model->table_id, 'url' => ['view', 'id' => $model->id]];
$this->params['breadcrumbs'][] = 'Update - '.$model->table_id;
?>

<div class="beacons-update">
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
</div>