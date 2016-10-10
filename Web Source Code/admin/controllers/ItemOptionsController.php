<?php

namespace app\controllers;

use Yii;
use app\models\ItemOptions;
use app\models\ItemOptionsSearch;
use app\models\Items;
use app\models\Categories;
use app\models\Stores;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\web\UploadedFile;

/**
 * ItemOptionsController implements the CRUD actions for ItemOptions model.
 */
class ItemOptionsController extends Controller
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
     * Lists all ItemOptions models.
     * @return mixed
     */
    public function actionIndex()
    {
		if(!isset($_GET['i'])) {
			$this->redirect(['categories/list']);
		} else {
			$item = Items::find(['id', 'item_name'])->where(['id'=> $_GET['i']])->one();
			$category = Categories::find(['id', 'category_name'])->where(['id' => $item->category_id])->one();
			$store = Stores::find(['id', 'store_name'])->where(['id' => $category->store_id])->one();
		}
		
        $searchModel = new ItemOptionsSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);

        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
			'item' => $item,
			'category' => $category,
			'store' => $store,
        ]);
    }

    /**
     * Displays a single ItemOptions model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
		if(!isset($_GET['i'])) {
			$this->redirect(['categories/list']);
		} else {
			$model = $this->findModel($id);
			
			$item = Items::find(['id', 'item_name'])->where(['id'=>$model->item_id])->one();
			$category = Categories::find(['id', 'category_name'])->where(['id' => $item->category_id])->one();
			$store = Stores::find(['id', 'store_name'])->where(['id' => $category->store_id])->one();
		}
        return $this->render('view', [
            'model' => $model,
			'item' => $item,
			'category' => $category,
			'store' => $store,
        ]);
    }

    /**
     * Creates a new ItemOptions model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
		if(!isset($_GET['i'])) {
			$this->redirect(['categories/list']);
		} else {
			$item = Items::find(['id', 'item_name'])->where(['id'=>$_GET['i']])->one();
			$category = Categories::find(['id', 'category_name'])->where(['id' => $item->category_id])->one();
			$store = Stores::find(['id', 'store_name'])->where(['id' => $category->store_id])->one();
		}
		
        $model = new ItemOptions();

        if ($model->load(Yii::$app->request->post()))
		{
			$upImage = UploadedFile::getInstance($model, 'images');
			$model->images = $upImage;
			
			if($upImage != "") {
				$model->images = time()."-".$model->images;
			} else {
				$model->images = "";
			}
			
			if($model->save())
			{
				$model_item = Items::findOne($model->item_id);
				$model_item->updateCounters(['no_of_option' => 1]);
				//$model_item->no_of_option = $model_item->no_of_option + 1;
				//$model_item->save();
				
				if($upImage != "")
				{
					$upImage->saveAs('../images/item-options/'.$model->images);
				}
				Yii::$app->session->setFlash('item_options', 'Item Option has been added');
            	return $this->redirect(['view', 'id' => $model->id, 'i' => $model->item_id]);
        	}
		}
		return $this->render('create', [
			'model' => $model,
			'item' => $item,
			'category' => $category,
			'store' => $store,
		]);
    }

    /**
     * Updates an existing ItemOptions model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		if(!isset($_GET['i'])) {
			$this->redirect(['categories/list']);
		} else {
			$item = Items::find(['id', 'item_name'])->where(['id'=>$_GET['i']])->one();
			$category = Categories::find(['id', 'category_name'])->where(['id' => $item->category_id])->one();
			$store = Stores::find(['id', 'store_name'])->where(['id' => $category->store_id])->one();
		}
		
        $model = $this->findModel($id);
		$old_image = $model->images;
		
        if ($model->load(Yii::$app->request->post()))
		{
			$upImage = UploadedFile::getInstance($model, 'images');
			$model->images = $upImage;
			if($upImage != "") {
				$model->images = time()."-".$model->images;
			} else {
				$model->images = $old_image;
			}
			
			if($model->save()) {
				if($upImage != "")
				{
					$upImage->saveAs('../images/item-options/'.$model->images);
					if($old_image != "" && file_exists('../images/item-options/'.$old_image))
					{
						@unlink('../images/item-options/'.$old_image);
					}
				}
				Yii::$app->session->setFlash('item_options', 'Item option has been updated');
            	return $this->redirect(['view', 'id' => $model->id, 'i' => $model->item_id]);
			}
		}
		return $this->render('update', [
			'model' => $model,				
			'item' => $item,
			'category' => $category,
			'store' => $store,
		]);
    }

    /**
     * Deletes an existing ItemOptions model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
        $model = $this->findModel($id);
		
		$item_id = $model->item_id;
		
		$images = $model->images;
		
		if($model->delete()) {
			
			$model_item = Items::findOne($item_id);
			$model_item->no_of_option = $model_item->no_of_option - 1;
			$model_item->save();
			
			if($images != "" && file_exists('../images/item-options/'.$images)) {
				@unlink('../images/item-options/'.$images);
			}
		}
		
		Yii::$app->session->setFlash('item_options', 'Item option has been deleted');
        return $this->redirect(['index', 'i' => $item_id]);
    }

    /**
     * Finds the ItemOptions model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return ItemOptions the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = ItemOptions::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
