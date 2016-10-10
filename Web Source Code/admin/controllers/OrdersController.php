<?php



namespace app\controllers;



use Yii;

use app\models\Orders;

use app\models\OrdersSearch;

use yii\web\Controller;

use yii\web\NotFoundHttpException;

use yii\filters\VerbFilter;



/**

 * OrdersController implements the CRUD actions for Orders model.

 */

class OrdersController extends Controller

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

     * Lists all Orders models.

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

		

		$searchModel = new OrdersSearch();

		$queryParams = array_merge(array(),Yii::$app->request->getQueryParams());

		$queryParams["OrdersSearch"]["store_id"] = $s_id;

		$dataProvider = $searchModel->search($queryParams);

		

        return $this->render('index', [

            'searchModel' => $searchModel,

            'dataProvider' => $dataProvider,

			'stores_list' => $stores_list,

        ]);

    }



    /**

     * Displays a single Orders model.

     * @param string $id

     * @return mixed

     */

    public function actionView($id)

    {

		$model = $this->findModel($id);

		

		/*if(!isset($_GET['o'])) {

			$this->redirect(['orders/index']);

		} else {

			$order = Orders::find(['id', 'order_number'])->where(['id'=>$_GET['o']])->one();

		}*/

		

		$order_details = Yii::$app->db->createCommand("SELECT O.*, I.item_name, I.price FROM order_details as O INNER JOIN items as I ON I.id = O.item_id WHERE O.order_id = $model->id")->queryAll();

		

		$i = 0;

		foreach($order_details as $od)

		{

			$item_options = $od['item_options_id'];

			if($item_options)

			{

				//$options = Yii::$app->db->createCommand("SELECT option_name, amount FROM item_options WHERE id IN ($item_options)")->queryAll();

				

				$options = Yii::$app->db->createCommand("SELECT  IOM.id as item_main_id, option_name, IOS.id as item_sub_id, sub_name, sub_amount FROM `item_option_sub` as IOS INNER JOIN `item_option_main` as IOM ON IOM.id = IOS.option_id WHERE IOS.id IN ($item_options)")->queryAll();				

				$order_details[$i]['options'] = $options;

			}

			else

			{

				$order_details[$i]['options'] = array();

			}		

			

			$item_variety_id = $od['item_variety_id'];

			if($item_variety_id != NULL)

			{

				$item_variety_details = Yii::$app->db->createCommand("SELECT variety_name, variety_price FROM item_variety WHERE `id` = '".$item_variety_id."' and item_id = '".$od['item_id']."'")->queryOne();

				

				if($item_variety_details)

				{

					$order_details[$i]['item_variety_name'] = $item_variety_details['variety_name'];

					//$order_details[$i]['item_variety_price'] = $item_variety_details['variety_price'];

					$order_details[$i]['item_amount'] = $item_variety_details['variety_price'];

				}
				else
				{
					$order_details[$i]['item_variety_id'] = NULL;
				}

			}

			

			$i++;	

		}

		

        return $this->render('view', [

            'model' => $model,

			'order_details' => $order_details,

        ]);

    }



    /**

     * Creates a new Orders model.

     * If creation is successful, the browser will be redirected to the 'view' page.

     * @return mixed

     */

    public function actionCreate()

    {

        $model = new Orders();



        if ($model->load(Yii::$app->request->post()) && $model->save()) {

			

			Yii::$app->session->setFlash('orders', 'Orders has been added successfully');

            return $this->redirect(['view', 'id' => $model->id]);

        } else {

            return $this->render('create', [

                'model' => $model,

            ]);

        }

    }



    /**

     * Updates an existing Orders model.

     * If update is successful, the browser will be redirected to the 'view' page.

     * @param string $id

     * @return mixed

     */

    public function actionUpdate($id)

    {

        $model = $this->findModel($id);

			

        if ($model->load(Yii::$app->request->post()) && $model->save()) {

			

			Yii::$app->session->setFlash('orders', 'Orders has been updated successfully');

            return $this->redirect(['view', 'id' => $model->id]);

        } else {

            return $this->render('update', [

                'model' => $model,

            ]);

        }

    }



    /**

     * Deletes an existing Orders model.

     * If deletion is successful, the browser will be redirected to the 'index' page.

     * @param string $id

     * @return mixed

     */

    public function actionDeleteeeeeeeee($id)

    {

        $model = $this->findModel($id);

		

		$store_id = $model->store_id;

		

		$model->delete();

		

		Yii::$app->session->setFlash('orders', 'Orders has been Deleted successfully');

        return $this->redirect(['index', 's'=>$store_id]);

    }



    /**

     * Finds the Orders model based on its primary key value.

     * If the model is not found, a 404 HTTP exception will be thrown.

     * @param string $id

     * @return Orders the loaded model

     * @throws NotFoundHttpException if the model cannot be found

     */

    protected function findModel($id)

    {

        if (($model = Orders::findOne($id)) !== null) {

            return $model;

        } else {

            throw new NotFoundHttpException('The requested page does not exist.');

        }

    }

	

	public function actionUpstatus()

	{

		$order_id = $_GET['order_id'];

		$new_order_status = $_GET['order_status'];

		

		$current_datetime = date("Y-m-d H:i:s");

		

		$model = Orders::findOne($order_id);

		

		$old_order_status = $model->status;

		

		if($new_order_status != $old_order_status)

		{

			if($new_order_status == 2 && $old_order_status == 1) {

				$model->p_datetime = $current_datetime;

			} else if($new_order_status == 3 && $old_order_status == 1) {

				$model->p_datetime = $model->r_datetime = $current_datetime;

			} else if($new_order_status == 3 && $old_order_status == 2) {

				$model->r_datetime = $current_datetime;

			} else if($new_order_status == 4 && $old_order_status == 1) {

				$model->p_datetime = $model->r_datetime = $model->c_datetime = $current_datetime;

			} else if($new_order_status == 4 && $old_order_status == 2) {

				$model->r_datetime = $model->c_datetime = $current_datetime;

			} else if($new_order_status == 4 && $old_order_status == 3) {

				$model->c_datetime = $current_datetime;

			} else if($new_order_status == 5 && $old_order_status == 1) {

				$model->p_datetime = $model->r_datetime = $model->c_datetime = $current_datetime;

			} else if($new_order_status == 5 && $old_order_status == 2) {

				$model->r_datetime = $model->c_datetime = $current_datetime;

			} else if($new_order_status == 5 && $old_order_status == 3) {

				$model->c_datetime = $current_datetime;

			}

			Yii::$app->db->createCommand("UPDATE order_details SET status = $new_order_status WHERE order_id = $order_id")->execute();

		}

		$model->status = $new_order_status;

		$model->save();

		Yii::$app->session->setFlash('orders', 'Orders status has been updated successfully');

		return $this->redirect(['view', 'id' => $order_id]);		

	}

}