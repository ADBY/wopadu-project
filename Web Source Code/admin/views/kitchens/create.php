<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\Kitchens */

$this->title = 'Add Area';
$this->params['breadcrumbs'][] = ['label' => 'Area', 'url' => ['index', 's'=>$_GET['s']]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="kitchens-create">
    <div class="row">
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        //'model_l' => $model_l,
						'model_k' => $model_k,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>