<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\TableBeacon */

$this->title = 'Update Table Beacon: ' . ' ' . $model->table_id;
$this->params['breadcrumbs'][] = ['label' => 'Table Beacons', 'url' => ['index', 's' => $model->store_id]];
//$this->params['breadcrumbs'][] = ['label' => $model->id, 'url' => ['view', 'id' => $model->id]];
$this->params['breadcrumbs'][] = 'Update';
?>

<div class="table-beacon-update">
    <div class="row">
        <div class="col-lg-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model' => $model,
						'beacons' => $beacons,
						'tables' => $tables,
						'beacons_distance' => $beacons_distance,
						'error' => $error,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>