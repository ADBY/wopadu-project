<?php

namespace app\controllers;

use Yii;
use app\models\SiteInfo;
use app\models\SiteInfoSearch;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

use mPDF;

/**
 * SiteInfoController implements the CRUD actions for SiteInfo model.
 */
class SiteInfoController extends Controller
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
     * Lists all SiteInfo models.
     * @return mixed
     */
    public function actionIndex()
    {
        $searchModel = new SiteInfoSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);

        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single SiteInfo model.
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
     * Creates a new SiteInfo model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
        $model = new SiteInfo();

        if ($model->load(Yii::$app->request->post()) && $model->save()) {
            return $this->redirect(['view', 'id' => $model->id]);
        } else {
            return $this->render('create', [
                'model' => $model,
						
            ]);
        }
    }

    /**
     * Updates an existing SiteInfo model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);

        if ($model->load(Yii::$app->request->post()) && $model->save()) {
			
			Yii::$app->session->setFlash('site_info', 'Site information has been update successfully');
			return $this->redirect(['index']);
        } 
		else 
		{
            return $this->render('update', [
                'model' => $model,
            ]);
        }
    }

    /**
     * Deletes an existing SiteInfo model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete($id)
    {
        $this->findModel($id)->delete();

        return $this->redirect(['index']);
    }

    /**
     * Finds the SiteInfo model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return SiteInfo the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = SiteInfo::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
	
	public function actionGetStores1()
	{
		$account_id = $_POST['ac_id'];
		$sel_stor = $_POST['sel_stor'];
		
		$stores = Yii::$app->db->createCommand("SELECT id, store_name FROM stores WHERE account_id = $account_id")->queryAll();
		
		if($stores) {
			
			$dropdown = '<option value="0" ';
			
			if($sel_stor != "" && $sel_stor == 0) {
				$dropdown .= ' selected="selected"';
			}
			$dropdown .= '>All</option>';
			
			foreach($stores as $store) {
				$dropdown .= '<option value="'.$store['id'].'"';
				
				if($sel_stor != "" && $sel_stor == $store['id']) {
					$dropdown .= ' selected="selected"';
				}
				$dropdown .= '>'.$store['store_name'].'</option>';
			}
		} else {
			$dropdown = '<option value="">No Stores exists</option>';
		}
		
		echo $dropdown;
		exit;
	}
	
	public function actionReports1()
	{
		$accounts_list = Yii::$app->db->createCommand("SELECT id, account_name FROM accounts")->queryAll();
		
		$report = [];
		$posted_data = [];
		
		if(isset($_POST['account']))
		{

			$account = $_POST['account'];
			$store = $_POST['store'];
			$oType = $_POST['type'];
			$startDate = $_POST['start_date'];
			$endDate = $_POST['end_date'];
			
			/*$account = 0;
			$store = 0;
			$oType = 0;
			$startDate = "2015-10-10";
			$endDate = "2015-11-30";*/
			
			$posted_data = ['account' => $account, 'store' => $store, 'type' => $oType, 'start_date' => $startDate, 'end_date' => $endDate];	
			$report = Yii::$app->mycomponent->createreport($posted_data);
		
		}
		return $this->render('reports', [
			'accounts_list' => $accounts_list,
			'report' => $report,
			'posted_data' => $posted_data,
		]);
			
	}
	
	public function actionDownloadReport1(){

		$account = $_POST['account'];
		$store = $_POST['store'];
		$oType = $_POST['type'];
		$startDate = $_POST['start_date'];
		$endDate = $_POST['end_date'];

		/*$account = 0;
		$store = 0;
		$oType = 0;
		$startDate = "2015-10-10";
		$endDate = "2015-11-30";*/

		$posted_data = ['account' => $account, 'store' => $store, 'type' => $oType, 'start_date' => $startDate, 'end_date' => $endDate];

		$report = Yii::$app->mycomponent->createreport($posted_data);
		$reportHtml = Yii::$app->mycomponent->printreportpdf($report);

		$mpdf=new mPDF();
		$stylesheet = file_get_contents('../css/bootstrap.min.css');
		$mpdf->WriteHTML($stylesheet,1); // The parameter 1 tells that this is css/style only and no body/html/text
		$mpdf->WriteHTML($reportHtml);
        //$mpdf->Output('MyPDF.pdf', 'D');
		$mpdf->Output();
        exit;
	}
}
