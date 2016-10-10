<?php
$items = 
[
	'order_number' => 1,
	'invoice_number' => 1,
	'table_location' => 2,
	'total_amount' => 123,
	'payment_done_date' => '2015-12-05 11:36:38',
	'payment_status' => 1,
	'add_note' => 'test',
	'status' => 5,
	'n_datetime' => '2015-12-05 11:36:38',
	'p_datetime' => '2015-12-05 11:36:38',
	'r_datetime' => '2015-12-05 11:36:38',
	'c_datetime' => '2015-12-05 11:36:38',
	'items' => 
	[
		[
			"item_id" => 5,
			"kitchen_id" => 1,
			"item_options_id" => "",
			"item_variety_id" => "5",
			"item_quantity" => 1,
			"item_amount" => "85.00",
			"item_options_amount" => "0.00",
			"item_discount" => "0.00",
			"tax_percentage" => "10",
			"final_amount" => "85.00",
			"item_note" => "extra spicy",
			"status" => 1
		],
		[
			"item_id" => 5,
			"kitchen_id" => 1,
			"item_options_id" => "",
			"item_variety_id" => "5",
			"item_quantity" => 1,
			"item_amount" => "685.00",
			"item_options_amount" => "0.00",
			"item_discount" => "0.00",
			"tax_percentage" => "10",
			"final_amount" => "85.00",
			"item_note" => "extra spicy",
			"status" => 1
		]
	],
];

//{"order_number":1,"invoice_number":1,"table_location":2,"total_amount":123,"payment_done_date":"2015-12-05 11:36:38","payment_status":1,"add_note":"test","status":5,"n_datetime":"2015-12-05 11:36:38","p_datetime":"2015-12-05 11:36:38","r_datetime":"2015-12-05 11:36:38","c_datetime":"2015-12-05 11:36:38","items":[{"item_id":5,"kitchen_id":1,"item_options_id":"","item_variety_id":"5","item_quantity":1,"item_amount":"85.00","item_options_amount":"0.00","item_discount":"0.00","tax_percentage":"10","final_amount":"85.00","item_note":"extra spicy","status":1},{"item_id":5,"kitchen_id":1,"item_options_id":"","item_variety_id":"5","item_quantity":1,"item_amount":"685.00","item_options_amount":"0.00","item_discount":"0.00","tax_percentage":"10","final_amount":"85.00","item_note":"extra spicy","status":1}]}

echo '<pre>';
//print_r($items);
print_r(json_encode($items));
echo '</pre>';

