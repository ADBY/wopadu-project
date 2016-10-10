<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\ItemVarietySearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Item Varieties';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="item-variety-index">
	<div class="row">
    <div class="col-sm-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
				<?= Html::encode($this->title) ?>
                
		            <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                        
                <span class="pull-right">
                	<?= Html::a('Create Item Variety', ['create'], ['class' => 'btn btn-success btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">

	        <?= GridView::widget([
            	'dataProvider' => $dataProvider,
            	'filterModel' => $searchModel,
        		'columns' => [
                	['class' => 'yii\grid\SerialColumn'],
    
					            'id',
            'item_id',
            'variety_name',
            'variety_price',
    
                    ['class' => 'yii\grid\ActionColumn'],
                ],
            ]); ?>
                 </div>
        </section>
    </div>
</div>
</div>