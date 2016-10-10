<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\ItemOption */
/* @var $form yii\widgets\ActiveForm */

$language = Yii::$app->db->createCommand("SELECT id, language_name, language_lc, language_code FROM languages WHERE status = 1")->queryAll();
?>
<?php if($model->isNewRecord) {

if(!empty($item_options_store)) {
	
echo '<h4 class="text-warning">Select from existing options</h4>
<br />';

echo '<form method="post" action="'.Yii::$app->urlManager->createUrl(['item-option/create', 'i' => $_GET['i'], 'c' => $_GET['c']]).'">';
echo '<div class="col-md-12">';
echo '<div class="col-md-10">';
$kl = 0;
foreach($item_options_store as $st_opt) {                        
	echo '<label class="checkbox-inline" style="padding: 5px 10px; margin-right: 20px;';
	if($kl == 0)
	{
		echo 'margin-left:10px';
	}
	echo '">
		<input type="checkbox" name="option_main_id[]" value="'.$st_opt['id'].'"> '.$st_opt['option_name'].'
	</label>';
	//echo '<input type="checkbox" name="option_main_id[]" value="'.$st_opt['id'].'"> '.$st_opt['option_name'];
	$kl++;
}
echo '<br />';
echo '<input type="hidden" name="_csrf" value="'.Yii::$app->request->getCsrfToken().'" />';
echo '<input type="submit" name="existing_option_save" value="Save" class="btn btn-success btn-md" style="margin:20px 0">';
echo '<span class="text-danger" style="margin-left:20px">';
if(isset($options_data['error_2'])) { echo $options_data['error_2']; }
echo '</span>';
echo '</div>';
echo '<div class="col-md-2">';
echo '<a href="'.Yii::$app->urlManager->createUrl(['item-option/index', 's' => $category->store_id]).'" class="btn btn-primary"> Edit Options </a>';
echo '</div>';
echo '</div>';
echo '</form>';
echo '<br />';
echo '<br />';

echo '<h4 class="text-warning">Add new option</h4>';
}
}
?>
<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal', 'enctype'=>'multipart/form-data'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-7\">{input}{error}</div>",
		'labelOptions' => ['class' => 'col-md-3 col-sm-3 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>

<?php if(!$model->isNewRecord) { ?>

<div class="col-md-12">
    <section class="panel">
    	<div class="col-md-3" style="float:right">
        	<select class="form-control m-bot15" onChange="dispLang(this.value)">
                <option value="0">Default Language</option>
                <?php
                foreach($language as $lang) {
					echo '<option value="'.$lang['id'].'">'.$lang['language_name'].'</option>';
				}
				?>
            </select>
        </div>
    </section>
</div>

<div class="col-md-12">
	<div class="" id="lang-0">
<?php } ?>

	<?php /*?><?php if($model->isNewRecord) { ?>
    <?= $form->field($model, 'store_id')->hiddenInput(['maxlength' => true, 'value' => $category->store_id])->label(false) ?>
    <?php } else { ?>
    <?= $form->field($model, 'store_id')->hiddenInput(['maxlength' => true, 'value' => $store_id])->label(false) ?>
    <?php } ?><?php */?>

    <?= $form->field($model, 'option_name')->textInput(['maxlength' => true]) ?>

    <div class="form-group">
    	<label class="col-md-3 col-sm-3 control-label"><strong>Product Options: </strong></label>
    </div>    
    <div id="options_div">
    	<?php //if(empty($options_data['option_name'])) { $count = 2; for($i=0; $i<2; $i++) { ?>
        <?php if(empty($options_data) || !isset($options_data['option_name'])) { $count = 2; for($i=0; $i<2; $i++) { ?>
        <div class="form-group">
            <label class="col-md-3 col-sm-3 control-label">Option Name</label>
            <div class="col-md-3">
                <input type="text" class="form-control" id="option_name_<?= $i+1 ?>" name="option_name[]" maxlength="256">
            </div>
            <label class="col-md-1 col-sm-1 control-label" >Price</label>
            <div class="col-md-3">
                <input type="text" class="form-control" id="price_<?= $i+1 ?>" name="price[]">
            </div>
        </div>
        <?php } } else { $count = count($options_data['option_name']); for($i=0; $i<$count; $i++) { ?>
        <div class="form-group">
            <label class="col-md-3 col-sm-3 control-label">Option Name</label>
            <div class="col-md-3">
                <input type="text" class="form-control" id="option_name_<?= $i+1 ?>" name="option_name[]" maxlength="256" value="<?= $options_data['option_name'][$i] ?>">
            </div>
            <label class="col-md-1 col-sm-1 control-label" >Price</label>
            <div class="col-md-3">
                <input type="text" class="form-control" id="price_<?= $i+1 ?>" name="price[]" value="<?= $options_data['price'][$i] ?>">
            </div>
        </div>
        <?php } } ?>
        <?php /*?><div class="form-group">
            <label class="col-md-3 col-sm-3 control-label">Option Name</label>
            <div class="col-md-3">
                <input type="text" class="form-control" id="option_name_2" name="option_name[]" maxlength="256">
            </div>
            <label class="col-md-1 col-sm-1 control-label">Price</label>
            <div class="col-md-3">
                <input type="text" class="form-control" id="price_2" name="price[]">
            </div>
        </div><?php */?>
    </div>
    
    <div class="form-group">
    	<div class="col-md-offset-3">
        	<div class="col-md-6"><span class="text-danger"><?php if(isset($options_data['error'])) { echo $options_data['error'];} ?></span></div>
        	<div class="col-md-3" style="text-align:right; padding-right:0">
            	<a class="btn btn-xs btn-primary" style="margin-left:15px;" onClick="newOptionAdd();">Add More</a>
            </div>
    	</div>
    </div>



<?php if(!$model->isNewRecord) { ?>

    </div>
    
	<?php foreach($language as $lang) { ?>
    <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
    <br />
	<?php
        //echo $form->field($model, 'variety_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter variety name in '.$lang['language_name']])->label('Variety Name');
		echo $form->field($model, 'option_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter options name in '.$lang['language_name']])->label("List Name");
		
		if(!empty($options_data) || isset($options_data['sub_name_'.$lang['language_lc']])) {
		$count = count($options_data['option_name']);
		?>
        <div class="form-group">
    	<label class="col-md-3 col-sm-3 control-label"><strong>Product Options: </strong></label>
    </div>  
        <?php 
		for($i=0; $i<$count; $i++)
		{
			//echo "Option - ".($i+1);
			//echo '<h4><strong>Option - '.($i+1).'</strong></h4>';
			 ?>
		
        <div class="form-group">
            <label class="col-md-3 col-sm-3 control-label"><?php echo 'Option - '.($i+1); ?></label>
            <div class="col-md-7">
	            <input type="text" class="form-control" name="sub_name_<?php echo $lang['language_lc']; ?>[]" maxlength="256" value="<?= $options_data['sub_name_'.$lang['language_lc']][$i] ?>" placeholder="Please enter options name in <?php echo $lang['language_name']; ?>">
            </div>
        </div>
        <?php 
		
		}
	}	
    ?>
    </div>
    <?php } ?>
</div>
        
<?php } ?>

    <?php /*?><div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div><?php */?>
    
    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?php if(!$model->isNewRecord) { ?>
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary', 'style' => 'margin-left:20px']) ?>
            <?php } else { ?>
            <?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
            <?php } ?>
            <?php if($gen_error != "" ){ echo '<span class="text-danger">'.$gen_error.'</span>'; } ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>

<script>
var i = <?= $count+1; ?>;
function newOptionAdd()
{
	var c = true;
	
	if(i>= 10)
	{
		alert("Maximum options limit reached")
		c = false;
		return false;
	}
	
	var j = 1;
	$('input[name^=option_name]').each(function() {
		var a = $("#option_name_"+j).val();
		var b = $("#price_"+j).val();
		if(a == "")
		{
			alert("Please enter the option name");
			c = false;
			return false;
		}
		else if(b != "" && $.isNumeric(b) == false)
		{
			alert("Please enter valid price");
			c = false;
			return false;
		}
		j++;
	});
	
	if(c == true) {
		var newdiv = '<div class="form-group"> \
			<label class="col-md-3 col-sm-3 control-label">Option Name</label> \
			<div class="col-md-3"> \
				<input type="text" class="form-control" id="option_name_'+i+'" name="option_name[]" maxlength="256"> \
			</div> \
			<label class="col-md-1 col-sm-1 control-label">Price</label> \
			<div class="col-md-3"> \
				<input type="text" class="form-control" id="price_'+i+'" name="price[]"> \
			</div> \
		</div>';
		$("#options_div").append(newdiv);
		i++;
	}
	else
	{
		return false;
	}
}

function dispLang(x)
{
	$('div[id^="lang-"]').css('display', 'none');
	$('#lang-'+x).css('display', 'block');
}
</script>
