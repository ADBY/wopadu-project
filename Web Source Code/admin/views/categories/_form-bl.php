<?php

use yii\helpers\Html;
use yii\helpers\ArrayHelper;
use yii\widgets\ActiveForm;
use app\models\Stores;
use app\models\Categories;

/* @var $this yii\web\View */
/* @var $model app\models\Categories */
/* @var $form yii\widgets\ActiveForm */
$session = Yii::$app->session;
?>

<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal', 'enctype'=>'multipart/form-data'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-7\">{input}{error}</div>",
		'labelOptions' => ['class' => 'col-md-3 col-sm-3 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>

	<?php if(isset($_GET['id'])) { } else if(isset($_GET['s'])) { ?>
    
	<?php /*?><?= $form->field($model, 'store_id')->hiddenInput(['maxlength' => true, 'value'=> $_GET['s']])->label(false) ?>
    
    <?= $form->field($model, 'parent_id')->hiddenInput(['value' => $_GET['c']])->label(false) ?><?php */?>
    
    <?= Html::activeHiddenInput($model, 'store_id', ['value' => $_GET['s']]) ?>
	<?= Html::activeHiddenInput($model, 'parent_id', ['value' => $_GET['c']]) ?>
    
    <?php /*?><?= $form->field($model, 'parent_id')->dropDownlist(ArrayHelper::map(Categories::find(['id', 'category_name'])->where(['store_id' => $_GET['s']])->all(), 'id', 'category_name'), ['id' => 'title', 'prompt' => 'None'])->label('Parent Category') ?><?php */?>
    
    <?php } else { ?>
    
    <?= $form->field($model, 'store_id')->dropDownlist(ArrayHelper::map(Stores::find(['id', 'store_name'])->where(['account_id' => $session['account_id']])->all(), 'id', 'store_name'), ['id' => 'title', 'prompt' => 'Select Store', 'onChange' => 'changeStore(this)'])->label('Store Name') ?>

    <?php /*?><?= $form->field($model, 'parent_id')->textInput(['maxlength' => true]) ?><?php */?>
    <?= $form->field($model, 'parent_id')->dropDownlist([''=> ''], ['id'=>'categories_parent_id'])->label('Parent Category') ?>
    
    <?php } ?>
    
    <?= $form->field($model, 'category_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter category name. E.g. Continental']) ?>
    
    <?php if(!$model->isNewRecord && $model->image_1 != "" && file_exists('images/categories/'.$model->image_1)) { ?>
    <div class="form-group field-categories-images">
	    <div class="col-md-offset-3 col-md-7">
        	<img src="../images/categories/<?= $model->image_1 ?>" title="Category Image" alt="Category Image" style="width:200px"/>
            <?php /*?><a href="<?php echo Yii::$app->urlManager->createUrl(["categories/del-image/", 'id' => $_GET['id'], 'img' => 1]); ?>" style="position:absolute; left:20px; top:5px" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i> Remove Image</a><?php */?>
        </div>
    </div>    	
	<?php } ?>

    <?= $form->field($model, 'image_1')->fileInput(['style'=>'margin-top:5px']) ?>
    
    <?php /*if((isset($_GET['id']) && $model->parent_id == 0) || (isset($_GET['c']) && $_GET['c'] == 0)) { ?>
    
    <?php if(!$model->isNewRecord && $model->image_2 != "" && file_exists('images/categories/'.$model->image_2)) { ?>
    <div class="form-group field-categories-images">
	    <div class="col-md-offset-3 col-md-7">
        	<img src="../images/categories/<?= $model->image_2 ?>" title="Category Image" alt="Category Image" style="width:200px"/>
            <a href="<?php echo Yii::$app->urlManager->createUrl(["categories/del-image/", 'id' => $_GET['id'], 'img' => 2]); ?>" style="position:absolute; left:20px; top:5px" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i> Remove Image</a>
            
        </div>
    </div>    	
	<?php } ?>

    <?= $form->field($model, 'image_2')->fileInput(['style'=>'margin-top:5px']) ?>
    
    <?php if(!$model->isNewRecord && $model->image_3 != "" && file_exists('images/categories/'.$model->image_3)) { ?>
    <div class="form-group field-categories-images">
	    <div class="col-md-offset-3 col-md-7">
        	<img src="../images/categories/<?= $model->image_3 ?>" title="Category Image" alt="Category Image" style="width:200px"/>
            <a href="<?php echo Yii::$app->urlManager->createUrl(["categories/del-image/", 'id' => $_GET['id'], 'img' => 3]); ?>" style="position:absolute; left:20px; top:5px" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i> Remove Image</a>
        </div>
    </div>    	
	<?php } ?>

    <?= $form->field($model, 'image_3')->fileInput(['style'=>'margin-top:5px']) ?>
    
    <?php }*/ ?>
    
    <?= $form->field($model, 'status')->dropDownList(['1'=>'Active', '2'=>'Deactive']) ?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Add' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
            <?php if(!$model->isNewRecord && $del_error == "") { ?>
            <?= Html::a('Delete', 
				[
					'delete', 'id' => $model->id
				],
				[
					'data-method' => 'post',
					'class' => 'btn btn-danger',
					'data-confirm' => 'Are you sure you want to delete this category?'
				]
			) ?>
            <?php } ?>
            
        </div>
    </div>

<?php ActiveForm::end(); ?>

<script>
function changeStore(x)
{
	//alert(x.value);
	$.ajax({
		url: '<?= Yii::$app->urlManager->createUrl('categories/fetch-categories') ?><?php //echo Yii::$app->urlManager->createUrl('categories/fetchCategories'); ?>',
		method: 'POST',
		data: 'x='+x.value,
		success: function(data){
			$("#categories_parent_id").html(data);
		},
		error: function(){
			alert("Something went wrong, Please try again");
		}		
	});
}
</script>
