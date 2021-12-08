<?php
print '<!DOCTYPE HTML>';
print '<html lang="ru">';
print '<head>
<link rel="shortcut icon" href="images/car.ico" type="image/x-icon">';
print '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
print '<meta name="viewport" content="width=device-width, initial-scale=1">';
print '<title>ГИБДД</title>';
print '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">';
print '<link rel="stylesheet" href="css/styles.css" type="text/css">';
print '</head>';
print '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>';
print '<body  class="bg-light">';
print '<main>';
$con = pg_connect('host=localhost port=5432 dbname=k283 user=postgres password=s2d3f4g5');
print '<div class="container">
    <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom bg-white rounded-bottom shadow">
      <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
        <svg class="bi me-2" width="40" height="32"><img style="width: 32px; height: 32px;" src="https://romanov-meh.ru/images/25.jpg?crc=4130315980"></svg>
        <span class="fs-5">&nbsp;Учёт автомобилей</span>
      </a>';

      if (isset($_POST["exit"])) {
        setcookie ("Ulogin", " ", time()-10);
        setcookie ("Upassw", " ", time()-10);
        header("Refresh: 0.5");
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
        <li class="nav-item el"><a href="#" class="lin activ tel">Реестр владельцев</a></li>
        <li class="nav-item el"><a href="avarii.php" class="lin tel">Аварии</a></li>
        
      </ul>
    </header>
  </div>';
print '<div class="container">';

if (isset($_POST['add']) && isset($_POST['fio']) && isset($_POST['data']) && isset($_POST['vin']))
{
    $fio = $_POST['fio'];
    $dat = $_POST['data'];
    $vinn =$_POST['vin'];
    $sqla = "select id,vin_nomer from public.auto where vin_nomer = '".$vinn."'";
    $resa = pg_query($con,$sqla);
    $obj = pg_fetch_object($resa);
    $va = $obj->id;
    $query = "INSERT INTO public.reestr_vladelcev(fio,data_postanovki,id_auto_rv) VALUES ('".$fio."','".$dat."','".$va."')";
    pg_query($con, $query);
    print '<div class="alert alert-success" role="alert">
    Успешно поставлен на учёт владелец автомобиля '.$vinn.'
</div>';
}

if (isset($_POST['sn']) && isset($_POST['fiolist']) && isset($_POST['datas']) && isset($_POST['vins']))
{
    $fio = $_POST['fiolist'];
    $datas= $_POST['datas'];
    $vin= $_POST['vins'];
    $selvin = "SELECT id,vin_nomer from public.auto where vin_nomer='".$vin."'";
    $idrow = pg_fetch_object(pg_query($con,$selvin));
    $id_rv = $idrow->id;
    $sqls = "UPDATE public.reestr_vladelcev SET data_snyatiya='".$datas."' WHERE fio = '".$fio."' and id_auto_rv = '".$id_rv."'";
    pg_query($con, $sqls);
    print '<div class="alert alert-success" role="alert">
    Успешно снят с учёта владелец автомобиля '.$vin.'
</div>';
}

print '<div class="row" style="margin:0">
    <div class="set2 col-sm" style="margin:0 0.5% 0 1%;">
      <p class="p-3 mb-5 text-center"><span class="hh">Поставить владельца на учёт</span>
 
             <form class="row g-3" method="POST" action=" ">
<div class="mb-3">
                                <label class="form-label">ФИО владельца</label>
                                  <input type="text" name="fio" class="form-control">
 </div>
 <div class="mb-3">
                              <label class="form-label">Дата постановки</label>
                                  <input class="form-control" type="date" name="data">
     </div>
     <div class="mb-3">
                           <select class="form-select form-select-lg" aria-label=".form-select-sm example" name="vin">
                     <option selected disabled>Выбрать автомобиль по номеру кузова</option>';

$sql="select distinct id,vin_nomer from public.auto order by vin_nomer";
$result=pg_query($con,$sql);
$n=pg_num_rows($result);
for($i=0; $i<$n; $i++)
{
    $row=pg_fetch_object($result);
    $id = $row->id;
    $vin = $row->vin_nomer;
    print '<option name="'.$id.'">'.$vin.'</option>';
}
print '
     </select>
         </div>
                            
     <div class="mb-1">
                                  <button type="submit" value="Save" name="add" class="hh" style="width: 20%;">Назначить</button>
                                  </div>
                             </form>
    </div>
    <div class="col-sm set2" style="margin:0 1% 0 0.5%;">
      <p class="p-3 mb-5 text-center"><span class="hh">Назначить дату снятия</span>
      <form class="row g-3" method="POST" action=" ">
      <div class="mb-3"></div>
      <div class="mb-3">
                               <select class="form-select form-select" aria-label=".form-select-sm example" name="fiolist">
                     <option selected disabled>Выбрать ФИО</option>';
$sql="select distinct * from public.reestr_vladelcev order by fio ASC";
$result=pg_query($con,$sql);
$n=pg_num_rows($result);
for($i=0; $i<$n; $i++)
{
    $row=pg_fetch_object($result);
    $id = $row->id;
    $num = $row->fio;
    print '<option name="'.$id.'">'.$num.'</option>';
}
print '
     </select>       
                                                                         </div>
                                                                          <div class="mb-3">
                                                                                    <label class="form-label">Дата снятия</label>
                                                                                  <input class="form-control" type="date" name="datas">
                                                                                  </div>
                                                                                  <div class="mb-3">
                                                                                  <select class="form-select form-select-lg" aria-label=".form-select-sm example" name="vins">
                     <option selected disabled>Выбрать автомобиль по номеру кузова</option>';




$sql="select distinct id,vin_nomer from public.auto order by vin_nomer";
$result=pg_query($con,$sql);
$n=pg_num_rows($result);
for($i=0; $i<$n; $i++)
{
    $row=pg_fetch_object($result);
    $id = $row->id;
    $vin = $row->vin_nomer;
    print '<option name="'.$id.'">'.$vin.'</option>';
}
print '
     </select>
                                                                                  </div>
                                                                          <div class="mb-1">
                                            <button type="submit" value="Save" name="sn" class="hh" style="width: 20%;">Снять</button>
                                                  </div> </div></div>';
print '
<div class="set3" >
    <form class="row g-3 form-control-lg" method="POST" action="">
    <p class="p-3 mb-5 text-center"><span class="hh">Запрос истории владельцев</span>
    <div class="mb-3">
    <select class="form-select" aria-label=".form-select-sm example" name="vinz">
                     <option selected disabled>Выбрать автомобиль</option>';
$sql="select distinct id,vin_nomer from public.auto order by vin_nomer";
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
<button type="submit" value="reg" name="zap" class="hh" style="width: 30%;">Запросить</button>
</form></div>';




if (isset($_POST['zap']) && isset($_POST['vinz'])) {
    $vin = $_POST['vinz'];

    $sv = "select * from public.auto where vin_nomer ='" . $vin . "'";
    $qsv = pg_query($con, $sv);
    $objv = pg_fetch_object($qsv);
    $idv = $objv->id;
    $sql = "select * from public.reestr_vladelcev where id_auto_rv = '" . $idv . "'";
    $qav = pg_query($con, $sql);
    $n = pg_num_rows($qav);
    print '<div class="cont">
<div class="set2"><p class="center"><span class="hh">История владельцев: ' . $vin . '</span></p>
    <table class="tb">
             <tr><td class="tbr">ФИО владельца<td class="tbr">Дата постановки на учёт<td class="tbr">Дата снятия с учёта</tr>';
    for ($i = 0; $i < $n; $i++) {
        $objv = pg_fetch_object($qav);
        $oa = $objv->fio;
        $da = $objv->data_postanovki;
        $das = $objv->data_snyatiya;
        print '<tr><td class="tbr">' . $oa . '<td class="tbr">' . $da . '<td class="tbr">' . $das . '';
    }

    print '</table></div></div>';
}
print '</main>';



print '</body>
</html>';
?>