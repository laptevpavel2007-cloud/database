alter table users drop column if exists pos;
alter table parameters drop column if exists column_id;
alter table parameters drop column if exists meas_id;
alter table parameters drop column if exists type_id;

drop table if exists base_measurement, measurement, type_parametrs, list_measurement;

create table base_measurement (
    id   int,
    name text
);

insert into base_measurement (id, name) values (1, 'Длина');
insert into base_measurement (id, name) values (2, 'Температура');
insert into base_measurement (id, name) values (3, 'Давление');
insert into base_measurement (id, name) values (4, 'Скорость');
insert into base_measurement (id, name) values (5, 'Угол');

create table measurement (
    id   int,
    name text,
	base_meas_id int, 
	ratio NUMERIC(12,4)
);

insert into measurement (id, name, base_meas_id, ratio) values (1, '°C', 2, 1);
insert into measurement (id, name, base_meas_id, ratio) values (2, 'Па', 3, 1);
insert into measurement (id, name, base_meas_id, ratio) values (3, 'м/с', 4, 1);
insert into measurement (id, name, base_meas_id, ratio) values (4, '°', 5, 1);
insert into measurement (id, name, base_meas_id, ratio) values (5, 'м', 1, 1);
insert into measurement (id, name, base_meas_id, ratio) values (6, 'мм рт.ст.', 3, 133.3224);

create table type_parametrs (
	id int,
	name text
);

insert into type_parametrs (id, name) values (1, 'Метеорологический');
insert into type_parametrs (id, name) values (2, 'Баллистический');
insert into type_parametrs (id, name) values (3, 'Геодезический');

create table list_measurement (
    id int,
    name text
);

insert into list_measurement (id, name) values (1, 'height');
insert into list_measurement (id, name) values (2, 'temp');
insert into list_measurement (id, name) values (3, 'pres');
insert into list_measurement (id, name) values (4, 'wind_dir');
insert into list_measurement (id, name) values (5, 'wind_speed');
insert into list_measurement (id, name) values (6, 'drift');


alter table parameters add column column_id int;
alter table parameters add column meas_id int;
alter table parameters add column type_id int;

comment on column parameters.column_id is 'Ссылка на справочник названий';
comment on column parameters.meas_id is 'Ссылка на справочник единиц измерения';
comment on column parameters.type_id is 'Ссылка на справочник типов параметров';

update parameters set column_id = 1, meas_id = 5, type_id = 3 where id = 1;
update parameters set column_id = 2, meas_id = 1, type_id = 1 where id = 2;
update parameters set column_id = 3, meas_id = 6, type_id = 1 where id = 3;
update parameters set column_id = 4, meas_id = 4, type_id = 1 where id = 4;
update parameters set column_id = 5, meas_id = 3, type_id = 1 where id = 5;
update parameters set column_id = 6, meas_id = 5, type_id = 2 where id = 6;

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

select 
    p.meas_at as "Дата измерения",
    p.id as "Номер пачки",
    u.name as "ФИО сотрудника",
    par.name || ' (' || m.name || ')' as "Наименование параметра и ед. измерения",
    pv.value as "Значение"
	from packs p
	join users u on p.user_id = u.id
	join positions pos on u.pos_id = pos.id
	join parameters par on pos.par_id = par.id
	join pack_values pv on p.id = pv.pack_id and pv.par_id = par.id
	join measurement m on par.meas_id = m.id
	order by p.meas_at, p.id, par.id;