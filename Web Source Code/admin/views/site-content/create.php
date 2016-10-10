<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\SiteContent */

$this->title = 'Create Site Content';
$this->params['breadcrumbs'][] = ['label' => 'Site Contents', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="site-content-create">
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