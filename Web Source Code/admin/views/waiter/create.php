<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\Waiter */

$this->title = 'Add Waiter';
$this->params['breadcrumbs'][] = ['label' => 'Waiters', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="waiter-create">
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