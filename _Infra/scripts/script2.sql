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