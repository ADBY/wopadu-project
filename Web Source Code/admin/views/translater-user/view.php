<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\TranslaterUser */

$this->title = $model_t->first_name.' '.$model_t->last_name;
$this->params['breadcrumbs'][] = ['label' => 'Translater Users', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;

$session = Yii::$app->session;

?>

<div class="Translater-user-view">
<div class="row">
    <div class="col-lg-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
            	<?= Html::encode($this->title) ?>
                <span class="pull-right">
                	<?= Html::a('Update', ['update', 'id' => $model_t->id], ['class' => 'btn btn-primary btn-xs']) ?>
                    <?php if($session['login_role'] != 6) { ?>
					<?= Html::a('Delete', ['delete', 'id' => $model_t->id], [
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

				<?php /*?><?= DetailView::widget([
                    'model' => $model,
                    'attributes' => [
                        'id',
                        'login_id',
                        'first_name',
                        'last_name',
                    ],
                ]) ?><?php */?>
                <table class="table_cust_1" style="width:100%">
					<tr>
                        <td style="width:30%"><strong>First Name</strong></td>
                        <td><?= $model_t->first_name ?></td>
                    </tr>
                    <tr>
                        <td><strong>Last Name</strong></td>
                        <td><?= $model_t->last_name ?></td>
                    </tr>
                    <tr>
                        <td><strong>Email</strong></td>
                        <td><?= $model_l->email ?></td>
                    </tr>
                    <tr>
                        <td><strong>Last login Date</strong></td>
                        <td><?= $model_l->last_login_date ?></td>
                    </tr>
                    <tr>
                        <td><strong>Last login Ip address</strong></td>
                        <td><?= $model_l->last_login_ip ?></td>
                    </tr>
                    <tr>
                        <td><strong>Status</strong></td>
                        <td><?php if($model_l->status == 1) { echo "Active"; } else { echo "Inactive"; } ?></td>
                    </tr>
                </table>
			</div>
        </section>
    </div>
</div>
</div>