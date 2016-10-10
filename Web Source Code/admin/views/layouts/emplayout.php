<?php

/* @var $this \yii\web\View */
/* @var $content string */

use yii\helpers\Html;
//use yii\bootstrap\Nav;
//use yii\bootstrap\NavBar;
use yii\widgets\Breadcrumbs;
use app\assets\EmpAsset;

EmpAsset::register($this);
?>
<?php $this->beginPage() ?>
<!DOCTYPE html>
<html lang="<?= Yii::$app->language ?>">
<head>
    <meta charset="<?= Yii::$app->charset ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?= Html::csrfMetaTags() ?>
    <title><?= Html::encode($this->title) ?></title>
    <link rel="shortcut icon" href="<?= Yii::$app->homeURL; ?>/favicon.ico" type="image/x-icon" />
    <?php $this->head() ?>
</head>
<body>
	<section>
        <div class="" >
    	    <div class="wrapper">
				<?php $this->beginBody() ?>
					<?= $content ?>
                <?php $this->endBody() ?>
			</div>
        </div>
    </section>
</body>
</html>
<?php $this->endPage() ?>