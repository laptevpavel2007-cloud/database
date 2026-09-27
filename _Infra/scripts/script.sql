drop table if exists packs, users, parameters, types_equipment, positions, pack_values;

create table positions
(
    id int,
    name text,
    par_id int
);

insert into positions(id, name, par_id) values (1, 'Начальник метеопоста', null);
insert into positions(id, name, par_id) values (2, 'Оператор ДМК', null);
insert into positions(id, name, par_id) values (3, 'Оператор ВР', null);
insert into positions(id, name, par_id) values (4, 'Топогеодезист', 1);
insert into positions(id, name, par_id) values (5, 'Метеоролог-термометрист', 2);
insert into positions(id, name, par_id) values (6, 'Метеоролог-барометрист', 3);
insert into positions(id, name, par_id) values (7, 'Аэролог (направление)', 4);
insert into positions(id, name, par_id) values (8, 'Аэролог (скорость)', 5);
insert into positions(id, name, par_id) values (9, 'Наблюдатель за сносом', 6);

create table types_equipment
(
    id int,
    name text
);

insert into types_equipment(id, name) values (1, 'ДМК');
insert into types_equipment(id, name) values (2, 'ВР');

create table users
(
    id int,
    name text,
    pos text,
    eq_id int
);

insert into users(id, name, pos, eq_id) values (1,  'Лаптев Павел Николаевич', 'Начальник метеопоста', 1);
insert into users(id, name, pos, eq_id) values (2,  'Лаптев Николай Борисович', 'Оператор ДМК', 1);
insert into users(id, name, pos, eq_id) values (3,  'Лаптева Юлия Сергеевна', 'Оператор ДМК', 1);
insert into users(id, name, pos, eq_id) values (4,  'Лаптева Лина Николаевна', 'Оператор ДМК', 1);
insert into users(id, name, pos, eq_id) values (5,  'Сабжаева Полина Николаевна', 'Оператор ВР', 2);
insert into users(id, name, pos, eq_id) values (6,  'Сабжаев Алексей Александрович', 'Оператор ВР', 2);
insert into users(id, name, pos, eq_id) values (7,  'Сабжаев Алексей Алексеевич', 'Аэролог (направление)', 2);
insert into users(id, name, pos, eq_id) values (8,  'Сабжаева Бусюня Алексеевна', 'Начальник метеопоста', 1);
insert into users(id, name, pos, eq_id) values (9,  'Иванов Иван Иванович', 'Топогеодезист', 1);
insert into users(id, name, pos, eq_id) values (10, 'Петров Пётр Петрович', 'Метеоролог-термометрист', 1);
insert into users(id, name, pos, eq_id) values (11, 'Сидоров Сидор Сидорович', 'Метеоролог-барометрист', 1);
insert into users(id, name, pos, eq_id) values (12, 'Кузнецова Анна Сергеевна', 'Аэролог (скорость)', 2);
insert into users(id, name, pos, eq_id) values (13, 'Морозов Дмитрий Олегович', 'Наблюдатель за сносом', 2);

alter table users add column pos_id int;

update users set pos_id = 1 where pos = 'Начальник метеопоста';
update users set pos_id = 2 where pos = 'Оператор ДМК';
update users set pos_id = 3 where pos = 'Оператор ВР';
update users set pos_id = 4 where pos = 'Топогеодезист'; 
update users set pos_id = 5 where pos = 'Метеоролог-термометрист';
update users set pos_id = 6 where pos = 'Метеоролог-барометрист';
update users set pos_id = 7 where pos = 'Аэролог (направление)';
update users set pos_id = 8 where pos = 'Аэролог (скорость)';
update users set pos_id = 9 where pos = 'Наблюдатель за сносом';

create table parameters
(
    id int,
    name text
);

insert into parameters(id, name) values (1, 'Высота метеопоста');
insert into parameters(id, name) values (2, 'Температура');
insert into parameters(id, name) values (3, 'Давление');
insert into parameters(id, name) values (4, 'Направление ветра');
insert into parameters(id, name) values (5, 'Скорость ветра');
insert into parameters(id, name) values (6, 'Дальность сноса пуль');

create table packs
(
    id int,            
    user_id int,           
    eq_id int,       
    meas_at timestamp,  
    appr boolean    
);

insert into packs values (1,  1, 1, '2026-09-20 09:30:00', false);
insert into packs values (2,  2, 1, '2026-09-20 10:15:00', false);
insert into packs values (3,  3, 1, '2026-09-20 11:00:00', true);
insert into packs values (4,  4, 1, '2026-09-21 08:45:00', false);
insert into packs values (5,  8, 1, '2026-09-21 09:20:00', false);
insert into packs values (6,  5, 2, '2026-09-20 09:45:00', false);
insert into packs values (12, 6, 2, '2026-09-20 11:20:00', false);
insert into packs values (13, 7, 2, '2026-09-20 12:00:00', true);
insert into packs values (14, 12, 2, '2026-09-21 08:30:00', false);
insert into packs values (15, 13, 2, '2026-09-21 10:10:00', false);


create table pack_values
(
    pack_id int,
    par_id int,
    value numeric(12, 2)
);

-- 1 пачка
insert into pack_values (pack_id, par_id, value) values (1, 1, 100);
insert into pack_values (pack_id, par_id, value) values (1, 2, 15.0);
insert into pack_values (pack_id, par_id, value) values (1, 3, 750);  
insert into pack_values (pack_id, par_id, value) values (1, 4, 0); 
insert into pack_values (pack_id, par_id, value) values (1, 5, 0);  
insert into pack_values (pack_id, par_id, value) values (1, 6, null);

-- 2 пачка
insert into pack_values (pack_id, par_id, value) values (2, 1, 100);
insert into pack_values (pack_id, par_id, value) values (2, 2, 14.5);
insert into pack_values (pack_id, par_id, value) values (2, 3, 752);
insert into pack_values (pack_id, par_id, value) values (2, 4, 15);
insert into pack_values (pack_id, par_id, value) values (2, 5, 4);
insert into pack_values (pack_id, par_id, value) values (2, 6, null);

-- 3 пачка
insert into pack_values (pack_id, par_id, value) values (3, 1, 100);
insert into pack_values (pack_id, par_id, value) values (3, 2, 16.0);
insert into pack_values (pack_id, par_id, value) values (3, 3, 748);
insert into pack_values (pack_id, par_id, value) values (3, 4, 30);
insert into pack_values (pack_id, par_id, value) values (3, 5, 6);
insert into pack_values (pack_id, par_id, value) values (3, 6, null);

-- 4 пачка
insert into pack_values (pack_id, par_id, value) values (4, 1, 100);
insert into pack_values (pack_id, par_id, value) values (4, 2, 13.0);
insert into pack_values (pack_id, par_id, value) values (4, 3, 755);
insert into pack_values (pack_id, par_id, value) values (4, 4, 45);
insert into pack_values (pack_id, par_id, value) values (4, 5, 3);
insert into pack_values (pack_id, par_id, value) values (4, 6, null);

-- 5 пачка
insert into pack_values (pack_id, par_id, value) values (5, 1, 100);
insert into pack_values (pack_id, par_id, value) values (5, 2, 12.0);
insert into pack_values (pack_id, par_id, value) values (5, 3, 751);
insert into pack_values (pack_id, par_id, value) values (5, 4, 20);
insert into pack_values (pack_id, par_id, value) values (5, 5, 5);
insert into pack_values (pack_id, par_id, value) values (5, 6, null);

-- 6 пачка
insert into pack_values (pack_id, par_id, value) values (6, 1, 100);
insert into pack_values (pack_id, par_id, value) values (6, 2, 15.0);
insert into pack_values (pack_id, par_id, value) values (6, 3, 750);
insert into pack_values (pack_id, par_id, value) values (6, 4, 0);
insert into pack_values (pack_id, par_id, value) values (6, 5, null);
insert into pack_values (pack_id, par_id, value) values (6, 6, 0);

-- 12 пачка
insert into pack_values (pack_id, par_id, value) values (12, 1, 100);
insert into pack_values (pack_id, par_id, value) values (12, 2, 14.0);
insert into pack_values (pack_id, par_id, value) values (12, 3, 752);
insert into pack_values (pack_id, par_id, value) values (12, 4, 15);
insert into pack_values (pack_id, par_id, value) values (12, 5, null);
insert into pack_values (pack_id, par_id, value) values (12, 6, 45);

-- 13 пачка
insert into pack_values (pack_id, par_id, value) values (13, 1, 100);
insert into pack_values (pack_id, par_id, value) values (13, 2, 16.5);
insert into pack_values (pack_id, par_id, value) values (13, 3, 748);
insert into pack_values (pack_id, par_id, value) values (13, 4, 30);
insert into pack_values (pack_id, par_id, value) values (13, 5, null);
insert into pack_values (pack_id, par_id, value) values (13, 6, 60);

-- 14 пачка
insert into pack_values (pack_id, par_id, value) values (14, 1, 100);
insert into pack_values (pack_id, par_id, value) values (14, 2, 13.5);
insert into pack_values (pack_id, par_id, value) values (14, 3, 755);
insert into pack_values (pack_id, par_id, value) values (14, 4, 45);
insert into pack_values (pack_id, par_id, value) values (14, 5, null);
insert into pack_values (pack_id, par_id, value) values (14, 6, 75);

-- 15 пачка
insert into pack_values (pack_id, par_id, value) values (15, 1, 100);
insert into pack_values (pack_id, par_id, value) values (15, 2, 12.5);
insert into pack_values (pack_id, par_id, value) values (15, 3, 751);
insert into pack_values (pack_id, par_id, value) values (15, 4, 20);
insert into pack_values (pack_id, par_id, value) values (15, 5, null);
insert into pack_values (pack_id, par_id, value) values (15, 6, 90);

/*
select
    p.id as Номер_пачки,
    u.name as Сотрудник,
    pos.name as Должность,
    par.name as Параметр_роли,
    te.name as Оборудование,
    p.meas_at as Дата_измерения,
    p.height as Высота,
    p.temp as Температура,
    p.pres as Давление,
    p.wind_dir as Направление_ветра,
    p.wind_speed as Скорость_ветра,
    p.drift as Дальность_сноса,
    p.appr as Действующий
from packs p
join users u on p.user_id = u.id
join positions pos on u.pos_id  = pos.id
join types_equipment te on p.eq_id = te.id
left join parameters par on pos.par_id = par.id
order by p.id;
*/