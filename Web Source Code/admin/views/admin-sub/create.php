<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\AdminSub */

$this->title = 'Create Admin Sub';
$this->params['breadcrumbs'][] = ['label' => 'Admin Subs', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="admin-sub-create">
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