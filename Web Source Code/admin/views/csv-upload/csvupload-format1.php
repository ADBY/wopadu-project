<?php

namespace app\controllers;
use Yii;


use yii\helpers\Html;
use yii\helpers\ArrayHelper;
use yii\widgets\ActiveForm;
//use app\models\Stores;
use app\models\Categories;
use app\models\Items;
use app\models\ItemVariety;
use app\models\ItemOption;
use app\models\ItemOptionMain;
use app\models\ItemOptionSub;

use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/* @var $this yii\web\View */
/* @var $model app\models\Categories */
/* @var $form yii\widgets\ActiveForm */

$this->title = 'Upload CSV';
$this->params['breadcrumbs'][] = ['label' => 'Menu', 'url' => ['categories/list', 's'=>$_GET['s']]];
$this->params['breadcrumbs'][] = $this->title;

$session = Yii::$app->session;
?>

<div class="categories-create">
	<div class="row">
		<div class="col-md-12">
			<section class="panel panel-primary">
				<header class="panel-heading">
				<?= Html::encode($this->title) ?>
				</header>
				<div class="panel-body">
					<form class="form-horizontal" role="form" enctype="multipart/form-data" action="" method="post">
						<div class="form-group" style="margin-top:20px">
							<label for="exampleInputFile2" class="col-lg-3 col-sm-3 control-label">Select File</label>
							<div class="col-lg-7">
								<input type="file" id="" name="csvfile" style="padding-top: 5px;">
							</div>
						</div>
                        <input type="hidden" name="_csrf" value="<?=Yii::$app->request->getCsrfToken()?>" />
						<div class="form-group">
							<div class="col-lg-offset-3 col-lg-7">
                            <br />
								<button type="submit" class="btn btn-success">Import</button>
                                <a href="<?php echo Yii::$app->urlManager->createUrl('csv-upload/download-sample?s='.$_GET['s']); ?>" class="btn btn-primary">Download Sample</a>
							</div>
						</div>
					</form>
				</div>
			</section>
			
			<div class="panel panel-warning" id="upload-status" style="display:none">
            	<div class="panel-heading">
                	<h3 class="panel-title">Upload Report</h3>
                </div>
                <div class="panel-body">
                    <!-- Progress bar holder -->
                    <div id="progress" style="width:100%;/*border:1px solid #ccc;*/"></div>
                    <!-- Progress information -->
                    <div id="information" class="text-info" style="width"></div><br />

<?php

$added_datetime = date("Y-m-d H:i:s");

if(isset($_FILES['csvfile']) && $_FILES['csvfile']['error'] == 0)
{
	/*echo '<script>$("#upload-status").css("display", "visible");</script>';*/
	echo '<script>document.getElementById("upload-status").style.display  = "block";</script>';
	//Import uploaded file to Database
	$handle = fopen($_FILES['csvfile']['tmp_name'], "r");
	
	$fp = file($_FILES['csvfile']['tmp_name']);
	$total_lines_csv = count($fp);
	
	/*echo '<script>alert("'.$total_lines_csv.'")</script>';*/

	$i = 0;
	$error = "";
	//$success_msg = "";
	
	$store_id = $_GET['s'];
	
	$language = Yii::$app->db->createCommand("SELECT language_lc, language_code FROM languages WHERE status = 1")->queryAll();
	
	$tax_array_db = Yii::$app->db->createCommand("SELECT * FROM tax")->queryAll();
	$tax_array = [];
	
	foreach($tax_array_db as $ta)
	{
		$tax_array[] = $ta['tax_percentage'];
	}
	
	/*echo "<pre>";
	print_r($tax_array);
	echo "</pre>";*/

	$area_array_db = Yii::$app->db->createCommand("SELECT id, kitchen_name FROM kitchens WHERE store_id = $store_id")->queryAll();
	$area_array = [];
	foreach($area_array_db as $aa)
	{
		$area_array[$aa['id']] = $aa['kitchen_name'];
	}

	$type_cat 			= "category";
	$type_pro 			= "product";
	$type_prod_var 		= "product-variety";
	$type_prod_main 	= "product-option";
	$type_prod_sub 		= "options";

	$type_name_array = [$type_cat, $type_pro, $type_prod_var, $type_prod_main, $type_prod_sub];

	while (($data = fgetcsv($handle, 1000, ",")) !== FALSE)
	{
		$error_individual = "";

		$type_name_err 				= true;
		$category_err 				= true;
		$product_err 				= true;
		$product_variety_err 		= true;
		$product_option_main_err 	= true;
		$product_option_sub_err 	= true;
		$tax_err 					= true;
		$area_err 					= true;
		
		if($i > 15)
		{
			$type_name 		= $data[0];
			$parameter_1 	= $data[1];
			$parameter_2 	= $data[2];
			$parameter_3 	= $data[3];
			$parameter_4 	= $data[4];
			$parameter_5 	= $data[5];
				
			if($type_name == "" && $parameter_1 == "" && $parameter_2 == "" && $parameter_3 == "" && $parameter_4 == "" && $parameter_5 == "")
			{
				$type_name_err = true;
			}
			else if(in_array($type_name, $type_name_array)) {
				$type_name_err = false;
			} else {
				$type_name_err = true;
				$error_individual .= '<p class="text-danger">Error in type name at line = '.($i+1).' <br /></p>';
			}
			
			if($type_name_err == false)
			{
				if($type_name == $type_cat)
				{
					if(isset($category_id)) {
						unset($category_id);
					}
					
					$category_name = $parameter_1;
					
					if($category_name == "")
					{
						$category_err = true;
						$error_individual .= '<p class="text-danger">Category name can not be empty at line = '.($i+1).' <br /></p>';
					}
					else
					{
						$check_cat = Yii::$app->db->createCommand("SELECT id FROM categories WHERE store_id = $store_id AND category_name = '$category_name' LIMIT 1")->queryOne();
						
						/*echo "<pre>";
						print_r($check_cat);
						echo "</pre>";*/
						
						if($check_cat)
						{
							$category_err = true;
							$category_id = $check_cat['id'];
							$error_individual .= '<p class="text-warning">Category name already exists at line = '.($i+1).' <br /></p>';
						}
						else
						{
							$model_cat = new Categories();
							
							$model_cat->store_id 		= $store_id;
							$model_cat->parent_id 		= 0;
							$model_cat->category_name 	= $category_name;
							$model_cat->added_datetime 	= $added_datetime;
							$model_cat->status 			= 1;
							
							foreach($language as $lang) {
								$cat_name_in_lang = "category_name_".$lang['language_lc'];
								$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model_cat->category_name, "en", $lang['language_code']);
								if($translated_array['response'] == "OK")
								{
									$model_cat->$cat_name_in_lang = $translated_array['translation'];
								}
								else
								{
									$category_err = false;
									$error_individual .= '<p class="text-danger">'.$translated_array['response'].' at line = '.($i+1).' <br /></p>';
									break;
								}
							}
							
							if($error_individual != "")
							{
								$category_err = true;
							}
							else if($model_cat->save())
							{
								Yii::$app->mycomponent->updateWaiterSync(['store_id' => $model_cat->store_id, 'type' => 'c']);
								Yii::$app->mycomponent->translateItemNotif(['type' => 2, 'item_id' => $model_cat->id]);

								$category_err = false;
								$category_id = $model_cat->id;
								$error_individual .= '<p class="text-success">Success, Category has been added. line = '.($i+1).' <br /></p>';
							}
							else
							{
								/*echo "<pre>";
								print_r($model_cat->getErrors());
								echo "</pre>";*/
								$category_err = true;
								$error_individual .= '<p class="text-danger">Sww, Category can not be saved at line = '.($i+1).' <br /></p>';
							}
						}
					}
				}
				
				if($type_name == $type_pro)
				{
					if(isset($item_id)) {
						unset($item_id);
					}
					
					if(!isset($category_id))
					{
						$product_err = true;
						$error_individual .= '<p class="text-danger">Category is not set at line = '.($i+1).' <br /></p>';
					}
					else
					{
						$item_name 			= $parameter_1;
						$item_description 	= $parameter_2;
						$price 				= $parameter_3;
						$tax_percentage 	= $parameter_4;
						$kitchen_id 		= $parameter_5;
						
						if($item_name == "" || $price == "" || $tax_percentage == "" || $kitchen_id == "")
						{
							$product_err = true;
							$error_individual .= '<p class="text-danger">Product details can not be empty at line = '.($i+1).' <br /></p>';
						}
						else if (!preg_match('/^[0-9]+(?:\.[0-9]{0,2})?$/', $price))
						{
							$product_err = true;
							$error_individual .= '<p class="text-danger">Product price is invalid at line = '.($i+1).' <br /></p>';
						}
						else if(!in_array($tax_percentage, $tax_array))
						{
							$product_err = true;
							$error_individual .= '<p class="text-danger">Tax percentage value is invalid at line = '.($i+1).' <br /></p>';
						}
						else if(!in_array($kitchen_id, $area_array))
						{
							$product_err = true;
							$error_individual .= '<p class="text-danger">Area name is invalid at line = '.($i+1).' <br /></p>';
						}
						else
						{
							$kitchen_id_key = array_search($kitchen_id, $area_array);
							
							$kitchen_id = $kitchen_id_key;
							
							$check_itm = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $category_id AND item_name = '$item_name' LIMIT 1")->queryOne();
						
							/*echo "<pre>";
							print_r($check_cat);
							echo "</pre>";*/
							
							if($check_itm)
							{
								$product_err = true;
								$item_id = $check_itm['id'];
								$error_individual .= '<p class="text-warning">Product name already exists at line = '.($i+1).' <br /></p>';
							}
							else
							{
								$model_item = new Items();
								
								$model_item->item_name 			= $item_name;
								$model_item->item_description 	= $item_description;
								$model_item->price 				= $price;
								$model_item->tax_percentage 	= $tax_percentage;
								$model_item->kitchen_id 		= $kitchen_id;
								
								$model_item->category_id 		= $category_id;
								$model_item->has_variety 		= 0;
								$model_item->no_of_option 		= 0;
								$model_item->is_new 			= 0;
								$model_item->added_datetime 	= $added_datetime;
								$model_item->status 			= 1;
								
								foreach($language as $lang)
								{
									$name_in_lang = "item_name_".$lang['language_lc'];
									$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model_item->item_name, "en", $lang['language_code']);
									if($translated_array['response'] == "OK")
									{
										$model_item->$name_in_lang = $translated_array['translation'];
									}
									else
									{
										$product_err = true;
										$error_individual .= '<p class="text-danger">'.$translated_array['response'].' at line = '.($i+1).' <br /></p>';
										break;
									}
								
									$name_in_lang = "item_description_".$lang['language_lc'];
									$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model_item->item_description, "en", $lang['language_code']);
									if($translated_array['response'] == "OK")
									{
										$model_item->$name_in_lang = $translated_array['translation'];
									}
									else
									{
										$product_err = true;
										$error_individual .= '<p class="text-danger">'.$translated_array['response'].' at line = '.($i+1).' <br /></p>';
										break;
									}
								}
								if($error_individual != "")
								{
									$product_err = true;
								}
								else if($model_item->save())
								{
									Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'i']);
									Yii::$app->mycomponent->translateItemNotif(['type' => 3, 'item_id' => $model_item->id]);
					
									$product_err = false;
									$item_id = $model_item->id;
									
									$error_individual .= '<p class="text-success">Success, Product has been added. line = '.($i+1).' <br /></p>';
								}
								else
								{
									/*echo "<pre>";
									print_r($model_item->getErrors());
									echo "</pre>";*/
									$product_err = true;
									$error_individual .= '<p class="text-danger">Sww, Product can not be saved at line = '.($i+1).' <br /></p>';
								}
							}
						}
					}					
				}
				
				// Product Variety
				if($type_name == $type_prod_var)
				{
					if(isset($variety_id)) {
						unset($variety_id);
					}
					
					if(!isset($category_id))
					{
						$product_variety_err = true;
						$error_individual .= '<p class="text-danger">Category is not set at line = '.($i+1).' <br /></p>';
					}
					else if(!isset($item_id))
					{
						$product_variety_err = true;
						$error_individual .= '<p class="text-danger">Product is not set at line = '.($i+1).' <br /></p>';
					}
					else
					{
						$variety_name 		= $parameter_1;
						$variety_price 		= $parameter_2;
						
						if($variety_name == "" || $variety_price == "")
						{
							$product_variety_err = true;
							$error_individual .= '<p class="text-danger">Product variety details can not be empty at line = '.($i+1).' <br />';
						}
						else if (!preg_match('/^[0-9]+(?:\.[0-9]{0,2})?$/', $variety_price))
						{
							$product_variety_err = true;
							$error_individual .= '<p class="text-danger">Variety price is invalid at line = '.($i+1).' <br /></p>';
						}
						else
						{
							$check_itm_var = Yii::$app->db->createCommand("SELECT id FROM item_variety WHERE item_id = $item_id AND variety_name = '$variety_name' LIMIT 1")->queryOne();
							
							if($check_itm_var)
							{
								$product_variety_err = true;
								$variety_id = $check_itm_var['id'];
								$error_individual .= '<p class="text-warning">Product variety name already exists at line = '.($i+1).' <br /></p>';
							}
							else
							{
								$model_var = new ItemVariety();
								
								$model_var->variety_name 		= $variety_name;
								$model_var->variety_price 		= $variety_price;
								
								$model_var->item_id 			= $item_id;
															
								foreach($language as $lang)
								{
									$name_in_lang = "variety_name_".$lang['language_lc'];
									$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model_var->variety_name, "en", $lang['language_code']);
									if($translated_array['response'] == "OK")
									{
										$model_var->$name_in_lang = $translated_array['translation'];
									}
									else
									{
										$product_variety_err = true;
										$error_individual .= '<p class="text-danger">'.$translated_array['response'].' at line = '.($i+1).' <br /></p>';
										break;
									}
								}
								
								if($error_individual != "")
								{
									$product_variety_err = true;
								}
								else if($model_var->save())
								{
									// Update countert in main item table for number of varieties
									$model_item->updateCounters(['has_variety' => 1]);
									
									Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'iv']);
									Yii::$app->mycomponent->translateItemNotif(['type' => 4, 'item_id' => $model_var->id]);
					
									$product_variety_err = false;
									$variety_id = $model_var->id;
									
									$error_individual .= '<p class="text-success">Success, Product variety has been added. line = '.($i+1).' <br /></p>';
								}
								else
								{
									$product_variety_err = true;
									$error_individual .= '<p class="text-danger">Sww, Product variety can not be saved at line = '.($i+1).' <br /></p>';
								}
							}
						}
					}					
				}
				
				// Product Option main
				if($type_name == $type_prod_main)
				{
					if(isset($item_option_main_id)) {
						unset($item_option_main_id);
					}
					
					if(!isset($category_id))
					{
						$product_option_main_err = true;
						$error_individual .= '<p class="text-danger">Category is not set at line = '.($i+1).' <br /></p>';
					}
					else if(!isset($item_id))
					{
						$product_option_main_err = true;
						$error_individual .= '<p class="text-danger">Product is not set at line = '.($i+1).' <br /></p>';
					}
					else
					{
						$option_name 		= $parameter_1;
						
						if($option_name == "")
						{
							$product_option_main_err = true;
							$error_individual .= '<p class="text-danger">Product list name can not be empty at line = '.($i+1).' <br /></p>';
						}
						else
						{
							$check_itm_list = Yii::$app->db->createCommand("SELECT id FROM item_option_main WHERE store_id = $store_id AND option_name = '$option_name' LIMIT 1")->queryOne();
							
							if($check_itm_list)
							{
								$product_option_main_err = true;
								$item_option_main_id = $check_itm_list['id'];
								$error_individual .= '<p class="text-warning">Product list name already exists at line = '.($i+1).' <br /></p>';
							}
							else
							{
								$model_opt_main = new ItemOptionMain();
								
								$model_opt_main->option_name 		= $option_name;
								
								$model_opt_main->store_id 			= $store_id;
															
								foreach($language as $lang)
								{
									$name_in_lang = "option_name_".$lang['language_lc'];
									$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model_opt_main->option_name, "en", $lang['language_code']);
									if($translated_array['response'] == "OK")
									{
										$model_opt_main->$name_in_lang = $translated_array['translation'];
									}
									else
									{
										$product_option_main_err = true;
										$error_individual .= '<p class="text-danger">'.$translated_array['response'].' at line = '.($i+1).' <br /></p>';
										break;
									}
								}
								
								if($error_individual != "")
								{
									$product_option_main_err = true;
								}
								else if($model_opt_main->save())
								{
									$product_option_main_err = false;
									$item_option_main_id = $model_opt_main->id;
									
									// Update countert in main item table for number of varieties
									$model_item->updateCounters(['no_of_option' => 1]);
									Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'io']);
									Yii::$app->mycomponent->translateItemNotif(['type' => 5, 'item_id' => $item_option_main_id]);
									
									$model_item_opt = new ItemOption();
									$model_item_opt->item_id = $item_id;
									$model_item_opt->option_main_id = $item_option_main_id;
									
									$model_item_opt->save();
									
									$error_individual .= '<p class="text-success">Success, Product list has been added. line = '.($i+1).' <br /></p>';
								}
								else
								{
									$product_option_main_err = true;
									$error_individual .= '<p class="text-danger">Sww, Product variety can not be saved at line = '.($i+1).' <br /></p>';
								}
							}
						}
					}					
				}
				
				// Product Option Sub
				if($type_name == $type_prod_sub)
				{
					if(!isset($category_id))
					{
						$product_option_sub_err = true;
						$error_individual .= '<p class="text-danger">Category is not set at line = '.($i+1).' <br /></p>';
					}
					else if(!isset($item_id))
					{
						$product_option_sub_err = true;
						$error_individual .= '<p class="text-danger">Product is not set at line = '.($i+1).' <br /></p>';
					}
					else if(!isset($item_option_main_id))
					{
						$product_option_sub_err = true;
						$error_individual .= '<p class="text-danger">Product list name is not set at line = '.($i+1).' <br /></p>';
					}
					else
					{
						$sub_name 			= $parameter_1;
						$sub_amount 		= $parameter_2;
						
						if($sub_name == "" || $sub_amount == "")
						{
							$product_option_sub_err = true;
							$error_individual .= '<p class="text-danger">Product option details can not be empty at line = '.($i+1).' <br /></p>';
						}
						else if (!preg_match('/^[0-9]+(?:\.[0-9]{0,2})?$/', $sub_amount))
						{
							$product_option_sub_err = true;
							$error_individual .= '<p class="text-danger">Variety price is invalid at line = '.($i+1).' <br /></p>';
						}
						else
						{
							$check_itm_sub = Yii::$app->db->createCommand("SELECT id FROM item_option_sub WHERE option_id = $item_option_main_id AND sub_name = '$sub_name' LIMIT 1")->queryOne();
							
							if($check_itm_sub)
							{
								$product_option_sub_err = true;
								$item_option_sub_id = $check_itm_sub['id'];
								$error_individual .= '<p class="text-warning">Product variety name already exists at line = '.($i+1).' <br /></p>';
							}
							else
							{
								$model_opt_sub = new ItemOptionSub();
								
								$model_opt_sub->sub_name 		= $sub_name;
								$model_opt_sub->sub_amount 		= $sub_amount;
								
								$model_opt_sub->option_id 		= $item_option_main_id;
															
								foreach($language as $lang)
								{
									$name_in_lang = "sub_name_".$lang['language_lc'];
									$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model_opt_sub->sub_name, "en", $lang['language_code']);
									if($translated_array['response'] == "OK")
									{
										$model_opt_sub->$name_in_lang = $translated_array['translation'];
									}
									else
									{
										$product_option_sub_err = true;
										$error_individual .= '<p class="text-danger">'.$translated_array['response'].' at line = '.($i+1).' <br /></p>';
										break;
									}
								}
								
								if($error_individual != "")
								{
									$product_option_sub_err = true;
								}
								else if($model_opt_sub->save())
								{
									Yii::$app->mycomponent->translateItemNotif(['type' => 6, 'item_id' => $model_opt_sub->id]);
					
									$product_option_sub_err = false;
									$opt_sub_id = $model_opt_sub->id;
									
									$error_individual .= '<p class="text-success">Success, Product option has been added. line = '.($i+1).' <br /></p>';
								}
								else
								{
									$product_option_sub_err = true;
									$error_individual .= '<p class="text-danger">Sww, Product option can not be saved at line = '.($i+1).' <br /></p>';
								}
							}
						}
					}					
				}
			}
		}
		
		$percent = intval(($i/($total_lines_csv-1)) * 100)."%";

		// Javascript for updating the progress bar and information
		echo '<script language="javascript">
		document.getElementById("progress").innerHTML="<div style=\"width:'.$percent.';background-color:#ddd;\">&nbsp;</div>";
		document.getElementById("information").innerHTML="'.$i.' row(s) processed.";
		</script>';
		
		$error .= $error_individual;
		//$success_msg .= $error_individual; 
		$i++;
	}

	fclose($handle);

	if(empty($error))
	{
		echo '<h3 class="text-success"><strong>Success!</strong> Menu has been imported succesfully.</h3>';
	}
	else
	{
		echo $error;
	}
	echo '<script language="javascript">document.getElementById("information").innerHTML="<strong>Process completed</strong>"</script>';

}
else if(isset($_FILES['csvfile']) && $_FILES['csvfile']['error'] == 4)
{
	/*echo '<script>$("#upload-status").css("display", "visible");</script>';*/
	echo '<script>document.getElementById("upload-status").style.display  = "block";</script>';
	/*echo '<script language="javascript">document.getElementById("information").innerHTML="Process completed"</script>';*/
	
	echo '<p class="text-danger"><strong>Oh snap!</strong> Please select a csv file to upload.</p>';
	
}
?>
				</div>
            </div>
		</div>			
	</div>
</div>