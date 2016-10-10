<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Accounts';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="row">
    <div class="col-sm-12">
    	<?php if(Yii::$app->session->hasFlash('accounts')) { ?>
        <div class="alert alert-warning fade in">
            <button type="button" class="close close-sm" data-dismiss="alert">
            	<i class="fa fa-times"></i>
            </button>
            <strong><?= Yii::$app->session->getFlash('accounts') ?></strong>
        </div>
        <?php } ?>
        
        <section class="panel panel-primary">
            <header class="panel-heading">
                <?= Html::encode($this->title) ?>
                <span class="pull-right">
                    <?= Html::a('Create Accounts', ['create'], ['class' => 'btn btn-primary btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">
                <?php /*?><?= GridView::widget([
                    'dataProvider' => $dataProvider,
                    'columns' => [
                        ['class' => 'yii\grid\SerialColumn'],
            
                        //'id',
                        'account_name',
                        'email:email',
                        //'password',
                        'allowed_stores',
                        // 'verif_link',
                        // 'added_datetime',
                        'last_login_date',
                        // 'last_login_ip',
                       
						'status',
						[
							'class' => 'yii\grid\ActionColumn',
							'template' => '{login}',
							'buttons' => [
								'login' => function ($url, $model, $key) {
									return Html::a(
										'<span class="fa fa-sign-in"></span> Login',
										['site/index', 'acc_id'=> $model->id], 
										[
											'title' => 'Login as this Admin',
											'class' => 'btn btn-xs btn-green-sea'
											//'data-confirm' => 'Are you sure you want to login as this Account Admin ?',
										]
									);
								},
							],
						],
                        
                        ['class' => 'yii\grid\ActionColumn'],
                    ],
                ]); ?><?php */?>
				<?= GridView::widget([
					'dataProvider' => $dataProvider,
					//'filterModel' => $searchModel,
					'columns' => [
						[
							'class' => 'yii\grid\SerialColumn',
							'options' => ['style' => 'width:80px'],
						],
						//'id',
						//'login_id',
						[
							'attribute' => 'account_name',
							//'options' => ['style' => 'width:90px'],
						],
						/*[
							'attribute' => 'email',
							'label' => 'Email',
							'value' => 'loginUser.email'
						],*/
						[
							'attribute' => 'allowed_stores',
							'options' => ['style' => 'width:150px'],
						],
						/*[
							'attribute' => 'last_login_date',
							//'label' => 'Email',
							'value' => 'loginUser.last_login_date'
						],
						[
							'attribute' => 'status',
							//'label' => 'Email',
							'value' => 'loginUser.status'
						],*/                        
						/*[
							'class' => 'yii\grid\ActionColumn',
							'options' => ['style' => 'width:100px'],
							'header' => '',
							'template' => '{login}',
							'buttons' => [
								'login' => function ($url, $model, $key) {
									return Html::a(
										'<span class="fa fa-sign-in"></span> Login',
										['site/index', 'acc_id'=> $model->id], 
										[
											'title' => 'Login as this Admin',
											'class' => 'btn btn-xs btn-green-sea',
											//'data-confirm' => 'Are you sure you want to login as this Account Admin ?',
										]
									);
								},
							],
						],*/
						/*[
							'class' => 'yii\grid\ActionColumn',
							'options' => ['style' => 'width:90px'],
						],*/
						[
							'class' => 'yii\grid\ActionColumn',
							'template' => '{login} {view}',
							'options' => ['style' => 'width:135px;'],
							'buttons' => [
								'login' => function ($url, $model, $key) {
									return Html::a(
										'<span class="fa fa-sign-in"></span> Login',
										['site/index', 'acc_id'=> $model->id], 
										[
											'title' => 'Login as this Admin',
											'class' => 'btn btn-xs btn-peter-river',
											//'data-confirm' => 'Are you sure you want to login as this Account Admin ?',
										]
									);
								},
								'view' => function ($url, $model, $key) {
									return Html::a('<span class="fa fa-eye"></span> View', ['view', 'id'=>$model->id], ['title' => 'View Account' ,'style' => '', 'class' => 'btn btn-xs btn-green-sea']);
								},
								'update' => function ($url, $model, $key) {
									return Html::a('<span class="fa fa-pencil"></span> Edit', ['update', 'id'=>$model->id], ['title' => 'Edit Account' ,'style' => '', 'class' => 'btn btn-xs btn-warning']);
								},
							],
						],
					],
                ]); ?>
            </div>
        </section>
    </div>            
</div>