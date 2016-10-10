<?php

namespace app\controllers;
use Yii;
use app\models\ItemVariety;
use app\models\ItemVarietySearch;
use app\models\Items;
use app\models\Categories;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
/**
 * ItemVarietyController implements the CRUD actions for ItemVariety model.
 */
class ItemVarietyController extends Controller
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
     * Lists all ItemVariety models.
     * @return mixed
     */
    public function actionIndex()
    {
        $searchModel = new ItemVarietySearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);
    }
    /**
     * Displays a single ItemVariety model.
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
     * Creates a new ItemVariety model.
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
			//$store = Stores::find(['id', 'store_name'])->where(['id' => $category->store_id])->one();
			if(!$item || !$category || $category->id != $_GET['c'] || !array_key_exists($category->store_id, $stores_list)) {
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
		}
		
        $model = new ItemVariety();
        if ($model->load(Yii::$app->request->post()))
		{
			if($model->save())
			{
				//$item->has_variety = 1;
				//$item->save();
				$item->updateCounters(['has_variety' => 1]);
				
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $category->store_id, 'type' => 'iv']);
				Yii::$app->session->setFlash('items', 'Product variety has been added');
            	return $this->redirect(['items/view', 'id' => $item->id, 'c' => $item->category_id]);
			}
        }
		return $this->render('create', [
			'model' => $model,
			'item' => $item,
			'category' => $category,
		]);
    }
    /**
     * Updates an existing ItemVariety model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		$first_store_id = key($stores_list);
		
		if(!isset($_GET['c']) || !isset($_GET['i'])) {
			$this->redirect(['categories/list?s='.$first_store_id]);
		} else {
			$item = Items::find(['id', 'category_id', 'item_name'])->where(['id'=>$_GET['i']])->one();
			$category = Categories::find(['id', 'store_id', 'category_name'])->where(['id' => $item->category_id])->one();
			//$store = Stores::find(['id', 'store_name'])->where(['id' => $category->store_id])->one();
			if(!$item || !$category || $category->id != $_GET['c'] || !array_key_exists($category->store_id, $stores_list)) {
				$this->redirect(['categories/list?s='.$first_store_id]);
			}
		}
		
        $model = $this->findModel($id);
        if ($model->load(Yii::$app->request->post()) && $model->save()) {
			Yii::$app->mycomponent->updateWaiterSync(['store_id' => $category->store_id, 'type' => 'iv']);
			Yii::$app->session->setFlash('items', 'Product variety has been updated');
           	return $this->redirect(['items/view', 'id' => $item->id, 'c' => $item->category_id]);
        } else {
            return $this->render('update', [
                'model' => $model,
				'item' => $item,
				'category' => $category,
            ]);
        }
    }
    /**
     * Deletes an existing ItemVariety model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id, $i, $c)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		$first_store_id = key($stores_list);
				
		$item = Items::find(['id', 'category_id', 'item_name'])->where(['id'=>$i])->one();
		$category = Categories::find(['id', 'store_id', 'category_name'])->where(['id' => $item->category_id])->one();
		
		if(!$item || !$category || $category->id != $c || !array_key_exists($category->store_id, $stores_list)) {
			$this->redirect(['categories/list?s='.$first_store_id]);
		}
		
        $model = $this->findModel($id);
		$model->delete();
		
		//$check_variety_exist = Yii::$app->db->createCommand("SELECT id FROM item_variety WHERE item_id = $i")->queryOne();
		
		//if(!$check_variety_exist) {
		//	$item->has_variety = 0;
		//	$item->save();			
		//}
		
		//$item = Items::findOne($item_id);
		$item->has_variety = $item->has_variety - 1;
		$item->save();
		
		Yii::$app->mycomponent->updateWaiterSync(['store_id' => $category->store_id, 'type' => 'iv']);
		Yii::$app->session->setFlash('items', 'Product variety has been deleted');
		return $this->redirect(['items/view', 'id' => $item->id, 'c' => $item->category_id]);
    }
    
	/**
     * Finds the ItemVariety model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return ItemVariety the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
	 
    protected function findModel($id)
    {
        if (($model = ItemVariety::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
