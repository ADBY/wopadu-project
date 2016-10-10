<?php
$controller_name 	= Yii::$app->controller->id;
$action_name		= Yii::$app->controller->action->id;
$session 			= Yii::$app->session;
?>

<div class="left-side sticky-left-side">
    <!--logo and iconic logo start-->
    <div class="logo">
        <a href="<?= Yii::$app->urlManager->createUrl('site/index') ?>"><img src="<?= Yii::$app->homeUrl ?>images/logo.png" alt=""></a>
    </div>
    <div class="logo-icon text-center">
        <a href="<?= Yii::$app->urlManager->createUrl('site/index') ?>"><img src="<?= Yii::$app->homeUrl ?>images/logo_icon.png" alt=""></a>
    </div>
    <!--logo and iconic logo end-->

    <div class="left-side-inner">

        <!--sidebar nav start-->
        <ul class="nav nav-pills nav-stacked custom-nav">
            
            <?php //if($_SESSION['login_role'] == 1 || $_SESSION['login_role'] == 2) { ?>
            <li <?php if($controller_name == "site" && $action_name == "index") { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('site/index') ?>">
                    <i class="fa fa-home"></i>
                    <span> Dashboard</span>
                </a>
            </li>
            <?php // } ?>
            
            
            <?php if($session['super_admin'] == 'YES') { ?>
            <li <?php if( $session['login_role'] == 1 && $controller_name == "accounts" && ($action_name == "index" || $action_name == "create" || $action_name == "update" || $action_name == "view")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('accounts/index') ?>">
                    <i class="fa fa-bars"></i>
                    <?php if($session['login_role'] == 1) { ?>
                    <span> Accounts</span>
                    <?php } else { ?>
                    <span> Back to All Accounts</span>
                    <?php } ?>
                </a>
            </li>
            <?php } ?>
            
            <?php if($session['login_role'] == 2) { ?>
            <li <?php if($controller_name == "accounts" && ($action_name == "update" || $action_name == "profile")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('accounts/profile') ?>">
                    <i class="fa fa-user"></i>
                    <span> My Account</span>
                </a>
            </li>
            
            <li <?php if($controller_name == "stores" && ($action_name == "index" || $action_name == "create" || $action_name == "update" || $action_name == "view")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('stores/index') ?>">
                    <i class="fa fa-square"></i>
                    <span> Stores</span>
                </a>
            </li>
            <?php } ?>
                        
            <?php if($session['super_admin'] == 'YES' && $_SESSION['login_role'] == 2) { ?>
            <li <?php if($controller_name == "beacons" && ($action_name == "index" || $action_name == "create" || $action_name == "update" || $action_name == "view")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('beacons/index') ?>">
                    <i class="fa fa-ticket"></i>
                    <span> Beacons</span>
                </a>
            </li>
            <?php } ?>
            
            <?php if($session['login_role'] == 2) { ?>
            
            <?php /*?><li <?php if($controller_name == "table-beacon") { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('table-beacon/index') ?>">
                    <i class="fa fa-thumb-tack"></i>
                    <span> Tables</span>
                </a>
            </li><?php */?>
            
            <li <?php if($controller_name == "kitchens") { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('kitchens/index') ?>">
                    <i class="fa fa-sitemap"></i>
                    <span> Area</span>
                </a>
            </li>
            
            
            <li <?php if(($controller_name == "categories" || $controller_name == "items" || $controller_name == "item-option") && ($action_name == "index" || $action_name == "list" || $action_name == "create" || $action_name == "update" || $action_name == "view")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('categories/list') ?>">
                    <i class="fa fa-cutlery"></i>
                    <span> Menu</span>
                </a>
            </li>
            
            <li <?php if($controller_name == "employee") { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('employee/index') ?>">
                    <i class="fa fa-asterisk"></i>
                    <span> Employees</span>
                </a>
            </li>
            
            <li <?php if($controller_name == "orders" || $controller_name == "order-details") { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('orders/index') ?>">
                    <i class="fa fa-shopping-cart"></i>
                    <span> Orders</span>
                </a>
            </li>
            
            <li <?php if($controller_name == "site-info" && ($action_name == "reports")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('reports/generate-report') ?>">
                    <i class="fa fa-file-text-o"></i>
                    <span> Reports</span>
                </a>
            </li>

            <?php } ?>
            
            <?php if($session['login_role'] == 1) { ?>
             
            <li <?php if($controller_name == "admin" && ($action_name == "profile" || $action_name == "update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('admin/profile') ?>">
                    <i class="fa fa-user"></i>
                    <span> Profile</span>
                </a>
            </li>
            <?php } ?>
            
            <?php if($session['login_role'] == 1) { ?>
            
            <li <?php if($controller_name == "users" && ($action_name == "index" || $action_name == "create" || $action_name == "update" || $action_name == "view")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('users/index') ?>">
                    <i class="fa fa-users"></i>
                    <span> Users</span>
                </a>
            </li>
            
            <?php /*?><li <?php if($controller_name == "feedback-review" && ($action_name == "index" || $action_name == "view")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('feedback-review/index') ?>">
                    <i class="fa fa-comment"></i>
                    <span> Feedback Reviews</span>
                </a>
            </li><?php */?>
            
            <li <?php if($controller_name == "app-rating" && ($action_name == "index" || $action_name == "view")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('app-rating/index') ?>">
                    <i class="fa fa-star-half-o"></i>
                    <span> App Ratings</span>
                </a>
            </li>
            
            <li <?php if($controller_name == "translater-user" && ($action_name == "index" || $action_name == "view" || $action_name == "create")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('translater-user/index') ?>">
                    <i class="fa fa-font"></i>
                    <span> Translater user</span>
                </a>
            </li>
            
            <li <?php if($controller_name == "site-content") { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('site-content/index') ?>">
                    <i class="fa fa-list-alt"></i>
                    <span> Site Content</span>
                </a>
            </li>
            
            <li <?php if($controller_name == "tax") { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('tax/index') ?>">
                    <i class="fa fa-tags"></i>
                    <span> Tax </span>
                </a>
            </li>
            
            <?php /*?><li <?php if($controller_name == "device-registered" && ($action_name == "index" || $action_name == "create" || $action_name == "update" || $action_name == "view")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('device-registered/index') ?>">
                    <i class="fa fa-mobile"></i>
                    <span> Registered Devices</span>
                </a>
            </li><?php */?>
            
            <li <?php if($controller_name == "site-info" && ($action_name == "index" || $action_name == "update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('site-info/index') ?>">
                    <i class="fa fa-cogs"></i>
                    <span> Settings</span>
                </a>
            </li>
            
            <li <?php if($controller_name == "site-info" && ($action_name == "reports")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('reports/generate-report') ?>">
                    <i class="fa fa-file-text-o"></i>
                    <span> Reports</span>
                </a>
            </li>
            
            <?php } ?>
            
            <?php if($session['login_role'] == 3) { ?>
            <li <?php if($controller_name == "cook" && ($action_name == "index" || $action_name == "update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('cook/index') ?>">
                    <i class="fa fa-user"></i>
                    <span> My Account</span>
                </a>
            </li>
            <li <?php if($controller_name == "cook" && $action_name == "orders") { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('cook/orders') ?>">
                    <i class="fa fa-cutlery"></i>
                    <span> Orders</span>
                </a>
            </li>
            <li <?php if($controller_name == "order-details" && $action_name == "resto") { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('cook/resto-screen') ?>">
                    <i class="fa fa-caret-square-o-right"></i>
                    <span> Restaurant Screen</span>
                </a>
            </li>
            <?php } ?>
            
            <?php if($session['login_role'] == 6) { ?>
            
            <style>
			.info-number .badge{
				right:initial;
			}
			a.list-group-item.active>.badge, .nav-pills>.active>a>.badge {
				color: #FFFFFF;
				background-color: #FF6C60;
			}
			</style>
            
            <?php
			// Fetch translated item count notifier
			$count_sql = Yii::$app->db->createCommand("SELECT type FROM translater_item WHERE action = 0")->queryAll();
			
			/*echo "<pre>";
			print_r($count_sql);
			echo "</pre>";*/
			$store_count = 0;
			$cat_count = 0;
			$prod_count = 0;
			$variety_count = 0;
			$op_main_count = 0;
			$op_sub_count = 0;
			
			foreach($count_sql as $cs)
			{
				if($cs['type'] == 1)
					$store_count++;
				else if($cs['type'] == 2)
					$cat_count++;
				else if($cs['type'] == 3)
					$prod_count++;
				else if($cs['type'] == 4)
					$variety_count++;
				else if($cs['type'] == 5)
					$op_main_count++;
				else if($cs['type'] == 6)
					$op_sub_count++;
			}
			?>

            <li <?php if($controller_name == "translater-user" && ($action_name == "view" || $action_name == "update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('translater-user/view?id='.$session['t_user_id']) ?>">
                    <i class="fa fa-user"></i>
                    <span> Profile</span>
                </a>
            </li>
            
            <li <?php if(isset($_GET['type']) && $_GET['type'] == 1 && ($action_name == "translate-item" || $action_name == "translate-item-update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('translater-user/translate-item?type=1') ?>" class="info-number">
                    <i class="fa fa-angle-double-right"></i>
                    <span> Stores</span>
                    <?php if($store_count > 0) { echo '<span class="badge">'.$store_count.'</span>'; } ?>
                </a>
            </li>
            <li <?php if(isset($_GET['type']) && $_GET['type'] == 2 && ($action_name == "translate-item" || $action_name == "translate-item-update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('translater-user/translate-item?type=2') ?>" class="info-number">
                    <i class="fa fa-angle-double-right"></i>
                    <span> Categories</span>
                    <?php if($cat_count > 0) { echo '<span class="badge">'.$cat_count.'</span>'; } ?>
                </a>
            </li>
            <li <?php if(isset($_GET['type']) && $_GET['type'] == 3 && ($action_name == "translate-item" || $action_name == "translate-item-update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('translater-user/translate-item?type=3') ?>" class="info-number">
                    <i class="fa fa-angle-double-right"></i>
                    <span> Products</span>
                    <?php if($prod_count > 0) { echo '<span class="badge">'.$prod_count.'</span>'; } ?>
                </a>
            </li>
            <li <?php if(isset($_GET['type']) && $_GET['type'] == 4 && ($action_name == "translate-item" || $action_name == "translate-item-update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('translater-user/translate-item?type=4') ?>" class="info-number">
                    <i class="fa fa-angle-double-right"></i>
                    <span> Products Varieties</span>
                    <?php if($variety_count > 0) { echo '<span class="badge">'.$variety_count.'</span>'; } ?>
                </a>
            </li>
            <li <?php if(isset($_GET['type']) && $_GET['type'] == 5 && ($action_name == "translate-item" || $action_name == "translate-item-update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('translater-user/translate-item?type=5') ?>" class="info-number">
                    <i class="fa fa-angle-double-right"></i>
                    <span> Product Options Main</span>
                    <?php if($op_main_count > 0) { echo '<span class="badge">'.$op_main_count.'</span>'; } ?>
                </a>
            </li>
            <li <?php if(isset($_GET['type']) && $_GET['type'] == 6 && ($action_name == "translate-item" || $action_name == "translate-item-update")) { echo 'class="active"'; } ?>>
                <a href="<?= Yii::$app->urlManager->createUrl('translater-user/translate-item?type=6') ?>" class="info-number">
                    <i class="fa fa-angle-double-right"></i>
                    <span> Products Option Sub</span>
                    <?php if($op_sub_count > 0) { echo '<span class="badge">'.$op_sub_count.'</span>'; } ?>
                </a>
            </li>
            
            <?php } ?>
            
        </ul>
        <!--sidebar nav end-->
    </div>
</div>