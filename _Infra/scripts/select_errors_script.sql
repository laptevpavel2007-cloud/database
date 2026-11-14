-- вывод пачек и их ошибок
with agg as (
    select
        p.id as pack_id,
        p.eq_id,
        max(v.value) filter (where v.par_id = 1) as height,
        max(v.value) filter (where v.par_id = 2) as temperature,
        max(v.value) filter (where v.par_id = 3) as pres,
        max(v.value) filter (where v.par_id = 4) as wind_dir,
        max(v.value) filter (where v.par_id = 5) as wind_speed,
        max(v.value) filter (where v.par_id = 6) as drift
    from packs p
    left join pack_values v on v.pack_id = p.id
    group by p.id, p.eq_id)
select
    a.pack_id as "№",
    te.name as "Тип оборудования",
    a.height as "Высота метеопоста",
    a.temperature as "Температура",
    a.pres as "Давление",
    a.wind_dir as "Направление ветра",
    a.wind_speed as "Скорость ветра",
    a.drift as "Дальность сноса пуль",
    c.error_flag as "Флаг: Есть ошибка",
    c.errors_list as "Описание ошибки"
from agg a
join types_equipment te on te.id = a.eq_id,
lateral check_errors( row(a.height, a.temperature, a.pres, a.wind_dir, a.wind_speed, a.drift)::list_par) c
order by a.pack_id;


-- вывод лучших стрелков
with agg as (
    select
        p.id as pack_id,
        p.eq_id,
        u.name as user_name,
        max(v.value) filter (where v.par_id = 1) as height,
        max(v.value) filter (where v.par_id = 2) as temperature,
        max(v.value) filter (where v.par_id = 3) as pres,
        max(v.value) filter (where v.par_id = 4) as wind_dir,
        max(v.value) filter (where v.par_id = 5) as wind_speed,
        max(v.value) filter (where v.par_id = 6) as drift
    from packs p
    left join pack_values v on v.pack_id = p.id
	left join users u on p.user_id = u.id
    group by p.id, p.eq_id, p.user_id, u.name)
select
	a.user_name as "Имя сотрудника",
    count(*) filter (where c.error_flag = 'Есть') as "Количество ошибок"
from agg a
join types_equipment te on te.id = a.eq_id,
lateral check_errors( row(a.height, a.temperature, a.pres, a.wind_dir, a.wind_speed, a.drift)::list_par) c
group by a.user_name
order by "Количество ошибок";

