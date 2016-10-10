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
                            <select name="store_id" id="store_id" class="form-control" onChange="javascript:window.location='list?id='+this.value">
                                <?php 
                                //$stores = Stores::find('id, store_name')->where(['account_id' => $session['account_id']])->all();
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
		<?php
		/*echo "<pre>";
		print_r($categories);
		echo "</pre>";*/
		
		$items = $categories;
		$id = '';
				 
		function sub2($items, $id, $i){
			$class_array = ['primary', 'success', 'warning', 'info', 'danger', 'default'];
			foreach($items as $item){
				if($item['parent_id'] == $id){
					echo '<div class="col-md-offset-'.$i.' col-sm-'.(12-$i).'" style="padding:0">';
					echo '<section class="panel panel-'.$class_array[$i].'">';
					echo '<div class="panel-heading" style="padding:5px 10px">';
					echo $item['category_name'];
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
				echo '<section class="panel panel-primary">';
				echo '<div class="panel-heading" style="padding:5px 10px">';
				echo $item['category_name'];
				echo '<span class="tools pull-right" style="margin:0">
                                <a class="btn-xs" href="" style="padding:1px 9px"><i class="fa fa-eye"></i> View</a>
								<a class="btn-xs" href="" style="padding:1px 9px"><i class="fa fa-edit"></i> Update</a>
								<a class="btn-xs" href="" style="padding:1px 9px"><i class="fa fa-trash-o"></i> Delete</a>
                            </span>';
				echo '</div>';
				echo '</section>';
				$id = $item['id'];
				sub2($items, $id, 1);
			}
		}
        ?>   
    </div>
</div>