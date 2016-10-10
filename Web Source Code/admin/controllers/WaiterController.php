<?php

namespace app\controllers;

use Yii;
use app\models\Waiter;
use app\models\WaiterSearch;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * WaiterController implements the CRUD actions for Waiter model.
 */
class WaiterController extends Controller
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
     * Lists all Waiter models.
     * @return mixed
     */
    public function actionIndex()
    {
        /*$searchModel = new WaiterSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);

        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);*/
		
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		if(isset($_GET['s'])) {
			$s_id = $_GET['s'];
			if(empty($stores_list) && $s_id == 0) {
				$s_id = 0;
			} else if(empty($stores_list) && $s_id != 0) {
				$this->redirect(['index', 's'=> 0]);
			} else {
				if(!array_key_exists($s_id, $stores_list)) {
					reset($stores_list);
					$this->redirect(['index', 's'=> key($stores_list)]);
				}
			}
		} else {
			if(empty($stores_list)) {
				$this->redirect(['index', 's'=> 0]);
			} else {
				reset($stores_list);
				$this->redirect(['index', 's'=> key($stores_list)]);
			}
		}
		
        $searchModel = new WaiterSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);

        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
			'stores_list' => $stores_list
        ]);
    }

    /**
     * Displays a single Waiter model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		$model = $this->findModel($id);
		$store_id = $model->store_id;
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['index', 's'=> key($stores_list)]);
		}
		
        return $this->render('view', [
            'model' => $model,
        ]);
    }

    /**
     * Creates a new Waiter model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
        $model = new Waiter();

        if($model->load(Yii::$app->request->post()))
		{
			$model->added_date = date('Y-m-d H:i:s');
			$model->password = md5($model->password);
			
			if($model->save())
			{
				Yii::$app->session->setFlash('waiter', 'Waiter has been added.');
            	return $this->redirect(['view', 'id' => $model->id]);
			}
        }
		return $this->render('create', [
			'model' => $model,
		]);
    }

    /**
     * Updates an existing Waiter model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		$model = $this->findModel($id);
		$store_id = $model->store_id;
		$cur_password = $model->password;
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['index', 's'=> key($stores_list)]);
		}

        if ($model->load(Yii::$app->request->post()))
		{
			if($model->re_password != "") {
				if($model->password != "" && $model->password == $model->re_password) {
					$model->password = md5($model->password);
				} else {
					$model->addError('password', 'Please enter same password twice');
					$model->password = $cur_password;
				}
			} else {
				$model->password = $cur_password;
			}
			
			$err_model = $model->getErrors();
			if(isset($err_model['password'])) {
				$error_1 = true;
			} else {
				$error_1 = false;
			}
			
			if($error_1 == false && $model->validate())
			{
				if($model->save())
				{
					Yii::$app->session->setFlash('waiter', 'Waiter details has been updated.');
					return $this->redirect(['view', 'id' => $model->id]);
				}
			}
		}
		return $this->render('update', [
			'model' => $model,
		]);
    }

    /**
     * Deletes an existing Waiter model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
		$session = Yii::$app->session;		
		$stores_list = $session['stores_list'];		
		
		$model = $this->findModel($id);
		$store_id = $model->store_id;
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			Yii::$app->session->setFlash('waiter', 'Waiter does not exist.');
			$this->redirect(['index', 's'=> key($stores_list)]);
		}
		
        $model->delete();
		
		Yii::$app->session->setFlash('waiter', 'Waiter details has been deleted.');
        return $this->redirect(['index', 's' => $store_id]);
    }

    /**
     * Finds the Waiter model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return Waiter the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Waiter::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
