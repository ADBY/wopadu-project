<?php

namespace app\controllers;

use Yii;
use app\models\Beacons;
use app\models\BeaconsSearch;
//use app\models\TableBeacon;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * BeaconsController implements the CRUD actions for Beacons model.
 */
class BeaconsController extends Controller
{
    public function behaviors()
    {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'delete' => ['post'],
					//'store'  => ['post'],
                ],
            ],
        ];
    }

    /**
     * Lists all Beacons models.
     * @return mixed
     */
    public function actionIndex()
    {
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
		
		$searchModel = new BeaconsSearch();
		$queryParams = array_merge(array(),Yii::$app->request->getQueryParams());
		$queryParams["BeaconsSearch"]["store_id"] = $s_id;
		$dataProvider = $searchModel->search($queryParams);
		
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
			'stores_list' => $stores_list,
        ]);
    }
	
	/**
     * Lists all Beacons models for single store.
     * @return mixed
     */
    public function actionStore($id)
    {
		$searchModel = new BeaconsSearch;
        $queryParams = array_merge(array(),Yii::$app->request->getQueryParams());
        $queryParams["BeaconsSearch"]["store_id"] = $id;
        $dataProvider = $searchModel->search($queryParams);
		
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single Beacons model.
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
     * Creates a new Beacons model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate($s)
    {
		/*
        $model = new Beacons();

        if ($model->load(Yii::$app->request->post()) && $model->save()) {
            return $this->redirect(['view', 'id' => $model->id]);
        } else {
            return $this->render('create', [
                'model' => $model,
            ]);
        }*/
		
		//$this->redirect([Yii::$app->request->referrer]);
		
		$model = new Beacons();
		$model->store_id = $s;
		$model->beacon_major = $s;
		$model->added_datetime = date('Y-m-d H:i:s');
		
		//$beacons = Beacons::find('beacon_minor')->where(['store_id' => $s])->all();
		
		$beacons = Yii::$app->db->createCommand("SELECT beacon_minor FROM beacons WHERE store_id = $s")->queryAll();
		
		$beacon_minor_arr = [];
		
		foreach($beacons as $b)
		{
			$beacon_minor_arr[] = $b['beacon_minor'];
		}
		
		asort($beacon_minor_arr);
		
		$beacon_minor_arr = array_values($beacon_minor_arr);
		
		$var = 0;
		foreach($beacon_minor_arr as $itm)
		{
			if($itm != ($var+1))
			{
				$b_minor_new = $itm - 1;
				break;
			}
			$var = $itm;
		}
		
		if(!isset($b_minor_new))
		{
			$b_minor_new = $var + 1;
		}
		
		$model->beacon_minor = $b_minor_new;
		$model->table_id = 'Table - '.$b_minor_new;
		
		
		//echo "<pre>";
		//echo $b_minor_new;
		//print_r($beacon_minor_arr);
		//exit;
		
		//$totalBeacons = Yii::$app->db->createCommand('SELECT MAX(`beacon_minor`) FROM beacons where store_id = '.$s)->queryScalar();
		
				
		/*if(!isset($totalBeacons))
		{
			$model->beacon_minor = 1;
			$model->table_id = 'Table - '.$model->beacon_minor;
		}
		else
		{
			$model->beacon_minor = $totalBeacons + 1;
			$model->table_id = 'Table - '.$model->beacon_minor;
		}*/
		
		$model->save();
		Yii::$app->session->setFlash('beacons', 'Beacon has been added successfully');
		$this->redirect(['index', 's' => $s]);
		
    }

    /**
     * Updates an existing Beacons model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);

        if ($model->load(Yii::$app->request->post()))
		{
			$check_tbl_name = Yii::$app->db->createCommand("SELECT id FROM beacons WHERE id != ".$id." and store_id = ".$model->store_id." and table_id = '".$model->table_id."'")->queryOne();
			
			$error_1 = true;
			if($check_tbl_name)
			{
				$model->addError('table_id', 'Table name already exits');
				$error_1 = false;
			}
			
			if($error_1 == true && $model->save()) {
				Yii::$app->session->setFlash('beacons', 'Beacon details has been updated successfully');
				return $this->redirect(['index', 's' => $model->store_id]);
			}
		}
		return $this->render('update', [
			'model' => $model,
		]);
    }

    /**
     * Deletes an existing Beacons model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
        $model = $this->findModel($id);
		
		$store_id = $model->store_id;
		$beacon_major = $model->beacon_major;
		$beacon_minor = $model->beacon_minor;
		
		Yii::$app->db->createCommand("DELETE FROM `table_beacon` WHERE store_id = '$store_id' and beacon_major = '$beacon_major' and beacon_minor = '$beacon_minor'")->execute();
		
		$model->delete();
		
		Yii::$app->session->setFlash('beacons', 'Beacon has been deleted successfully');
		
        //return $this->redirect([Yii::$app->request->referrer]);
		return $this->redirect(['index', 's'=> $store_id]);	
    }

    /**
     * Finds the Beacons model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return Beacons the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Beacons::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
