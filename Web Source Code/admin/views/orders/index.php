<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\OrdersSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Orders';
$this->params['breadcrumbs'][] = $this->title;
$session = Yii::$app->session;
?>

<div class="beacons-index">
	<div class="row">
        <?php if(Yii::$app->session->hasFlash('orders')) { ?>
        <div class="col-md-12">
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('orders') ?></strong>
            </div>
        </div>
        <?php } ?>
        
        <?php if(empty($stores_list)) { ?>
        <div class="col-sm-12">
            <div class="alert alert-danger fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong>No Store exists. Please add new store.</strong>
            </div>
        </div>
        <?php } else { ?>
        <div class="col-md-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <form class="form-horizontal adminex-form" method="get">
                        <div class="form-group">
                            <label class="col-sm-2 col-sm-2 control-label">Select Store</label>
                            <div class="col-sm-8">
                                <select name="store_id" id="store_id" class="form-control" onChange="javascript:window.location='index?s='+this.value">
                                    <?php
                                    foreach($stores_list as $key=>$store)
                                    {
                                        $selected = "";
                                        if(isset($_GET['s']) && $_GET['s'] == $key)
                                        {
                                            $selected = ' selected="selected"';
                                        }
                                        echo '<option value="'.$key.'" '.$selected.'>'.$store.'</option>';
                                    }
                                    ?>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
    	<div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                        <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                    <?php /*?><span class="pull-right">
                        <?= Html::a('Add Order', ['create', 's'=> $_GET['s']], ['class' => 'btn btn-primary btn-xs']) ?>
                    </span><?php */?>
                </header>
                <div class="panel-body">
                <?= GridView::widget([
                    'dataProvider' => $dataProvider,
                    //'filterModel' => $searchModel,
                    'columns' => [
                        ['class' => 'yii\grid\SerialColumn'],
        
                        //'id',
                        //'user_id',
                        [
                            'attribute' => 'user_id',
                            'label' => 'Name',
                            'value' => 'user.first_name',
                        ],
                        /*[
                            'attribute' => 'user_id',
                            'label' => 'Last Name',
                            'value' => 'user.last_name',
                        ],*/
                        //'store_id',
                        'order_number',
                        //'invoice_number',
                        // 'order_type',
                        //'table_location',
                        // 'total_amount',
                        // 'add_note',
                        [
							'attribute' => 'n_datetime',
							'value' => function($data) { return date("j/n/Y h:i A", strtotime($data->n_datetime)); }
						],
                        //'status',
						[
							'attribute' => 'status',
							'format'	=> 'html',
							'value' => function($data){
								if($data->status == 1)
								{
									return '<span style="color:#C0392B">New</span>';
								}
								else if($data->status == 2)
								{
									return '<span style="color:#FF7F00">Processing</span>';
								}
								else if($data->status == 3)
								{
									return '<span style="color:#2ECC71">Ready to be collected</span>';
								}
								else if($data->status == 4)
								{
									return '<span style="color:#3498DB">Completed</span>';
								}
								else
								{
									return '<span style="color:#808080">Cancelled</span>';
								}
							}
						],
						[
							'label' => 'Details',
							'format' => 'html',
							'options' => ['style' => 'width:80px'],
							'value' => function($data){
								return Html::a(
									'<span class="fa fa-book"></span> Details',
									['view', 'id'=> $data->id],
									[
										'title' => 'View Order Details',
										'class' => 'btn btn-xs btn-primary'
									]
								);
							}
						],
						[
							'label' => 'Invoice',
							'format' => 'html',
							'options' => ['style' => 'width:80px'],
							'value' => function($data){
								return Html::a(
									'<span class="fa fa-file-text"></span> Invoice',
									['order-details/details', 'id'=> $data->id],
									[
										'title' => 'Invoice',
										'class' => 'btn btn-xs btn-primary'
									]
								);
							}
						],
						/*[
							'label' => 'Print',
							'format' => 'html',
							'options' => ['style' => 'width:60px'],
							'value' => function($data){
								return Html::a(
									'<span class="fa fa-print"></span> Print',
									['order-details/print', 'id'=> $data->id],
									[
										'title' => 'Print',
										'class' => 'btn btn-xs btn-primary',
										'target'=>'_blank'
									]
								);
							}
						],*/
                        /*[
							'class' => 'yii\grid\ActionColumn',
							'template' => '{update}{delete}',
						],*/
                    ],
                ]); ?>
                </div>
            </section>
    	</div>
        
        <?php } ?>
	</div>
</div>