<?php
print '<!DOCTYPE HTML>';
print '<html lang="ru">';
print '<head>
<link rel="shortcut icon" href="images/car.ico" type="image/x-icon">';
print '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
print '<meta name="viewport" content="width=device-width, initial-scale=1">';
print '<title>Регистрация</title>';
print '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">';
print '<link rel="stylesheet" href="css/styles.css" type="text/css"/>';
print '</head>';
print '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>';
print '<body class="bg-light">';
print '<main>';
$con = pg_connect('host=localhost port=5432 dbname=gibdd user=postgres');
print '<div class="container ">';
$Error = '';
$accept = '';
if ((empty($_POST['login']) or empty($_POST['password'])) && isset($_POST['submit']))
{
$Error = ("Вы ввели не всю информацию, вернитесь назад и заполните все поля!"); 
} else
if (isset($_POST['login']) && isset($_POST['password']) && isset($_POST['submit'])) 
    {
    $login = $_POST['login']; 
    $password = $_POST['password'];


$login = stripslashes($login);
$login = htmlspecialchars($login);
$password = stripslashes($password);
$password = htmlspecialchars($password);

$login = trim($login);
$password = trim($password);


$result = pg_query($con,"SELECT * from set_login('$login')") or die('Query failed: ' . pg_last_error());
$myrow = pg_fetch_array($result);
if (!empty($myrow['id'])) {
$Error = "Извините, введённый вами логин уже зарегистрирован. Введите другой логин.";
} 
else {
$result2 = pg_query ("SELECT adduser('$login','$password')");
    if ($result2==true && isset($_POST['submit']))
    {
    $accept = "<p style='color: green'>Вы успешно зарегистрированы! Теперь вы можете зайти на сайт. <br><a href='index.php'>Главная страница</a>";
    }
    else if ($result2==false && isset($_POST['submit'])) {
    $Error = "Ошибка! Вы не зарегистрированы.";
}
}
}

print '<div style="text-align:center; margin-top: 25%; margin-bottom: 25%;">
<svg class="bi me-2" width="40" height="32"><img style="width: 32px; height: 32px;" src="https://romanov-meh.ru/images/25.jpg?crc=4130315980"></svg>
<span class="fs-5">&nbsp;Учёт автомобилей</span>
<p style="color:red">'.$Error.'
'.$accept.'
<form action="" method="post">
<p>
<label>Ваш логин:<br></label>
<input name="login" type="text" size="15" maxlength="15">
</p>
<p>
<label>Ваш пароль:<br></label>
<input name="password" type="password" size="15" maxlength="15">
</p> 
<p>
<input type="submit" name="submit" value="Зарегистрироваться"> 
</p></form>
</div>';

print '</div>';


print '</main></body>
</html>';
?>