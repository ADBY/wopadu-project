<?php

namespace app\controllers;
use Yii;
use app\models\Categories;
use app\models\Items;
use app\models\ItemOption;
use app\models\ItemOptionMain;
use app\models\ItemOptionSub;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
/**
 * ItemOptionController implements the CRUD actions for ItemOption model.
 */
class ItemOptionController extends Controller
{
    public function behaviors()
    {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'delete' => ['post'],
                ],
            ],
        ];
    }
    /**
     * Lists all ItemOption models.
     * @return mixed
     */
    public function actionIndex()
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		if(isset($_GET['s'])) {
			$s_id = $_GET['s'];			
			if(!array_key_exists($s_id, $stores_list)) {
				reset($stores_list);
				$this->redirect(['list', 's'=> key($stores_list)]);
			}
		} else {
			reset($stores_list);
			$this->redirect(['list', 's'=> key($stores_list)]);
		}
		
        $i = 0;
		//$item_options = [];
		
		$item_options = Yii::$app->db->createCommand("SELECT IOM.id, IOM.option_name, IOS.sub_name, IOS.sub_amount FROM item_option_main as IOM INNER JOIN item_option_sub as IOS ON IOS.option_id = IOM.id WHERE IOM.store_id = ".$_GET['s'])->queryAll();
		//$item_options[] = $opt_list;
		//$i++;
		$temp = $item_options;
		$item_options = [];
		foreach($temp as $i)
		{
			$item_options[$i['id']][] = $i;
		}
        return $this->render('index', [
            'item_options' => $item_options,
        ]);
    }
    /**
     * Displays a single ItemOption model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
        return $this->render('view', [
            'model' => $this->findModel($id),
        ]);
    }
    /**
     * Creates a new ItemOption model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		$first_store_id = key($stores_list);
		
		if(!isset($_GET['c']) || !isset($_GET['i'])) {
			$this->redirect(['categories/list?s='.$first_store_id]);
		} else {
			$item = Items::find(['id', 'category_id', 'item_name'])->where(['id'=>$_GET['i']])->one();
			$category = Categories::find(['id', 'store_id', 'category_name'])->where(['id' => $item->category_id])->one();
			if(!$item || !$category || $category->id != $_GET['c'] || !array_key_exists($category->store_id, $stores_list)) {
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
		}
		
		$item_options_store = Yii::$app->db->createCommand("SELECT id, option_name FROM item_option_main WHERE store_id = ".$category->store_id)->queryAll();
		
		$already_added_option = Yii::$app->db->createCommand("SELECT option_main_id FROM item_option WHERE item_id = ".$item->id)->queryAll();
//echo "<pre>";
//print_r($item_options_store);print_r($already_added_option);
		$temp = [];
		foreach($already_added_option as $opt)
		{
			$temp[] = $opt['option_main_id'];
		}
		
		foreach($item_options_store as $key=>$value)
		{
			if(in_array($value['id'], $temp))
			{
				unset($item_options_store[$key]);
			}
		}
		
		$item_options_store = array_values($item_options_store);
		
//print_r($item_options_store);
//echo "</pre>";
//exit;
        $model = new ItemOptionMain();
		
		$options_data = [];
		
		if(isset($_POST['ItemOptionMain']))
		{		
			if($model->load(Yii::$app->request->post()))
			{
				$model->store_id = $category->store_id;
				
				$options_data['option_name'] = $_POST['option_name'];
				$options_data['price'] = $_POST['price'];
				
				if($model->save()) {
					
					$option_main_id = $model->id;
					
					for($i = 0; $i< count($options_data['option_name']); $i++)
					{
						if($options_data['option_name'][$i] != "") {
							
							if($options_data['price'][$i] == "") {
								$options_data['price'][$i] = 0;
							}
							
							$model_sub = new ItemOptionSub();
							$model_sub->option_id = $option_main_id;
							$model_sub->sub_name = $options_data['option_name'][$i];
							$model_sub->sub_amount = $options_data['price'][$i];
							
							$model_sub->save();
						}
					}
					//store_id = $category->store_id;
					$model_item_opt = new ItemOption();
					$model_item_opt->item_id = $_GET['i'];
					$model_item_opt->option_main_id = $option_main_id;
					
					$model_item_opt->save();
					
					//$model_item = Items::findOne($model->item_id);
					//$model_item->updateCounters(['no_of_option' => 1]);
					//$model_item->no_of_option = $model_item->no_of_option + 1;
					//$model_item->save();
					$item->updateCounters(['no_of_option' => 1]);
					
					Yii::$app->mycomponent->updateWaiterSync(['store_id' => $category->store_id, 'type' => 'io']);
					Yii::$app->session->setFlash('items', 'Product option list has been added');
					return $this->redirect(['items/view', 'id' => $_GET['i'], 'c' => $_GET['c']]);
				}
	
			}
		}
		else if(isset($_POST['existing_option_save']))
		{
			if(isset($_POST['option_main_id']))
			{
				$option_main_id = $_POST['option_main_id'];
				
				foreach($option_main_id as $main_id)
				{
					$model_item_opt = new ItemOption();
					$model_item_opt->item_id = $_GET['i'];
					$model_item_opt->option_main_id = $main_id;
					
					$model_item_opt->save();
				}
				
				$count = count($option_main_id);
				$item->updateCounters(['no_of_option' => $count]);
				
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $category->store_id, 'type' => 'io']);
				Yii::$app->session->setFlash('items', 'Product option list has been added');
				return $this->redirect(['items/view', 'id' => $_GET['i'], 'c' => $_GET['c']]);
			}
			else
			{
				$options_data['error_2'] = "No options selected ";
			}
		}
		return $this->render('create', [
			'model' => $model,
			'options_data' => $options_data,
			'item' => $item,
			'category' => $category,
			'item_options_store' => $item_options_store,
		]);
    }
    /**
     * Updates an existing ItemOption model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		$first_store_id = key($stores_list);
		
		if(isset($_GET['s']))
		{
			if(!array_key_exists($_GET['s'], $stores_list)) {
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
			$store_id = $_GET['s'];
			$item = [];
			$category = [];
		}
		else if(isset($_GET['i'])) 
		{
			$item = Items::find(['id', 'category_id', 'item_name'])->where(['id'=>$_GET['i']])->one();
			$category = Categories::find(['id', 'category_name', 'store_id'])->where(['id' => $item->category_id])->one();
			if(!$item || !$category || !array_key_exists($category->store_id, $stores_list)) {
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
			$store_id = $category->store_id;
			
		}
		else
		{
			$this->redirect(['categories/list?s='.$first_store_id]);
			
		}
		
        $model = ItemOptionMain::findOne($id);
		
		$item_options = Yii::$app->db->createCommand("SELECT IOM.id, IOM.option_name, IOS.sub_name, IOS.sub_amount FROM item_option_main as IOM INNER JOIN item_option_sub as IOS ON IOS.option_id = IOM.id WHERE IOM.id = ".$id)->queryAll();
		
		$options_data = [];
		
		foreach($item_options as $i)
		{
			$options_data['option_name'][] = $i['sub_name'];
			$options_data['price'][] = $i['sub_amount'];
		}
        if ($model->load(Yii::$app->request->post()))
		{
			$options_data['option_name'] = $_POST['option_name'];
			$options_data['price'] = $_POST['price'];
			
			if($model->save())
			{
				$option_main_id = $model->id;
				
				ItemOptionSub::deleteAll(['option_id' => $option_main_id]);
				
				for($i = 0; $i< count($options_data['option_name']); $i++)
				{
					if($options_data['option_name'][$i] != "") {
						
						if($options_data['price'][$i] == "") {
							$options_data['price'][$i] = 0;
						}
						
						$model_sub = new ItemOptionSub();
						$model_sub->option_id = $option_main_id;
						$model_sub->sub_name = $options_data['option_name'][$i];
						$model_sub->sub_amount = $options_data['price'][$i];
						
						$model_sub->save();
					}
				}
				
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'io']);
				Yii::$app->session->setFlash('items', 'Product option list has been updated');
				
				if(isset($_GET['s'])) {
					return $this->redirect(['item-option/index', 's' => $_GET['s']]);
				} else if(isset($_GET['i'])) {
					return $this->redirect(['items/view', 'id' => $_GET['i'], 'c' => $item->category_id]);
				}
			}
        }
		return $this->render('update', [
			'model' => $model,
			'options_data' => $options_data,
			'store_id' => $store_id,
			'item' => $item,
			'category' => $category,
		]);
    }
    /**
     * Deletes an existing ItemOption model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		$first_store_id = key($stores_list);
			
		if(isset($_GET['s']))
		{
			if(!array_key_exists($_GET['s'], $stores_list)) {
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
			$store_id = $_GET['s'];
			
			$model = ItemOptionMain::findOne(['id' => $id, 'store_id' => $_GET['s']]);
			
			if($model)
			{
				$model_io = ItemOption::findAll(['option_main_id' => $id]);
				
				foreach($model_io as $io)
				{
					//$io->item_id;
					$item_io = Items::findOne($io->item_id);
					$item_io->no_of_option = $item_io->no_of_option - 1;
					$item_io->save();
				}
				
				ItemOption::deleteAll(['option_main_id' => $id]);
				
				$model_sub = ItemOptionSub::deleteAll(['option_id' => $id]);
				$model->delete();
				
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'io']);
				Yii::$app->session->setFlash('items', 'Product option list has been deleted');
				$this->redirect(['item-option/index', 's' => $store_id]);
			}
		}
		else if(isset($_GET['i'])) 
		{
			$item = Items::find(['id', 'category_id', 'item_name'])->where(['id'=>$_GET['i']])->one();
			$category = Categories::find(['id', 'category_name', 'store_id'])->where(['id' => $item->category_id])->one();
			if(!$item || !$category || !array_key_exists($category->store_id, $stores_list)) {
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
			$store_id = $category->store_id;
			
			if(!array_key_exists($category->store_id, $stores_list)) {
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
			
			$model = ItemOption::findOne(['option_main_id' => $id, 'item_id' => $_GET['i']]);
			$model->delete();
			
			$item->no_of_option = $item->no_of_option - 1;
			$item->save();
			
			Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'io']);
			Yii::$app->session->setFlash('items', 'Product option list has been deleted');
			$this->redirect(['items/view', 'id' => $_GET['i'], 'c' => $item->category_id]);
		}
		else
		{
			$this->redirect(['categories/list?s='.$first_store_id]);
		}
		
		// Decrease number of option counter
		//$model_item = Items::findOne($item_id);
		//$model_item->no_of_option = $model_item->no_of_option - 1;
		//$model_item->save();
        //$this->findModel($id)->delete();
        //return $this->redirect(['index']);
    }
    /**
     * Finds the ItemOption model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return ItemOption the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = ItemOption::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
