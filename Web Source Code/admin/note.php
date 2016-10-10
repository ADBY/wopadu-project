// Buttons

.btn-default
.btn-primary
.btn-success
.btn-info
.btn-warning
.btn-danger
.btn-green-sea
.btn-orange
.btn-nephritis
.btn-concrete
.btn-belize-hole
.btn-peter-river



// Panels
.panel-primary
.panel-success
.panel-info
.panel-warning
.panel-danger
.panel-peter-river


// Site controller Forgot password - current URL


*	Order Status
*	1 = New   – Red color - #C0392B
*	2 = Processing – Orange - #FF7F00
*	3 = Ready to collected – Green - #2ECC71
*	4 = Completed – Blue color - #3498DB
*	5 = Cancelled – Grey color - #808080




User Role:
1 = Super Admin
2 = Account Login User
3 = Kitchen Cook
4 = Employee
5 = Waiter





$session = Yii::$app->session;
$session['super_admin'] = YES/NO
$session['login_id']
$session['login_role']
$session['login_email']
$session['account_id']
$session['account_name']
$session['allowed_stores'];
$session['stores_list'];