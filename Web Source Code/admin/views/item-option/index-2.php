<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Item Options';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="item-option-index">
	<div class="row">
    <div class="col-sm-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
				<?= Html::encode($this->title) ?>
                
		                
                <span class="pull-right">
                	<?= Html::a('Create Item Option', ['create'], ['class' => 'btn btn-success btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">

	        <?= GridView::widget([
            	'dataProvider' => $dataProvider,
            	'columns' => [
                	['class' => 'yii\grid\SerialColumn'],
    
					            'id',
            'item_id',
            'option_main_id',
    
                    ['class' => 'yii\grid\ActionColumn'],
                ],
            ]); ?>
                 </div>
        </section>
    </div>
</div>
</div>