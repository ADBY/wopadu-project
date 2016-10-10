<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Accounts */

$this->title = $model->account_name;
if(!isset(\Yii::$app->user->identity->role)) {
	$this->params['breadcrumbs'][] = $this->title;
} else {
$this->params['breadcrumbs'][] = ['label' => 'Accounts', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
}
?>

<div class="row">
    <div class="col-md-12">
    	
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
                	<?= Html::a('Update', ['update', 'id' => $model->id], ['class' => 'btn btn-primary btn-xs']) ?>
					<?php if(isset(\Yii::$app->user->identity->role)) { ?>
					<?= Html::a('Delete', ['delete', 'id' => $model->id], [
                        'class' => 'btn btn-danger btn-xs',
                        'data' => [
                            'confirm' => 'Are you sure you want to delete this item?',
                            'method' => 'post',
                        ],
                    ]) ?>
                    <?php } ?>
                </span>
            </header>
            <div class="panel-body">
            	
            	<?= DetailView::widget([
					'model' => $model,
					'attributes' => [
						//'id',
						'account_name',
						'email:email',
						//'password',
						'allowed_stores',
						//'verif_link',
						'added_datetime',
						'last_login_date',
						'last_login_ip',
						//'status',
						[
							'attribute' => 'status',
							'value' => $model->status == 1 ? 'Active' : 'Inactive',
						],
					],
				]) ?>
            </div>
        </section>
    </div>
</div>
