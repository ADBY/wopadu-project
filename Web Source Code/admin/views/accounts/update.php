<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Accounts */

$session = Yii::$app->session;

$this->title = 'Update Account: ' . ' ' . $model_a->account_name;
if($session['login_role'] == 2) {
	$this->params['breadcrumbs'][] = ['label' => $model_a->account_name, 'url' => ['profile']];
} else {
	$this->params['breadcrumbs'][] = ['label' => 'Accounts', 'url' => ['index']];
	$this->params['breadcrumbs'][] = ['label' => $model_a->account_name, 'url' => ['view', 'id' => $model_a->id]];
}
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
					'model_l' => $model_l,
					'model_a' => $model_a,
				]) ?>
            </div>
        </section>
    </div>
</div>