<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Accounts */

$session = Yii::$app->session;

$this->title = $model_a['account_name'];
if($session['super_admin'] == "NO") {
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
                	<?php if($session['login_role'] != 2) { ?>
					<?= Html::a(
							'<span class="fa fa-sign-in"></span> Login',
							['site/index', 'acc_id'=> $model_a['id']], 
							[
								'title' => 'Login as this Admin',
								'class' => 'btn btn-xs btn-nephritis',
								//'data-confirm' => 'Are you sure you want to login as this Account Admin ?',
							]
						);
					?>
                    <?php } ?>
					<?= Html::a('Update', ['update', 'id' => $model_a['id']], ['class' => 'btn btn-primary btn-xs']) ?>
					<?php if($session['super_admin'] == 'YES') { ?>
					<?= Html::a('Delete', ['delete', 'id' => $model_a['id']], [
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
                <table class="table_cust_1" style="width:100%">
                	<tr>
                		<td style="width:30%"><strong>Account Name</strong></td>
                		<td><?= $model_a['account_name'] ?></td>
                	</tr>
                    <tr>
                		<td><strong>Email</strong></td>
                		<td><?= $model_l['email'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Number of allowed stores</strong></td>
                		<td><?= $model_a['allowed_stores'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Added Date</strong></td>
                		<td><?= $model_l['added_date'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Last login Date</strong></td>
                		<td><?php if($session['super_admin'] == 'YES') { echo $model_l['last_login_date']; } else { echo $session['last_login_date']; } ?></td>
                	</tr>
                	<tr>
                		<td><strong>Last login Ip address</strong></td>
                        <td><?php if($session['super_admin'] == 'YES') { echo $model_l['last_login_ip']; } else { echo $session['last_login_ip']; } ?></td>
                	</tr>
                    <tr>
                		<td><strong>Status</strong></td>
                		<td><?php if($model_l['status'] == 1) { echo "Active"; } else { echo "Inactive"; } ?></td>
                	</tr>
                </table>
            </div>
        </section>
    </div>
</div>
