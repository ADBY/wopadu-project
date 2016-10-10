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
		$area_array[$aa['id']] = strtolower($aa['kitchen_name']);
	}
	
	$csv_category_array = array();

	while (($data = fgetcsv($handle, 1000, ",")) !== FALSE)
	{
		$error_individual = "";

		$category_err 				= true;
		$product_err 				= true;
		$product_variety_err 		= true;
		$tax_err 					= true;
		$area_err 					= true;
		
		if($i > 0)
		{
			$category_name			= $data[0];
			$item_name 				= $data[1];
			$item_description 		= $data[2];
			$price 					= $data[3];
			$tax_percentage			= $data[4];
			$kitchen_id				= strtolower($data[5]);
			$variety_1				= $data[6];
			$v1_price 				= $data[7];
			$variety_2				= $data[8];
			$v2_price 				= $data[9];
			$variety_3				= $data[10];
			$v3_price 				= $data[11];
			$variety_4				= $data[12];
			$v4_price 				= $data[13];
			$variety_5				= $data[14];
			$v5_price 				= $data[15];
				
			if($category_name == "")
			{
				$error_individual .= '<p class="text-danger">Category name can not be empty at line = '.($i+1).' <br /></p>';
			}
			else if($item_name == "")
			{
				$error_individual .= '<p class="text-danger">Product name can not be empty at line = '.($i+1).' <br /></p>';
			}
			else if($item_description == "")
			{
				$error_individual .= '<p class="text-danger">Product description can not be empty at line = '.($i+1).' <br /></p>';
			}
			else if($price == "")
			{
				$error_individual .= '<p class="text-danger">Product price can not be empty at line = '.($i+1).' <br /></p>';
			}
			else if($tax_percentage == "")
			{
				$error_individual .= '<p class="text-danger">Tax value can not be empty at line = '.($i+1).' <br /></p>';
			}
			else if($kitchen_id == "")
			{
				$error_individual .= '<p class="text-danger">Area name can not be empty at line = '.($i+1).' <br /></p>';
			}
			else if (!preg_match('/^[0-9]+(?:\.[0-9]{0,2})?$/', $price))
			{
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
				$category_name_lower_case = strtolower($category_name);
				
				// Category check, insert if not found
				if(isset($csv_category_array[$category_name_lower_case]))
				{
					$category_id = $csv_category_array[$category_name_lower_case];
				}
				else
				{
					$check_cat = Yii::$app->db->createCommand("SELECT id FROM categories WHERE store_id = $store_id AND category_name = '$category_name' LIMIT 1")->queryOne();
					
					if($check_cat)
					{
						$category_id = $check_cat['id'];
					}
					else
					{
						$model_cat = new Categories();
						
						$model_cat->store_id 		= $store_id;
						$model_cat->parent_id 		= 0;
						$model_cat->category_name 	= $category_name;
						$model_cat->added_datetime 	= $added_datetime;
						$model_cat->status 			= 1;
						
						foreach($language as $lang)
						{
							$cat_name_in_lang = "category_name_".$lang['language_lc'];
							$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model_cat->category_name, "en", $lang['language_code']);
							if($translated_array['response'] == "OK")
							{
								$model_cat->$cat_name_in_lang = $translated_array['translation'];
							}
							else
							{
								$error_individual .= '<p class="text-danger">Category name translation: '.$translated_array['response'].' at line = '.($i+1).' <br /></p>';
								break;
							}
						}
						
						if($error_individual == "")
						{
							if($model_cat->save())
							{
								Yii::$app->mycomponent->updateWaiterSync(['store_id' => $model_cat->store_id, 'type' => 'c']);
								Yii::$app->mycomponent->translateItemNotif(['type' => 2, 'item_id' => $model_cat->id]);
								
								$category_id = $model_cat->id;
							}
							else
							{
								/*echo "<pre>";
								print_r($model_cat->getErrors());
								echo "</pre>";*/
								$error_individual .= '<p class="text-danger">Sww, Category can not be saved at line = '.($i+1).' <br /></p>';
							}
						}
					}
				}
			
				// Product Insert
				if($error_individual == "")
				{
					if(!isset($category_id))
					{
						$error_individual .= '<p class="text-danger">Category is not set at line = '.($i+1).' <br /></p>';
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
							$item_id = $check_itm['id'];
							$error_individual .= '<p class="text-warning">Product already exists at line = '.($i+1).' <br /></p>';
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
									$error_individual .= '<p class="text-danger">'.$translated_array['response'].' at line = '.($i+1).' <br /></p>';
									break;
								}
							}
							
							if($error_individual == "")
							{
								if($model_item->save())
								{
									Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'i']);
									Yii::$app->mycomponent->translateItemNotif(['type' => 3, 'item_id' => $model_item->id]);
					
									$item_id = $model_item->id;
								}
								else
								{
									/*echo "<pre>";
									print_r($model_item->getErrors());
									echo "</pre>";*/
									$error_individual .= '<p class="text-danger">Sww, Product can not be saved at line = '.($i+1).' <br /></p>';
								}
							}
						}
					}					
				}
				
				// Product Variety
				if($error_individual == "")
				{
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
						$variety_array = array();
						
						if($variety_1 != "" && $v1_price != "")
						{
							if (!preg_match('/^[0-9]+(?:\.[0-9]{0,2})?$/', $v1_price))
							{
								$error_individual .= '<p class="text-danger">Variety price is invalid at line = '.($i+1).' <br /></p>';
							}
							else
							{
								$variety_array[] = array($variety_1, $v1_price);
							}
						}
						else if(($variety_1 == "" && $v1_price != "") || ($variety_1 != "" && $v1_price == ""))
						{
							$error_individual .= '<p class="text-danger">Product variety details can not be empty at line = '.($i+1).' <br />';
						}
						
						if($error_individual == "" && $variety_2 != "" && $v2_price != "")
						{
							if (!preg_match('/^[0-9]+(?:\.[0-9]{0,2})?$/', $v2_price))
							{
								$error_individual .= '<p class="text-danger">Variety price is invalid at line = '.($i+1).' <br /></p>';
							}
							else
							{
								$variety_array[] = array($variety_2, $v2_price);
							}
						}
						else if($error_individual == "" && (($variety_2 == "" && $v2_price != "") || ($variety_2 != "" && $v2_price == "")))
						{
							$error_individual .= '<p class="text-danger">Product variety details can not be empty at line = '.($i+1).' <br />';
						}
						
						if($error_individual == "" && $variety_3 != "" && $v3_price != "")
						{
							if (!preg_match('/^[0-9]+(?:\.[0-9]{0,2})?$/', $v3_price))
							{
								$error_individual .= '<p class="text-danger">Variety price is invalid at line = '.($i+1).' <br /></p>';
							}
							else
							{
								$variety_array[] = array($variety_3, $v3_price);
							}
						}
						else if($error_individual == "" && (($variety_3 == "" && $v3_price != "") || ($variety_3 != "" && $v3_price == "")))
						{
							$error_individual .= '<p class="text-danger">Product variety details can not be empty at line = '.($i+1).' <br />';
						}
						
						if($error_individual == "" && $variety_4 != "" && $v4_price != "")
						{
							if (!preg_match('/^[0-9]+(?:\.[0-9]{0,2})?$/', $v4_price))
							{
								$error_individual .= '<p class="text-danger">Variety price is invalid at line = '.($i+1).' <br /></p>';
							}
							else
							{
								$variety_array[] = array($variety_4, $v4_price);
							}
						}
						else if($error_individual == "" && (($variety_4 == "" && $v4_price != "") || ($variety_4 != "" && $v4_price == "")))
						{
							$error_individual .= '<p class="text-danger">Product variety details can not be empty at line = '.($i+1).' <br />';
						}
						
						if($error_individual == "" && $variety_5 != "" && $v5_price != "")
						{
							if (!preg_match('/^[0-9]+(?:\.[0-9]{0,2})?$/', $v5_price))
							{
								$error_individual .= '<p class="text-danger">Variety price is invalid at line = '.($i+1).' <br /></p>';
							}
							else
							{
								$variety_array[] = array($variety_5, $v5_price);
							}
						}
						else if($error_individual == "" && (($variety_5 == "" && $v5_price != "") || ($variety_5 != "" && $v5_price == "")))
						{
							$error_individual .= '<p class="text-danger">Product variety details can not be empty at line = '.($i+1).' <br />';
						}
						
						if($error_individual == "" && !empty($variety_array))
						{
							foreach($variety_array as $va)
							{
								$variety_name 	= $va[0];
								$variety_price 	= $va[1];
								
								$check_itm_var = Yii::$app->db->createCommand("SELECT id FROM item_variety WHERE item_id = $item_id AND variety_name = '$variety_name' LIMIT 1")->queryOne();

								if($check_itm_var)
								{
									$variety_id = $check_itm_var['id'];
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
											$error_individual .= '<p class="text-danger">'.$translated_array['response'].' at line = '.($i+1).' <br /></p>';
											break;
										}
									}
									
									if($error_individual == "")
									{
										if($model_var->save())
										{
											// Update countert in main item table for number of varieties
											$model_item->updateCounters(['has_variety' => 1]);
											
											Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'iv']);
											Yii::$app->mycomponent->translateItemNotif(['type' => 4, 'item_id' => $model_var->id]);
											$variety_id = $model_var->id;
											//$error_individual .= '<p class="text-success">Success, Product variety has been added. line = '.($i+1).' <br /></p>';
										}
										else
										{
											//$product_variety_err = true;
											$error_individual .= '<p class="text-danger">Sww, Product variety can not be saved at line = '.($i+1).' <br /></p>';
											break;
										}
									}
									else
									{
										break;
									}
								}							
							}
						}
					}					
				}
				
				if($error_individual == "")
				{
					$error_individual .= '<p class="text-success">Success, Product has been added. line = '.($i+1).' <br /></p>';
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