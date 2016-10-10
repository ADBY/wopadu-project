<?php

namespace app\controllers;

use Yii;
use app\models\SiteContent;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * SiteContentController implements the CRUD actions for SiteContent model.
 */
class SiteContentController extends Controller
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
     * Lists all SiteContent models.
     * @return mixed
     */
    public function actionIndex()
    {
        $model = SiteContent::findAll([1,2,3,4]);

        return $this->render('index', [
            'model' => $model,
        ]);
    }

    /**
     * Displays a single SiteContent model.
     * @param string $id
     * @return mixed
     */
    public function actionView111($id)
    {
        return $this->render('view', [
            'model' => $this->findModel($id),
        ]);
    }

    /**
     * Creates a new SiteContent model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate111()
    {
        $model = new SiteContent();

        if ($model->load(Yii::$app->request->post()) && $model->save()) {
            return $this->redirect(['view', 'id' => $model->id]);
        } else {
            return $this->render('create', [
                'model' => $model,
            ]);
        }
    }

    /**
     * Updates an existing SiteContent model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);

        if ($model->load(Yii::$app->request->post()))
		{
			//$model->value = preg_replace("/[\r\n]+/", "\n", $model->value);
			
			if($model->save())
			{
				Yii::$app->session->setFlash('sitecontent', 'Details has been updated successfully');
            	return $this->redirect(['index']);
			}
		}
		return $this->render('update', [
			'model' => $model,
		]);
    }

    /**
     * Deletes an existing SiteContent model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDelete111($id)
    {
        $this->findModel($id)->delete();

        return $this->redirect(['index']);
    }

    /**
     * Finds the SiteContent model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return SiteContent the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = SiteContent::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}
