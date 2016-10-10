<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\stores */

$this->title = 'Update Store: ' . ' ' . $model->store_name;
$this->params['breadcrumbs'][] = ['label' => 'Stores', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->store_name, 'url' => ['view', 'id' => $model->id]];
$this->params['breadcrumbs'][] = 'Update';
?>
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
