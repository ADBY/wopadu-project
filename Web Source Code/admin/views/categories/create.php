<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\Categories */

$this->title = 'Add Category';
$this->params['breadcrumbs'][] = ['label' => 'Categories', 'url' => ['list', 's'=>$_GET['s']]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="categories-create">
    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model' => $model,
						'del_error' => $del_error,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>