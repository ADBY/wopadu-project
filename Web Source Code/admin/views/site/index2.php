<?php

/* @var $this yii\web\View */

$this->title = 'Welcome to Wopado';
$this->params['breadcrumbs'][] = $this->title;

$session = Yii::$app->session;
?>
<div class="site-index">

    <div class="jumbotron">
        <h1>Welcome!</h1>
        <h3><?= $session['email'] ?></h3>
<?php
echo "<pre>";
if(Yii::$app->user->isGuest)
{
	echo "Guest User";
}
else
{
	echo "Super Admin: ".$session['super_admin'];
	echo "<br />";
	echo "Login Id: ".$session['login_id'];
	echo "<br />";
	echo "Role: ".$session['login_role'];
	echo "<br />";
	echo "Email: " .$session['login_email'];
	
	if($session['login_role'] == 2)
	{
		echo "<br />";
		echo "Account Id: ".$session['account_id'];
		echo "<br />";
		echo "Account Name: " .$session['account_name'];
		echo "<br />";
		echo "Allowed Stores: " .$session['allowed_stores'];
		echo "<br />";
		echo "Stores List: <br />";
		print_r($session['stores_list']);
	}
}
echo "</pre>";
?>
        <?php /*?><p class="lead">You have successfully created your Yii-powered application.</p>

        <p><a class="btn btn-lg btn-success" href="http://www.yiiframework.com">Get started with Yii</a></p><?php */?>
    </div>

    <?php /*?><div class="body-content">

        <div class="row">
            <div class="col-md-4">
                <h2>Heading</h2>

                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et
                    dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip
                    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
                    fugiat nulla pariatur.</p>

                <p><a class="btn btn-default" href="http://www.yiiframework.com/doc/">Yii Documentation &raquo;</a></p>
            </div>
            <div class="col-md-4">
                <h2>Heading</h2>

                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et
                    dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip
                    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
                    fugiat nulla pariatur.</p>

                <p><a class="btn btn-default" href="http://www.yiiframework.com/forum/">Yii Forum &raquo;</a></p>
            </div>
            <div class="col-md-4">
                <h2>Heading</h2>

                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et
                    dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip
                    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
                    fugiat nulla pariatur.</p>

                <p><a class="btn btn-default" href="http://www.yiiframework.com/extensions/">Yii Extensions &raquo;</a></p>
            </div>
        </div>

    </div><?php */?>
</div>
