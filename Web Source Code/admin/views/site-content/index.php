<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Site Contents';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="site-content-index">
	<div class="row">
    	<?php if(Yii::$app->session->hasFlash('sitecontent')) { ?>
            <div class="col-sm-12">
                <div class="alert alert-warning fade in">
	                <button type="button" class="close close-sm" data-dismiss="alert">
    	        	    <i class="fa fa-times"></i>
        	        </button>
            	    <strong><?= Yii::$app->session->getFlash('sitecontent') ?></strong>
                </div>
            </div>
        <?php } ?>
                
        <div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    About
                    <span class="pull-right">
                        <a href="<?= Yii::$app->urlManager->createUrl(['site-content/update', 'id' => '1']) ?>" title="Update" class="btn btn-success btn-xs">Update</a>
                    </span>
                </header>
                <div class="panel-body">
                    <?php if($model[0]->value == "") { echo "empty.."; } else { echo str_replace("\n", "<br>",$model[0]->value); } ?>
                </div>
            </section>
        </div>
        <div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    Terms
                    <span class="pull-right">
                        <a href="<?= Yii::$app->urlManager->createUrl(['site-content/update', 'id' => '2']) ?>" title="Update" class="btn btn-success btn-xs">Update</a>
                    </span>
                </header>
                <div class="panel-body">
                    <?php if($model[1]->value == "") { echo "empty.."; } else { echo str_replace("\n", "<br>",$model[1]->value); } ?>
                </div>
            </section>
        </div>
        <div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    Privacy Policy
                    <span class="pull-right">
                        <a href="<?= Yii::$app->urlManager->createUrl(['site-content/update', 'id' => '4']) ?>" title="Update" class="btn btn-success btn-xs">Update</a>
                    </span>
                </header>
                <div class="panel-body">
                    <?php if($model[3]->value == "") { echo "empty.."; } else { echo str_replace("\n", "<br>",$model[3]->value); } ?>
                </div>
            </section>
        </div>
        <div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    Faqs
                    <span class="pull-right">
                        <a href="<?= Yii::$app->urlManager->createUrl(['site-content/update', 'id' => '3']) ?>" title="Update" class="btn btn-success btn-xs">Update</a>
                    </span>
                </header>
                <div class="panel-body">
                    <?php if($model[2]->value == "") { echo "empty.."; } else { echo str_replace("\n", "<br>",$model[2]->value); } ?>
                </div>
            </section>
        </div>
        
        
    </div>
</div>