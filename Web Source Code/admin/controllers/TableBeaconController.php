<?php

namespace app\controllers;

use Yii;
use app\models\TableBeacon;
use app\models\TableBeaconSearch;
use app\models\Beacons;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * TableBeaconController implements the CRUD actions for TableBeacon model.
 */
class TableBeaconController extends Controller
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
     * Lists all TableBeacon models.
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
		
		$searchModel = new TableBeaconSearch();
		$queryParams = array_merge(array(),Yii::$app->request->getQueryParams());
		$queryParams["TableBeaconSearch"]["store_id"] = $s_id;
		$dataProvider = $searchModel->search($queryParams);
		
		$tables_fetch = Yii::$app->db->createCommand("SELECT * FROM table_beacon WHERE store_id = ".$s_id." order by table_id, beacon_minor asc")->queryAll();
		$tables = [];
				
		foreach($tables_fetch as $row)
		{
			$tables[$row['table_id']][] = $row;
		}
		
		//$beacons = Yii::$app->db->createCommand("SELECT beacon_major, beacon_minor FROM beacons WHERE store_id = ".$s_id)->queryAll();
		
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
			'stores_list' => $stores_list,
			'tables' => $tables,
			//'beacons' => $beacons,
        ]);
    }

    /**
     * Displays a single TableBeacon model.
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
     * Creates a new TableBeacon model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
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
		
        $model = new TableBeacon();
		$beacons_distance = [];
		$error = "";
		//$beacons = Beacons::find()->where(['store_id' => $s_id]);
		$beacons = Yii::$app->db->createCommand("SELECT * FROM beacons WHERE store_id = ".$s_id)->queryAll();
		$tables = [];
		
        if ($model->load(Yii::$app->request->post()))
		{
			$table_id = $model->table_id;
			$store_id = $s_id;
			
			$beacons_distance = $_POST['beacon'];
			$beacon_details = [];
			foreach($beacons_distance as $distance)
			{
				if($distance == "") {
					$error = "Please insert distance for all beacons";
					break;
				} 
				if (!is_numeric($distance)) {
					$error = "Please insert valid distance";
					break;
				} /*else {
					$beacon_fetch = Yii::$app->db->createCommand("SELECT beacon_major, beacon_minor FROM beacons WHERE store_id = '$s_id'")->queryOne();
					$beacon_details[$key];
				}*/
			}
			
			if($error == "")
			{
				foreach($beacons_distance as $key=>$distance)
				{
					$model = new TableBeacon();
					$model->store_id = $store_id;
					$model->table_id = $table_id;
					$model->beacon_major = $store_id;
					$model->beacon_minor = $key;
					$model->distance = $distance;

					$model->save();
				}
				
				Yii::$app->session->setFlash('tablebeacon', 'Table has been added.');
				return $this->redirect(['index', 's' => $s_id]);
			}
		}
		
		return $this->render('create', [
			'model' => $model,
			'beacons' => $beacons,
			'tables' => $tables,
			'beacons_distance' => $beacons_distance,
			'error' => $error,
		]);
    }

    /**
     * Updates an existing TableBeacon model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
		$model = $this->findModel($id);
		$old_table_id = $model->table_id;
		
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		
		$store_id = $model->store_id;
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['index', 's'=> key($stores_list)]);
		}
		
		$beacons_fetch = Yii::$app->db->createCommand("SELECT * FROM table_beacon WHERE store_id = ".$store_id." and table_id = '".$model->table_id."'")->queryAll();
		
		$beacons_distance = [];
		
		foreach($beacons_fetch as $b)
		{
			$beacons_distance[$b['beacon_minor']] = $b['distance'];
		}

		$error = "";
		$beacons = Yii::$app->db->createCommand("SELECT * FROM beacons WHERE store_id = ".$store_id)->queryAll();
		$tables = [];

        if ($model->load(Yii::$app->request->post()))
		{
			$table_id = $model->table_id;
			$store_id = $store_id;
			
			$beacons_distance = $_POST['beacon'];
			$beacon_details = [];
			foreach($beacons_distance as $distance)
			{
				if($distance == "") {
					$error = "Please insert distance for all beacons";
					break;
				} 
				if (!is_numeric($distance)) {
					$error = "Please insert valid distance";
					break;
				}
			}
			
			if($error == "")
			{
				foreach($beacons_distance as $key=>$distance)
				{
					$check_tab_beac = Yii::$app->db->createCommand("SELECT id FROM table_beacon WHERE store_id = ".$store_id." and beacon_minor = ".$key." and table_id ='".$old_table_id."'")->queryOne();
					if($check_tab_beac)
					{
						$model = $this->findModel($check_tab_beac['id']);
					}
					else
					{
						$model = new TableBeacon();
					}
					$model->store_id = $store_id;
					$model->table_id = $table_id;
					$model->beacon_major = $store_id;
					$model->beacon_minor = $key;
					$model->distance = $distance;

					$model->save();
				}
				
				Yii::$app->session->setFlash('tablebeacon', 'Table has been updated.');
				return $this->redirect(['index', 's' => $store_id]);
			}
		}
		return $this->render('update', [
			'model' => $model,
			'beacons' => $beacons,
			'tables' => $tables,
			'beacons_distance' => $beacons_distance,
			'error' => $error,
		]);
    }

    /**
     * Deletes an existing TableBeacon model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
		$model = $this->findModel($id);
		$store_id = $model->store_id;
		$table_id = $model->table_id;
		
		Yii::$app->db->createCommand("DELETE FROM table_beacon WHERE store_id = $store_id and table_id = '".$table_id."'")->execute();

		//$model->delete();
		Yii::$app->session->setFlash('tablebeacon', 'Table has been removed.');
		return $this->redirect(['index', 's' => $store_id]);
	}

    /**
     * Finds the TableBeacon model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return TableBeacon the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = TableBeacon::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
