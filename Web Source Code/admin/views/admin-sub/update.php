<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\AdminSub */

$this->title = 'Update Admin Sub';
$this->params['breadcrumbs'][] = ['label' => 'Admin Subs', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model_a->first_name.' '.$model_a->last_name, 'url' => ['view', 'id' => $model_a->id]];
$this->params['breadcrumbs'][] = 'Update';
?>

<div class="admin-sub-update">
    <div class="row">
        <div class="col-lg-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model_l' => $model_l,
						'model_a' => $model_a,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>