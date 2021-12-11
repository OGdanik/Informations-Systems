## SQL-запросы
Вывести факультеты с самым большим количеством преподавателей >= max-1
```sql
select f.name
from facult f inner join students s on f.id=s.id_f
inner join marks m on s.id=m.id_st
group by f.name, m.id_prepod
having count(*) >=
(
select max(cou)
from
(
select a.name, count(*) as cou
from
(
select f.name, m.id_prepod
from facult f inner join students s on f.id=s.id_f
inner join marks m on s.id=m.id_st
group by f.name, m.id_prepod
) a
group by a.name
) bb
) - 1
