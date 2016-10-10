<?php

/* @var $this \yii\web\View */
/* @var $content string */

use yii\helpers\Html;
//use yii\bootstrap\Nav;
//use yii\bootstrap\NavBar;
use yii\widgets\Breadcrumbs;
use app\assets\AppAsset;

AppAsset::register($this);
?>
<?php $this->beginPage() ?>
<!DOCTYPE html>
<html lang="<?= Yii::$app->language ?>">
<head>
    <meta charset="<?= Yii::$app->charset ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?= Html::csrfMetaTags() ?>
    <title><?= Html::encode($this->title) ?></title>
    <link rel="shortcut icon" href="../favicon.ico" type="image/x-icon" />
    <?php $this->head() ?>
</head>
<body class="sticky-header">
<?php $this->beginBody() ?>

<section>

	<!-- left side start-->
	<?php require_once __DIR__ . "/sidebar.php"; ?>
    <!-- left side end-->
    
    <!-- main content start-->
    <div class="main-content" >
    
    	<!-- header section start-->
        <?php require_once __DIR__ . "/header.php"; ?>
        <!-- header section end-->
        
        <!-- page heading start-->
        <div class="page-heading">
            <h3>
                <?= $this->title; ?>
            </h3>
            <?php /*?><ul class="breadcrumb">
                <li>
                    <a href="#">Dashboard</a>
                </li>
                <li class="active"> My Dashboard </li>
            </ul><?php */?>
            <?= Breadcrumbs::widget([
                'links' => isset($this->params['breadcrumbs']) ? $this->params['breadcrumbs'] : [],
            ]) ?>
        </div>
        <!-- page heading end-->

        <!--body wrapper start-->
        <div class="wrapper">
        	<?= $content ?>
        </div>
        <!--body wrapper end-->
        
        <!--footer section start-->
        <footer>
            <?= date('Y') ?> &copy; Wopadu by <a href="http://www.lucsoninfotech.com/" target="_blank" class="text-danger">LucsonInfotech.com</a>
        </footer>
        <!--footer section end-->
    </div>
</section>
<?php $this->endBody() ?>
</body>
</html>
<?php $this->endPage() ?>
