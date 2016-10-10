<?php

namespace app\controllers;

use Yii;
use app\models\OrderDetails;
use app\models\OrderDetailsSearch;
use app\models\OrderComplete;
use app\models\Orders;
use app\models\Items;
use app\models\Employee;
//use app\models\ItemOptions;
use app\models\Stores;
use app\models\Kitchens;
use app\models\Users;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * OrderDetailsController implements the CRUD actions for OrderDetails model.
 */
class OrderDetailsController extends Controller
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
     * Lists all OrderDetails models.
     * @return mixed
     */
    public function actionIndex()
    {
		if(!isset($_GET['o'])) {
			$this->redirect(['orders/index']);
		} else {
			$order = Orders::find(['id', 'order_number'])->where(['id'=>$_GET['o']])->one();
		}
		
       /* $searchModel = new OrderDetailsSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);

        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
			'order' => $order,
        ]);*/
		
		//$order_details = OrderDetails::findAll(['order_id' => $order->id]);
		$order_details = Yii::$app->db->createCommand("SELECT O.*, I.item_name, I.price FROM order_details as O INNER JOIN items as I ON I.id = O.item_id WHERE O.order_id = $order->id")->queryAll();
		
		$i = 0;
		foreach($order_details as $od)
		{
			$item_options = $od['item_options_id'];
			if($item_options)
			{
				$options = Yii::$app->db->createCommand("SELECT option_name, amount FROM item_options WHERE id IN ($item_options)")->queryAll();
				$order_details[$i]['options'] = $options;
			}
			else
			{
				$order_details[$i]['options'] = array();
			}
			$i++;	
		}
		
		return $this->render('index', [
            'order' => $order,
			'order_details' => $order_details,
        ]);
    }

    /**
     * Displays a single OrderDetails model.
     * @param string $id
     * @return mixed
     */
    public function actionView($id)
    {
		//if(!isset($_GET['o'])) {
		//	$this->redirect(['orders/index']);
		//} else {
		//	$order = Orders::find(['id', 'order_number'])->where(['id'=>$_GET['o']])->one();
		//}
		$model = $this->findModel($id);
		$order = Orders::findOne($model->order_id);
		$item_options = array();
		
		if($model->item_options_id)
		{
			$item_options_id_str = $model->item_options_id;
			$item_options = Yii::$app->db->createCommand("SELECT id, option_name, amount FROM item_options WHERE id IN ($item_options_id_str)")->queryAll();
		}

        return $this->render('view', [
            'model' => $model,
			'order' => $order,
			'item_options' => $item_options,
        ]);
    }

    /**
     * Creates a new OrderDetails model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
        $model = new OrderDetails();

        if ($model->load(Yii::$app->request->post()) && $model->save()) {
			
			Yii::$app->session->setFlash('order_details', 'Order Details has been added successfully');
            return $this->redirect(['view', 'id' => $model->id]);
        } else {
            return $this->render('create', [
                'model' => $model,
            ]);
        }
    }

    /**
     * Updates an existing OrderDetails model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);
		
		$old_item_options_amount = $model->item_options_amount;
		
		$old_final_amount = $model->final_amount;
		
		$old_amount_without_opt = $old_final_amount - $old_item_options_amount;
		
		$order = Orders::findOne($model->order_id);
		
		/*$item_option = Yii::$app->db->createCommand("SELECT id, option_name, amount FROM item_options WHERE item_id = $model->item_id")->queryAll();
		
		$new_item_option = array();
		foreach($item_option as $ia)
		{
			$new_item_option[$ia['id']] = $ia;
		}*/
		
		/*$res_option = Yii::$app->db->createCommand("SELECT option_main_id FROM item_option WHERE item_id = ".$model->item_id)->queryAll();
		
		if($res_option)
		{
			$options = array();
			$temp_1 = 0;
			foreach($res_option as $row_option)
			{
				$res_main_sub_option = Yii::$app->db->createCommand("SELECT IOM.id as item_option_main_id, IOS.id as item_option_sub_id, IOM.option_name, IOS.sub_name, IOS.sub_amount FROM item_option_main as IOM INNER JOIN item_option_sub as IOS ON IOS.option_id = IOM.id WHERE IOM.id = ".$row_option['option_main_id'])->queryAll();
				if($res_main_sub_option)
				{
					foreach($res_main_sub_option as $row_main_sub_option)
					{
						$options[$temp_1][] = $row_main_sub_option;
					}
				}
				$temp_1++;
			}
			
			$new = [];
			
			foreach($options as $m)
			{
				$sub = [];
				
				foreach($m as $n)
				{
					$item_option_main_id = $n['item_option_main_id'];
					$item_option_main_name = $n['option_name'];
					
					$sub[] = 
						[
							'item_option_sub_id' => $n['item_option_sub_id'],
							'sub_name' => $n['sub_name'],
							'sub_amount' => $n['sub_amount'], 
						];
				}
				$new[] = 
					[
						'item_option_main_id' => $m[0]['item_option_main_id'],
						'item_option_main_name' => $m[0]['option_name'],
						'options' => $sub,
					];
			}

			$item_option = $new;
		}*/
		
        if ($model->load(Yii::$app->request->post()))
		{
			/*$new_item_options_amount = 0;
		
			if(isset($_POST['item_options'])) {
				$item_option_array = $_POST['item_options'];
				foreach($item_option_array as $ioa)
				{
					$new_item_options_amount += $new_item_option[$ioa]['amount'];
				}
				
				$model->item_options_id = implode(",", $item_option_array);
			} else {
				$model->item_options_id = "";
			}
			
			$model->item_options_amount = $new_item_options_amount;
			$new_final_amount = $old_amount_without_opt + $new_item_options_amount;
			$model->final_amount = $new_final_amount;*/
			
			if($model->save())
			{
				//$order_last_amount = Yii::$app->db->createCommand("SELECT total_amount FROM orders WHERE id =  $model->order_id")->queryOne();
				
				/*$orderUpdate = $order; //Orders::findOne($model->order_id);
				$old_total_amount = $orderUpdate->total_amount;
				$new_total_amount = ($old_total_amount - $old_final_amount) + $new_final_amount;
				$orderUpdate->total_amount = $new_total_amount;
				$orderUpdate->save();*/

				Yii::$app->session->setFlash('orders', 'Order Details has been updated successfully');
            	return $this->redirect(['orders/view', 'id' => $model->order_id]);
        	}
		}
				
		return $this->render('update', [
			'model' => $model,
			'order' => $order,
			//'item_option' => $item_option,
		]);
	
    }

    /**
     * Deletes an existing OrderDetails model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param string $id
     * @return mixed
     */
    public function actionDeleteeee($id)
    {
        //$this->findModel($id)->delete();
		
		$model = $this->findModel($id);
		$order_id = $model->order_id;
		$old_final_amount = $model->final_amount;
		
		//$old_amount_without_opt = $old_final_amount - $old_item_options_amount;
		
		if($model->delete())
		{
			$orderUpdate = Orders::findOne($order_id);
			
			$old_total_amount = $orderUpdate->total_amount;
			$new_total_amount = ($old_total_amount - $old_final_amount);
			$orderUpdate->total_amount = $new_total_amount;
			$orderUpdate->save();
		}
		
		Yii::$app->session->setFlash('orders', 'Ordered item has been deleted successfully');
        return $this->redirect(['orders/view', 'id' => $order_id]);
    }

    /**
     * Finds the OrderDetails model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return OrderDetails the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = OrderDetails::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
	
	public function actionDetails($id)
	{
		//	Select All With condition
		$orders = Orders::find()->where(['id' => $id])->one();
		//$order_details = OrderDetails::find()->where(['order_id' => $id])->all();
		
		$order_details = Yii::$app->db->createCommand("SELECT O.*, I.item_name, I.price FROM order_details as O INNER JOIN items as I ON I.id = O.item_id WHERE O.order_id = $id")->queryAll();

		$store = Stores::find(['id, store_name, store_branch, address, image'])->where(['id' => $orders->store_id])->one();
		if($orders->waiter_id == NULL)
		{
			$user = Users::find(['id, first_name, last_name, email, mobile'])->where(['id' => $orders->user_id])->one();
		}
		else
		{
			$user = [];
		}
		$i = 0;
		foreach($order_details as $od)
		{
			$item_options = $od['item_options_id'];
			if($item_options)
			{
				//$options = Yii::$app->db->createCommand("SELECT option_name, amount FROM item_options WHERE id IN ($item_options)")->queryAll();
				//$order_details[$i]['options'] = $options;
				
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

		return $this->render('details', [
			'orders' => $orders,
			'order_details' => $order_details,
			'store' => $store,
			'user' => $user,
		]);
	}
	
	
	public function actionPrint($id)
	{
		//	Select All With condition
		$orders = Orders::find()->where(['id' => $id])->one();
		//$order_details = OrderDetails::find()->where(['order_id' => $id])->all();
		
		$order_details = Yii::$app->db->createCommand("SELECT O.*, I.item_name, I.price FROM order_details as O INNER JOIN items as I ON I.id = O.item_id WHERE O.order_id = $id")->queryAll();

		$store = Stores::find(['id, store_name, store_branch, address, image'])->where(['id' => $orders->store_id])->one();
		if($orders->waiter_id == NULL)
		{
			$user = Users::find(['id, first_name, last_name, email, mobile'])->where(['id' => $orders->user_id])->one();
		}
		else
		{
			$user = [];
		}
		$i = 0;
		foreach($order_details as $od)
		{
			$item_options = $od['item_options_id'];
			if($item_options)
			{
				//$options = Yii::$app->db->createCommand("SELECT option_name, amount FROM item_options WHERE id IN ($item_options)")->queryAll();
				//$order_details[$i]['options'] = $options;
				
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
		
		echo '<!doctype html>
		<html>
		<head>
		<meta charset="utf-8">
		<title>Untitled Document</title>
		<style>		
		html, body, div, span, applet, object, iframe,
		h1, h2, h3, h4, h5, h6, p, blockquote, pre,
		a, abbr, acronym, address, big, cite, code,
		del, dfn, em, img, ins, kbd, q, s, samp,
		small, strike, strong, sub, sup, tt, var,
		b, u, i, center,
		dl, dt, dd, ol, ul, li,
		fieldset, form, label, legend,
		table, caption, tbody, tfoot, thead, tr, th, td,
		article, aside, canvas, details, embed, 
		figure, figcaption, footer, header, hgroup, 
		menu, nav, output, ruby, section, summary,
		time, mark, audio, video {
			margin: 0;
			padding: 0;
			border: 0;
			font-size: 100%;
			font: inherit;
			vertical-align: baseline;
		}
		article, aside, details, figcaption, figure, 
		footer, header, hgroup, menu, nav, section {
			display: block;
		}
		body {
			line-height: 1;
		}
		</style>
		</head>		
		<body>';
		//-------------
		echo '<table border="0" width="100%" style="font-family:arial;font-size: 12px;" align="center">';
		echo '<tr>';
		echo '<td align="center">';
		echo '<strong style="font-size:18px">'.$store->store_name.'</strong>';
		echo '<br/>';
		echo $store->store_branch;
		echo '<br/>';
        echo str_replace(",", ",<br/>", $store->address);
		echo '</td>';
		echo '</tr>';
		
		echo '<tr>';
		echo '<td align="center">';
		echo "<br /><strong>Order Details</strong><br />";
		echo '</td>';
		echo '</tr>';
		
		echo '<tr>';
		echo '<td>';
			echo '<hr style="border:none; border-top:1px dashed #000; color:#fff; background-color:#fff; height:1px; width:100%;">';
			echo '<table width="100%" style="font-size: 12px;">';
			echo '<tr>';
			echo '<td>';
			if($orders->table_location == "Takeaway") { echo 'Type: '.$orders->table_location.' Order'; }
			else { echo ''.$orders->table_location; }
			
			echo '</td>';
			echo '<td align="right">';
			echo 'Invoice#: '.$orders->invoice_number;
			
			echo '</td>';
			echo '</tr>';
			echo '</table>';
			echo '<hr style="border:none; border-top:1px dashed #000; color:#fff; background-color:#fff; height:1px; width:100%;">';		
		echo '</td>';
		echo '</tr>';
				
		echo '<tr>';
		echo '<td>';
			echo '<table width="100%" style="font-size: 12px;">';
			
			$total_tax_price = 0;
			$total_item_price = 0;
            foreach($order_details as $ord)
			{
            	echo '<tr>';
                echo '<td class="text-center" style="vertical-align:top">'.$ord['quantity'].' x</td>';
				echo '<td colspan="2">';
                echo '<div style="float:left">';
				echo '<strong>'.$ord['item_name'].'</strong>';
				
				if($ord['options'])
				{
				echo '<br /><span style="text-align:right; ">';
				foreach($ord['options'] as $opt)
				{
					echo "&nbsp;&nbsp;".$opt['sub_name'].' <small>('.$opt['option_name'].')</small><br>';
				}
				echo '</span>';
				}
				
				echo '</div>';
				echo '</td>';
				
				
				$tax_for_this_item = (($ord['final_amount'] * $ord['tax_percentage']) / 100);
				$price_for_this_item = $ord['final_amount'] - $tax_for_this_item;
					
				$total_tax_price += $tax_for_this_item;
				$total_item_price += $price_for_this_item;
				
                echo '<td align="right" style="vertical-align:top"><strong>'.number_format((float)$price_for_this_item, 2, '.', '').'</strong></td>';
                echo '</tr>';
				$i++;
                }
			
			echo '</table>';		
		echo '</td>';
		echo '</tr>';
		
		echo '<tr>';
		echo '<td>';
			echo '<hr style="border:none; border-top:1px dashed #000; color:#fff; background-color:#fff; height:1px; width:100%;">';
			echo '<table width="100%" style="font-size: 12px;">';
			
			echo '<tr>';
			echo '<td>';
			echo 'TOTAL PRICE: ';
			echo '</td>';
			echo '<td align="right">';
			echo number_format((float)$total_item_price, 2, '.', ''); 			
			echo '</td>';
			echo '</tr>';
			
			echo '<tr>';
			echo '<td>';
			echo 'TOTAL TAX: ';
			echo '</td>';
			echo '<td align="right">';
			echo number_format((float)$total_tax_price, 2, '.', ''); 			
			echo '</td>';
			echo '</tr>';
			
			echo '<tr>';
			echo '<td>';
			echo '<h4 style="padding: 0;margin: 0;">GRAND TOTAL: </h4>';
			echo '</td>';
			echo '<td align="right"><h4 style="padding: 0;margin: 0;">';
			echo number_format((float)$orders->total_amount, 2, '.', '');
			echo '</h4></td>';
			echo '</tr>';
			
			echo '</table>';
			echo '<hr style="border:none; border-top:1px dashed #000; color:#fff; background-color:#fff; height:1px; width:100%;">';		
		echo '</td>';
		echo '</tr>';
		
		echo '<tr>';
		echo '<td align="center">';
		echo ''.date('l jS F Y g:i A', strtotime($orders->n_datetime)).'';
		echo '<br />';
		echo '<br />';
		//echo '<strong>'.date('g:ia \o\n l jS F Y', strtotime($orders->n_datetime)).'</strong>';
		echo '<strong style="font-size:16px;">..Thank You..</strong>';
		echo '</td>';
		echo '</tr>';
		
		echo "</table>";
		
		
		///--------------
		echo '</body>
		</html>';

		
		echo "<script>window.print();</script>";
		/*echo "<pre>";
		print_r($orders);
		print_r($order_details);
		print_r($store);
		print_r($store);*/
		exit;

		/*return $this->render('print', [
			'orders' => $orders,
			'order_details' => $order_details,
			'store' => $store,
			'user' => $user,
		]);*/
	}
	
	public function actionCook($id){
		$this->layout = 'emplayout';
		
		$kitchen = Kitchens::findOne($id);
		$cook = [];
		
		if($kitchen)
		{
			$store_id = $kitchen->store_id;
			
			$orders = Yii::$app->db->createCommand("SELECT id,order_number, table_location, add_note, status, n_datetime FROM orders WHERE store_id = $store_id and (status = 1 or status = 2) order by status desc")->queryAll();

			$cook = $orders;
			if($orders)
			{
				$s = 0;
				foreach($orders as $order)
				{
					$order_details = Yii::$app->db->createCommand("SELECT OD.status, OD.quantity, OD.add_note, OD.item_options_id, OD.id as od_id, I.item_name FROM order_details as OD INNER JOIN items as I ON I.id = OD.item_id WHERE OD.order_id = '".$order['id']."' and OD.kitchen_id = '".$id."'")->queryAll();
	
					if($order_details)
					{
						$k = 0;
						$complete_kitchen = true;
						foreach($order_details as $details)
						{
							if($details['status'] == 1 || $details['status'] == 2)
							{
								$complete_kitchen = false;
							}
							
							if($details['item_options_id'] != "")
							{
								$item_options = Yii::$app->db->createCommand("SELECT option_name FROM item_options WHERE id IN (".$details['item_options_id'].")")->queryAll();
								
								if($item_options)
								{
									$opt_array = [];
									foreach($item_options as $opt)
									{
										$opt_array[] = $opt['option_name'];
									}
									$order_details[$k]['options'] = $opt_array;
								}
								else
								{
									$order_details[$k]['options'] = [];
								}
							}
							else
							{
								$order_details[$k]['options'] = [];
							}
							$k++;
						}
						if($complete_kitchen == true)
						{
							unset($cook[$s]);
						}
						else
						{
							$cook[$s]['ordered_items'] = $order_details;
						}
					}
					else
					{
						unset($cook[$s]);
					}
					$s++;
				}
			}
			
			$prev_datetime = date("Y-m-d H:i:s", strtotime("-5 minutes"));
			
			$cook_cancelled = [];
			$cancelled = Yii::$app->db->createCommand("SELECT id,order_number, table_location, add_note, status, c_datetime  FROM orders WHERE store_id = $store_id and c_datetime > '$prev_datetime' and status = 5 order by id asc")->queryAll();
			
			$cook_cancelled = $cancelled;
			
			if($cancelled)
			{
				$s = 0;
				foreach($cancelled as $order)
				{
					$order_details = Yii::$app->db->createCommand("SELECT OD.status, OD.quantity, OD.add_note, OD.item_options_id, OD.id as od_id, I.item_name FROM order_details as OD INNER JOIN items as I ON I.id = OD.item_id WHERE OD.order_id = '".$order['id']."' and OD.kitchen_id = '".$id."'")->queryAll();
					
					if($order_details)
					{
						$k = 0;
						$complete_kitchen = true;
						
						foreach($order_details as $details)
						{
							if($details['status'] == 1 || $details['status'] == 2)
							{
								$complete_kitchen = false;
							}
							
							if($details['item_options_id'] != "")
							{
								$item_options = Yii::$app->db->createCommand("SELECT option_name FROM item_options WHERE id IN (".$details['item_options_id'].")")->queryAll();
								
								if($item_options)
								{
									$opt_array = [];
									foreach($item_options as $opt)
									{
										$opt_array[] = $opt['option_name'];
									}
									$order_details[$k]['options'] = $opt_array;
								}
								else
								{
									$order_details[$k]['options'] = [];
								}
							}
							else
							{
								$order_details[$k]['options'] = [];
							}
							$k++;
						}
						
						if($complete_kitchen == true)
						{
							unset($cook_cancelled[$s]);
						}
						else
						{
							$cook_cancelled[$s]['ordered_items'] = $order_details;
						}						
					}
					else
					{
						unset($cook_cancelled[$s]);
					}					
					$s++;
				}
			}
			$cook = array_merge($cook_cancelled, $cook);
		}
		/*echo "<pre>";
		print_r($cook);
		echo "</pre>";
		exit;*/

		return $this->render('cook', [
			'cook' => array_values($cook),
		]);
	}
	
	public function actionResto($id){
		$this->layout = 'emplayout';
		
		$resto = [];
		$order_completed = Yii::$app->db->createCommand("SELECT DISTINCT(order_id) FROM order_complete WHERE store_id = $id order by id asc")->queryAll();
		if($order_completed)
		{
			$order_id_str = "";
			foreach($order_completed as $comp)
			{
				$order_id_str .= $comp['order_id'].",";
			}
			$order_id_str = rtrim($order_id_str, ",");
			
			$order_details = Orders::find(['order_number', 'table_location'])->where("id in ($order_id_str)")->all();
			$order_details = Yii::$app->db->createCommand("SELECT order_number, table_location FROM orders WHERE id in ($order_id_str)")->queryAll();
			
			$resto = $order_details;
		}

		return $this->render('resto', [
			'resto' => $resto,
		]);
	}
	
	public function actionUporderstatus_old()		// Moved to cook controller
	{
		$new_od_status = $_POST['status'];
		$od_id = $_POST['od_id'];

		$datetime = date("Y-m-d H:i:s");

		$orderItem = OrderDetails::findOne($od_id);
		$order_id = $orderItem->order_id;
		$kitchen_id = $orderItem->kitchen_id;
		$old_od_status = $orderItem->status;

		if($old_od_status != $new_od_status)
		{
			$orderItem->status = $new_od_status;
			$orderItem->save();

			$order = Orders::findOne($order_id);

			$store_id = $order->store_id;
			$new_o_status = $order->status;
			

			if($new_od_status == 1)
			{
				$order_details = Yii::$app->db->createCommand("SELECT id FROM order_details WHERE order_id = $order_id and status > 1")->queryAll();
				if(!$order_details)
				{
					if($new_o_status != 1)
					{
						$order->status = 1;
						$order->p_datetime = NULL;
						$order->r_datetime = NULL;
						$order->c_datetime = NULL;
						$order->save();
					}
				}
				else
				{
					if($new_o_status != 2)
					{
						$order->status = 2;
						//$order->p_datetime = $datetime;
						$order->r_datetime = NULL;
						$order->c_datetime = NULL;
						$order->save();
					}
				}
			}
			else if($new_od_status == 2)
			{
				if($new_o_status != 2)
				{
					$order->status = 2;
					$order->p_datetime = $datetime;
					$order->r_datetime = NULL;
					$order->c_datetime = NULL;
					$order->save();
				}
			}
			else if($new_od_status == 3)
			{
				$order_details = Yii::$app->db->createCommand("SELECT id FROM order_details WHERE order_id = $order_id and status < 3")->queryAll();
				if(!$order_details)
				{
					if($new_o_status != 3)
					{
						$order->status = 3;
						if($order->p_datetime == NULL)
						{
							$order->p_datetime = $datetime;
						}
						$order->r_datetime = $datetime;
						$order->c_datetime = NULL;
						$order->save();
					}
				}
				else
				{
					if($new_o_status != 2)
					{
						$order->status = 2;
						//$order->p_datetime = $datetime;
						$order->r_datetime = NULL;
						$order->c_datetime = NULL;
						$order->save();
					}
				}
			}
			
			$o_status = $order->status;
			$rem_o_id = "";
			if($o_status != 3)
			{
				/*$new_check_kitchen_status = Yii::$app->db->createCommand("SELECT id FROM order_details WHERE order_id = $order_id and kitchen_id = $kitchen_id and status < 3")->queryOne();
				if(!$new_check_kitchen_status)
				{
					$o_status = 3;
				}*/
				
				$new_check_status = Yii::$app->db->createCommand("SELECT id,status, kitchen_id FROM order_details WHERE order_id = $order_id and status < 3")->queryAll();
				if(!$new_check_status)
				{
					$o_k_status = 3; // Order status for this particular kitchen
				}
				else
				{
					$this_kitchen = false;
					foreach($new_check_status as $single_check)
					{
						if($single_check['kitchen_id'] == $kitchen_id)
						{
							$this_kitchen = true;
						}
						$rem_o_id .= $single_check['id'].",";
					}
					$rem_o_id = rtrim($rem_o_id, ",");
					
					if($this_kitchen == false)
					{
						$o_k_status = 3; // Order status for this particular kitchen
					}
					else
					{
						$o_k_status = $o_status; // Order status for this particular kitchen
					}
				}
			}
			else
			{
				$o_k_status = $o_status;	// Order status for this particular kitchen
			}
			
			if($new_od_status == 3)
			{
				$model = new OrderComplete();
				$model->store_id = $store_id;
				$model->order_id = $order_id;
				$model->order_detail_id = $od_id;
				$model->remaining_od = $rem_o_id;
				$model->added_date = date("Y-m-d H:i:s");
				$model->save();
			}

			echo json_encode(['o_id' => $order_id, 'o_status' => "$o_k_status", 'od_status' => $new_od_status]);
		}
		else
		{
			echo json_encode("ok");
		}
	}
	
	public function actionCancelod($id)
	{
		$model = $this->findModel($id);
		$order_id = $model->order_id;
		$order_details_id = $id;
		
		$orders_all = Yii::$app->db->createCommand("SELECT id FROM order_details WHERE order_id = $order_id and id != $order_details_id and status != 5")->queryAll();
		
		if(!$orders_all)
		{
			$c_datetime = date("Y-m-d H:i:s");
			$update_order = Yii::$app->db->createCommand("UPDATE orders SET status = 5, c_datetime = '$c_datetime' WHERE id = $order_id")->execute();
		}
		
		$orders_complete = Yii::$app->db->createCommand("DELETE FROM order_complete WHERE order_id = $order_id and order_detail_id = $order_details_id")->execute();
		
		$model->status = 5; // Cancelled
		$model->save();
		
		$this->redirect(['orders/view', 'id' => $order_id]);
	}
	
	
}
