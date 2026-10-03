select u.id, count(p.id) as cnt
from users u
left join packs p on p.user_id = u.id
group by u.id


select p.id, pv.par_id, pv.value
from packs p
join pack_values pv on p.id = pv.pack_id
where pv.value is null
order by p.id, pv.par_id;

select p.id, count(pv.value) as cnt
from packs p
left join pack_values pv on p.id = pv.pack_id
group by p.id
having count(pv.value) != 6
order by p.id

select 
    p.meas_at as "Дата измерения",
    p.id as "Номер пачки",
    u.name as "ФИО сотрудника",
    par.name || ' (' || m.name || ')' as "Наименование параметра и ед. измерения",
    pv.value as "Значение",
	case
	    when pv.value is null then 'Нет данных'
	    when par.id = 1 and (pv.value <= 0 or pv.value > 5000) then 'Вне диапазона'
	    when par.id = 2 and (pv.value < -60 or pv.value > 60) then 'Вне диапазона'
	    when par.id = 3 and (pv.value < 600 or pv.value > 800) then 'Вне диапазона'
	    when par.id = 4 and (pv.value < 0 or pv.value > 360) then 'Вне диапазона'
	    when par.id = 5 and (pv.value < 0 or pv.value > 60) then 'Вне диапазона'
	    when par.id = 6 and (pv.value < 0 or pv.value > 1000) then 'Вне диапазона'
	    else 'OK'
    end as "Проверка диапазона"
	from packs p
	join users u on p.user_id = u.id
	left join positions pos on u.pos_id = pos.id
	join parameters par on pos.par_id = par.id
	join pack_values pv on p.id = pv.pack_id
	join measurement m on par.meas_id = m.id
	order by p.meas_at, p.id, par.id;

select 
    p.meas_at as "Дата измерения",
    p.id as "Номер пачки",
    u.name as "ФИО сотрудника",
    par.name || ' (' || m.name || ')' as "Наименование параметра и ед. измерения",
    pv.value as "Значение",
    case
        when par.id = 1 and par.meas_id = 5 then 'OK' 
        when par.id = 2 and par.meas_id = 1 then 'OK'  
        when par.id = 3 and par.meas_id = 6 then 'OK' 
        when par.id = 4 and par.meas_id = 4 then 'OK' 
        when par.id = 5 and par.meas_id = 3 then 'OK'
        when par.id = 6 and par.meas_id = 5 then 'OK'
        else 'НЕ OK'
    end as "Проверка параметра"
	from packs p
	join users u on p.user_id = u.id
	join pack_values pv on p.id = pv.pack_id
	join parameters par on pv.par_id = par.id
	join measurement m on par.meas_id = m.id
	order by p.meas_at, p.id, par.id;