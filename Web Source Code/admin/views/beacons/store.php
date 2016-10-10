<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\BeaconsSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Beacons';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="beacons-index">
	<div class="row">
    <div class="col-sm-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
				<?= Html::encode($this->title) ?>
		            <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                <span class="pull-right">
                	<?= Html::a('Create Beacons', ['create'], ['class' => 'btn btn-primary btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">
				<?= GridView::widget([
                    'dataProvider' => $dataProvider,
                    //'filterModel' => $searchModel,
					'tableOptions' => ['class' => 'table'],
                    'columns' => [
                        ['class' => 'yii\grid\SerialColumn'],    
                        //'id',
                        'store_id',
                        'beacon_major',
                        'beacon_minor',
                        //'added_datetime',
                        ['class' => 'yii\grid\ActionColumn', 'template' => '{view}{delete}'],
                    ],
                ]); ?>
			</div>
        </section>
    </div>
</div>