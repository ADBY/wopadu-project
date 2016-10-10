<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\CategoriesSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Categories';
$this->params['breadcrumbs'][] = $this->title;

$session = Yii::$app->session;
?>

<div class="categories-index">
	<div class="row">
    
    <?php if(Yii::$app->session->hasFlash('categories')) { ?>
        <div class="col-sm-12">
        <div class="alert alert-warning fade in">
            <button type="button" class="close close-sm" data-dismiss="alert">
            	<i class="fa fa-times"></i>
            </button>
            <strong><?= Yii::$app->session->getFlash('categories') ?></strong>
        </div>
        </div>
    <?php } ?>
        
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <form class="form-horizontal adminex-form" method="get">
                    <div class="form-group">
                        <label class="col-sm-2 col-sm-2 control-label">Select Store</label>
                        <div class="col-sm-8">
                            <select name="store_id" id="store_id" class="form-control" onChange="javascript:window.location='index?id='+this.value">
                                <?php 
                                $stores = Yii::$app->db->createCommand('SELECT id, store_name FROM stores where account_id = '.$session['account_id'])->queryAll();
                                foreach($stores as $store)
                                {
                                    $selected = "";
                                    if(isset($_GET['s']) && $_GET['s'] == $store['id'])
                                    {
                                        $selected = ' selected="selected"';
                                    }
                                    echo '<option value="'.$store['id'].'" '.$selected.'>'.$store['store_name'].'</option>';
                                }
                                ?>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
        
    <div class="col-sm-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
				<?= Html::encode($this->title) ?>
                
		            <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                        
                <span class="pull-right">
                	<?= Html::a('Create Categories', ['create'], ['class' => 'btn btn-primary btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">

	        <?= GridView::widget([
            	'dataProvider' => $dataProvider,
            	//'filterModel' => $searchModel,
        		'columns' => [
                	['class' => 'yii\grid\SerialColumn'],
					//'id',
					//'store_id',
					//'parent_id',
					[
						'attribute'=>'parent_id',
						'label'=>'Parent Category',
						'format'=>'text',//raw, html
						'content'=>function($data){
							$parent_name = $data->getParentName();
							if($parent_name != "") { 
								return $parent_name;
							} else {
								return "-";
							}
						}
					],
					//'parent.category_name',
					'category_name',
					//'images',
					/*[
						'attribute' => 'images',
						'format' => 'html',
						'value' => function($data) { return Html::img(Yii::$app->urlManager->baseUrl.'../../images/categories/'.$data->images, ['width'=>'100']); },
					],*/
					// 'added_datetime',
					// 'status',   
					[
						'label' => 'Add Product',
						'format' => 'raw',
						'value' => function ($data){
							return Html::a('Add', ['my-action', 'id'=>$data->id]);
							}
					],
					[
						'label' => 'View Product',
						'format' => 'raw',
						'value' => function ($data){
							return Html::a('View', ['my-action', 'id'=>$data->id]);
							}
					],
                    ['class' => 'yii\grid\ActionColumn'],
                ],
            ]); ?>
            </div>
        </section>
    </div>
</div>