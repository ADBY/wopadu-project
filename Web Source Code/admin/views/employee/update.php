<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Employee */

$this->title = 'Update Employee';
$this->params['breadcrumbs'][] = ['label' => 'Employees', 'url' => ['index', 's'=>$model_e->store_id]];
$this->params['breadcrumbs'][] = ['label' => $model_e->emp_name, 'url' => ['view', 'id' => $model_e->id]];
$this->params['breadcrumbs'][] = 'Update';
?>

<div class="employee-update">
    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model_l' => $model_l,
						'model_e' => $model_e,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>