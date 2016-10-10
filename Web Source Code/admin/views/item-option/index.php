<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Product Options';
$this->params['breadcrumbs'][] = ['label' => 'Menu', 'url' => ['categories/list', 's' => $_GET['s']]];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="item-option-index">
	<div class="row">
    	
		<?php if(Yii::$app->session->hasFlash('items')) { ?>
        <div class="col-sm-12">
            <div class="alert alert-warning fade in">
                <button type="button" class="close close-sm" data-dismiss="alert">
                    <i class="fa fa-times"></i>
                </button>
                <strong><?= Yii::$app->session->getFlash('items') ?></strong>
            </div>
        </div>
        <?php } ?>
        
        <div class="col-sm-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?php if($item_options) { ?>
                    <table class="table_cust_2">
                        <tr>
                            <td style="width:33%"><strong>List Name</strong> </td>
                            <td><strong>Options Name / Price</strong> </td>
                            <td style="width:150px"></td>
                        </tr>
                        <?php foreach($item_options as $option)
                        {
                            echo '<tr class="">';
                            echo '<td style="vertical-align:top">'.$option[0]['option_name'].'</td>';
                            echo '<td>';
                            echo '<table class="table_cust_3">';
                            foreach($option as $op)
                            {
                                //echo "<strong>".$op['sub_amount']."</strong> - ";
                                //echo $op['sub_name']." <br /> ";
                                echo '<tr>';
                                echo '<td>'.$op['sub_name'].'</td>';
                                echo '<td>'.$op['sub_amount'].'</td>';
                                echo '</tr>';
                            }
                            echo '</table>';
                            echo '</td>';
                            //echo '<td></td>';
                            echo '<td style="vertical-align:top">';
                            
                            echo Html::a('<span class="fa fa-pencil"></span> Edit',
                                        ['item-option/update', 'id' => $option[0]['id'], 's'=> $_GET['s']],
                                        [
                                            'title' => 'Edit',
                                            'class' => 'btn btn-xs btn-green-sea'
                                        ]
                                    );
                            echo "&nbsp;&nbsp;&nbsp;";
                            echo Html::a('<span class="glyphicon glyphicon-trash"></span> Delete',
                                        ['item-option/delete', 'id' => $option[0]['id'], 's'=> $_GET['s']],
                                        [
                                            'title' => 'Delete',
                                            'data-method' => 'post',
                                            'data-confirm' => 'Are you sure you want to delete this item?',
                                            'class' => 'btn btn-xs btn-danger'
                                        ]
                                    );
                            echo '</td>';
                            echo '</tr>';
                        } ?>
                    </table>
                    <?php } else { ?>
                    No options added..
                    <?php } ?>
                </div>
            </section>
        </div>
    </div>
</div>