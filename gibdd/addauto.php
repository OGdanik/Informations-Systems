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
print '<div class="container ">
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
        <li class="nav-item el"><a href="#" class="lin activ tel">Добавить / удалить автомобиль</a></li>
        <li class="nav-item el"><a href="ReestrNomerov.php" class="lin tel">Реестр номеров</a></li>
        <li class="nav-item el"><a href="RVladelcev.php" class="lin tel">Реестр владельцев</a></li>
        <li class="nav-item el"><a href="avarii.php" class="lin tel">Аварии</a></li>
        
      </ul>
    </header>';

    if (empty($_COOKIE["Ulogin"]))
    print '<p style="text-align: center;"><a href="index.php">Авторизуйтесь</a> для доступа к системе</p>';
  else {

if (isset($_POST['save']) && isset($_POST['line1']) && isset($_POST['line2'])) {
    $marka = $_POST['line1'];
    $model = $_POST['line2'];
    $query = "SELECT addmm('".$marka."','".$model."');";
        print '<div class="alert alert-success" role="alert">
        Добавлен автомобиль '.$marka.' '.$model.'
            </div>';
    pg_query($con, $query) or die('Error: ' . pg_last_error());
}

if (isset($_POST['savevin']) && isset($_POST['marmod']) && isset($_POST['line3'])) {
    $idmm = $_POST['marmod'];
    $vinn = $_POST['line3'];
    $query = "SELECT addvin('".$vinn."','".$idmm."');";
    pg_query($con, $query) or die('Error: Такой VIN-номер уже существует ');
}

if (isset($_POST['del']) && isset($_POST['delvin'])) {
    $id = $_POST['delvin'];
    $qdel = "SELECT del_vin('".$id."')";
    pg_query($con, $qdel);
    print '<div class="alert alert-success" role="alert">
    Успешно удалён автомобиль
</div>';
}

if (isset($_POST['fsub'])) {
    $file = file($_POST['f']);
    $del = ';';
    $mm = 'model_marka(marka,model)';
    pg_copy_from($con,$mm,$file,$del);
}
print '<div class="row">
<div class="col-sm set2" style="margin:0 0.5% 0 1%;">
<p class="p-3 text-center"><span class="hh">Добавить марку и модель</span>
             <form class="row g-3" method="POST" action="">
<div class="mb-3">
                                <label class="form-label">Марка</label>
                                  <input type="text" name="line1" class="form-control">
 </div>
 <div class="mb-3">
                              <label class="form-label">Модель</label>
                                  <input class="form-control" type="text" name="line2">
     </div>
                                  <button type="submit" value="Save" name="save" class="hh" style="width: 20%; margin: 0 2%;">Добавить</button>
                             </form>
                             
                             </div>
                             <div class="col-sm set2"  style="margin:0 1% 0 0.5%;">
                             <p class="p-3 text-center"><span class="hh">Добавить номер кузова</span>
                             <form class="row g-3 form-control-lg" method="POST" action=" ">
                             <label>Марка и модель</label>
                                                                               <select class="form-select mb-3" id="mm" name="marmod">
                                                                               <option selected disabled>Выбрать марку и модель</option>
                                                                               ';
$sql="select id,marka,model from public.model_marka order by marka";
$result=pg_query($con,$sql);
$n=pg_num_rows($result);
for($i=0; $i<$n; $i++)
{
    $row=pg_fetch_object($result);
    $id = $row->id;
    $mar = $row->marka;
    $mod = $row->model;
    print '<option value="'.$id.'">'.$mar.' '.$mod.'</option>';
}
print '</select>

    
                              <p style="margin-bottom: 0">VIN номер</p>
                                  <input class="form-control" type="text" name="line3" style="margin-top: 3px;">
     
                                  <button type="submit" value="Save" name="savevin" class="hh" style="width: 20%;">Добавить</button>
                             </form></div></div>
                             
                             ';





print '
<div class="row">
<div class="col-sm set2"  style="margin:1% 2% 0 1%;">
<form class="row g-3 form-control-lg" method="POST" action="">';

print '
<p class="p-3 text-center"><span class="hh">Удалить автомобиль</span>
     <div class="mb-3">
                              <select class="form-select form-select-lg" aria-label=".form-select-sm example" name="delvin">
                     <option selected disabled>Выбрать автомобиль по номеру кузова</option>';
$sql="select distinct id,vin_nomer from public.auto order by vin_nomer";
$result=pg_query($con,$sql);
$n=pg_num_rows($result);
for($i=0; $i<$n; $i++)
{
    $row=pg_fetch_object($result);
    $id = $row->id;
    $vin = $row->vin_nomer;
    print '<option value="'.$id.'">'.$vin.'</option>';
}
print '
     </select>
     </div>
     
                                  <button type="submit" value="DELETE" name="del" class="hh" style="width: 20%;">Удалить</button>
                                  <div class="rd"><span class="des">(Удалятся все записи об автомобиле)</span></div>
                             </form></div>
                             <div class="col-sm"></div>
                             </div>';
  }





print '</main>';


pg_close($con);
print '</body>
</html>';
?>