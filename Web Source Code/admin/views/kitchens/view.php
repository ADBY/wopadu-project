<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\Kitchens */

$this->title = $model_k->kitchen_name;
$this->params['breadcrumbs'][] = ['label' => 'Area', 'url' => ['index', 's' => $model_k->store_id]];
$this->params['breadcrumbs'][] = $this->title;

?>

<div class="kitchens-view">
    <div class="row">
    	<?php if(Yii::$app->session->hasFlash('kitchens')) { ?>
        <div class="col-md-12">
			<div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('kitchens') ?></strong>
            </div>
        </div>
        <?php } ?>
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <span class="pull-right">
                        <?= Html::a('Update', ['update', 'id' => $model_k->id], ['class' => 'btn btn-primary btn-xs']) ?>
                        <?= Html::a('Delete', ['delete', 'id' => $model_k->id], [
                            'class' => 'btn btn-danger btn-xs',
                            'data' => [
                                'confirm' => 'Are you sure you want to delete this item?',
                                'method' => 'post',
                            ],
                        ]) ?>
                    </span>
                </header>
                <?php /*?><div class="panel-body">
    
					<?= DetailView::widget([
						'model' => $model,
						'attributes' => [
							//'id',
							[
								'attribute' => 'Store Name',
								'value' => $model->store->store_name,
							],
							'cook_name',
							'kitchen_name',
							'kitchen_description:ntext',
							//'added_date',
						],
                    ]) ?>
                </div><?php */?>
                <div class="panel-body">
                    <table class="table_cust_1" style="width:100%">
                        <?php /*?><tr>
                            <td style="width:30%"><strong>Store Name</strong></td>
                            <td><?= $model_k->store_id ?></td>
                        </tr><?php */?>
                        <?php /*?><tr>
                            <td><strong>Cook Name</strong></td>
                            <td><?= $model_k->cook_name ?></td>
                        </tr>
                        <tr>
                            <td><strong>Cook Email</strong></td>
                            <td><?= $model_l->email ?></td>
                        </tr><?php */?>
                        <tr>
                            <td><strong>Area Name</strong></td>
                            <td><?= $model_k->kitchen_name ?></td>
                        </tr>
                        <tr>
                            <td><strong>Area Description</strong></td>
                            <td><?= $model_k->kitchen_description ?></td>
                        </tr>
                        <tr>
                            <td><strong>Added Date</strong></td>
                            <td><?= $model_k['added_date'] ?></td>
                        </tr>
                        <?php /*?><tr>
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
                        </tr><?php */?>
                    </table>
                </div>
            </section>
        </div>
    </div>
</div>