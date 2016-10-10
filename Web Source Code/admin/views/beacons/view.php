<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Beacons */

$this->title = $model->id;
$this->params['breadcrumbs'][] = ['label' => 'Beacons', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="beacons-view">
<div class="row">
    <div class="col-md-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
            	<?= Html::encode($this->title) ?>
                <span class="pull-right">
                	<?= Html::a('Update', ['update', 'id' => $model->id], ['class' => 'btn btn-primary btn-xs']) ?>
                    <?= Html::a('Delete', ['delete', 'id' => $model->id], [
                        'class' => 'btn btn-danger btn-xs',
                        'data' => [
                            'confirm' => 'Are you sure you want to delete this item?',
                            'method' => 'post',
                        ],
                    ]) ?>
                </span>
            </header>
            <div class="panel-body">

					<?= DetailView::widget([
                        'model' => $model,
                        'attributes' => [
                            'id',
            'store_id',
            'beacon_major',
            'beacon_minor',
            'added_datetime',
                        ],
                    ]) ?>
			</div>
        </section>
    </div>
</div>
