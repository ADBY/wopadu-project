<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\DeviceRegistered */

$this->title = $model->device_id;
$this->params['breadcrumbs'][] = ['label' => 'Device Registered', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
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
						//'id',
						//'user_id',
						[
							'attribute' => 'User Name',
							'value' => $model->user->first_name. ' '.$model->user->last_name,
						],
						'device_id',
						'notif_id',
						//'type',
						[
							'attribute' => 'type',
							'value'		=> $model->type == 1 ? 'iOs':'Android',
						],
						'reg_datetime',
						//'status',
						[
							'attribute' => 'status',
							'value'		=> $model->status == 1 ? 'Active':'Inactive',
						],
					],
				]) ?>
            </div>
        </section>
    </div>
</div>
