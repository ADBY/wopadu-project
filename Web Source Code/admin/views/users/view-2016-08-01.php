<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Users */

$this->title = $model->first_name." ".$model->last_name;
$this->params['breadcrumbs'][] = ['label' => 'Users', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<?php /*?><div class="users-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Update', ['update', 'id' => $model->id], ['class' => 'btn btn-primary']) ?>
        <?= Html::a('Delete', ['delete', 'id' => $model->id], [
            'class' => 'btn btn-danger',
            'data' => [
                'confirm' => 'Are you sure you want to delete this item?',
                'method' => 'post',
            ],
        ]) ?>
    </p>

    <?= DetailView::widget([
        'model' => $model,
        'attributes' => [
            'id',
            'first_name',
            'last_name',
            'email:email',
            'password',
            'pin_number',
            'mobile',
            'image',
            'reg_datetime',
            'verif_account',
            'verif_code',
            'verif_code_exp_datetime',
            'verif_datetime',
            'status',
        ],
    ]) ?>

</div><?php */?>

<div class="row">
    <div class="col-md-12">
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
                	<?= Html::a('Reg Devices ', ['device-registered', 'id' => $model->id], ['class' => 'btn btn-primary btn-xs']) ?>
					<?= Html::a('Update', ['update', 'id' => $model->id], ['class' => 'btn btn-primary btn-xs']) ?>
					<?php /*?><?= Html::a('Delete', ['delete', 'id' => $model->id], [
                        'class' => 'btn btn-danger btn-xs',
                        'data' => [
                            'confirm' => 'Are you sure you want to delete this item?',
                            'method' => 'post',
                        ],
                    ]) ?><?php */?>
                </span>
            </header>
            <div class="panel-body">
            	<?= DetailView::widget([
					'model' => $model,
					'attributes' => [
						//'id',
						[
							'attribute' => 'first_name',
							'label' => 'First Name',
						],
						'last_name',
						'email:email',
						//'password',
						'pin_number',
						'mobile',
						'allergies',
						//'image',
						/*[
							'attribute'=>'image',
							'value'=> $model->image == "" ? "../../images/users/nouser.jpg":"../../images/users/".$model->image,
							'format' => ['image',['width'=>'100']],
						],*/
						//'reg_datetime',
						[
							'attribute' => 'reg_datetime',
							'format'	=> ['date' , 'php:j/n/Y g:i A'],
						],
						//'verif_account',
						[
							'attribute' => 'verif_account',
							'value'		=> $model->verif_account == 1 ? 'Yes':'No',
						],
						'verif_code',
						'verif_code_exp_datetime',
						'verif_datetime',
						[
							'attribute' => 'facebook_connect',
							'value'		=> $model->facebook_connect == 1 ? 'Yes':'No',
						],
						[
							'attribute' => 'fb_reg_datetime',
							'format'	=> ['date' , 'php:j/n/Y g:i A'],
						],
						[
							'attribute' => 'google_connect',
							'value'		=> $model->google_connect == 1 ? 'Yes':'No',
						],
						[
							'attribute' => 'g_reg_datetime',
							'format'	=> ['date' , 'php:j/n/Y g:i A'],
						],
						//'status',
						[
							'attribute' => 'status',
							'value'		=> $model->status == 1 ? 'Active':'Inactive',
						],
					],
				]) ?>
            </div>
        </section>
    </div>
</div>

