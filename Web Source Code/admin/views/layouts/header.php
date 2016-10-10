<!-- header section start-->
<div class="header-section">

    <!--toggle button start-->
    <a class="toggle-btn"><i class="fa fa-bars"></i></a>
    <!--toggle button end-->

    <!--search start-->
    <?php /*?><form class="searchform" action="index.html" method="post">
        <input type="text" class="form-control" name="keyword" placeholder="Search here..." />
    </form><?php */?>
    <!--search end-->

    <!--notification menu start -->
    <div class="menu-right">
        <ul class="notification-menu">
            <?php /*?><li>
                <a href="#" class="btn btn-default dropdown-toggle info-number" data-toggle="dropdown">
                    <i class="fa fa-tasks"></i>
                    <span class="badge">8</span>
                </a>
                <div class="dropdown-menu dropdown-menu-head pull-right">
                    <h5 class="title">You have 8 pending task</h5>
                    <ul class="dropdown-list user-list">
                        <li class="new">
                            <a href="#">
                                <div class="task-info">
                                    <div>Database update</div>
                                </div>
                                <div class="progress progress-striped">
                                    <div style="width: 40%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="40" role="progressbar" class="progress-bar progress-bar-warning">
                                        <span class="">40%</span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="new">
                            <a href="#">
                                <div class="task-info">
                                    <div>Dashboard done</div>
                                </div>
                                <div class="progress progress-striped">
                                    <div style="width: 90%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="90" role="progressbar" class="progress-bar progress-bar-success">
                                        <span class="">90%</span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <div class="task-info">
                                    <div>Web Development</div>
                                </div>
                                <div class="progress progress-striped">
                                    <div style="width: 66%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="66" role="progressbar" class="progress-bar progress-bar-info">
                                        <span class="">66% </span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <div class="task-info">
                                    <div>Mobile App</div>
                                </div>
                                <div class="progress progress-striped">
                                    <div style="width: 33%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="33" role="progressbar" class="progress-bar progress-bar-danger">
                                        <span class="">33% </span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <div class="task-info">
                                    <div>Issues fixed</div>
                                </div>
                                <div class="progress progress-striped">
                                    <div style="width: 80%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="80" role="progressbar" class="progress-bar">
                                        <span class="">80% </span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="new"><a href="">See All Pending Task</a></li>
                    </ul>
                </div>
            </li>
            <li>
                <a href="#" class="btn btn-default dropdown-toggle info-number" data-toggle="dropdown">
                    <i class="fa fa-envelope-o"></i>
                    <span class="badge">5</span>
                </a>
                <div class="dropdown-menu dropdown-menu-head pull-right">
                    <h5 class="title">You have 5 Mails </h5>
                    <ul class="dropdown-list normal-list">
                        <li class="new">
                            <a href="">
                                <span class="thumb"><img src="<?= Yii::$app->homeUrl ?>images/photos/user1.png" alt="" /></span>
                                <span class="desc">
                                  <span class="name">John Doe <span class="badge badge-success">new</span></span>
                                  <span class="msg">Lorem ipsum dolor sit amet...</span>
                                </span>
                            </a>
                        </li>
                        <li>
                            <a href="">
                                <span class="thumb"><img src="<?= Yii::$app->homeUrl ?>images/photos/user2.png" alt="" /></span>
                                <span class="desc">
                                  <span class="name">Jonathan Smith</span>
                                  <span class="msg">Lorem ipsum dolor sit amet...</span>
                                </span>
                            </a>
                        </li>
                        <li>
                            <a href="">
                                <span class="thumb"><img src="<?= Yii::$app->homeUrl ?>images/photos/user3.png" alt="" /></span>
                                <span class="desc">
                                  <span class="name">Jane Doe</span>
                                  <span class="msg">Lorem ipsum dolor sit amet...</span>
                                </span>
                            </a>
                        </li>
                        <li>
                            <a href="">
                                <span class="thumb"><img src="<?= Yii::$app->homeUrl ?>images/photos/user4.png" alt="" /></span>
                                <span class="desc">
                                  <span class="name">Mark Henry</span>
                                  <span class="msg">Lorem ipsum dolor sit amet...</span>
                                </span>
                            </a>
                        </li>
                        <li>
                            <a href="">
                                <span class="thumb"><img src="<?= Yii::$app->homeUrl ?>images/photos/user5.png" alt="" /></span>
                                <span class="desc">
                                  <span class="name">Jim Doe</span>
                                  <span class="msg">Lorem ipsum dolor sit amet...</span>
                                </span>
                            </a>
                        </li>
                        <li class="new"><a href="">Read All Mails</a></li>
                    </ul>
                </div>
            </li><?php */?>
            
            <?php if($session['login_role'] == 6) { 
			
			//$count_notif = Yii::$app->db->createCommand("SELECT count(id) FROM translater_item WHERE action = 0")->queryScalar();
			
			?>
			<script>
            function f() { 
                //alert('Hi');
                var _csrf = yii.getCsrfToken();
                $.ajax({
                    url: '<?= Yii::$app->urlManager->createUrl('translater-user/update-notif') ?>',
                    method: 'POST',
                    data: 'tbl_n=1&_csrf='+_csrf,
                    cache: false,
                    success: function(data){
                        //if(data == 1) {
                            $("#notif-header").html(data);
                        /*} else {
                            alert("Something went wrong, Please try again");
                        }*/
                    },
                    error: function(){
                        alert("Something went wrong, Please try again");
                    }		
                });
                setTimeout(f, 60000)
            }
            setTimeout(f, 60000)
            </script>

            <li id="notif-header">
                <a href="#" class="btn btn-default dropdown-toggle info-number" data-toggle="dropdown">
                    <i class="fa fa-bell-o"></i>
                    <?php if($count_notif > 0) { echo '<span class="badge">'.$count_notif.'</span>'; } ?>
                </a>
                <div class="dropdown-menu dropdown-menu-head pull-right">
                    <h5 class="title">Notifications</h5>
                    <ul class="dropdown-list normal-list">
                    	<?php if($count_notif > 0) { ?>
						<?php if($store_count > 0) { echo '<li class="new"><a href="'.Yii::$app->urlManager->createUrl('translater-user/translate-item?type=1').'"><span class="label label-danger"><i class="fa fa-bolt"></i></span><span class="name">'.$store_count.' Stores had been added.</span></a></li>';
} ?>
						<?php if($cat_count > 0) { echo '<li class="new"><a href="'.Yii::$app->urlManager->createUrl('translater-user/translate-item?type=2').'"><span class="label label-danger"><i class="fa fa-bolt"></i></span><span class="name">'.$cat_count.' Categories had been added.</span></a></li>';
} ?>
						<?php if($prod_count > 0) { echo '<li class="new"><a href="'.Yii::$app->urlManager->createUrl('translater-user/translate-item?type=3').'"><span class="label label-danger"><i class="fa fa-bolt"></i></span><span class="name">'.$prod_count.' Products had been added.</span></a></li>';
} ?>
						<?php if($variety_count > 0) { echo '<li class="new"><a href="'.Yii::$app->urlManager->createUrl('translater-user/translate-item?type=4').'"><span class="label label-danger"><i class="fa fa-bolt"></i></span><span class="name">'.$variety_count.' Products varieties had been added.</span></a></li>';
} ?>
						<?php if($op_main_count > 0) { echo '<li class="new"><a href="'.Yii::$app->urlManager->createUrl('translater-user/translate-item?type=5').'"><span class="label label-danger"><i class="fa fa-bolt"></i></span><span class="name">'.$op_main_count.' Product options had been added.</span></a></li>';
} ?>
						<?php if($op_sub_count > 0) { echo '<li class="new"><a href="'.Yii::$app->urlManager->createUrl('translater-user/translate-item?type=6').'"><span class="label label-danger"><i class="fa fa-bolt"></i></span><span class="name">'.$op_sub_count.' Sub options had been added.</span></a></li>';
} ?>
						<?php } else { ?>
                        <li class="new"><a href="#">No new notifications</a></li>
                        <?php } ?>
                    </ul>
                </div>
            </li>
            
            <?php } ?>
            <li>
                <a href="#" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                    <img src="<?= Yii::$app->homeUrl ?>images/user-avatar.png" alt="" />
                    <?php $session = Yii::$app->session; if($session['login_role'] == 1) { echo "Admin"; } else if($session['login_role'] == 2) { echo $session['account_name']; } else if($session['login_role'] == 3) { echo $session['emp_name']; } else if($session['login_role'] == 6) { echo $session['first_name'].' '.$session['last_name']; } ?>
                    <span class="caret"></span>
                </a>
                <ul class="dropdown-menu dropdown-menu-usermenu pull-right">
                    <?php /*?><li><a href="#"><i class="fa fa-user"></i>  Profile</a></li>
                    <li><a href="#"><i class="fa fa-cog"></i>  Settings</a></li><?php */?>
                    <li><a href="<?= Yii::$app->homeUrl ?>site/logout" data-method="get"><i class="fa fa-sign-out"></i> Log Out</a></li>
                </ul>
            </li>

        </ul>
    </div>
    <!--notification menu end -->

</div>
<!-- header section end-->