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
         
        <?php if(empty($stores_list)) { ?>
        <div class="col-sm-12">
            <div class="alert alert-danger fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong>No Store exists. Please add new store.</strong>
            </div>
        </div>
        <?php } else { ?>
        <div class="col-md-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <form class="form-horizontal adminex-form" method="get">
                        <div class="form-group">
                            <label class="col-sm-2 col-sm-2 control-label">Select Store</label>
                            <div class="col-sm-8">
                                <select name="store_id" id="store_id" class="form-control" onChange="javascript:window.location='list?s='+this.value">
                                    <?php
                                    foreach($stores_list as $key=>$store)
                                    {
                                        $selected = "";
                                        if(isset($_GET['s']) && $_GET['s'] == $key)
                                        {
                                            $selected = ' selected="selected"';
                                        }
                                        echo '<option value="'.$key.'" '.$selected.'>'.$store.'</option>';
                                    }
                                    ?>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        
        <?php /*?><div class="col-sm-12" style="text-align:right">
            <span>Main Category</span>
            <a class="btn btn-success btn-xs" style="font-family:consolas; margin-right:20px;" href="<?= Yii::$app->urlManager->createUrl(['categories/create/', 's' => $_GET['s'], 'c' => 0]) ?>"><i class="fa fa-plus"> ADD</i></a>
            <span>Product Option</span>
            <a class="btn btn-success btn-xs" style="font-family:consolas" href="<?= Yii::$app->urlManager->createUrl(['item-option/index/', 's' => $_GET['s']]) ?>"><i class="fa fa-eye"> View</i></a>
            <br /><br />
        </div><?php */?>
        
        <div class="col-sm-12">
        	<section class="panel panel-peter-river">
				<div class="panel-heading">
                	&nbsp;
                	<span class="pull-right">
                    	<span>Main Category</span>
            			<a class="btn btn-primary btn-xs" style="font-family:consolas; margin-right:20px;" href="<?= Yii::$app->urlManager->createUrl(['categories/create/', 's' => $_GET['s'], 'c' => 0]) ?>"><i class="fa fa-plus"> ADD</i></a>
                        <span>Product Option</span>
            <a class="btn btn-primary btn-xs" href="<?= Yii::$app->urlManager->createUrl(['item-option/index/', 's' => $_GET['s']]) ?>"><i class="fa fa-eye"> View</i></a>
                    </span>
                </div>
            </section>
        </div>
        
        <div class="col-sm-12">
    
		<?php
		/*echo "<pre>";
		print_r($categories);
		echo "</pre>";*/
		
		$items = $categories;
		
		if(!$items) { ?>
        
        <section class="panel">
            <header class="panel-heading">
                Categories
            </header>
            <div class="panel-body">
            	<strong> No categories found. Please add some categories.</strong>
            </div>
        </section>
                    
		<?php 
		} else {
			$id = '';
			function sub2($items, $id, $i){
				$class_array = ['primary', 'success', 'warning', 'info', 'danger', 'default'];
				foreach($items as $item){
					if($item['parent_id'] == $id){
						echo '<div class="col-md-offset-'.$i.' col-sm-'.(12-$i).'" style="padding:0">';
						echo '<section class="panel">';
						echo '<div class="panel-heading">';
						echo $item['category_name'];
						echo '<span class="pull-right">';
						
						$item_id = $item['id'];
						/*$sub_cat_exists = "no";
						foreach($items as $check_all)
						{
							if($check_all['parent_id'] == $item_id)
							{
								$sub_cat_exists = "yes";
								break;
							}
						}
						
						if($sub_cat_exists == "no")*/
						if($item['sub_cat_exists_res'] == 'NO')
						{
							echo '<a class="btn btn-xs btn-peter-river" href="'.Yii::$app->urlManager->createUrl(['items/create', 'c' => $item['id']]).'" style="margin-right:20px;"><i class="fa fa-plus-square"></i> Add Product</a>';
						}

						if($item['sub_cat_exists_res'] == 'NO' && $item['prod_exists_in_cat_res'] == 'YES')
						{
							echo '<a class="btn btn-xs btn-peter-river" href="'.Yii::$app->urlManager->createUrl(['items/index', 'c' => $item['id']]).'" style="margin-right:20px;"><i class="fa fa-indent"></i> All Product</a>';
						}

						if($item['prod_exists_in_cat_res'] == 'NO' && $i < 1)
						{
							echo '<a class="btn btn-xs btn-concrete" href="'.Yii::$app->urlManager->createUrl(['categories/create', 's' => $_GET['s'], 'c' => $item['id']]).'" style="margin-right:20px;"><i class="fa fa-plus-square"></i> Add Sub Category</a>';
						}
						
						echo '	<a class="btn btn-xs btn-green-sea" href="'.Yii::$app->urlManager->createUrl(['categories/add-discount', 's' => $_GET['s'], 't' => '1', 'i' => $item['id']]).'" style="margin-right:20px;"><i class="fa fa-plus-square"></i> Add Discount</a>';
						
						if($item['discount_exists'] == 'YES')
						{
							echo '	<a class="btn btn-xs btn-green-sea" href="'.Yii::$app->urlManager->createUrl(['categories/view-discount', 's' => $_GET['s'], 't' => '1', 'i' => $item['id']]).'" style="margin-right:20px;"><i class="fa fa-indent"></i> View Discounts</a>';
						}

						echo '<a class="btn btn-xs btn-warning" href="'.Yii::$app->urlManager->createUrl(['categories/update', 'id' => $item['id']]).'"><i class="fa fa-edit"></i> Edit</a>';
						
						echo '</span>';
						echo '</div>';
						echo '</section>';
						echo '</div>';
						echo '<div class="clearfix"></div>';
						sub2($items, $item['id'], $i+1);
					}
				}
			}				 
				
			foreach($items as $item){
				if($item['parent_id'] == 0){
					echo '<section class="panel">';
					echo '<div class="panel-heading">';
					echo $item['category_name'];
					echo '<span class="pull-right">';
					
					$item_id = $item['id'];
					/*$sub_cat_exists = "no";
					foreach($items as $check_all)
					{
						if($check_all['parent_id'] == $item_id)
						{
							$sub_cat_exists = "yes";
							break;
						}
					}

					if($sub_cat_exists == "no")*/
					if($item['sub_cat_exists_res'] == 'NO')
					{
						echo '	<a class="btn btn-xs btn-peter-river" href="'.Yii::$app->urlManager->createUrl(['items/create', 'c' => $item['id']]).'" style="margin-right:20px;"><i class="fa fa-plus-square"></i> Add Product</a>';
					}
					
					if($item['sub_cat_exists_res'] == 'NO' && $item['prod_exists_in_cat_res'] == 'YES')
					{
						echo '	<a class="btn btn-xs btn-peter-river" href="'.Yii::$app->urlManager->createUrl(['items/index', 'c' => $item['id']]).'" style="margin-right:20px;"><i class="fa fa-indent"></i> All Product</a>';
					}
					
					if($item['prod_exists_in_cat_res'] == 'NO')
					{
						echo '	<a class="btn btn-xs btn-concrete" href="'.Yii::$app->urlManager->createUrl(['categories/create', 's' => $_GET['s'], 'c' => $item['id']]).'"  style="margin-right:20px;"><i class="fa fa-plus-square"></i> Add Sub Category</a>';
					}
					
					echo '	<a class="btn btn-xs btn-green-sea" href="'.Yii::$app->urlManager->createUrl(['categories/add-discount', 's' => $_GET['s'], 't' => '1', 'i' => $item['id']]).'" style="margin-right:20px;"><i class="fa fa-plus-square"></i> Add Discount</a>';
					
					if($item['discount_exists'] == 'YES')
					{
						echo '	<a class="btn btn-xs btn-green-sea" href="'.Yii::$app->urlManager->createUrl(['categories/view-discount', 's' => $_GET['s'], 't' => '1', 'i' => $item['id']]).'" style="margin-right:20px;"><i class="fa fa-indent"></i> View Discounts</a>';
					}
										
					echo '	<a class="btn btn-xs btn-warning" href="'.Yii::$app->urlManager->createUrl(['categories/update', 'id' => $item['id']]).'"><i class="fa fa-edit"></i> Edit</a>';

					echo '</span>';
					echo '</div>';
					echo '</section>';
					$id = $item['id'];
					sub2($items, $id, 1);
				}
			}
		}
        ?>   
    	</div>
    
    <?php } ?>
	</div>
</div>