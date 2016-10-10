<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\Employee */

$this->title = 'Add Employee';
$this->params['breadcrumbs'][] = ['label' => 'Employees', 'url' => ['index', 's'=>$_GET['s']]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="employee-create">
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