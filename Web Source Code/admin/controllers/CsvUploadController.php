<?php
namespace app\controllers;
use Yii;

use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\web\UploadedFile;
/**
 * CategoriesController implements the CRUD actions for Categories model.
 */
class CsvUploadController extends Controller
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
    
	public function actionCsvUpload()
	{
		$session = Yii::$app->session;
		
		$stores_list = $session['stores_list'];
		
		if(isset($_GET['s'])) {
			$s_id = $_GET['s'];
			if(empty($stores_list) && $s_id == 0) {
				$s_id = 0;
			} else if(empty($stores_list) && $s_id != 0) {
				$this->redirect(['list', 's'=> 0]);
			} else {
				if(!array_key_exists($s_id, $stores_list)) {
					reset($stores_list);
					$this->redirect(['list', 's'=> key($stores_list)]);
				}
			}
		} else {
			if(empty($stores_list)) {
				$this->redirect(['list', 's'=> 0]);
			} else {
				reset($stores_list);
				$this->redirect(['list', 's'=> key($stores_list)]);
			}
		}
		
		return $this->render('csvupload');
	}
	
	public function actionDownloadSample()
	{
		$session = Yii::$app->session;
		
		$stores_list = $session['stores_list'];
		
		if(isset($_GET['s'])) {
			$s_id = $_GET['s'];
			if(empty($stores_list) && $s_id == 0) {
				$s_id = 0;
			} else if(empty($stores_list) && $s_id != 0) {
				$this->redirect(['list', 's'=> 0]);
			} else {
				if(!array_key_exists($s_id, $stores_list)) {
					reset($stores_list);
					$this->redirect(['list', 's'=> key($stores_list)]);
				}
			}
		} else {
			if(empty($stores_list)) {
				$this->redirect(['list', 's'=> 0]);
			} else {
				reset($stores_list);
				$this->redirect(['list', 's'=> key($stores_list)]);
			}
		}
		
		$fileName = 'csv-sample-menu.csv';
 
		header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
		header('Content-Description: File Transfer');
		header("Content-type: text/csv");
		header("Content-Disposition: attachment; filename={$fileName}");
		header("Expires: 0");
		header("Pragma: public");

		$fh = @fopen( 'php://output', 'w' );
		
		//fputcsv($fh, array("CSV Menu Upload Sample"));
		//fputcsv($fh, array(""));
		
		/*$tax_array_db = Yii::$app->db->createCommand("SELECT * FROM tax")->queryAll();
		$tax_array = ['Tax Values Available'];
		foreach($tax_array_db as $ta)
		{
			$tax_array[] = $ta['tax_percentage'];
		}
		
		if(!$tax_array_db)
		{
			$tax_array[] = 'Tax option has not been added, Please contact super admin';
		}
		else
		{
			$tax_array[] = '';
			$tax_array[] = '( Choose product tax values from this options )';
		}*/
		
		/*echo "<pre>";
		print_r($tax_array);
		echo "</pre>";*/
	
		/*fputcsv($fh, $tax_array);

		$area_array_db = Yii::$app->db->createCommand("SELECT id, kitchen_name FROM kitchens WHERE store_id = $s_id")->queryAll();
		$area_array = ['Areas Available'];
		foreach($area_array_db as $aa)
		{
			$area_array[] = $aa['kitchen_name'];
		}
		
		if(!$area_array_db)
		{
			$area_array[] = 'Area names has not been added, Please add it from admin panel, Then you can add Products';
		}
		else
		{
			$area_array[] = '';
			$area_array[] = '( Choose product are from this options )';
		}
		
		fputcsv($fh, $area_array);
		fputcsv($fh, array(""));*/
		
		/*	echo "<pre>";
		print_r($area_array);
		echo "</pre>";*/
		/*fputcsv($fh, array("Sample Product Data"));
		fputcsv($fh, array(""));*/
		fputcsv($fh, array("Category name", "Product name", "Product description", "Price", "Tax", "Area name", "variety 1", "v1 price", "variety 2", "v2 price", "variety 3", "v3 price", "variety 4", "v4 price", "variety 5", "v5 price"));
		/*fputcsv($fh, array("Breakfast", "The Brekkiw Board", "Crispy fried bacon lightly fried free range egg, and toasty bun", "5.5", "10", "Front Counter", "regular", "3", "large", "5"));
		
		fputcsv($fh, array(""));
		fputcsv($fh, array("**********", "**********", "**********", "**********", "**********", "**********"));
		fputcsv($fh, array("Start From Here, Overwrite this line"));*/
		
		// Close the file*/
		fclose($fh);
		
		// Make sure nothing else is sent, our file is done
		exit;
	}
}