drop table if exists packs, users, parameters, types_equipment, positions, pack_values, base_measurement, measurement, type_parametrs, list_measurement,
temp_cor cascade;

drop sequence if exists positions_id_seq, types_equipment_id_seq, users_id_seq, parameters_id_seq, packs_id_seq, pack_values_id_seq, base_measurement_id_seq,
measurement_id_seq, type_parametrs_id_seq, list_measurement_id_seq, temp_correction_id_seq cascade;

begin;
do $$
begin
	create table positions
	(
	    id int primary key, 
	    name text,
	    par_id int
	);
	create sequence if not exists positions_id_seq start 1;
	alter table positions alter column id set default nextval('positions_id_seq');
	
	create table types_equipment
	(
	    id int primary key,
	    name text
	);
	create sequence if not exists types_equipment_id_seq start 1;
	alter table types_equipment alter column id set default nextval('types_equipment_id_seq');
	
	create table users
	(
	    id int primary key,
	    name text,
	    pos_id int,
	    eq_id int
	);
	create sequence if not exists users_id_seq start 1;
	alter table users alter column id set default nextval('users_id_seq');
	
	create table parameters
	(
	    id int primary key,
	    name text
	);
	create sequence if not exists parameters_id_seq start 1;
	alter table parameters alter column id set default nextval('parameters_id_seq');
	
	create table packs
	(
	    id int primary key,
	    user_id int,       
	    eq_id int,       
	    meas_at timestamp,  
	    appr boolean
	);
	create sequence if not exists packs_id_seq start 1;
	alter table packs alter column id set default nextval('packs_id_seq');
	
	create table pack_values
	(
		id int primary key,
	    pack_id int,
	    par_id int,
	    value numeric(12, 2)
	);
	create sequence if not exists pack_values_id_seq start 1;
	alter table pack_values alter column id set default nextval('pack_values_id_seq');
	
	create table base_measurement (
	    id int primary key,
	    name text
	);
	create sequence if not exists base_measurement_id_seq start 1;
	alter table base_measurement alter column id set default nextval('base_measurement_id_seq');
	
	create table measurement (
	    id int primary key,
	    name text,
		base_meas_id int, 
		ratio NUMERIC(12,4)
	);
	create sequence if not exists measurement_id_seq start 1;
	alter table measurement alter column id set default nextval('measurement_id_seq');
	
	create table type_parametrs (
	    id int primary key,
	    name text
	);
	create sequence if not exists type_parametrs_id_seq start 1;
	alter table type_parametrs alter column id set default nextval('type_parametrs_id_seq');
	
	create table list_measurement (
	    id int primary key,
	    name text
	);
	create sequence if not exists list_measurement_id_seq start 1;
	alter table list_measurement alter column id set default nextval('list_measurement_id_seq');

	create table temp_cor (
        id          int primary key,
        temp_from   numeric(5,1),       
        temp_to     numeric(5,1),       
        delta_tv    numeric(4,1) not null,
        description text
    );
    create sequence if not exists temp_correction_id_seq start 1;
    alter table temp_cor alter column id set default nextval('temp_correction_id_seq');
 
end $$;
commit;

begin;
do $$
begin
	
	-- ------------------------------------------------------------
	-- base_measurement
	-- ------------------------------------------------------------
	insert into base_measurement (id, name) values
	    (1, 'длина'),
	    (2, 'температура'),
	    (3, 'давление'),
	    (4, 'скорость'),
	    (5, 'угол');
	
	-- ------------------------------------------------------------
	-- measurement
	-- ------------------------------------------------------------
	insert into measurement (id, name, base_meas_id, ratio) values
	    (1, '°c',        2, 1),
	    (2, 'па',        3, 1),
	    (3, 'м/с',       4, 1),
	    (4, '°',         5, 1),
	    (5, 'м',         1, 1),
	    (6, 'мм рт.ст.', 3, 133.3224);
	
	-- ------------------------------------------------------------
	-- type_parametrs
	-- ------------------------------------------------------------
	insert into type_parametrs (id, name) values
	    (1, 'метеорологический'),
	    (2, 'баллистический'),
	    (3, 'геодезический');
	
	-- ------------------------------------------------------------
	-- list_measurement
	-- ------------------------------------------------------------
	insert into list_measurement (id, name) values
	    (1, 'height'),
	    (2, 'temp'),
	    (3, 'pres'),
	    (4, 'wind_dir'),
	    (5, 'wind_speed'),
	    (6, 'drift');
	
	-- ------------------------------------------------------------
	-- positions
	-- ------------------------------------------------------------
	insert into positions (id, name, par_id) values
	    (1, 'начальник метеопоста',    null),
	    (2, 'оператор дмк',            null),
	    (3, 'оператор вр',             null),
	    (4, 'топогеодезист',           1),
	    (5, 'метеоролог-термометрист', 2),
	    (6, 'метеоролог-барометрист',  3),
	    (7, 'аэролог (направление)',   4),
	    (8, 'аэролог (скорость)',      5),
	    (9, 'наблюдатель за сносом',   6);
	
	-- ------------------------------------------------------------
	-- types_equipment
	-- ------------------------------------------------------------
	insert into types_equipment (id, name) values
	    (1, 'дмк'),
	    (2, 'вр');
	
	-- ------------------------------------------------------------
	-- users
	-- ------------------------------------------------------------
	insert into users (id, name, pos_id, eq_id) values
	    (1,  'лаптев павел николаевич', 1, 1),
	    (2,  'лаптев николай борисович', 2, 1),
	    (3,  'лаптева юлия сергеевна', 2, 1),
	    (4,  'лаптева лина николаевна', 2, 1),
	    (5,  'сабжаева полина николаевна', 3, 2),
	    (6,  'сабжаев алексей александрович', 3, 2),
	    (7,  'сабжаев алексей алексеевич', 7, 2),
	    (8,  'сабжаева бусюня алексеевна', 1, 1),
	    (9,  'иванов иван иванович', 4, 1),
	    (10, 'петров пётр петрович', 5, 1),
	    (11, 'сидоров сидор сидорович', 6, 1),
	    (12, 'кузнецова анна сергеевна', 7, 2),
	    (13, 'морозов дмитрий олегович', 6, 2);
	
	-- ------------------------------------------------------------
	-- parameters
	-- ------------------------------------------------------------
	insert into parameters (id, name) values
	    (1, 'высота метеопоста'),
	    (2, 'температура'),
	    (3, 'давление'),
	    (4, 'направление ветра'),
	    (5, 'скорость ветра'),
	    (6, 'дальность сноса пуль');
	
	-- ------------------------------------------------------------
	-- packs
	-- ------------------------------------------------------------
	insert into packs (id, user_id, eq_id, meas_at, appr) values
	    (1,   1, 1, '2026-09-20 09:30:00', false),
	    (2,   2, 1, '2026-09-20 10:15:00', false),
	    (3,   3, 1, '2026-09-20 11:00:00', true),
	    (4,   4, 1, '2026-09-21 08:45:00', false),
	    (5,   8, 1, '2026-09-21 09:20:00', false),
	    (6,   5, 2, '2026-09-20 09:45:00', false),
	    (12,  6, 2, '2026-09-20 11:20:00', false),
	    (13,  7, 2, '2026-09-20 12:00:00', true),
	    (14, 12, 2, '2026-09-21 08:30:00', false),
	    (15, 13, 2, '2026-09-21 10:10:00', false),
	    (16,  9, 1, '2026-09-22 08:00:00', false),
	    (17, 10, 1, '2026-09-22 08:30:00', false),
	    (18, 11, 1, '2026-09-22 09:00:00', false),
	    (19, 12, 2, '2026-09-22 09:30:00', false),
	    (20, 13, 2, '2026-09-22 10:00:00', true),
	    (21,  1, 1, '2026-09-23 08:00:00', false),
	    (22,  2, 1, '2026-09-23 08:30:00', false),
	    (23,  3, 1, '2026-09-23 09:00:00', false),
	    (24,  5, 2, '2026-09-23 09:30:00', false),
	    (25,  7, 2, '2026-09-23 10:00:00', true),
	    (26,  9, 1, '2026-09-24 08:00:00', false),
	    (27, 10, 1, '2026-09-24 08:30:00', false),
	    (28, 11, 1, '2026-09-24 09:00:00', false),
	    (29, 12, 2, '2026-09-24 09:30:00', false),
	    (30, 13, 2, '2026-09-24 10:00:00', false);
	
	-- ------------------------------------------------------------
	-- pack_values
	-- ------------------------------------------------------------
	insert into pack_values (pack_id, par_id, value) values
	    -- пачка 1
	    (1, 1, 100.00), (1, 2, 15.00), (1, 3, 750.00),
	    (1, 4,   0.00), (1, 5,  0.00), (1, 6,  null),
	    -- пачка 2
	    (2, 1, 100.00), (2, 2, 14.50), (2, 3, 752.00),
	    (2, 4,  15.00), (2, 5,  4.00), (2, 6,  null),
	    -- пачка 3
	    (3, 1, 100.00), (3, 2, 16.00), (3, 3, 748.00),
	    (3, 4,  30.00), (3, 5,  6.00), (3, 6,  70.00),
	    -- пачка 4
	    (4, 1, 100.00), (4, 2, 13.00), (4, 3, 755.00),
	    (4, 4,  45.00), (4, 5,  3.00), (4, 6,   0.00),
	    -- пачка 5
	    (5, 1, 100.00), (5, 2, 12.00), (5, 3, 751.00),
	    (5, 4,  20.00), (5, 5,  5.00), (5, 6,   0.00),
	    -- пачка 6
	    (6, 1, 100.00), (6, 2, 15.00), (6, 3, 750.00),
	    (6, 4,   0.00), (6, 5,  null), (6, 6,   0.00),
	    -- пачка 12
	    (12, 1, 100.00), (12, 2, 14.00), (12, 3, 752.00),
	    (12, 4,  15.00), (12, 5,  null), (12, 6,  45.00),
	    -- пачка 13
	    (13, 1, 100.00), (13, 2, 16.50), (13, 3, 748.00),
	    (13, 4,  30.00), (13, 5,  null), (13, 6,  60.00),
	    -- пачка 14
	    (14, 1, 100.00), (14, 2, 13.50), (14, 3, 755.00),
	    (14, 4,  45.00), (14, 5,  null), (14, 6,  75.00),
	    -- пачка 15
	    (15, 1, 100.00), (15, 2, 12.50), (15, 3, 751.00),
	    (15, 4,  20.00), (15, 5,  null), (15, 6,  90.00),
	    -- пачка 16 — нормальные
	    (16, 1, 150.00), (16, 2, 18.50), (16, 3, 760.00),
	    (16, 4,  90.00), (16, 5,  7.50), (16, 6, 120.00),
	    -- пачка 17 — границы min
	    (17, 1,   1.00), (17, 2, -60.00), (17, 3, 600.00),
	    (17, 4,   0.00), (17, 5,   0.00), (17, 6,   0.00),
	    -- пачка 18 — границы max
	    (18, 1, 5000.00), (18, 2, 60.00), (18, 3, 800.00),
	    (18, 4,  360.00), (18, 5, 60.00), (18, 6, 1000.00),
	    -- пачка 19 — выход за диапазон
	    (19, 1, 6000.00), (19, 2, -80.00), (19, 3, 900.00),
	    (19, 4,  400.00), (19, 5,  80.00), (19, 6, 1500.00),
	    -- пачка 20 — всё null
	    (20, 1, null), (20, 2, null), (20, 3, null),
	    (20, 4, null), (20, 5, null), (20, 6, null),
	    -- пачка 21 — отрицательные
	    (21, 1, -10.00), (21, 2,  20.00), (21, 3, 755.00),
	    (21, 4,  -5.00), (21, 5,  -1.00), (21, 6, -20.00),
	    -- пачка 22 — нули
	    (22, 1,   0.00), (22, 2,   0.00), (22, 3,   0.00),
	    (22, 4,   0.00), (22, 5,   0.00), (22, 6,   0.00),
	    -- пачка 23 — смешанные нормальные
	    (23, 1, 250.00), (23, 2,   5.00), (23, 3, 745.00),
	    (23, 4, 180.00), (23, 5,  12.00), (23, 6, 350.00),
	    -- пачка 24 — часть null
	    (24, 1, 300.00), (24, 2,  null), (24, 3, 750.00),
	    (24, 4,  null), (24, 5,   8.00), (24, 6,  null),
	    -- пачка 25 — дробные
	    (25, 1, 123.45), (25, 2, -12.75), (25, 3, 748.50),
	    (25, 4,  45.50), (25, 5,   3.25), (25, 6,  77.77),
	    -- пачка 26 — норма + граница
	    (26, 1, 500.00), (26, 2,  25.00), (26, 3, 700.00),
	    (26, 4, 360.00), (26, 5,  15.00), (26, 6, 1000.00),
	    -- пачка 27 — выход по давлению
	    (27, 1, 100.00), (27, 2,  22.00), (27, 3, 810.00),
	    (27, 4, 270.00), (27, 5,  10.00), (27, 6, 400.00),
	    -- пачка 28 — сильный ветер
	    (28, 1, 200.00), (28, 2,  10.00), (28, 3, 765.00),
	    (28, 4, 315.00), (28, 5,  59.99), (28, 6, 900.00),
	    -- пачка 29 — мороз
	    (29, 1, 100.00), (29, 2, -45.00), (29, 3, 770.00),
	    (29, 4, 135.00), (29, 5,   2.00), (29, 6,  50.00),
	    -- пачка 30 — жара
	    (30, 1, 100.00), (30, 2,  55.00), (30, 3, 720.00),
	    (30, 4, 225.00), (30, 5,   1.00), (30, 6,  10.00);
	
	
	alter table parameters add column meas_id int;
	alter table parameters add column type_id int;
	alter table parameters add column column_id int;
		
	update parameters set meas_id = 5, type_id = 3, column_id = 1 where id = 1;
	update parameters set meas_id = 1, type_id = 1, column_id = 2 where id = 2;
	update parameters set meas_id = 6, type_id = 1, column_id = 3 where id = 3;
	update parameters set meas_id = 4, type_id = 1, column_id = 4 where id = 4;
	update parameters set meas_id = 3, type_id = 1, column_id = 5 where id = 5;
	update parameters set meas_id = 5, type_id = 2, column_id = 6 where id = 6;
	
	insert into temp_cor (id, temp_from, temp_to, delta_tv, description) values
	        (1, null,  0,  0,    'ниже 0'),
	        (2, 0,     5,  0.5,  '0 - 5'),
	        (3, 10,   15,  1,    '10 - 15'),
	        (4, 20,   20,  1.5,  '20'),
	        (5, 25,   25,  2,    '25'),
	        (6, 30,   30,  3.5,  '30'),
	        (7, 40,   40,  4.5,  '40');

end $$;
commit;

begin;
do $$
begin
	
	alter table measurement add constraint fk_measurement_base
	foreign key (base_meas_id) references base_measurement (id);
	
	alter table users add constraint fk_users_position
	foreign key (pos_id) references positions (id);
	
	alter table users add constraint fk_users_equipment
	foreign key (eq_id) references types_equipment (id);
	
	alter table packs add constraint fk_packs_user
	foreign key (user_id) references users (id);
	
	alter table packs add constraint fk_packs_equipment
	foreign key (eq_id) references types_equipment (id);
	
	alter table pack_values add constraint fk_pack_values_pack
	foreign key (pack_id) references packs (id) on delete cascade;
	
	alter table pack_values add constraint fk_pack_values_parameter
	foreign key (par_id) references parameters (id);
	
	alter table parameters add constraint fk_parameters_measurement
	foreign key (meas_id) references measurement (id);
	
	alter table parameters add constraint fk_parameters_type
	foreign key (type_id) references type_parametrs (id);

	alter table parameters add constraint fk_parameters_column
	foreign key (column_id) references list_measurement (id);
	
	
	
	alter table positions alter column name set not null;
	
	alter table types_equipment alter column name set not null;
	
	alter table users alter column name set not null;
	
	alter table parameters alter column name set not null;
	
	alter table packs alter column user_id set not null;
	alter table packs alter column eq_id set not null;
	alter table packs alter column meas_at set not null;
	alter table packs alter column appr set not null;
	
	alter table base_measurement alter column name set not null;
	
	alter table measurement alter column name set not null;
	alter table measurement alter column base_meas_id set not null;
	alter table measurement alter column ratio set not null;
	
	alter table type_parametrs alter column name set not null;
	
	alter table list_measurement alter column name set not null;
	
	alter table pack_values alter column pack_id set not null;
	alter table pack_values alter column par_id set not null;
	
	alter table temp_cor alter column temp_from drop not null;
	alter table temp_cor alter column description set not null;
	
	
	alter table pack_values add constraint chk_height check (par_id <> 1 or value is null or (value > 0 and value <= 5000)) not valid;
	
	alter table pack_values add constraint chk_temp check (par_id <> 2 or value is null or (value >= -60 and value <= 60)) not valid;
	
	alter table pack_values add constraint chk_pres check (par_id <> 3 or value is null or (value >= 600 and value <= 800)) not valid;
	
	alter table pack_values add constraint chk_wind_dir check (par_id <> 4 or value is null or (value >= 0 and value <= 360)) not valid;
	
	alter table pack_values add constraint chk_wind_speed check (par_id <> 5 or value is null or (value >= 0 and value <= 60)) not valid;
	
	alter table pack_values add constraint chk_drift check (par_id <> 6 or value is null or (value >= 0 and value <= 1000)) not valid;

end $$;
commit;
