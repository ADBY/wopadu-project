<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Items */

$this->title = 'Add Product';
$this->params['breadcrumbs'][] = ['label' => 'Category: '.$category['category_name'], 'url' => ['categories/list', 's'=>$category['store_id']]];
//$this->params['breadcrumbs'][] = ['label' => $category['category_name'], 'url' => ['categories/view', 'id' => $category['id']]];
$this->params['breadcrumbs'][] = ['label' => 'Products', 'url' => ['index', 'c'=>$category['id']]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="items-create">
    <div class="row">
    	<?php $kitchens_check = Yii::$app->db->createCommand("SELECT id from kitchens WHERE store_id = ".$category->store_id)->queryOne(); 
    	if(!$kitchens_check) { ?>
        <div class="col-sm-12">
            <div class="alert alert-danger fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong>No Areas added. Please add area first to add new products.</strong>
            </div>
        </div>
        <?php } ?>
        
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?= $this->render('_form', [
                        'model' => $model,
						'category' => $category,
						'gen_error' => $gen_error,
                    ]) ?>
                </div>
            </section>
        </div>
    </div>
</div>