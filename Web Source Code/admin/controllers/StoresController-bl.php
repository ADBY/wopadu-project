<?php

namespace app\controllers;

use Yii;
use app\models\Stores;
use app\models\StoresSearch;
//use app\models\Categories;
//use app\models\Orders;
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
			
			if($model->save())
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
		
		// Check if category exists or not
		// Orders, Categories, ItemOptionMain, Kitchens, Beacons.
		
		$order_check = Yii::$app->db->createCommand("SELECT id FROM orders WHERE store_id = $id")->queryOne();
		if($order_check) {
			Yii::$app->session->setFlash('stores', 'Please delete orders first to delete store');
			return $this->redirect(['view', 'id' => $id]);
		}
		
		$category_check = Yii::$app->db->createCommand("SELECT id FROM categories WHERE store_id = $id")->queryOne();
		if($category_check) {
			Yii::$app->session->setFlash('stores', 'Please delete categories first to delete store');
			return $this->redirect(['view', 'id' => $id]);
		}
		
		$item_option_check = Yii::$app->db->createCommand("SELECT id FROM item_option_main WHERE store_id = $id")->queryOne();
		if($item_option_check) {
			Yii::$app->session->setFlash('stores', 'Please delete product options first to delete store');
			return $this->redirect(['view', 'id' => $id]);
		}
		
		$kitchen_check = Yii::$app->db->createCommand("SELECT id FROM kitchens WHERE store_id = $id")->queryOne();
		if($kitchen_check) {
			Yii::$app->session->setFlash('stores', 'Please delete kitchen first to delete store');
			return $this->redirect(['view', 'id' => $id]);
		}
		
		$kitchen_check = Yii::$app->db->createCommand("SELECT id FROM waiter WHERE store_id = $id")->queryOne();
		if($kitchen_check) {
			Yii::$app->session->setFlash('stores', 'Please delete waiters first to delete store');
			return $this->redirect(['view', 'id' => $id]);
		}
		
		/*$beacons_check = Yii::$app->db->createCommand("SELECT id FROM beacons WHERE store_id = $id")->queryOne();
		if($beacons_check) {
			Yii::$app->session->setFlash('stores', 'Please delete beacons first to delete store');
			return $this->redirect(['view', 'id' => $id]);
		}*/

		Beacons::deleteAll(['store_id' => $id]);
			
		if($model->image != "" && file_exists('images/stores/'.$model->image))
		{
			@unlink('images/stores/'.$model->image);
		}

		$model->delete();
		
		$session_store_list = $session["stores_list"];
		unset($session_store_list[$id]);
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
