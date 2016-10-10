<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Employee */

$this->title = $model_e->emp_name;
$this->params['breadcrumbs'][] = ['label' => 'Employees', 'url' => ['index', 's'=>$model_e->store_id]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="employee-view">
    <div class="row">
    	<?php if(Yii::$app->session->hasFlash('employee')) { ?>
        <div class="col-md-12">
			<div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('employee') ?></strong>
            </div>
        </div>
        <?php } ?>
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <span class="pull-right">
                        <?= Html::a('Update', ['update', 'id' => $model_e->id], ['class' => 'btn btn-primary btn-xs']) ?>
                        <?= Html::a('Delete', ['delete', 'id' => $model_e->id], [
                            'class' => 'btn btn-danger btn-xs',
                            'data' => [
                                'confirm' => 'Are you sure you want to delete this item?',
                                'method' => 'post',
                            ],
                        ]) ?>
                    </span>
                </header>
                <div class="panel-body">
    
					<?php /*?><?= DetailView::widget([
                        'model' => $model,
                        'attributes' => [
                            'id',
                            'login_id',
                            'store_id',
                            'emp_name',
                        ],
                    ]) ?><?php */?>
                    
                    <div class="panel-body">
                    <table class="table_cust_1" style="width:100%">
                        <?php /*?><tr>
                            <td style="width:30%"><strong>Store Name</strong></td>
                            <td><?= $model_k->store_id ?></td>
                        </tr><?php */?>
                        <tr>
                            <td><strong>Employee Name</strong></td>
                            <td><?= $model_e->emp_name ?></td>
                        </tr>
                        <tr>
                            <td><strong>Email</strong></td>
                            <td><?= $model_l->email ?></td>
                        </tr>
                        <tr>
                            <td><strong>Role</strong></td>
                            <td><?= Yii::$app->mycomponent->loginrole($model_l->role) ?></td>
                        </tr>
                        <?php if($model_l->role == 3) { ?>
                        <tr>
                            <td><strong>Area Name</strong></td>
                            <td><?= $model_e->kitchen->kitchen_name ?></td>
                        </tr>
                        <?php } ?>
                        <tr>
                            <td><strong>Last login Date</strong></td>
                            <td><?= $model_l['last_login_date'] ?></td>
                        </tr>
                        <tr>
                            <td><strong>Last login Ip address</strong></td>
                            <td><?= $model_l['last_login_ip'] ?></td>
                        </tr>
                        <tr>
                            <td><strong>Status</strong></td>
                            <td><?php if($model_l['status'] == 1) { echo "Active"; } else { echo "Inactive"; } ?></td>
                        </tr>
                    </table>
                </div>
                    
                        
                </div>
            </section>
        </div>
    </div>
</div>