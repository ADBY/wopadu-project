<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\UsersSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Users';
$this->params['breadcrumbs'][] = $this->title;
?>
<?php /*?><div class="users-index">

    <h1><?= Html::encode($this->title) ?></h1>
    <?php // echo $this->render('_search', ['model' => $searchModel]); ?>

    <p>
        <?= Html::a('Create Users', ['create'], ['class' => 'btn btn-success']) ?>
    </p>

    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'filterModel' => $searchModel,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],

            'id',
            'first_name',
            'last_name',
            'email:email',
            'password',
            // 'pin_number',
            // 'mobile',
            // 'image',
            // 'reg_datetime',
            // 'verif_account',
            // 'verif_code',
            // 'verif_code_exp_datetime',
            // 'verif_datetime',
            // 'status',

            ['class' => 'yii\grid\ActionColumn'],
        ],
    ]); ?>

</div><?php */?>

<div class="row">
    <div class="col-sm-12">
    
    	<?php if(Yii::$app->session->hasFlash('users')) { ?>
        <div class="alert alert-warning fade in">
            <button type="button" class="close close-sm" data-dismiss="alert">
            	<i class="fa fa-times"></i>
            </button>
            <strong><?= Yii::$app->session->getFlash('users') ?></strong>
        </div>
        <?php } ?>
        <section class="panel panel-primary">
            <header class="panel-heading">
                <?= Html::encode($this->title) ?>
                <span class="pull-right">
                    <?= Html::a('Add User', ['create'], ['class' => 'btn btn-primary btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">
                <?= GridView::widget([
					'dataProvider' => $dataProvider,
					//'filterModel' => $searchModel,
					'tableOptions' =>['class' => 'table'],
					'columns' => [
						['class' => 'yii\grid\SerialColumn'],
			
						//'id',
						'first_name',
						//'last_name',
						//'fullname',
						'email:email',
						//'password',
						// 'pin_number',
						'mobile',
						// 'image',
						// 'reg_datetime',
						// 'verif_account',
						// 'verif_code',
						// 'verif_code_exp_datetime',
						// 'verif_datetime',
						//'status',
						[
							'attribute' => 'status',
							'filter'	=> ["1"=>"Active","0"=>"Inactive"],
							'format'	=> 'text',
							'content'	=> function($data){ if($data->status == 1) { return "Active"; } else { return "Inactive"; } },
						],
									
						//['class' => 'yii\grid\ActionColumn'],
						[
							'class' => 'yii\grid\ActionColumn',
							'template' => '{view} {update}',
							'options' => ['style' => 'width:130px;'],
							'buttons' => [
								'view' => function ($url, $model, $key) {
									return Html::a('<span class="fa fa-eye"></span> View', ['view', 'id'=>$model->id], ['title' => 'View' ,'style' => '', 'class' => 'btn btn-xs btn-green-sea']);
								},
								'update' => function ($url, $model, $key) {
									return Html::a('<span class="fa fa-pencil"></span> Edit', ['update', 'id'=>$model->id], ['title' => 'Update' ,'style' => '', 'class' => 'btn btn-xs btn-warning']);
								},
							],
						],
					],
				]); ?>
            </div>
        </section>
    </div>            
</div>
