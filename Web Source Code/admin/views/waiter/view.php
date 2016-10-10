<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Waiter */

$this->title = $model->name;
$this->params['breadcrumbs'][] = ['label' => 'Waiters', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="waiter-view">
    <div class="row">
    	<?php if(Yii::$app->session->hasFlash('waiter')) { ?>
    	<div class="col-md-12">
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('waiter') ?></strong>
            </div>
        </div>
        <?php } ?>
        
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
                            //'store_id',
                            [
								'attribute' => 'Store Name',
								'value' => $model->store->store_name,
							],
							'name',
                            'email:email',
                            //'password',
                            'added_date',
                            //'status',
							[
								'attribute' => 'status',
								'value' => $model->status==1?'Active':'Inactive',
							],
                        ],
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>