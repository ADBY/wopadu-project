<?php

use yii\helpers\Html;
use yii\widgets\DetailView;
/* @var $this yii\web\View */
/* @var $model app\models\Kitchens */

$this->title = "Profile";
//$this->params['breadcrumbs'][] = ['label' => 'Kitchens', 'url' => ['index', 's' => $model_k->store_id]];
$this->params['breadcrumbs'][] = $this->title;

$session = Yii::$app->session;
?>

<div class="kitchens-view">
    <div class="row">
    	
        <div class="col-md-12">
			<?php if(Yii::$app->session->hasFlash('kitchens')) { ?>
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('kitchens') ?></strong>
            </div>
            <?php } ?>        
        </div>
        <div class="col-md-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                    <span class="pull-right">
                        <?= Html::a('Update', ['update', 'id' => $model_k->id], ['class' => 'btn btn-primary btn-xs']) ?>
                    </span>
                </header>

                <div class="panel-body">
                    <table class="table_cust_1" style="width:100%">
                        
						<tr>
                            <td><strong>Employee Name</strong></td>
                            <td><?= $model_e['emp_name'] ?></td>
                        </tr>
                        <tr>
                            <td style="width:30%"><strong>Store Name</strong></td>
                            <td><?php 
							echo $store = Yii::$app->db->createCommand("SELECT store_name FROM `stores` WHERE id = ".$model_e->store_id."")->queryScalar();
							?></td>
                        </tr>
                        <tr>
                            <td><strong>Cook Email</strong></td>
                            <td><?= $model_l->email ?></td>
                        </tr>
                        <tr>
                            <td><strong>Kitchen Name</strong></td>
                            <td><?= $model_k->kitchen_name ?></td>
                        </tr>
                        <tr>
                            <td><strong>Kitchen Description</strong></td>
                            <td><?= $model_k->kitchen_description ?></td>
                        </tr>
                        <tr>
                            <td><strong>Last login Date</strong></td>
                            <td><?= $session['last_login_date']; ?></td>
                        </tr>
                        <tr>
                            <td><strong>Last login Ip address</strong></td>
                            <td><?= $session['last_login_ip'] ?></td>
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
</div>