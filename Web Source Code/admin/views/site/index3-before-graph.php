<?php

/* @var $this yii\web\View */

$this->title = 'Welcome to Wopado';
$this->params['breadcrumbs'][] = $this->title;

$session = Yii::$app->session;
?>
<div class="site-index">    
    
    <div class="wrapper">
        <div class="row">
            <div class="col-md-12">
                
                
    			<?php if($session['login_role'] == 1) { ?>
                <h4>Hello, <?= $session['login_email'] ?></h4><br />
                <div class="row state-overview" style="color:#607D8B">
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-tasks"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM accounts")->queryScalar(); ?></div>
                                <div class="title">Total Accounts</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-tags"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM stores")->queryScalar(); ?></div>
                                <div class="title">Total Stores</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-user"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM users")->queryScalar(); ?></div>
                                <div class="title">Registered Users</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-star-half-o"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM app_rating")->queryScalar(); ?></div>
                                <div class="title">Total Reviews</div>
                            </div>
                        </div>
                    </div>
                </div>
				<?php } else if($session['login_role'] == 2) { ?>
				
                <section class="panel">
                    <div class="panel-body"><h4>Hello, <?= $session['account_name'] ?></h4><small><?= $session['login_email'] ?></small></div>
                </section>
                    
				<?php $stores_list = $session['stores_list']; ?>
                
                <?php foreach($stores_list as $key=>$value) { ?>
                
                <h4><?= $value ?></h4>
                <div class="row state-overview" style="color:#607D8B">
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-cutlery"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(I.id) FROM `items` as I INNER JOIN categories as C ON I.category_id = C.id AND C.store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Products</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-shopping-cart"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM orders  WHERE store_id = $key and payment_status = 1")->queryScalar(); ?></div>
                                <div class="title">Total Orders</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-sitemap"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM kitchens WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Kitchens</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-mobile"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM waiter WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Waiters</div>
                            </div>
                        </div>
                    </div>
                </div>
                <?php } ?>
                
				<?php if(!$stores_list) { ?>
                <section class="panel">
                    <div class="panel-body"><h4 style="display:inline-block">No Store exists. Please add new store. </h4>
                    <a href="<?php echo Yii::$app->urlManager->createUrl("stores/create"); ?>" class="btn btn-md- btn-green-sea" style="float:right">Add Store</a>
                    </div>
                </section>
                <?php } ?>
                
				<?php /*?><?php foreach($stores_list as $key=>$value) { ?>
                <h4><?= $value ?></h4>
                <div class="row state-overview">
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel purple">
                            <div class="symbol">
                                <i class="fa fa-tasks"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(I.id) FROM `items` as I INNER JOIN categories as C ON I.category_id = C.id AND C.store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Products</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel red">
                            <div class="symbol">
                                <i class="fa fa-tags"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM orders  WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Orders</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel blue">
                            <div class="symbol">
                                <i class="fa fa-user"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM kitchens WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Kitchens</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel green">
                            <div class="symbol">
                                <i class="fa fa-star-half-o"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><?= $countAccount = Yii::$app->db->createCommand("SELECT count(id) FROM waiter WHERE store_id = $key")->queryScalar(); ?></div>
                                <div class="title">Total Waiters</div>
                            </div>
                        </div>
                    </div>
                </div>
                <?php } ?><?php */?>
                
				<?php /*?><?php foreach($stores_list as $key=>$value) { ?>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title"><?= $value ?></h3>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3">
                                <h4><i class="fa fa-cutlery"></i> Total Products: 123</h4>
                            </div>
                            <div class="col-md-3">
                                <h4><i class="fa fa-shopping-cart"></i> Total Orders: 123</h4>
                            </div>
                            <div class="col-md-3">
                                <h4><i class="fa fa-sitemap"></i> Total Kitchens: 123</h4>
                            </div>
                            <div class="col-md-3">
                                <h4><i class="fa fa-mobile"></i> Total Waiters: 123</h4>
                            </div>
                        </div>
                    </div>
                </div>
                <?php } ?><?php */?>
                
                
                <?php } else if($session['login_role'] == 3) { ?>
                <h4>Hello, <?= $session['login_email'] ?></h4><br />
                <div class="row state-overview" style="color:#607D8B">
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-cutlery"></i>
                            </div>
                            <div class="state-value">
                                <?php /*?><div class="value"><?= $totalPendingOrders = Yii::$app->db->createCommand("SELECT COUNT(DISTINCT order_id) FROM `order_details` WHERE kitchen_id = ".$session['kitchen_id']." and status < 4")->queryScalar(); ?></div><?php */?>
                                <div class="value"><?= $totalPendingOrders = Yii::$app->db->createCommand("SELECT COUNT(DISTINCT order_id) FROM `order_details` as OD INNER JOIN orders as O ON O.id = OD.order_id WHERE OD.kitchen_id = ".$session['kitchen_id']." and OD.status < 4 and O.payment_status = 1")->queryScalar(); ?></div>
                                <div class="title">Pending Orders</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-user"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><a href="<?= Yii::$app->urlManager->createUrl('cook/index') ?>" style="text-decoration:initial; color:#607D8B">View</a></div>
                                <div class="title"><a href="<?= Yii::$app->urlManager->createUrl('cook/index') ?>" style="text-decoration:initial; color:#607D8B">My Account</a></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-tags"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><a href="<?= Yii::$app->urlManager->createUrl('cook/orders') ?>" style="text-decoration:initial; color:#607D8B">View</a></div>
                                <div class="title"><a href="<?= Yii::$app->urlManager->createUrl('cook/orders') ?>" style="text-decoration:initial; color:#607D8B">Orders</a></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3 col-xs-6 col-sm-3">
                        <div class="panel">
                            <div class="symbol">
                                <i class="fa fa-caret-square-o-right"></i>
                            </div>
                            <div class="state-value">
                                <div class="value"><a href="<?= Yii::$app->urlManager->createUrl('cook/resto-screen') ?>" style="text-decoration:initial; color:#607D8B">View</a></div>
                                <div class="title"><a href="<?= Yii::$app->urlManager->createUrl('cook/resto-screen') ?>" style="text-decoration:initial; color:#607D8B">Resto Screen</a></div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                
				<?php } else { ?>
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
                </div>
                
                <?php } ?>
    
    		</div>
        </div>
    </div>
</div>
