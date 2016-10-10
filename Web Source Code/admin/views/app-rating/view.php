<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\AppRating */

$this->title = $model->user->first_name;
$this->params['breadcrumbs'][] = ['label' => 'App Ratings', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="app-rating-view">
    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <span class="pull-right">
                        <?php /*?><?= Html::a('Update', ['update', 'id' => $model->id], ['class' => 'btn btn-primary btn-xs']) ?><?php */?>
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
								'user.first_name',
								'rating',
								'review',
								//'added_date',
								[
									'attribute' => 'added_date',
									'format' => ['date', 'php:j/n/Y g:i A']
								],
                            ],
                        ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>