<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\AppRating */

$this->title = 'Create App Rating';
$this->params['breadcrumbs'][] = ['label' => 'App Ratings', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="app-rating-create">
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