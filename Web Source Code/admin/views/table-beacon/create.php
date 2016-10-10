<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\TableBeacon */

$this->title = 'Add New Table';
$this->params['breadcrumbs'][] = ['label' => 'Tables', 'url' => ['index', 's' => $_GET['s']]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="table-beacon-create">
    <div class="row">
    	<?php if(empty($beacons)) { ?>
		<div class="col-sm-12">
            <div class="alert alert-danger fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong>No Beacons found. Please add beacons first.</strong>
            </div>
        </div>
		<?php } else { ?>
        
        <div class="col-lg-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model' => $model,
						'beacons' => $beacons,
						'tables' => $tables,
						'beacons_distance' => $beacons_distance,
						'error' => $error,
                    ]) ?>
                </div>
            </section>
        </div>
        <?php } ?>
    </div>
</div>