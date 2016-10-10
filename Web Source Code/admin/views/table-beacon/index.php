<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel app\models\TableBeaconSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Tables';
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="table-beacon-index">
	<div class="row">
    	<?php if(Yii::$app->session->hasFlash('tablebeacon')) { ?>
        <div class="col-sm-12">
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('tablebeacon') ?></strong>
            </div>
        </div>
        <?php } ?>
        
        <?php if(empty($stores_list)) { ?>
		<div class="col-sm-12">
            <div class="alert alert-danger fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong>No Store exists. Please add new store.</strong>
            </div>
        </div>
		<?php } else { ?>
        
        <div class="col-md-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <form class="form-horizontal adminex-form" method="get">
                        <div class="form-group">
                            <label class="col-sm-2 col-sm-2 control-label">Select Store</label>
                            <div class="col-sm-8">
                                <select name="store_id" id="store_id" class="form-control" onChange="javascript:window.location='index?s='+this.value">
                                    <?php
									foreach($stores_list as $key=>$store)
									{
										$selected = "";
										if(isset($_GET['s']) && $_GET['s'] == $key)
										{
											$selected = ' selected="selected"';
										}
										echo '<option value="'.$key.'" '.$selected.'>'.$store.'</option>';
									}
									?>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                        <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
                    <span class="pull-right">
                        <?= Html::a('Add Table', ['create', 's'=> $_GET['s']], ['class' => 'btn btn-success btn-xs']) ?>
                    </span>
                </header>
                <div class="panel-body">
					<?php /*?><?= GridView::widget([
                        'dataProvider' => $dataProvider,
                        //'filterModel' => $searchModel,
                        'columns' => [
                            ['class' => 'yii\grid\SerialColumn'],
                            //'id',
                            'store_id',
                            'table_id',
                            'beacon_major',
                            'beacon_minor',
                            'distance',
                            ['class' => 'yii\grid\ActionColumn'],
                        ],
                    ]); ?><?php */?>
                	
                    <?php if(empty($tables)) { ?>
                    <h5>No tables found.</h5>
                    <?php } else { ?>
                    <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Table</th>
                            <th>Beacon Major</th>
                            <th>Beacon Minor</th>
                            <th>Distance (meter)</th>
                            <?php /*?><th>Action</th><?php */?>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
					foreach($tables as $key=>$table)
					{
						$row_span = count($table);
						
						echo '<tr style="border-top:2px solid #dede99">';
						echo '<td rowspan="'.$row_span.'">';
						echo '<h5>'.$key.'</h5>';
						echo Html::a('<span class="fa fa-edit"></span> Update', ['update', 'id'=>$table[0]['id']], ['title' => 'Update' ,'style' => '', 'class' => 'btn btn-xs btn-warning']);
						echo " &nbsp;&nbsp;&nbsp;";
						echo Html::a('<span class="fa fa-trash-o"></span> Delete', ['delete', 'id'=>$table[0]['id']], ['title' => 'Delete' ,'style' => '', 'class' => 'btn btn-xs btn-danger', 'data-method' => 'post', 'data-confirm' => 'Are you sure you want to delete this item?']);
						echo '</td>';
						
						$i = 0;
						foreach($table as $beac)
						{
							if($i != 0) { echo '<tr>'; }
                            echo '<td style="width:25%">'.$beac['beacon_major'].'</td>
                                <td style="width:25%">'.$beac['beacon_minor'].'</td>
                                <td style="width:25%">'.$beac['distance'].'</td>';
							//if($i != 0) { echo '</tr>'; }
							/*echo '<td style="width:90px">';
							echo Html::a('<span class="fa fa-edit"></span> Update', ['update', 'id'=>$beac['id']], ['title' => 'View' ,'style' => '', 'class' => 'btn btn-xs btn-warning']);
							echo '</td>';*/
							echo '</tr>';
							$i++;
						}
						//echo '</tr>';
						echo '';
					}
					?>
                    </tbody>
                    </table>
                    
                    <?php } ?>
                </div>
            </section>
        </div>
        <?php } ?>
    </div>
</div>