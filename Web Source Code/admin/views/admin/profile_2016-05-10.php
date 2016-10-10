<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Admin */

$this->title = "Profile";
//$this->params['breadcrumbs'][] = ['label' => 'Admins', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;

$session = Yii::$app->session;
?>
<div class="row">
    <div class="col-md-12">
    	
		<?php if(Yii::$app->session->hasFlash('admin_msg')) { ?>
        <div class="alert alert-warning fade in">
            <button type="button" class="close close-sm" data-dismiss="alert">
            	<i class="fa fa-times"></i>
            </button>
            <strong><?= Yii::$app->session->getFlash('admin_msg') ?></strong>
        </div>
        <?php } ?>
        
        <section class="panel panel-primary">
            <header class="panel-heading">
                <?= Html::encode($this->title) ?>
                <span class="pull-right">
                	<?= Html::a('Update', ['update'], ['class' => 'btn btn-primary btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">
            	<table class="table_cust_1" style="width:100%">
                	<tr>
                		<td style="width:30%"><strong>Email</strong></td>
                		<td><?= $model['email'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Mobile Number</strong></td>
                		<td><?= $model['mobile'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Security Question</strong></td>
                		<td><?= $model['security_question'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Security Answer</strong></td>
                		<td><?= $model['security_answer'] ?></td>
                	</tr>
                	<tr>
                		<td><strong>Last login Date</strong></td>
                		<td><?= $session['last_login_date']; ?></td>
                	</tr>
                	<tr>
                		<td><strong>Last login Ip address</strong></td>
                		<td><?= $session['last_login_ip'] ?></td>
                	</tr>
                </table>
            </div>
        </section>
    </div>
</div>