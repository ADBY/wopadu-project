<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Admin */

$this->title = "Profile";
$this->params['breadcrumbs'][] = ['label' => 'Admins', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<?php /*?><div class="admin-view">

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
            'email:email',
            'password',
            'mobile',
            'auth_key',
            'password_reset_token',
            'security_question',
            'security_answer',
            'verif_link',
            'last_login_date',
            'last_login_ip',
            'status',
        ],
    ]) ?>

</div><?php */?>

<div class="row">
    <div class="col-md-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
                <?= Html::encode($this->title) ?>
                <span class="pull-right">
                	<?= Html::a('Update', ['update', 'id' => $model->id], ['class' => 'btn btn-primary btn-xs']) ?>
                </span>
            </header>
            <div class="panel-body">
            	<?= DetailView::widget([
					'model' => $model,
					'attributes' => [
						//'id',
						'email:email',
						//'password',
						'mobile',
						'auth_key',
						'password_reset_token',
						'security_question',
						'security_answer',
						'verif_link',
						'last_login_date',
						'last_login_ip',
					],
				]) ?>
            </div>
        </section>
    </div>
</div>