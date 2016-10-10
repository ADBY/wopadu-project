<?php
namespace app\controllers;
use Yii;
use app\models\Categories;
use app\models\CategoriesSearch;
use app\models\CategoryDiscount;
use app\models\CatDiscountDaterange;
use app\models\CatDiscountDays;
use app\models\ItemDiscount;
use app\models\ItemDiscountDaterange;
use app\models\ItemDiscountDays;
use app\models\ItemOptionMain;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use yii\web\UploadedFile;
/**
 * CategoriesController implements the CRUD actions for Categories model.
 */
class CategoriesController extends Controller
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
     * Lists all Categories models.
     * @return mixed
     */
    public function actionIndex111()
    {
        /*$searchModel = new CategoriesSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);*/
		$session = Yii::$app->session;
		if(isset($_GET['s'])) {
			$id = $_GET['s'];
			
			$storeExist = Yii::$app->db->createCommand('SELECT count(`id`) FROM stores where id = "'.$id.'" and account_id = '.$session['account_id'])->queryScalar();
			if($storeExist != 1){
				$storeId = Yii::$app->db->createCommand('SELECT `id` FROM stores where account_id = '.$session['account_id'].' LIMIT 1')->queryScalar();
				$this->redirect(['index', 'id'=> $storeId]);
			}
			
		} else {
			$storeId = Yii::$app->db->createCommand('SELECT `id` FROM stores where account_id = '.$session['account_id'].' LIMIT 1')->queryScalar();
			$this->redirect(['index', 'id'=> $storeId]);
		}
		$searchModel = new CategoriesSearch();
		$queryParams = array_merge(array(),Yii::$app->request->getQueryParams());
		$queryParams["CategoriesSearch"]["store_id"] = $id;
		$dataProvider = $searchModel->search($queryParams);
		
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);
    }
    /**
     * Displays a single Categories model.
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
     * Creates a new Categories model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
		$session = Yii::$app->session;
		$stores_list = $session['stores_list'];
		$del_error = "";
		
		if(!isset($_GET['s']) || !isset($_GET['c']))
		{
			if(isset($_GET['s']))
			{
				$this->redirect(['list', 's' => $_GET['s']]);
			}
			else
			{
				$this->redirect(['list']);
			}
		}
		else
		{
			if(!array_key_exists($_GET['s'], $stores_list)) {
				reset($stores_list);
				$this->redirect(['list', 's'=> key($stores_list)]);
			}
			
			if($_GET['c'] != 0)
			{
				$check_cat_ex = Yii::$app->db->createCommand("SELECT id FROM categories WHERE id = ".$_GET['c']." and store_id = ".$_GET['s'])->queryOne();
				
				if(!$check_cat_ex)
				{
					reset($stores_list);
					$this->redirect(['list', 's'=> key($stores_list)]);
				}	
			}
		}
		
		
        $model = new Categories();
        if ($model->load(Yii::$app->request->post()))
		{
			if($model->parent_id == "")
			{
				$model->parent_id = 0;
			}
						
			/*$upImage_1 = UploadedFile::getInstance($model, 'image_1');
			$model->image_1 = $upImage_1;
			
			if($upImage_1 != "")
			{
				$ext = pathinfo($model->image_1, PATHINFO_EXTENSION);
				$model->image_1 = time()."-".rand(1000,9999).'.'.$ext;
			}
			
			if($model->parent_id == 0)
			{
				$upImage_2 = UploadedFile::getInstance($model, 'image_2');
				$model->image_2 = $upImage_2;
				
				if($upImage_2 != "")
				{
					$ext = pathinfo($model->image_2, PATHINFO_EXTENSION);
					$model->image_2 = time()."-".rand(1000,9999).'.'.$ext;
				}
				
				$upImage_3 = UploadedFile::getInstance($model, 'image_3');
				$model->image_3 = $upImage_3;
				
				if($upImage_3 != "")
				{
					$ext = pathinfo($model->image_3, PATHINFO_EXTENSION);
					$model->image_3 = time()."-".rand(1000,9999).'.'.$ext;
				}
			}
			
			if($model->parent_id != 0)
			{
				$model->images = $model->image_1;
			}
			else
			{
				$image_str = $model->image_1.",".$model->image_2.",".$model->image_3;
				$image_str = trim($image_str, ",");
				$image_str = preg_replace('/,+/', ',', $image_str);
				$model->images = $image_str;
			}*/
			
			$model->added_datetime = date("Y-m-d H:i:s");
			
			// Translate Category Name uncomment later
						
			if($model->category_name != "") {
				$language = Yii::$app->db->createCommand("SELECT language_lc, language_code FROM languages WHERE status = 1")->queryAll();
				foreach($language as $lang) {
					$cat_name_in_lang = "category_name_".$lang['language_lc'];
					$translated_array = Yii::$app->mycomponent->bingTraslateAPI($model->category_name, "en", $lang['language_code']);
					if($translated_array['response'] == "OK")
					{
						$model->$cat_name_in_lang = $translated_array['translation'];
					}
					else
					{
						$del_error = $translated_array['response'];
						break;
					}
				}
			}
			
			$fileName 		= $_FILES["Categories"]["name"]["image_1"]; // The file name
			$fileTmpLoc 	= $_FILES["Categories"]["tmp_name"]["image_1"]; // File in the PHP tmp folder
			$fileType 		= $_FILES["Categories"]["type"]["image_1"]; // The type of file it is
			$fileSize 		= $_FILES["Categories"]["size"]["image_1"]; // File size in bytes
			$fileErrorMsg 	= $_FILES["Categories"]["error"]["image_1"]; // 0 for false... and 1 for true
			
			if($fileName != "")
			{
				$kaboom 		= explode(".", $fileName); // Split file name into an array using the dot
				$fileExt 		= end($kaboom); // Now target the last array element to get the file extension
				$fileName 		= time()."-".rand(1000,9999).".".$fileExt;
				$folder_type 	= "images/categories";
				
				$model->images = $fileName;

				$image_proc = Yii::$app->mycomponent->image_validation($fileName, $fileTmpLoc, $fileType, $fileSize, $fileErrorMsg, $kaboom, $fileExt);
				
				if($image_proc['error'] != "")
				{
					$del_error = $image_proc['error'];
				}
				else
				{
					$image_is_set = TRUE;
				}
			}
			
			if($del_error == "" && $model->save())
			{
				/*if($upImage_1 != "")
				{
					$upImage_1->saveAs('images/categories/'.$model->image_1);
				}
				
				if($model->parent_id == 0)
				{
					if($upImage_2 != "")
					{
						$upImage_2->saveAs('images/categories/'.$model->image_2);
					}
					if($upImage_3 != "")
					{
						$upImage_3->saveAs('images/categories/'.$model->image_3);
					}
				}
				*/
				
				if(isset($image_is_set))
				{
					$image_resizing = Yii::$app->mycomponent->image_resizing($fileName, $fileTmpLoc, $fileType, $fileSize, $fileErrorMsg, $kaboom, $fileExt, $folder_type);
				}
				
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $model->store_id, 'type' => 'c']);
				Yii::$app->mycomponent->translateItemNotif(['type' => 2, 'item_id' => $model->id]);
				
				Yii::$app->session->setFlash('categories', 'Category has been added.');
            	return $this->redirect(['list', 's' => $model->store_id]);
			}
		}
	
		return $this->render('create', [
			'model' => $model,
			'del_error' => $del_error,
		]);
    }
    /**
     * Updates an existing Categories model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param string $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $session = Yii::$app->session;		
		$stores_list = $session['stores_list'];		
		$model = $this->findModel($id);
		if(!array_key_exists($model->store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['list', 's'=> key($stores_list)]);
		}
		/*if($model->parent_id == 0)
		{
			$ex = explode(",", $model->images);
			$count = count($ex);
			if($count == 1) { $model->image_1 = $ex[0]; $old_image_1 = $ex[0]; $old_image_2 = ""; $old_image_3 = ""; }
			else if($count == 2) { $model->image_1 = $ex[0]; $model->image_2 = $ex[1]; $old_image_1 = $ex[0]; $old_image_2 = $ex[1]; $old_image_3 = ""; }
			else if($count == 3) { $model->image_1 = $ex[0]; $model->image_2 = $ex[1]; $model->image_3 = $ex[2]; $old_image_1 = $ex[0]; $old_image_2 = $ex[1]; $old_image_3 = $ex[2]; }
		}
		else
		{
			$model->image_1 = $model->images;
			$old_image_1 = $model->images;
		}*/
		$old_image_1 = $model->images;
		
		// Checking for existing product or category exists under this category
		
		$del_error = "";
		/*if($model->parent_id == 0) {
			$sub_cat_check = Yii::$app->db->createCommand("SELECT id FROM categories WHERE parent_id = $id")->queryOne();
			if($sub_cat_check) {
				$del_error = "Please first delete sub categories of this category and products under this category to delete this category.";
			} else {
				$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $id")->queryOne();
				if($sub_cat_check) {
					$del_error = "Please first delete products under this category to delete this category.";
				}
			} 
		} else {
			$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $id")->queryOne();
			if($sub_prod_check) {
				$del_error = "Please first delete products under this category to delete this category.";
			}
		}*/
		
        if ($model->load(Yii::$app->request->post()))
		{
			//$upImage_1 = UploadedFile::getInstance($model, 'image_1');
			//$model->image_1 = $upImage_1;
			/*echo "<pre>";
			print_r($_FILES);
			exit;*/
			
			$fileName 		= $_FILES["Categories"]["name"]["image_1"]; // The file name
			$fileTmpLoc 	= $_FILES["Categories"]["tmp_name"]["image_1"]; // File in the PHP tmp folder
			$fileType 		= $_FILES["Categories"]["type"]["image_1"]; // The type of file it is
			$fileSize 		= $_FILES["Categories"]["size"]["image_1"]; // File size in bytes
			$fileErrorMsg 	= $_FILES["Categories"]["error"]["image_1"]; // 0 for false... and 1 for true
			
			if($fileName != "")
			{
				$kaboom 		= explode(".", $fileName); // Split file name into an array using the dot
				$fileExt 		= end($kaboom); // Now target the last array element to get the file extension
				$fileName 		= time()."-".rand(1000,9999).".".$fileExt;
				$folder_type 	= "images/categories";
				
				$model->images = $fileName;

				$image_proc = Yii::$app->mycomponent->image_validation($fileName, $fileTmpLoc, $fileType, $fileSize, $fileErrorMsg, $kaboom, $fileExt);
				
				if($image_proc['error'] != "")
				{
					$del_error = $image_proc['error'];
				}
				else
				{
					$image_is_set = TRUE;
				}
			}	
			else
			{
				$model->images = $old_image_1;
			}
			
			/*if($upImage_1 != "") {
				$ext = pathinfo($model->image_1, PATHINFO_EXTENSION);
				$model->image_1 = time()."-".rand(1000,9999).'.'.$ext;
			} else {
				$model->image_1 = $old_image_1;
			}
			
			if($model->parent_id == 0)
			{
				$upImage_2 = UploadedFile::getInstance($model, 'image_2');
				$model->image_2 = $upImage_2;
				
				if($upImage_2 != "") {
					$ext = pathinfo($model->image_2, PATHINFO_EXTENSION);
					$model->image_2 = time()."-".rand(1000,9999).'.'.$ext;
				} else {
					$model->image_2 = $old_image_2;
				}
				
				$upImage_3 = UploadedFile::getInstance($model, 'image_3');
				$model->image_3 = $upImage_3;
				
				if($upImage_3 != "") {
					$ext = pathinfo($model->image_3, PATHINFO_EXTENSION);
					$model->image_3 = time()."-".rand(1000,9999).'.'.$ext;
				} else {
					$model->image_3 = $old_image_3;
				}
			}
			
			if($model->parent_id != 0) {
				$model->images = $model->image_1;
			} else {
				$image_str = $model->image_1.",".$model->image_2.",".$model->image_3;
				$image_str = trim($image_str, ",");
				$image_str = preg_replace('/,+/', ',', $image_str);
				$model->images = $image_str;
			}*/
			
			/*echo "<pre>";
			print_r($model);
			exit;*/
			
			if($del_error == "" && $model->save()) {
				
				/*if($upImage_1 != "") {
					$upImage_1->saveAs('images/categories/'.$model->image_1);
					
					$imagine = Image::getImagine();
					$image_resize = $imagine->open('images/categories/' . $model->image_1);
					$image_resize->resize(new Box(530, 400))->save('images/categories/' . $model->image_1->baseName . '-530x400.' . $model->image_1->extension, ['quality' => 71]);
					unlink('images/categories/' . $model->image_1->baseName . '.'  . $model->image_1->extension);

					if($old_image_1 != "" && file_exists('images/categories/'.$old_image_1)) {
						@unlink('images/categories/'.$old_image_1);
					}
				}*/
				
				/*if($model->parent_id == 0) {
					if($upImage_2 != "") {
						$upImage_2->saveAs('images/categories/'.$model->image_2);
						if($old_image_2 != "" && file_exists('images/categories/'.$old_image_2)) {
							@unlink('images/categories/'.$old_image_2);
						}
					}
					if($upImage_3 != "") {
						$upImage_3->saveAs('images/categories/'.$model->image_3);
						if($old_image_3 != "" && file_exists('images/categories/'.$old_image_3))	{
							@unlink('images/categories/'.$old_image_3);
						}
					}
				}*/
				
				if(isset($image_is_set))
				{
					$image_resizing = Yii::$app->mycomponent->image_resizing($fileName, $fileTmpLoc, $fileType, $fileSize, $fileErrorMsg, $kaboom, $fileExt, $folder_type);
					if($old_image_1 != "" && file_exists('images/categories/'.$old_image_1)) {
						@unlink('images/categories/'.$old_image_1);
					}
				}
				
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $model->store_id, 'type' => 'c']);
				Yii::$app->session->setFlash('categories', 'Category has been edited.');
            	return $this->redirect(['list', 's' => $model->store_id]);
        	}
		}
		
		return $this->render('update', [
			'model' => $model,
			'del_error' => $del_error,
		]);
    }
    /**
     * Deletes an existing Categories model.
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
			$this->redirect(['list', 's'=> key($stores_list)]);
		}
		
		if($model->parent_id == 0)
		{
			$sub_cat_check = Yii::$app->db->createCommand("SELECT id FROM categories WHERE parent_id = $id")->queryAll();
			if($sub_cat_check)
			{
				//Yii::$app->session->setFlash('categories', 'Please first delete sub categories of this category and products under this category to delete this category.');
            	//return $this->redirect(['list', 's' => $store_id]);
				foreach($sub_cat_check as $sc)
				{
					$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = ".$sc['id'])->queryAll();
					if($sub_prod_check)
					{
						foreach($sub_prod_check as $sp)
						{
							ItemsController::deleteItemCustom(['id' => $sp['id'], 'store_id' => $store_id]);
						}
					}					
					$this->deleteCategoriesAll(['id' => $sc['id'], 'store_id' => $store_id]);
				}
			}
			else
			{
				$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $id")->queryAll();
				if($sub_prod_check)
				{
					//Yii::$app->session->setFlash('categories', 'Please first delete products under this category to delete this category.');
					//return $this->redirect(['list', 's' => $store_id]);
					
					foreach($sub_prod_check as $sp)
					{
						ItemsController::deleteItemCustom(['id' => $sp['id'], 'store_id' => $store_id]);
					}
				}
			}
		}
		else
		{
			$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $id")->queryAll();
			if($sub_prod_check)
			{
				//Yii::$app->session->setFlash('categories', 'Please first delete products under this category to delete this category.');
           		//return $this->redirect(['list', 's' => $store_id]);
				foreach($sub_prod_check as $sp)
				{
					ItemsController::deleteItemCustom(['id' => $sp['id'], 'store_id' => $store_id]);
				}
			}
		}
		$this->deleteCategoriesAll(['id' => $id, 'store_id' => $store_id]);
		
		Yii::$app->session->setFlash('categories', 'Category has been deleted.');
        return $this->redirect(['list', 's'=>$store_id]);
    }
	
	/** function for delete whole menu  **/
	public function actionDeleteMenu($id)
    {
		$session = Yii::$app->session;		
		$stores_list = $session['stores_list'];		
		
		$store_id = $id;
		
		if(!array_key_exists($store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['list', 's'=> key($stores_list)]);
		}
		
		$cat_check = Yii::$app->db->createCommand("SELECT id, parent_id FROM categories WHERE store_id = $store_id")->queryAll();
		if($cat_check) {
			foreach($cat_check as $ct) {
				$id = $ct['id'];
				if($ct['parent_id']== 0) {
					$sub_cat_check = Yii::$app->db->createCommand("SELECT id FROM categories WHERE parent_id = $id")->queryAll();
					if($sub_cat_check) {
						foreach($sub_cat_check as $sc) {
							$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = ".$sc['id'])->queryAll();
							if($sub_prod_check) {
								foreach($sub_prod_check as $sp) {
									ItemsController::deleteItemCustom(['id' => $sp['id'], 'store_id' => $store_id]);
								}
							}
							$this->deleteCategoriesAll(['id' => $sc['id'], 'store_id' => $store_id]);
						}
					} else {
						$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $id")->queryAll();
						if($sub_prod_check) {
							foreach($sub_prod_check as $sp) {
								ItemsController::deleteItemCustom(['id' => $sp['id'], 'store_id' => $store_id]);
							}
						}
					}
				} else {
					$sub_prod_check = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = $id")->queryAll();
					if($sub_prod_check) {
						foreach($sub_prod_check as $sp) {
							ItemsController::deleteItemCustom(['id' => $sp['id'], 'store_id' => $store_id]);
						}
					}
				}
				$this->deleteCategoriesAll(['id' => $id, 'store_id' => $store_id]);
			}
		}
		
		// Item option Delete all - sub will be deleted by foreign key ref
		ItemOptionMain::deleteAll(['store_id' => $store_id]);
		
		Yii::$app->session->setFlash('categories', 'Menu has been deleted.');
        return $this->redirect(['list', 's'=>$store_id]);
    }
	
	
	public function deleteCategoriesAll($data)
	{
		$id 		= $data['id'];
		$store_id 	= $data['store_id'];
		
		$model = Categories::findOne($id);
			
		// Delete discounts applied on category
		$category_discount = CategoryDiscount::findAll(['category_id' => $id]);
		if($category_discount)
		{
			foreach($category_discount as $discount)
			{
				$discount_id = $discount->discount_id;
				if($discount->promotion_main_type == 1) {
					CatDiscountDaterange::findOne($discount_id)->delete();
				} else if($discount->promotion_main_type == 2) {
					CatDiscountDays::findOne($discount_id)->delete();
				}
			}
			CategoryDiscount::deleteAll(['category_id' => $id]);
		}
		
		$images = $model->images;
		
		if($model->delete()) {
			Yii::$app->mycomponent->updateWaiterSync(['store_id' => $store_id, 'type' => 'c']);
			$ex_image = explode(",", $images);
			foreach($ex_image as $img) {
				if($img != "" && file_exists('images/categories/'.$img)) {
					@unlink('images/categories/'.$img);
				}
			}
		}
	}
	
    /**
     * Finds the Categories model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param string $id
     * @return Categories the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Categories::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
	public function actionFetchCategories()
	{
		$id = $_POST['x'];
		//exit;
		$model = Categories::find(['id', 'category_name'])->where(['store_id' => $id])->all();
		
		foreach($model as $item)
		{
			echo '<option value="'.$item['id'].'">'.$item['category_name'].'</option>';
		}
	}
	/**
     * Lists all Categories models.
     * @return mixed
     */
    public function actionList()
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
		
		/*if(isset($_GET['s'])) {
			$s_id = $_GET['s'];
			
			$storeExist = Yii::$app->db->createCommand('SELECT count(`id`) FROM stores where id = "'.$s_id.'" and account_id = '.$session['account_id'])->queryScalar();
			if($storeExist != 1){
				$storeId = Yii::$app->db->createCommand('SELECT `id` FROM stores where account_id = '.$session['account_id'].' LIMIT 1')->queryScalar();
				$this->redirect(['list', 's'=> $storeId]);
			}
			
		} else {
			$storeId = Yii::$app->db->createCommand('SELECT `id` FROM stores where account_id = '.$session['account_id'].' LIMIT 1')->queryScalar();
			$this->redirect(['list', 's'=> $storeId]);
		}*/
		
		
		$store_id = $s_id;
		$result = Yii::$app->db->createCommand("SELECT * from categories WHERE store_id = '$store_id'")->queryAll();
		
		//if(!$result)
		{
		//	throw new \yii\web\NotFoundHttpException("Something went wrong, Please try again");
		}
		//else
		{
			//if(count($result) == 0)
			{
			//	throw new \yii\web\NotFoundHttpException("No categories found");
			}
			//else
			{
				$rows = array();
				foreach($result as $row)
				{					
					$new_item_res = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = ".$row['id']." and is_new = 1")->queryOne();
					/*echo "<pre>new_item_res";
					print_r($new_item_res);
					echo "</pre>";*/
					if($new_item_res)
					{
						$row['new_items'] = "YES";
					}
					else
					{
						$row['new_items'] = "NO";
					}
					
					$sub_cat_exists_res = Yii::$app->db->createCommand("SELECT id FROM categories WHERE parent_id = ".$row['id'])->queryOne();
					/*echo "<pre>sub_cat_exist_res";
					print_r($sub_cat_exist_res);
					echo "</pre>";*/
					if($sub_cat_exists_res)
					{
						$row['sub_cat_exists_res'] = "YES";
					}
					else
					{
						$row['sub_cat_exists_res'] = "NO";
					}
					
					$prod_exists_in_cat_res = Yii::$app->db->createCommand("SELECT id FROM items WHERE category_id = ".$row['id'])->queryOne();
					/*echo "<pre>prod_exist_in_cat_res";
					print_r($prod_exist_in_cat_res);
					echo "</pre>";*/
					if($prod_exists_in_cat_res)
					{
						$row['prod_exists_in_cat_res'] = "YES";
					}
					else
					{
						$row['prod_exists_in_cat_res'] = "NO";
					}
					
					$discount_exists = Yii::$app->db->createCommand("SELECT id FROM category_discount WHERE category_id = ".$row['id'])->queryOne();
					/*echo "<pre>discount_exists";
					print_r($discount_exists);
					echo "</pre>";*/
					if($discount_exists)
					{
						$row['discount_exists'] = "YES";
					}
					else
					{
						$row['discount_exists'] = "NO";
					}
					
					$rows[] = $row;
				}
				$categories = $rows;	
				
						
				/*$items = $rows;
				$id = '';
				$categories = array();
				
				function sub($items, $id)
				{
					$output = array();
					foreach($items as $item)
					{
						if($item['parent_id'] == $id)
						{
							$item['sub_menu'] = sub($items, $item['id']);
							$output[] = $item;
						}
					}
					return $output;
				}
				foreach($items as $item)
				{	
					if($item['parent_id'] == 0)
					{
						$id = $item['id'];
						$item['sub_menu'] = sub($items, $id);
						$categories[] = $item;
					}
				}*/
			}
		}
		
		/*echo "<pre>";
		print_r($categories);
		echo "</pre>";
		exit;*/
	
        return $this->render('list', [
            'categories' => $categories,
			'stores_list' => $stores_list,
        ]);
    }
	
	public function actionAddDiscount($s, $t, $i)
	{
		
		$store_id 	= $_GET['s'];
		$type 		= $_GET['t'];		// t = 1 - Category, 2 - Products
		$id 		= $_GET['i'];
		
		if($type == 1) {
			$item = Yii::$app->db->createCommand("SELECT id, category_name as name FROM categories WHERE id = $id")->queryOne();
		} else if($type == 2) {
			$item = Yii::$app->db->createCommand("SELECT id, item_name as name, category_id FROM items WHERE id = $id")->queryOne();
			if($item)
			{
				$category = Yii::$app->db->createCommand("SELECT id, category_name, store_id FROM categories WHERE id = ".$item['category_id'])->queryOne();
				$item['store_id'] = $category['store_id'];
				$item['category_id'] = $category['id'];
				$item['category_name'] = $category['category_name'];
			}
			else
			{
				$this->redirect('list');
			}
			
		} else {
			$this->redirect('list');
		}
		
		$item['store_id'] = $store_id;
		$item['type'] = $type;	
		$discount['promotion_main_type'] 	= 1;
		$discount['type1_start_date'] 		= date("Y-m-d");
		$discount['type1_end_date'] 		= date("Y-m-d", strtotime("+5 days"));
		$discount['type2_day'] 				= [];
		$discount['type2_all_day'] 			= 0;
		$discount['type2_time_start'] 		= "00:00:00";
		$discount['type2_time_end'] 		= "00:00:00";
		$discount['promotion_sub'] 			= 1;
		$discount['promotion_sub_value'] 	= "0.00";
		if(isset($_POST['submit']))
		{
			$discount['promotion_main_type'] 	= $_POST['promotion_main_type'];
			$discount['type1_start_date'] 		= $_POST['type1_start_date'];
			$discount['type1_end_date'] 		= $_POST['type1_end_date'];
			if(isset($_POST['type2_day'])){
				$discount['type2_day'] 			= $_POST['type2_day'];
			} else {
				$discount['type2_day'] 			= [];
			}
			if(isset($_POST['type2_all_day'])){
				$discount['type2_all_day'] 		= 1;
			} else {
				$discount['type2_all_day'] 		= 0;
			}			
			$discount['type2_time_start'] 		= $_POST['type2_time_start'];
			$discount['type2_time_end'] 		= $_POST['type2_time_end'];
			$discount['promotion_sub'] 			= $_POST['promotion_sub'];
			$discount['promotion_sub_value'] 	= $_POST['promotion_sub_value'];
			
			if($discount['promotion_main_type'] == 1)
			{
				$exp_type1_start_date = explode("-", $discount['type1_start_date']);
				$exp_type1_end_date = explode("-", $discount['type1_end_date']);
				
				if(@!checkdate($exp_type1_start_date[1], $exp_type1_start_date[2], $exp_type1_start_date[0]))
				{
					$discount['error'] = "Discount start date is not valid";
				}
				else if(@!checkdate($exp_type1_end_date[1], $exp_type1_end_date[2], $exp_type1_end_date[0]))
				{
					$discount['error'] = "Discount end date is not valid";
				}
				else if($discount['type1_start_date'] > $discount['type1_end_date'])
				{
					$discount['error'] = "Discount end date should not be less than start date";
				}
				else if($discount['promotion_sub_value'] == 0)
				{
					$discount['error'] = "Discount value can not be zero";
				}
				/*else
				{
					$discount['error'] = "ok";
				}*/
			}
			else if($discount['promotion_main_type'] == 2)
			{
				$expl_type2_time_start = explode(":", $discount['type2_time_start']);
				$expl_type2_time_end = explode(":", $discount['type2_time_end']);
				
				$str_time_start = str_replace(":", "", $discount['type2_time_start']);
				$str_time_end = str_replace(":", "", $discount['type2_time_end']);
		
				if(empty($discount['type2_day']))
				{
					$discount['error'] = "Please select days for discount";
				}
				else if($discount['type2_all_day'] == 0 && !preg_match('/^\d{2}:\d{2}:\d{2}$/', $discount['type2_time_start']))
				{
					$discount['error'] = "Please enter correct start time format";
				}
				else if($discount['type2_all_day'] == 0 && !preg_match('/^\d{2}:\d{2}:\d{2}$/', $discount['type2_time_end']))
				{
					$discount['error'] = "Please enter correct end time format";
				}
				else if($discount['type2_all_day'] == 0 && ($expl_type2_time_start[0] > 23 || $expl_type2_time_start[1] > 59 || $expl_type2_time_start[2] > 59))
				{
					$discount['error'] = "Please enter correct start time format";
				}
				else if($discount['type2_all_day'] == 0 && ($expl_type2_time_start[0] > 23 || $expl_type2_time_start[1] > 59 || $expl_type2_time_start[2] > 59))
				{
					$discount['error'] = "Please enter correct end time format";
				}
				else if($discount['type2_all_day'] == 0 && $str_time_start >= $str_time_end)
				{
					$discount['error'] = "Please enter correct time for discount";
				}
				else if($discount['promotion_sub_value'] == 0)
				{
					$discount['error'] = "Discount value can not be zero";
				}
				/*else
				{
					$discount['error'] = "ok";
				}*/
			}
			else
			{
				$discount['error'] = "Invalid discount type";
			}
			
			if(!isset($discount['error']) || $discount['error'] == "")
			{
				if($type == 1 && $discount['promotion_main_type'] == 1)		// Categories Discount Based on daterange
				{
					$model = new CatDiscountDaterange();
				}
				else if($type == 2 && $discount['promotion_main_type'] == 1)		// Item Discount Based on daterange
				{
					$model = new ItemDiscountDaterange();
				}
				else if($type == 1 && $discount['promotion_main_type'] == 2)		// Categories Discount Based on fixed days
				{
					$model = new CatDiscountDays();
				}
				else if($type == 2 && $discount['promotion_main_type'] == 2)		// Item Discount Based on fixed days
				{
					$model = new ItemDiscountDays();
				}
				
				if($discount['promotion_main_type'] == 1)		// Based on daterange
				{
					$model->start_date = $discount['type1_start_date'];
					$model->end_date = $discount['type1_end_date'];
				}
				else if($discount['promotion_main_type'] == 2)		// Based on fixed days
				{
					$day_str = ",";
					foreach($discount['type2_day'] as $d_day)
					{
						$day_str .= $d_day.",";
					}
					$model->day = $day_str;		// Extra commas(,) at both end
					$model->all_day = $discount['type2_all_day'];
					
					if($model->all_day == 1)
					{
						$model->time_start = "00:00:00";
						$model->time_end = "00:00:00";
					}
					else
					{
						$model->time_start = $discount['type2_time_start'];
						$model->time_end = $discount['type2_time_end'];
					}
				}
				
				$model->promotion_sub = $discount['promotion_sub'];
				$model->promotion_sub_value = $discount['promotion_sub_value'];
					
				if($model->save())
				{
					$discount_id = $model->id;
					
					if($type == 1)		// Categories Discount
					{
						$model_2 = new CategoryDiscount();
						$model_2->category_id = $id;
					}
					if($type == 2)		// Items Discount
					{
						$model_2 = new ItemDiscount();
						$model_2->item_id = $id;
					}
					$model_2->discount_id = $discount_id;
					$model_2->promotion_main_type = $discount['promotion_main_type'];
					$model_2->save();
					
					if($type == 1) {
						Yii::$app->mycomponent->updateWaiterSync(['store_id' => $item['store_id'], 'type' => 'cd']);
					} else  if($type == 2) {
						Yii::$app->mycomponent->updateWaiterSync(['store_id' => $item['store_id'], 'type' => 'id']);
					}
					Yii::$app->session->setFlash("discounts", "Discount has been added");
					$this->redirect(['categories/view-discount', 's' =>$item['store_id'], 't' => $item['type'], 'i' => $item['id']]);
					//$discount['error'] = "Discount has been added";
				}
				else
				{
					$error = "";
					//echo "<pre>";
					//print_r($model->errors);
					//print_r($model->getErrors());
					
					foreach($model->getErrors() as $errors)
					{
						foreach($errors as $err)
						{
							$error .= $err.'<br />';
						}
					}
					//echo "</pre>";
					//exit;
					$discount['error'] = $error;
				}
				
			}
		}	
		/*echo "<pre>";
		print_r($discount);
		echo "</pre>";
		exit;*/
		return $this->render('add-discount', [
			'item' => $item,
			'discount' => $discount,
        ]);
	}
	
	public function actionViewDiscount($s, $t, $i)
	{
		
		$store_id 	= $_GET['s'];
		$type 		= $_GET['t'];		// t = 1 - Category, 2 - Products
		$id 		= $_GET['i'];		// Category Id / Product Id
		
		$daterange_discount = [];
		$days_discount = [];
		
		$daterange_id_str = "";
		$days_id_str = "";
		if($type == 1) {
			$item = Yii::$app->db->createCommand("SELECT id, category_name as name FROM categories WHERE id = $id")->queryOne();
			$discounts = Yii::$app->db->createCommand("SELECT `discount_id`, `promotion_main_type` FROM `category_discount` WHERE category_id = $id")->queryAll();
			
			foreach($discounts as $disc)
			{
				if($disc['promotion_main_type'] == 1)
				{
					$daterange_id_str .= $disc['discount_id'].",";
				}
				else if($disc['promotion_main_type'] == 2)
				{
					$days_id_str .= $disc['discount_id'].",";
				}				
			}
			
			$daterange_id_str = rtrim($daterange_id_str, ",");
			$days_id_str = rtrim($days_id_str, ",");
			
			if($daterange_id_str != "")
			{
				$daterange_discount = Yii::$app->db->createCommand("SELECT * FROM cat_discount_daterange WHERE id IN ($daterange_id_str)")->queryAll();
			}
			
			if($days_id_str != "")
			{
				$days_discount = Yii::$app->db->createCommand("SELECT * FROM cat_discount_days WHERE id IN ($days_id_str)")->queryAll();
			}
			
		} else if($type == 2) {
			$item = Yii::$app->db->createCommand("SELECT id, item_name as name, category_id FROM items WHERE id = $id")->queryOne();
			if($item)
			{
				$category = Yii::$app->db->createCommand("SELECT id, category_name, store_id FROM categories WHERE id = ".$item['category_id'])->queryOne();
				$item['store_id'] = $category['store_id'];
				$item['category_id'] = $category['id'];
				$item['category_name'] = $category['category_name'];
			}
			else
			{
				$this->redirect('list');
			}
			$discounts = Yii::$app->db->createCommand("SELECT `discount_id`, `promotion_main_type` FROM `item_discount` WHERE item_id = $id")->queryAll();
			foreach($discounts as $disc)
			{
				if($disc['promotion_main_type'] == 1)
				{
					$daterange_id_str .= $disc['discount_id'].",";
				}
				else if($disc['promotion_main_type'] == 2)
				{
					$days_id_str .= $disc['discount_id'].",";
				}				
			}
			$daterange_id_str = rtrim($daterange_id_str, ",");
			$days_id_str = rtrim($days_id_str, ",");
			if($daterange_id_str != "")
			{
				$daterange_discount = Yii::$app->db->createCommand("SELECT * FROM item_discount_daterange WHERE id IN ($daterange_id_str)")->queryAll();
			}
			
			if($days_id_str != "")
			{
				$days_discount = Yii::$app->db->createCommand("SELECT * FROM item_discount_days WHERE id IN ($days_id_str)")->queryAll();
			}
			
		} else {
			$this->redirect('list');
		}
		$item['store_id'] = $store_id;
		$item['type'] = $type;
		
		$temp_daterange_discount = $daterange_discount;
		$daterange_discount = [];
		
		foreach($temp_daterange_discount as $item1)
		{
			$daterange_discount[$item1['id']] = $item1;
		}
		
		$temp_days_discount = $days_discount;
		$days_discount = [];
		
		foreach($temp_days_discount as $item2)
		{
			$days_discount[$item2['id']] = $item2;
		}
		
		$temp_discounts = $discounts;
		$discounts = [];
		
		foreach($temp_discounts as $item3)
		{
			if($item3['promotion_main_type'] == 1)
			{
				$merged_array = array_merge($item3, $daterange_discount[$item3['discount_id']]);
			}
			else if($item3['promotion_main_type'] == 2)
			{
				$merged_array = array_merge($item3, $days_discount[$item3['discount_id']]);
			}
			$discounts[] = $merged_array;
		}
		
		/*echo "<pre>";
		print_r($discounts);
		echo "</pre>";
		exit;*/
		return $this->render('view-discount', [
			'item' => $item,
			'discounts' => $discounts,
        ]);
	}
	
	public function actionEditDiscount($s, $t, $i, $id, $p)
	{		
		$store_id 				= $_GET['s'];
		$type 					= $_GET['t'];		// t = 1 - Category, 2 - Products
		$id 					= $_GET['i'];
		$discount_id			= $_GET['id'];
		$promotion_main_type	= $_GET['p'];
		if($type == 1) {
			$item = Yii::$app->db->createCommand("SELECT id, category_name as name FROM categories WHERE id = $id")->queryOne();
		} else if($type == 2) {
			$item = Yii::$app->db->createCommand("SELECT id, item_name as name,category_id FROM items WHERE id = $id")->queryOne();
			if($item)
			{
				$category = Yii::$app->db->createCommand("SELECT id, category_name, store_id FROM categories WHERE id = ".$item['category_id'])->queryOne();
				$item['store_id'] = $category['store_id'];
				$item['category_id'] = $category['id'];
				$item['category_name'] = $category['category_name'];
			}
			else
			{
				$this->redirect('list');
			}
		} else {
			$this->redirect('list');
		}
		$item['store_id'] = $store_id;
		$item['type'] = $type;
		$item['discount_id'] = $discount_id;
		$item['promotion_main_type'] = $promotion_main_type;
		if($type == 1)	// Category
		{
			$check_disc_exist = Yii::$app->db->createCommand("SELECT id FROM category_discount WHERE category_id = $id and discount_id = $discount_id")->queryOne();
			if($promotion_main_type == 1)		// Based on Daterange
			{	
				if($check_disc_exist) {
					$discount = Yii::$app->db->createCommand("SELECT * FROM cat_discount_daterange WHERE id = $discount_id")->queryOne();
					if($discount)
					{
						$discount['type1_start_date'] = $discount['start_date'];
						$discount['type1_end_date'] = $discount['end_date'];
					}
				} else {
					$this->redirect('list');
				}
			} else if($promotion_main_type == 2)		// Based on Days
			{
				if($check_disc_exist) {
					$discount = Yii::$app->db->createCommand("SELECT * FROM cat_discount_days WHERE id = $discount_id")->queryOne();
					if($discount)
					{
						$discount['type2_day'] = explode(",", trim($discount['day'],","));
						$discount['type2_all_day'] = $discount['all_day'];
						$discount['type2_time_start'] = $discount['time_start'];
						$discount['type2_time_end'] = $discount['time_end'];
					}
				} else {
					$this->redirect('list');
				}
			}
		}
		else if($type == 2)	// Item
		{
			$check_disc_exist = Yii::$app->db->createCommand("SELECT id FROM item_discount WHERE item_id = $id and discount_id = $discount_id")->queryOne();
			if($promotion_main_type == 1)		// Based on Daterange
			{	
				if($check_disc_exist) {
					$discount = Yii::$app->db->createCommand("SELECT * FROM item_discount_daterange WHERE id = $discount_id")->queryOne();
					if($discount)
					{
						$discount['type1_start_date'] = $discount['start_date'];
						$discount['type1_end_date'] = $discount['end_date'];
					}
				} else {
					$this->redirect('list');
				}
			} else if($promotion_main_type == 2)		// Based on Days
			{
				if($check_disc_exist) {
					$discount = Yii::$app->db->createCommand("SELECT * FROM item_discount_days WHERE id = $discount_id")->queryOne();
					if($discount)
					{
						$discount['type2_day'] = explode(",", trim($discount['day'],","));
						$discount['type2_all_day'] = $discount['all_day'];
						$discount['type2_time_start'] = $discount['time_start'];
						$discount['type2_time_end'] = $discount['time_end'];
					}
				} else {
					$this->redirect('list');
				}
			}
		}
		
		$discount['promotion_main_type'] = $promotion_main_type;
		if(isset($_POST['submit']))
		{
			/*echo "<pre>";
print_r($_POST);
echo "</pre>";
exit;*/
			$discount['promotion_main_type'] 	= $promotion_main_type;
			
			if($promotion_main_type == 1)
			{
				$discount['type1_start_date'] 		= $_POST['type1_start_date'];
				$discount['type1_end_date'] 		= $_POST['type1_end_date'];
			}
			
			if($promotion_main_type == 2)
			{
				if(isset($_POST['type2_day'])){
					$discount['type2_day'] 			= $_POST['type2_day'];
				} else {
					$discount['type2_day'] 			= [];
				}
	
				if(isset($_POST['type2_all_day'])){
					$discount['type2_all_day'] 		= 1;
				} else {
					$discount['type2_all_day'] 		= 0;
				}			
	
				$discount['type2_time_start'] 		= $_POST['type2_time_start'];
				$discount['type2_time_end'] 		= $_POST['type2_time_end'];
			}
			
			$discount['promotion_sub'] 			= $_POST['promotion_sub'];
			$discount['promotion_sub_value'] 	= $_POST['promotion_sub_value'];
			
			if($discount['promotion_main_type'] == 1)
			{
				$exp_type1_start_date = explode("-", $discount['type1_start_date']);
				$exp_type1_end_date = explode("-", $discount['type1_end_date']);
				
				if(@!checkdate($exp_type1_start_date[1], $exp_type1_start_date[2], $exp_type1_start_date[0]))
				{
					$discount['error'] = "Discount start date is not valid";
				}
				else if(@!checkdate($exp_type1_end_date[1], $exp_type1_end_date[2], $exp_type1_end_date[0]))
				{
					$discount['error'] = "Discount end date is not valid";
				}
				else if($discount['type1_start_date'] > $discount['type1_end_date'])
				{
					$discount['error'] = "Discount end date should not be less than start date";
				}
				else if($discount['promotion_sub_value'] == 0)
				{
					$discount['error'] = "Discount value can not be zero";
				}
				/*else
				{
					$discount['error'] = "ok";
				}*/
			}
			else if($discount['promotion_main_type'] == 2)
			{
				$expl_type2_time_start = explode(":", $discount['type2_time_start']);
				$expl_type2_time_end = explode(":", $discount['type2_time_end']);
				
				$str_time_start = str_replace(":", "", $discount['type2_time_start']);
				$str_time_end = str_replace(":", "", $discount['type2_time_end']);
		
				if(empty($discount['type2_day']))
				{
					$discount['error'] = "Please select days for discount";
				}
				else if($discount['type2_all_day'] == 0 && !preg_match('/^\d{2}:\d{2}:\d{2}$/', $discount['type2_time_start']))
				{
					$discount['error'] = "Please enter correct start time format";
				}
				else if($discount['type2_all_day'] == 0 && !preg_match('/^\d{2}:\d{2}:\d{2}$/', $discount['type2_time_end']))
				{
					$discount['error'] = "Please enter correct end time format";
				}
				else if($discount['type2_all_day'] == 0 && ($expl_type2_time_start[0] > 23 || $expl_type2_time_start[1] > 59 || $expl_type2_time_start[2] > 59))
				{
					$discount['error'] = "Please enter correct start time format";
				}
				else if($discount['type2_all_day'] == 0 && ($expl_type2_time_start[0] > 23 || $expl_type2_time_start[1] > 59 || $expl_type2_time_start[2] > 59))
				{
					$discount['error'] = "Please enter correct end time format";
				}
				else if($discount['type2_all_day'] == 0 && $str_time_start >= $str_time_end)
				{
					$discount['error'] = "Please enter correct time for discount";
				}
				else if($discount['promotion_sub_value'] == 0)
				{
					$discount['error'] = "Discount value can not be zero";
				}
				/*else
				{
					$discount['error'] = "ok";
				}*/
			}
			else
			{
				$discount['error'] = "Invalid discount type";
			}
			
			if(!isset($discount['error']) || $discount['error'] == "")
			{
				if($type == 1 && $discount['promotion_main_type'] == 1)		// Categories Discount Based on daterange
				{
					$model = CatDiscountDaterange::findOne($discount_id);
				}
				else if($type == 2 && $discount['promotion_main_type'] == 1)		// Item Discount Based on daterange
				{
					$model = ItemDiscountDaterange::findOne($discount_id);
				}
				else if($type == 1 && $discount['promotion_main_type'] == 2)		// Categories Discount Based on fixed days
				{
					$model = CatDiscountDays::findOne($discount_id);
				}
				else if($type == 2 && $discount['promotion_main_type'] == 2)		// Item Discount Based on fixed days
				{
					$model = ItemDiscountDays::findOne($discount_id);
				}
				
				if($discount['promotion_main_type'] == 1)		// Based on daterange
				{
					$model->start_date = $discount['type1_start_date'];
					$model->end_date = $discount['type1_end_date'];
				}
				else if($discount['promotion_main_type'] == 2)		// Based on fixed days
				{
					$day_str = ",";
					foreach($discount['type2_day'] as $d_day)
					{
						$day_str .= $d_day.",";
					}
					$model->day = $day_str;		// Extra commas(,) at both end
					$model->all_day = $discount['type2_all_day'];
					
					if($model->all_day == 1)
					{
						$model->time_start = "00:00:00";
						$model->time_end = "00:00:00";
					}
					else
					{
						$model->time_start = $discount['type2_time_start'];
						$model->time_end = $discount['type2_time_end'];
					}
				}
				
				$model->promotion_sub = $discount['promotion_sub'];
				$model->promotion_sub_value = $discount['promotion_sub_value'];
					
				if($model->save())
				{
					//$discount_id = $model->id;
					if($item['type'] == 1) {
						Yii::$app->mycomponent->updateWaiterSync(['store_id' => $item['store_id'], 'type' => 'cd']);
					} else  if($item['type'] == 2) {
						Yii::$app->mycomponent->updateWaiterSync(['store_id' => $item['store_id'], 'type' => 'id']);
					}
					
					Yii::$app->session->setFlash("discounts", "Discount has been updated");
					$this->redirect(['categories/view-discount', 's' =>$item['store_id'], 't' => $item['type'], 'i' => $item['id']]);
					//$discount['error'] = "Discount has been added";
				}
				else
				{
					$error = "";
					//echo "<pre>";
					//print_r($model->errors);
					//print_r($model->getErrors());
					
					foreach($model->getErrors() as $errors)
					{
						foreach($errors as $err)
						{
							$error .= $err.'<br />';
						}
					}
					//echo "</pre>";
					//exit;
					$discount['error'] = $error;
				}
				
			}
		}	
		/*echo "<pre>";
		print_r($discount);
		echo "</pre>";
		exit;*/
		return $this->render('edit-discount', [
			'item' => $item,
			'discount' => $discount,
        ]);
	}
	
	public function actionDeleteDiscount($s, $t, $i, $id, $p)
	{
		$store_id 				= $s;
		$type 					= $t;		// t = 1 - Category, 2 - Products
		$item_or_cat_id			= $i;
		$discount_id			= $id;
		$promotion_main_type	= $p;
		if($type == 1) {
			$check_disc_exist = Yii::$app->db->createCommand("SELECT id FROM category_discount WHERE category_id = $item_or_cat_id and discount_id = $discount_id and promotion_main_type = $promotion_main_type")->queryOne();
			if($check_disc_exist)
			{
				$main_discount_id = $check_disc_exist['id'];
				CategoryDiscount::findOne($main_discount_id)->delete();
				if($promotion_main_type == 1)
				{
					CatDiscountDaterange::findOne($discount_id)->delete();
				}
				else if($promotion_main_type == 2)
				{
					CatDiscountDays::findOne($discount_id)->delete();
				}
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $s, 'type' => 'cd']);
				Yii::$app->session->setFlash("discounts", "Discount has been deleted");
				$this->redirect(['categories/view-discount', 's'=>$s, 't' => $t, 'i'=>$i]);
			}
			else
			{
				$this->redirect('list');
			}
		} else if($type == 2) {
			$check_disc_exist = Yii::$app->db->createCommand("SELECT id FROM item_discount WHERE item_id = $item_or_cat_id and discount_id = $discount_id and promotion_main_type = $promotion_main_type")->queryOne();
			if($check_disc_exist)
			{
				$main_discount_id = $check_disc_exist['id'];
				ItemDiscount::findOne($main_discount_id)->delete();
				if($promotion_main_type == 1)
				{
					ItemDiscountDaterange::findOne($discount_id)->delete();
				}
				else if($promotion_main_type == 2)
				{
					ItemDiscountDays::findOne($discount_id)->delete();
				}
				Yii::$app->mycomponent->updateWaiterSync(['store_id' => $s, 'type' => 'id']);
				Yii::$app->session->setFlash("discounts", "Discount has been deleted");
				$this->redirect(['categories/view-discount', 's'=>$s, 't' => $t, 'i'=>$i]);
			}
			else
			{
				$this->redirect('list');
			}
		} else {
			$this->redirect('list');
		}
	}
	
	public function actionDelImage($id, $img)
	{
		$session = Yii::$app->session;		
		$stores_list = $session['stores_list'];		
		$model = $this->findModel($id);
		if(!array_key_exists($model->store_id, $stores_list)) {
			reset($stores_list);
			$this->redirect(['list', 's'=> key($stores_list)]);
		}
		
		$images = $model->images;
		
		$image_number = $img - 1;
		$ex_image = explode(",", $images);
		
		
		
		if(isset($ex_image[$image_number]))
		{
			$imag_name = $ex_image[$image_number];
			if($imag_name != "" && file_exists('images/categories/'.$imag_name))
			{
				@unlink('images/categories/'.$imag_name);
			}
			unset($ex_image[$image_number]);
			$ex_image = array_values($ex_image);
			$imp_images = implode(",", $ex_image);
			$model->images = $imp_images;
			$model->save();
			Yii::$app->mycomponent->updateWaiterSync(['store_id' => $s_idd, 'type' => 'c']);
			Yii::$app->session->setFlash('categories_img_del', 'Image has been removed.');
		}
		
        return $this->redirect(['update', 'id'=>$id]);
		
	}
	
}