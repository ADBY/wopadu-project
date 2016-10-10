<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Admin */

$this->title = 'Update Profile';
//$this->params['breadcrumbs'][] = ['label' => 'Admins', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => 'Profile', 'url' => ['profile']];
$this->params['breadcrumbs'][] = 'Update';
?>
<?php /*?><div class="admin-update">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
<?php */?>

<div class="row">
    <div class="col-md-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
                <?= Html::encode($this->title) ?>
            </header>
            <div class="panel-body">
            	<?= $this->render('_form', [
					'model_a' => $model_a,
					'model_l' => $model_l,
				]) ?>
            </div>
        </section>
    </div>
</div>