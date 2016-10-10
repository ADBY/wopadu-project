<?php
namespace app\controllers;
use Yii;
use app\models\Stores;
use app\models\StoresSearch;
use app\models\Categories;
use app\models\Orders;
//use app\models\ItemOptionMain;
//use app\models\Kitchens;
use app\models\Beacons;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\web\UploadedFile;
/**
 * StoresController implements the CRUD actions for Stores model.
 */
class StoresController extends Controller
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
     * Lists all Stores models.
     * @return mixed
     */
    public function actionIndex()
    {
		$session = Yii::$app->session;
		
		//print_r($session['stores_list']);
		//exit;
		
        $searchModel = new StoresSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
		
		/*$model = Stores::find()
			->select('id, account_id, store_name, store_branch, tax_invoice, abn_number')
			->where('account_id = '.Yii::$app->user->id)
			->all();
		*/
		$session = Yii::$app->session;
		//$totalStores = Yii::$app->db->createCommand('SELECT COUNT(id) FROM stores where account_id = '.$session['account_id']);
		//$storeCount = $totalStores->queryScalar();
		$stores_list = $session['stores_list'];
		$storeCount = count($stores_list);
		
        return $this->render('index', [
            'searchModel' 	=> $searchModel,
            'dataProvider' 	=> $dataProvider,
			'storeCount'	=> $storeCount
        ]);
		/*return $this->render('index', [
            'model' 		=> $model,
			'storeCount'	=> $storeCount
        ]);*/
    }
    /**
     * Displays a single Stores model.
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
     * Creates a new Stores model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
		$session = Yii::$app->session;
		//$totalStores = Yii::$app->db->createCommand('SELECT COUNT(id) FROM stores where account_id = '.$session['account_id']);
		//$storeCount = $totalStores->queryScalar();
		
		$stores_list = $session['stores_list'];
		$storeCount = count($stores_list);
		$gen_error = "";
		
		if($storeCount >= $session['allowed_stores']) {
			$this->redirect(['index']);
		}
        
        $model = new Stores();
        if($model->load(Yii::$app->request->post()))
		{
			$stores_list = $session['stores_list'];
			$storeCount = count($stores_list);
			if($storeCount >= $session['allowed_stores']) {
				return $this->redirect(['index']);
			}
			
			$model->account_id = $session['account_id'];
			$upImage = UploadedFile::getInstance($model, 'image');
			$model->image = $upImage;
			
			if($upImage != "")
			{
				$ext = pathinfo($model->image, PATHINFO_EXTENSION);
				$model->image = time()."-".rand(1000,9999).'.'.$ext;
			}
			
			$language = Yii::$app->db->createCommand("SELECT language_lc, language_code FROM languages WHERE status = 1")->queryAll();
			
			if($model->store_name != "") {				
				foreach($language as $lang) {
					$name_in_lang = "store_name_".$lang['language_lc'];
					$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model->store_name, "en", $lang['language_code']);
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
			
			if($gen_error == "" && $model->description != "") {
				foreach($language as $lang) {
					$name_in_lang = "description_".$lang['language_lc'];
					$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model->description, "en", $lang['language_code']);
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
					$upImage->saveAs('images/stores/'.$model->image);
				}
				
				//$session["stores_list"] = [$model->id => $model->store_name];
				$session_store_list = $session["stores_list"];
				$session_store_list[$model->id] = $model->store_name;
				$session->set('stores_list', $session_store_list);
				
				Yii::$app->session->setFlash('stores', 'Store has been added');
            	return $this->redirect(['view', 'id' => $model->id]);
       		}
		}
		return $this->render('create', [
			'model' => $model,
			'gen_error' => $gen_error,
		]);
    }
    /**
     * Updates an existing Stores model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$session = Yii::$app->session;
		
        $model = $this->findModel($id);
		$old_image = $model->image;
		$gen_error = "";
		
        if ($model->load(Yii::$app->request->post()))
		{
			$upImage = UploadedFile::getInstance($model, 'image');
			
			$model->image = $upImage;
			
			if($upImage != "")
			{
				$ext = pathinfo($model->image, PATHINFO_EXTENSION);
				$model->image = time()."-".rand(1000,9999).'.'.$ext;
			}
			else
			{
				$model->image = $old_image;
			}
			//exit;
			if ($model->validate()) 
			{				
				if($model->save())
				{
					if($upImage != "")
					{
						$upImage->saveAs('images/stores/'.$model->image);
						
						if($old_image != "" && file_exists('images/stores/'.$old_image))
						{
							unlink('images/stores/'.$old_image);
						}
					}
					
					//unset($session["stores_list.$id"]);
					//$session["stores_list.".$id] = $model->store_name;
					//$session["stores_list"] = [$model->id => $model->store_name];
					
					$session_store_list = $session["stores_list"];
					$session_store_list[$model->id] = $model->store_name;
					$session->set('stores_list', $session_store_list);
					
					Yii::$app->session->setFlash('stores', 'Store has been updated');
					return $this->redirect(['view', 'id' => $model->id]);
				}
			}
        }
		return $this->render('update', [
			'model' => $model,
			'gen_error' => $gen_error,
		]);
    }
    /**
     * Deletes an existing Stores model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
        $session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		$model = $this->findModel($id);
		if(!array_key_exists($id, $stores_list)) {
			$this->redirect(['index']);
		}
		
		// Beacons, Categories, Categories Discount, Employee, Login User, Items, Items Discount, Item Options, Item Variety, 
		// Kitchens, Orders, Order Details, Order Complete, Request Water, Store, Stripe Accounts, Waiter, Waiter Update
		
		// Employees
		// Login User
		$employee_check = Yii::$app->db->createCommand("SELECT id FROM employee WHERE store_id = $id")->queryOne();
		if($employee_check) {
			Yii::$app->session->setFlash('stores', 'Please delete employees first to delete store');
			return $this->redirect(['view', 'id' => $id]);
		}
		
		// Kitchens
		$kitchen_check = Yii::$app->db->createCommand("SELECT id FROM kitchens WHERE store_id = $id")->queryOne();
		if($kitchen_check) {
			Yii::$app->session->setFlash('stores', 'Please delete area first to delete store');
			return $this->redirect(['view', 'id' => $id]);
		}
		
		$store_id = $id;
		// Beacons
		Beacons::deleteAll(['store_id' => $store_id]);
		
		// Categories
		// Categories Discount
		// Items
		// Items Discount
		// Item Variety 		+ Foreign Key constraint
		// Orders 				+ Foreign Key constraint
		// Order Details 		+ Foreign Key constraint
		// Order Complete
		$category_check = Yii::$app->db->createCommand("SELECT id FROM categories WHERE store_id = $store_id")->queryAll();
		if($category_check)
		{
			foreach($category_check as $cc)
			{
				$id = $cc['id'];
				$model_c = Categories::findOne($id);
				$store_id = $model_c->store_id;
				
				if($model_c->parent_id == 0)
				{
					$sub_cat_check = Yii::$app->db->createCommand("SELECT id FROM categories WHERE parent_id = $id")->queryAll();
					if($sub_cat_check)
					{
						foreach($sub_cat_check as $sc)
						{
							$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = ".$sc['id'])->queryAll();
							if($sub_prod_check)
							{
								foreach($sub_prod_check as $sp)
								{
									ItemsController::deleteItemCustom(['id' => $sp['id'], 'store_id' => $store_id]);
								}
							}					
							CategoriesController::deleteCategoriesAll(['id' => $sc['id'], 'store_id' => $store_id]);
						}
					}
					else
					{
						$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $id")->queryAll();
						if($sub_prod_check)
						{
							foreach($sub_prod_check as $sp)
							{
								ItemsController::deleteItemCustom(['id' => $sp['id'], 'store_id' => $store_id]);
							}
						}
					}
				}
				else
				{
					$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $id")->queryAll();
					if($sub_prod_check)
					{
						foreach($sub_prod_check as $sp)
						{
							ItemsController::deleteItemCustom(['id' => $sp['id'], 'store_id' => $store_id]);
						}
					}
				}
				CategoriesController::deleteCategoriesAll(['id' => $id, 'store_id' => $store_id]);
			}
		}
		
		// Item Options
		// This will be deleted by foreign key contraint - apply CASCADE action ON DELETE store_id in item_option_main table and item_option_sub table
		
		// Request Water
		Yii::$app->db->createCommand("DELETE FROM `request_water` WHERE `store_id` = $store_id")->execute();
		
		// Stripe Accounts
		Yii::$app->db->createCommand("DELETE FROM `stripe_accounts` WHERE `store_id` = $store_id")->execute();
		
		// Waiter
		Yii::$app->db->createCommand("DELETE FROM `waiter` WHERE `store_id` = $store_id")->execute();
		
		// Waiter Update
		Yii::$app->db->createCommand("DELETE FROM `waiter_update` WHERE `store_id` = $store_id")->execute();
		
		// Redelete if anything wrong
		Orders::deleteAll(['store_id' => $store_id]);
			
		if($model->image != "" && file_exists('images/stores/'.$model->image))
		{
			@unlink('images/stores/'.$model->image);
		}
		$model->delete();
		
		$session_store_list = $session["stores_list"];
		unset($session_store_list[$store_id]);
		$session->set('stores_list', $session_store_list);
		
		Yii::$app->session->setFlash('stores', 'Store has been deleted');
        return $this->redirect(['index']);
    }
    /**
     * Finds the Stores model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return Stores the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Stores::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
	
	/*public function actionSession()
	{
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		echo "<pre>";
		print_r($stores_list);
		echo "</pre>";
		exit;
	}*/
}
