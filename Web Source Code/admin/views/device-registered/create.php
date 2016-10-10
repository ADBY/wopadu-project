<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\DeviceRegistered */

$this->title = 'Add Registered Device';
$this->params['breadcrumbs'][] = ['label' => 'Devices Registered', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<?php /*?><div class="device-registered-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div><?php */?>
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
