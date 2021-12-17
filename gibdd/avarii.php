<?php
print '<!DOCTYPE HTML>';
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
$con = pg_connect('host=localhost port=5432 dbname=k283 user=postgres');
print '<div class="container">
    <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom bg-white rounded-bottom shadow">
      <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
        <svg class="bi me-2" width="40" height="32"><img style="width: 32px; height: 32px;" src="https://romanov-meh.ru/images/25.jpg?crc=4130315980"></svg>
        <span class="fs-5">&nbsp;Учёт автомобилей</span>
      </a>';

      if (isset($_POST["exit"])) {
        setcookie ("Ulogin", " ", time()-10);
        header("Refresh: 0.1");
      }

      if (isset($_COOKIE["Ulogin"])) {
        print '
        <table>
        <tr><td><p>Добро пожаловать, '.$_COOKIE["Ulogin"].'</p>
        <td><form style="margin: 1% 10px;" action="'.$_SERVER['PHP_SELF'].'" method="post">
        <input type="submit" value="Выйти" name="exit" />
        </form>
        </table>';
          }

      print '<ul class="nav nav-pills">
<li class="nav-item el"><a href="index.php" class="lin tel" aria-current="page">Меню/вход</a></li>
      <li class="nav-item el"><a href="search.php" class="lin tel">Поиск по VIN</a></li>
        <li class="nav-item el"><a href="addauto.php" class="lin tel">Добавить / удалить автомобиль</a></li>
        <li class="nav-item el"><a href="ReestrNomerov.php" class="lin tel">Реестр номеров</a></li>
        <li class="nav-item el"><a href="RVladelcev.php" class="lin tel">Реестр владельцев</a></li>
        <li class="nav-item el"><a href="#" class="lin activ tel">Аварии</a></li>
        
      </ul>
    </header>
  </div>';
  if (empty($_COOKIE["Ulogin"]))
  print '<p style="text-align: center;"><a href="index.php">Авторизуйтесь</a> для доступа к системе</p>';
else {
print '<div class="cont">';

if (isset($_POST['reg']) && isset($_POST['vinn']) && isset($_POST['data']) && isset($_POST['avo'])) {
    $op = $_POST['avo'];
    $d = $_POST['data'];
    $v = $_POST['vinn'];
    $query = "SELECT add_av('".$op."','".$d."','".$v."');";
    pg_query($con, $query);
    print '<div class="alert alert-success" role="alert">
    Успешно зарегестрирована авария автомобиля '.$v.'
</div>';
}

print '<div class="set2">
    <form class="row g-3 form-control-lg" method="POST" action="">
  <div class="row gx-3">
       <p class="p-3 mb-5 text-center"><span class="hh">Зарегестрировать аварию:</span>
    <div class="col">

     <div class="mb-1">
                              <label class="form-label">Описание аварии</label>
                                  <textarea class="form-control" name="avo" rows="3"></textarea>
     </div>
     
 

    </div>
    <div class="col">
    <div class="mb-1">
                              <label class="form-label">Дата аварии</label>
                                  <input type="date" class="form-control" name="data" style="width: 50%">
                              </div><div class="mb-1"></div>    
                                 <div class="mb-1">
                                  <select class="form-select" aria-label=".form-select-sm example" name="vinn" style="width: 50%">
                     <option selected disabled>Выбрать автомобиль</option>';

$sql="SELECT distinct id,vin_nomer from list_auto() order by vin_nomer";
$result=pg_query($con,$sql);
$n=pg_num_rows($result);
for($i=0; $i<$n; $i++)
{
    $row=pg_fetch_object($result);
    $vin = $row->vin_nomer;
    print '<option>'.$vin.'</option>';
}
print '
     </select>
     </div>
     </div>
    </div>
   <button type="submit" value="reg" name="reg" class="hh" style="width: 30%;">Зарегестрировать</button>
  </div>

  </form></div></div>
  


';
}
print '</main>';



print '</body>
</html>';
?>