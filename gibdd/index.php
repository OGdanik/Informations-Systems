<?php
print '<html lang="ru">';
print '<head>
<link rel="shortcut icon" href="images/car.ico" type="image/x-icon">';
print '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
print '<meta name="viewport" content="width=device-width, initial-scale=1">';
print '<title>ГИБДД</title>';
print '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">';
print '<link rel="stylesheet" href="css/styles.css" type="text/css"/>';
print '</head>';
print '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>';
print '<body class="bg-light">';
print '<main>';


$Error = "";
if (isset($_POST["exit"])) {
  setcookie ("Ulogin", " ", time()-10);
  header("Refresh: 0.1");
}

if(isset($_POST["Send"]) && $_POST["Ulogin"]!="" && $_POST["Upassw"]!="") {
        $Ulogin = htmlspecialchars($_POST["Ulogin"]);
        $Upassw = htmlspecialchars($_POST["Upassw"]);

$dbconn = pg_connect('host=localhost port=5432 dbname=k283 user=postgres')
or die('Could not connect: ' . pg_last_error());
$query = "SELECT * FROM accounts WHERE login = '$Ulogin'";
$result = pg_query($dbconn,$query) or die('Query failed: ' . pg_last_error());
$passw = pg_fetch_array($result);
if (empty($passw['pass'])) {
  $Error = "Такого пользователя не существует";
} else
if($Upassw != $passw['pass']) {
if(isset($_POST["Send"])) 
$Error = "Неверное имя пользователя/пароль";

    } else {

    setcookie ("Ulogin", $Ulogin, time()+3600);
    header("Refresh: 0.1");

    }
  }


$con = pg_connect('host=localhost port=5432 dbname=k283 user=postgres');
print '<div class="container">
    <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom bg-white rounded-bottom shadow">
    <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
    <svg class="bi me-2" width="40" height="32"><img style="width: 32px; height: 32px;" src="https://romanov-meh.ru/images/25.jpg?crc=4130315980"></svg>
    <span class="fs-5">&nbsp;Учёт автомобилей</span>
  </a>';

      if (isset($_COOKIE["Ulogin"])) {
        print '
        <table>
        <tr><td><p>Добро пожаловать, '.$_COOKIE["Ulogin"].'</p>
        <td><form style="margin: 1% 10px;" action="'.$_SERVER['PHP_SELF'].'" method="post">
        <input type="submit" value="Выйти" name="exit" />
        </form>
        </table>';
          }

          print '
      <ul class="nav nav-pills tel">
      <li class="nav-item el"><a href="#" class="lin activ tel" aria-current="page">Меню/вход</a></li>
      <li class="nav-item el"><a href="search.php" class="lin tel">Поиск по VIN</a></li>
        <li class="nav-item el"><a href="addauto.php" class="lin tel">Добавить / удалить автомобиль</a></li>
        <li class="nav-item el"><a href="ReestrNomerov.php" class="lin tel">Реестр номеров</a></li>
        <li class="nav-item el"><a href="RVladelcev.php" class="lin tel">Реестр владельцев</a></li>
        <li class="nav-item el"><a href="avarii.php" class="lin tel">Аварии</a></li>
        
      </ul>
    </header>';
    print '<div class="divb">';
    if (empty($_COOKIE["Ulogin"]))
    print '<p style="text-align: center;"><a href="index.php">Авторизуйтесь</a> для доступа к системе</p>';
  else {
    print '<a class="button" href="search.php">Поиск по номеру кузова</a>
<a class="button" href="addauto.php">Добавить / удалить автомобиль</a>
<a class="button" href="ReestrNomerov.php">Реестр номеров</a>
<a class="button" href="RVladelcev.php">Реестр владельцев</a>
<a class="button" href="avarii.php">Аварии</a>';
  }
if (!isset($_COOKIE["Ulogin"])) {
print '
  <div style="padding: 70px 0; text-align: center;">
  <p style="font-size: 16pt;">Вход
  <p align="center"><b style="color:red">'.$Error.'</b></p>
  <form action="'.$_SERVER['PHP_SELF'].'" method="post">
    <table style="text-align: center; margin-left: auto; margin-right: auto;">
    <tr><td>Логин:<td><input type="text" name="Ulogin" />
    <tr><td>Пароль:<td><input type="password" name="Upassw" />
    </table>
  <p><br>
  <input type="submit" value="Войти" name="Send" />
  </form>
  <a href="reg.php">Регистрация</a>
 </div>';
}
 print '
</div>
</div>';
    
  print '</main>';
  print '</body>
</html>';
?>