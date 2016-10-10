<?php

namespace app\controllers;

use Yii;
use app\models\Users;
use app\models\UsersSearch;
use app\models\DeviceRegistered;
use app\models\DeviceRegisteredSearch;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\web\UploadedFile;

/**
 * UsersController implements the CRUD actions for Users model.
 */
class UsersController extends Controller
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
     * Lists all Users models.
     * @return mixed
     */
    public function actionIndex()
    {
        $searchModel = new UsersSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);

        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single Users model.
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
     * Creates a new Users model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
        $model = new Users();

        if ($model->load(Yii::$app->request->post()))
		{
			
			//$upImage = UploadedFile::getInstance($model, 'image');
			//$model->image = $upImage;
			
			/*if($upImage != "")
			{
				$model->image = time()."-".$model->image;
			}*/
			
			
			$model->reg_datetime = date("Y-m-d H:i:s");
			if($model->verif_account == 0)
			{
				$model->verif_code = md5(time().rand(1000, 9999));
				$model->verif_code_exp_datetime = date("Y-m-d H:i:s", strtotime("+6 hours"));
				$model->verif_datetime = NULL;
			}
			else
			{
				$model->verif_code = NULL;
				$model->verif_code_exp_datetime = NULL;
				$model->verif_datetime = date("Y-m-d H:i:s");
			}
			
			if($model->validate())
			{			
				if($model->password != $model->re_password)
				{
					$model->addError("re_password", "Password must be same");
				}
				else
				{
					//$model->password = Yii::$app->security->generatePasswordHash($model->password);
					$model->password = md5($model->password);
					if($model->save())
					{
						/*if($upImage != "")
						{
							$upImage->saveAs('../images/users/'.$model->image);
						}*/
						Yii::$app->session->setFlash('users', 'Users has been added');
						return $this->redirect(['view', 'id' => $model->id]);
					}
				}
			}
			
		}
		return $this->render('create', [
			'model' => $model,
		]);
    }

    /**
     * Updates an existing Users model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);
		$old_password = $model->password;
		$old_verif_account = $model->verif_account;
		
		//$old_image = $model->image;

        if ($model->load(Yii::$app->request->post()))
		{
			
			/*$upImage = UploadedFile::getInstance($model, 'image');
			
			$model->image = $upImage;
			
			if($upImage != "")
			{
				$model->image = time()."-".$model->image;
			}
			else
			{
				$model->image = $old_image;
			}*/
			
			if($old_verif_account == 1 && $model->verif_account == 0)
			{
				$model->verif_code = md5(time().rand(1000, 9999));
				$model->verif_code_exp_datetime = date("Y-m-d H:i:s", strtotime("+6 hours"));
				$model->verif_datetime = NULL;
			}
			else if($old_verif_account == 0 && $model->verif_account == 1)
			{
				$model->verif_code = NULL;
				$model->verif_code_exp_datetime = NULL;
				$model->verif_datetime = date("Y-m-d H:i:s");
			}
			
			if($model->validate())
			{
				if($model->re_password != "" && $model->password != $model->re_password)
				{
					$model->addError("re_password", "Password must be same");
				}
				else
				{
					if($model->re_password == "")
					{
						$model->password = $old_password;
					}
					else
					{
						//$model->password = Yii::$app->security->generatePasswordHash($model->password);
						$model->password = md5($model->password);
					}					
					if($model->save())
					{
						/*if($upImage != "")
						{
							$upImage->saveAs('../images/users/'.$model->image);
							if($old_image != "" && file_exists('../images/users/'.$old_image))
							{
								@unlink('../images/users/'.$old_image);
							}
						}*/
						
						Yii::$app->session->setFlash('users', 'Users has been updated');
						return $this->redirect(['view', 'id' => $model->id]);
					}
				}
			}
			
			
		}
		return $this->render('update', [
			'model' => $model,
		]);
    }

    /**
     * Deletes an existing Users model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDeleteeeeeee($id)
    {
        $model = $this->findModel($id);
		$model->delete();
		/*$image = $model->image;

		if($model->delete())
		{
			if($image != "" && file_exists('../images/users/'.$image))
			{
				@unlink('../images/users/'.$image);
			}			
		}*/
		
		Yii::$app->session->setFlash('users', 'Users has been deleted');

       return $this->redirect(['index']);
    }

    /**
     * Finds the Users model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return Users the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Users::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
	
	public function actionDeviceRegistered($id)
	{
		//$searchModel = new DeviceRegisteredSearch();
        //$dataProvider = $searchModel->search(Yii::$app->request->queryParams);
		
		$searchModel = new DeviceRegisteredSearch;
		$queryParams = array_merge(array(),Yii::$app->request->getQueryParams());
		$queryParams["DeviceRegisteredSearch"]["user_id"] = $id;
		$dataProvider = $searchModel->search($queryParams);

		$user = Users::findOne($id);

        return $this->render('device-registered', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
			'user' => $user,
        ]);
	}
	
	public function actionDeleteDevice($id, $uid)
    {
        //$this->findModel($id)->delete();
		//DeviceRegistered::delete(['id' => $id]);
		
		DeviceRegistered::findOne($id)->delete();
		
		Yii::$app->session->setFlash('device', 'Device id has been deleted');
        return $this->redirect(['device-registered', 'id' => $uid]);
    }
}
