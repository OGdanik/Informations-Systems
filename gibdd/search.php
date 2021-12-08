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
$con = pg_connect('host=localhost port=5432 dbname=k283 user=postgres password=s2d3f4g5');
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
      <ul class="nav nav-pills">
      <li class="nav-item el"><a href="index.php" class="lin tel" aria-current="page">Меню/вход</a></li>
        <li class="nav-item el"><a href="#" class="lin activ tel">Поиск по VIN</a></li>
     
        <li class="nav-item el"><a href="addauto.php" class="lin tel">Добавить / удалить автомобиль</a></li>
        <li class="nav-item el"><a href="ReestrNomerov.php" class="lin tel">Реестр номеров</a></li>
        <li class="nav-item el"><a href="RVladelcev.php" class="lin tel">Реестр владельцев</a></li>
        <li class="nav-item el"><a href="avarii.php" class="lin tel">Аварии</a></li>
        
      </ul>
    </header>
  </div>';
print '<div class="container-sm">';
print '<form class="row g-3 form-control-lg" method="POST" action="">
<div class="mb-3">
<label for="selvin">Поиск автомобиля по номеру кузова</label>
<input style="width: 50%;" list="listvin" id="selvin" name="selvin">
                                <datalist name="vin" id="listvin">';
$sql="select distinct id,vin_nomer from public.auto order by vin_nomer";
$result=pg_query($con,$sql);
$n=pg_num_rows($result);
for($i=0; $i<$n; $i++)
{
    $row=pg_fetch_object($result);
    $id = $row->id;
    $vin = $row->vin_nomer;
    print '<option value="'.$vin.'"></option>';
}
print '
     </datalist>
 </div>
                                  <div style="text-align: center;"><button type="submit" value="Search" name="search" class="btnsearch" style="width: 20%;"><span class="btnfont">Поиск</span></button></div>
                             </form>';

print '<form class="row g-3 form-control-lg" method="POST" action="">
<div class="mb-3">
<label for="selfio">Поиск автомобилей владельца</label>
<input style="width: 50%;" list="listfio" id="selfio" name="selfio">
                                <datalist name="fio" id="listfio">';
                                $sql="select distinct fio from public.reestr_vladelcev order by fio";
                                $result=pg_query($con,$sql);
                                $n=pg_num_rows($result);
                                for($i=0; $i<$n; $i++)
                                {
                                    $row=pg_fetch_object($result);
                                            $fio = $row->fio;
                                                print '<option value="'.$fio.'"></option>';
                                                }
                                                print '
                                                     </datalist>
                                                      </div>
                                                        <div style="text-align: center;"><button type="submit" value="Search" name="searchfio" class="btnsearch" style="width: 20%;"><span class="btnfont">Поиск</span></button></div>
                                    </form>';

print '</div>';
print '<div class="cont">';
if (isset($_POST['searchfio']) && isset($_POST['selfio'])) {
$fio1 = $_POST['selfio'];

$countvin = pg_query($con,"select b.fio, count(a)
from auto a inner join reestr_vladelcev b on a.id=b.id_auto_rv
group by b.fio
having b.fio = '".$fio1."'");
$count = pg_fetch_object($countvin)->count;
$arrvin = array();

    $ffio = $_POST['selfio'];
    $svin = "select a.vin_nomer, a.id, a.id_mm, b.fio
    from auto a inner join reestr_vladelcev b on a.id=b.id_auto_rv
    where b.fio = '".$ffio."'";
    $rvin = pg_query($con,$svin);
    $n = pg_num_rows($rvin);
    for ($i=0; $i<$n; $i++) {
    $rowvin = pg_fetch_object($rvin);
    $vinid = $rowvin->id;
    $vin = $rowvin->vin_nomer;
    $vinidmm = $rowvin->id_mm;
    $arrvin[$i] = $vin;
    }
    
    
    
    for ($ivin=0; $ivin<$count;$ivin++) {
    
    $fvin = $arrvin[$ivin];
        $svin = "select * from public.auto where vin_nomer = '".$fvin."'";
            $rvin = pg_query($con,$svin);
                $rowvin = pg_fetch_object($rvin);
                    $vinid = $rowvin->id;
                        $vin = $rowvin->vin_nomer;
                            $vinidmm = $rowvin->id_mm;
                            
    
     $sql="select * from public.model_marka where id = '".$vinidmm."'";
     $resmm=pg_query($con,$sql);
     $fo = pg_fetch_object($resmm);
     $marka = $fo->marka;
     $model = $fo->model;
    print '<div class="set"><span class="hh">VIN номер: '.$vin.'</span></div><div class="set"><span class="hh">Автомобиль: '.$marka . $model.'</span></div>';
      $selnum = "select * from public.reestr_nomerov where id_auto_rn = '".$vinid."'";
      $resnum=pg_query($con,$selnum);
      $n = pg_num_rows($resnum);

      print '<div class="set"><p><span class="hh">История гос. номеров:</span></p><table class="tb">
             <tr><td class="tbr">Номер </td><td class="tbr">Дата выдачи </td><td class="tbr">Дата снятия </td></tr>';
    for($i=0; $i<$n; $i++) {
        $rownum = pg_fetch_object($resnum);
        $num = $rownum->number;
        $datav = $rownum->data_vidachi;
        $datas = $rownum->data_snyatiya;
print '<tr><td class="tbr">'.$num.'<td class="tbr">'.$datav.'<td class="tbr">'.$datas.' ';
    }
    print '</table></div>';

    print '<div class="set"><p><span class="hh">История владельцев:</span></p>
<table class="tb">
             <tr><td class="tbr">ФИО владельца </td><td class="tbr">Дата постановки </td><td class="tbr">Дата снятия </td></tr>';

       $selfio = "select * from public.reestr_vladelcev where id_auto_rv = '".$vinid."'";
       $resfio=pg_query($con,$selfio);
       $nf = pg_num_rows($resfio);
    for($i=0; $i<$nf; $i++) {
        $rowfio = pg_fetch_object($resfio);
        $fio = $rowfio->fio;
        $datavp = $rowfio->data_postanovki;
        $datass = $rowfio->data_snyatiya;
        print '<tr><td class="tbr">'.$fio.'<td class="tbr">'.$datavp.'<td class="tbr">'.$datass.' ';
    }
print '</table></div>';
    print '<div class="set1"><p style="padding: 3px;"><span class="hh">История аварий:</span></p>
    <table class="tb">
             <tr><td class="tbr">Описание аварии</td><td class="tbr"><span class="kat">Дата аварии</span></td></tr>';
        $selav = "select * from public.avarii where id_auto_av = '".$vinid."'";
        $resav=pg_query($con,$selav);
        $na = pg_num_rows($resav);
    for($i=0; $i<$na; $i++) {
        $rowav = pg_fetch_object($resav);
        $av = $rowav->avariya;
        $dataav = $rowav->data_avarii;
        print '<tr><td class="tbr">'.$av.'<td class="tbr" style="width: 10%">'.$dataav.'';
    }
}
print '</td></div>';
}


print '<div class="cont">';
if (isset($_POST['search']) && isset($_POST['selvin'])) {
$fvin = $_POST['selvin'];
    $svin = "select * from public.auto where vin_nomer = '".$fvin."'";
    $rvin = pg_query($con,$svin);
    $rowvin = pg_fetch_object($rvin);
    $vinid = $rowvin->id;
    $vin = $rowvin->vin_nomer;
    $vinidmm = $rowvin->id_mm;
                    $sql="select * from public.model_marka where id = '".$vinidmm."'";
                    $resmm=pg_query($con,$sql);
                    $fo = pg_fetch_object($resmm);
                    $marka = $fo->marka;
                    $model = $fo->model;
                    print '<div class="set"><span class="hh">VIN номер: '.$vin.'</span></div><div class="set"><span class="hh">Автомобиль: '.$marka . $model.'</span></div>';
    $selnum = "select * from public.reestr_nomerov where id_auto_rn = '".$vinid."'";
    $resnum=pg_query($con,$selnum);
    $n = pg_num_rows($resnum);
                                                                          
    print '<div class="set"><p><span class="hh">История гос. номеров:</span></p><table class="tb">
    <tr><td class="tbr">Номер </td><td class="tbr">Дата выдачи </td><td class="tbr">Дата снятия </td></tr>';
        for($i=0; $i<$n; $i++) {
            $rownum = pg_fetch_object($resnum);
            $num = $rownum->number;
            $datav = $rownum->data_vidachi;
            $datas = $rownum->data_snyatiya;
            print '<tr><td class="tbr">'.$num.'<td class="tbr">'.$datav.'<td class="tbr">'.$datas.' ';
                              }
             print '</table></div>';
                        print '<div class="set"><p><span class="hh">История владельцев:</span></p>
                        <table class="tb">
                        <tr><td class="tbr">ФИО владельца </td><td class="tbr">Дата постановки </td><td class="tbr">Дата снятия </td></tr>';
                         $selfio = "select * from public.reestr_vladelcev where id_auto_rv = '".$vinid."'";
                         $resfio=pg_query($con,$selfio);
                         $nf = pg_num_rows($resfio);
                          for($i=0; $i<$nf; $i++) {
                            $rowfio = pg_fetch_object($resfio);
                            $fio = $rowfio->fio;
                            $datavp = $rowfio->data_postanovki;
                            $datass = $rowfio->data_snyatiya;
                            print '<tr><td class="tbr">'.$fio.'<td class="tbr">'.$datavp.'<td class="tbr">'.$datass.' ';
                                                }
                            print '</table></div>';
    print '<div class="set1"><p style="padding: 3px;"><span class="hh">История аварий:</span></p>
        <table class="tb">
        <tr><td class="tbr">Описание аварии</td><td class="tbr"><span class="kat">Дата аварии</span></td></tr>';
        $selav = "select * from public.avarii where id_auto_av = '".$vinid."'";
        $resav=pg_query($con,$selav);
        $na = pg_num_rows($resav);
        for($i=0; $i<$na; $i++) {
        $rowav = pg_fetch_object($resav);
        $av = $rowav->avariya;
        $dataav = $rowav->data_avarii;
        print '<tr><td class="tbr">'.$av.'<td class="tbr" style="width: 10%">'.$dataav.'';
                                 }
}
                                                                                                                                                                                                                                                                                                                     


print '</table></div></div>';
print '</main>';



print '</body>
</html>';
?>
