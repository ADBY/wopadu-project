<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\TranslaterUser */

$this->title = 'Update Translater User';
$this->params['breadcrumbs'][] = ['label' => 'Translater Users', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model_t->first_name.' '.$model_t->last_name, 'url' => ['view', 'id' => $model_t->id]];
$this->params['breadcrumbs'][] = 'Update';
?>

<div class="Translater-user-update">
    <div class="row">
        <div class="col-lg-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model_l' => $model_l,
						'model_t' => $model_t,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>