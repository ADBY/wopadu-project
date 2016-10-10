<?php

namespace app\controllers;
use Yii;
use app\models\Items;
use app\models\ItemsSearch;
use app\models\ItemVariety;
use app\models\ItemOption;
use app\models\ItemOptionMain;
use app\models\ItemOptionSub;
use app\models\ItemDiscount;
use app\models\ItemDiscountDaterange;
use app\models\ItemDiscountDays;
use app\models\Categories;
use app\models\OrderDetails;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\web\UploadedFile;
/**
 * ItemsController implements the CRUD actions for Items model.
 */
class ItemsController extends Controller
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
     * Lists all Items models.
     * @return mixed
     */
    public function actionIndex()
    {
        //$searchModel = new ItemsSearch();
        //$dataProvider = $searchModel->search(Yii::$app->request->queryParams);
		$searchModel = new ItemsSearch();
		$queryParams = array_merge(array(),Yii::$app->request->getQueryParams());
		if(isset($_GET['c'])) {
			$queryParams["ItemsSearch"]["category_id"] = $_GET['c'];
			$category = Categories::find()->where(['id'=>$_GET['c']])->one();
		} else {
			$this->redirect(['categories/list']);
		}
		$dataProvider = $searchModel->search($queryParams);
		return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
			'category'	=> $category,
        ]);
    }
    /**
     * Displays a single Items model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
		if(!isset($_GET['c'])) {
			$this->redirect(['categories/list']);
		} else {
			$category = Categories::find()->where(['id'=>$_GET['c']])->one();
		}
		
		$model = $this->findModel($id);
		if($model->has_variety > 0) {
			//$item_variety = ItemVariety::find()->where(['item_id' => $id])->all();
			$item_variety_ids = Yii::$app->db->createCommand("SELECT * from item_variety WHERE item_id = $id")->queryAll();
			$i = 0;
			$item_variety = [];
			foreach($item_variety_ids as $item)
			{
				$item_variety[] = $item;
				$i++;
			}
		} else {
			$item_variety = [];
		}
		
		if($model->no_of_option > 0) {
			$item_options_ids = Yii::$app->db->createCommand("SELECT option_main_id from item_option WHERE item_id = $id")->queryAll();
			$i = 0;
			$item_options = [];
			foreach($item_options_ids as $item)
			{
				$opt_list = Yii::$app->db->createCommand("SELECT IOM.id, IOM.option_name, IOS.sub_name, IOS.sub_amount FROM item_option_main as IOM INNER JOIN item_option_sub as IOS ON IOS.option_id = IOM.id WHERE IOM.id = ".$item['option_main_id'])->queryAll();
				$item_options[] = $opt_list;
				$i++;
			}
			
		} else {
			$item_options = [];
		}
        return $this->render('view', [
            'model' => $model,
			'category' => $category,
			'item_variety' => $item_variety,
			'item_options' => $item_options,
        ]);
    }
    /**
     * Creates a new Items model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
		$session = Yii::$app->session;
		
		$stores_list = $session['stores_list'];
		
		$first_store_id = key($stores_list);
		
		$gen_error = "";
		
		if(!isset($_GET['c'])) {
			$this->redirect(['categories/list?s='.$first_store_id]);
		} else {
			$category = Categories::find(['id', 'store_id', 'category_name'])->where(['id' => $_GET['c']])->one();
			//$store = Stores::find(['id', 'store_name'])->where(['id' => $category->store_id])->one();
			if(!$category || !array_key_exists($category->store_id, $stores_list))
			{
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
		}
		
        $model = new Items();
        if($model->load(Yii::$app->request->post()))
		{
			$upImage = UploadedFile::getInstance($model, 'images');
			$model->images = $upImage;
			
			if($upImage != "")
			{
				$ext = pathinfo($model->images, PATHINFO_EXTENSION);
				$model->images = time()."-".rand(1000,9999).'.'.$ext;
			}
			$model->added_datetime = date("Y-m-d H:i:s");
			$model->no_of_option = 0;
			
			$language = Yii::$app->db->createCommand("SELECT language_lc, language_code FROM languages WHERE status = 1")->queryAll();
			
			if($model->item_name != "") {				
				foreach($language as $lang) {
					$name_in_lang = "item_name_".$lang['language_lc'];
					$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model->item_name, "en", $lang['language_code']);
					if($translated_array['response'] == "OK")
					{
						$model->$name_in_lang = $translated_array['translation'];
					}
					else
					{
						$gen_error = $translated_array['response'];
						break;
					}
				}
			}
			
			if($gen_error == "" && $model->item_description != "") {
				foreach($language as $lang) {
					$name_in_lang = "item_description_".$lang['language_lc'];
					$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model->item_description, "en", $lang['language_code']);
					if($translated_array['response'] == "OK")
					{
						$model->$name_in_lang = $translated_array['translation'];
					}
					else
					{
						$gen_error = $translated_array['response'];
						break;
					}
				}
			}
			
			if($gen_error == "" && $model->save())
			{
				if($upImage != "")
				{
					$upImage->saveAs('images/items/'.$model->images);
				}
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $category->store_id, 'type' => 'i']);
				Yii::$app->session->setFlash('items', 'Product has been added');
            	return $this->redirect(['view', 'id' => $model->id, 'c' => $model->category_id]);
        	}
		}
		
        return $this->render('create', [
        	'model' => $model,
			'category' => $category,
			'gen_error' => $gen_error,
        ]);
    }
    /**
     * Updates an existing Items model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		$first_store_id = key($stores_list);
		$gen_error = "";
		
		if(!isset($_GET['c']))
		{
			$this->redirect(['categories/list']);
		}
		else
		{
			$category = Categories::find()->where(['id'=>$_GET['c']])->one();
			if(!$category || !array_key_exists($category->store_id, $stores_list))
			{
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
		}
		
        $model = $this->findModel($id);
		
		$old_image = $model->images;
        if ($model->load(Yii::$app->request->post()))
		{
			$upImage = UploadedFile::getInstance($model, 'images');
			
			$model->images = $upImage;
			
			if($upImage != "")
			{
				$ext = pathinfo($model->images, PATHINFO_EXTENSION);
				$model->images = time()."-".rand(1000,9999).'.'.$ext;
			}
			else
			{
				$model->images = $old_image;
			}
					
			if($model->save())
			{
				if($upImage != "")
				{
					$upImage->saveAs('images/items/'.$model->images);
					if($old_image != "" && file_exists('images/items/'.$old_image))
					{
						@unlink('images/items/'.$old_image);
					}
				}
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $category->store_id, 'type' => 'i']);
				Yii::$app->session->setFlash('items', 'Product has been updated');
            	return $this->redirect(['view', 'id' => $model->id, 'c' => $model->category_id]);
        	}
        }
		return $this->render('update', [
			'model' => $model,
			'category' => $category,
			'gen_error' => $gen_error,
		]);
    }
    /**
     * Deletes an existing Items model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		$first_store_id = key($stores_list);

		$model = $this->findModel($id);
		$category_id = $model->category_id;
		
		$category = Categories::find()->where(['id'=>$category_id])->one();
		$store_id = $category->store_id;
		if(!$category || !array_key_exists($category->store_id, $stores_list))
		{
			$this->redirect(['categories/list?s='.$first_store_id]);
		}
		
		$this->deleteItemCustom(['id' => $id, 'store_id' => $store_id]);
		
		/*$images = $model->images;
		
		// Delete discounts applied on item
		$item_discount = ItemDiscount::findAll(['item_id' => $id]);
		if($item_discount)
		{
			foreach($item_discount as $discount)
			{
				$discount_id = $discount->discount_id;
				if($discount->promotion_main_type == 1) {
					ItemDiscountDaterange::findOne($discount_id)->delete();
				} else if($discount->promotion_main_type == 2) {
					ItemDiscountDays::findOne($discount_id)->delete();
				}
			}
			ItemDiscount::deleteAll(['item_id' => $id]);
		}
		
		// Delete all variety of item if available
		ItemVariety::deleteAll(['item_id' => $id]);
		
		// Delete all options of items if available
		ItemOption::deleteAll(['item_id' => $id]);
		
		// Delete all orders of items if available
		OrderDetails::deleteAll(['item_id' => $id]);
		// Add foreign key constraints on DELETE to CASCADE for order_complete table on all keys
		
		Yii::$app->db->createCommand("DELETE FROM orders USING orders LEFT JOIN order_details ON(orders.id = order_details.order_id) WHERE orders.store_id = $store_id AND order_details.order_id IS NULL")->execute();
		
		if($model->delete()) {
			Yii::$app->mycomponent->updateWaiterSync(['store_id' => $category->store_id, 'type' => 'i']);
			if($images != "" && file_exists('images/items/'.$images)) {
				@unlink('images/items/'.$images);
			}
		}
		*/
		Yii::$app->session->setFlash('items', 'Product has been deleted');
        return $this->redirect(['index', 'c' => $category_id]);
    }
	
	public function deleteItemCustom($data)
	{
		$id 		= $data['id'];
		$store_id 	= $data['store_id'];
		
		$model = Items::findOne($id);
		
		$images = $model->images;
		
		// Delete discounts applied on item
		$item_discount = ItemDiscount::findAll(['item_id' => $id]);
		if($item_discount)
		{
			foreach($item_discount as $discount)
			{
				$discount_id = $discount->discount_id;
				if($discount->promotion_main_type == 1) {
					ItemDiscountDaterange::findOne($discount_id)->delete();
				} else if($discount->promotion_main_type == 2) {
					ItemDiscountDays::findOne($discount_id)->delete();
				}
			}
			ItemDiscount::deleteAll(['item_id' => $id]);
		}
		
		// Delete all variety of item if available
		ItemVariety::deleteAll(['item_id' => $id]);
		
		// Delete all options of items if available
		ItemOption::deleteAll(['item_id' => $id]);
		
		// Delete all orders of items if available
		OrderDetails::deleteAll(['item_id' => $id]);
		// Add foreign key constraints on DELETE to CASCADE for order_complete table on all keys
		
		Yii::$app->db->createCommand("DELETE FROM orders USING orders LEFT JOIN order_details ON(orders.id = order_details.order_id) WHERE orders.store_id = $store_id AND order_details.order_id IS NULL")->execute();

		if($model->delete()) {
			Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'i']);
			if($images != "" && file_exists('images/items/'.$images)) {
				@unlink('images/items/'.$images);
			}
		}
	}
	
    /**
     * Finds the Items model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return Items the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Items::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
