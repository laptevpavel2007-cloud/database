do $$
begin
	begin

		drop table if exists calc_correction_heights, calc_correction_headers, calc_correction_types, calc_correction cascade;
		drop procedure if exists calculations (p_pack_id int, p_eq_type text, inout p_result refcursor) cascade;
		drop sequence if exists calc_correction_height_seq, calc_correction_headers_id_seq, calc_correction_types_seq, calc_correction_seq cascade;
		
	end;

	-- Создаем новые структуры
	begin
		
		-- Таблица стандартных высот
		create sequence if not exists calc_correction_height_seq start 1;
		create table calc_correction_heights
		(
		    id integer primary key not null default nextval('calc_correction_height_seq'),
		    height integer not null
		);
		
		
		insert into calc_correction_heights(height)
		values(200),(400),(800),(1200),(1600),(2000),(2400),(3000),(4000);
	
		comment on table calc_correction_heights is 'Таблица стандартных высот';
		comment on column calc_correction_heights.id is 'Уникальный код';
		comment on column calc_correction_heights.height is 'Высота';
		
		
		-- Справочник заголовков таблиц
		create table calc_correction_headers
		(
		    id int primary key not null,
		    header_values int[]
		);
		create sequence if not exists calc_correction_headers_id_seq start 1;
		alter table calc_correction_headers alter column id set default nextval('calc_correction_headers_id_seq');
		
		comment on table calc_correction_headers is 'Справочник заголовков таблиц корректировок';
		comment on column calc_correction_headers.id is 'Уникальный код';
		comment on column calc_correction_headers.header_values is 'Значения в заголовке таблицы';
		

		-- Справочник типов таблиц корректировок
		create sequence if not exists calc_correction_types_seq start 1;
		create table calc_correction_types
		(
		    id integer primary key not null default nextval('calc_correction_types_seq'),
		    parent_id integer,
		    equipment_type_id integer,
		    description text not null,
		    header_id integer
		);

	
		comment on table calc_correction_types is 'Справочник типов таблиц с собственными заголовками';
		comment on column calc_correction_types.id is 'Уникальный код';
		comment on column calc_correction_types.parent_id is 'Уникальный код владельца - тип таблицы';
		comment on column calc_correction_types.equipment_type_id is 'Тип оборудования';
		comment on column calc_correction_types.description is 'Описание к таблице';
		comment on column calc_correction_types.header_id is 'Ссылка на заголовок таблицы';


		-- Универсальная таблица корректировок
		create sequence if not exists calc_correction_seq start 1;
		create table calc_correction
		(
		    id integer primary key not null default nextval('calc_correction_seq'),
		    height_id integer not null,
		    type_id integer not null,
		    row_values integer[]
		);

		comment on table calc_correction is 'Универсальная таблица корректировок';
		comment on column calc_correction.id is 'Уникальный код';
		comment on column calc_correction.height_id is 'Код высоты';
		comment on column calc_correction.type_id is 'Код типа таблиц';
		comment on column calc_correction.row_values is 'Значения с корректировками';

	end;	

	-- Добавляем данные
	begin

		insert into calc_correction_headers(id, header_values) values
		(1, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50]),
		(2, array[40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]),
		(3, array[3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
		
		insert into calc_correction_types(id, description, header_id)
		values(1, 'Таблица 2', 1),  -- 1
		(2, 'Таблица 3, скорость среднего ветра', null), -- 2
		(3, 'Таблица 3, направление среднего ветра', null);       -- 3

		insert into calc_correction_types(id, description, parent_id, equipment_type_id, header_id)
		values
		(4, 'Таблица 3, Скорость среднего ветра (ВР)',     2, 2, 2), -- 4
		(5, 'Таблица 3, Направление среднего ветра (ВР)',  3, 2, 2), -- 5
		(6, 'Таблица 3, Скорость среднего ветра (ДМК)',    2, 1, 3), -- 6
		(7, 'Таблица 3, Направление среднего ветра (ДМК)', 3, 1, 3); -- 7
		
		insert into calc_correction_types(id, description, parent_id)
		values(8, 'Таблица 2, Отрицательные температуры', 1 ), -- 8
		(9, 'Таблица 2, Положительные температуры', 1 ); --9

		
		insert into calc_correction(height_id, type_id, row_values )
		-- Таблица 2, отрицптельные значения
		values(1, 8, array[-1, -2, -3, -4, -5, -6, -7, -8, -8, -9, -20, -29, -39, -49]), -- 200
		(2, 8, array[-1, -2, -3, -4, -5, -6, -6, -7, -8, -9, -19, -29, -39, -48]), -- 400
		(3, 8, array[-1, -2, -3, -4, -5, -6, -6, -7, -7, -8, -18, -28, -37, -46]), -- 800
		(4, 8, array[-1, -2, -3, -4, -4, -5, -5, -6, -7, -8, -17, -26, -35, -44]), -- 1200
		(5, 8, array[-1, -2, -3, -3, -4, -4, -5, -6, -7, -7, -17, -25, -34, -42]), -- 1600
		(6, 8, array[-1, -2, -3, -3, -4, -4, -5, -6, -6, -7, -16, -24, -32, -40]), -- 2000
		(7, 8, array[-1, -2, -2, -3, -4, -4, -5, -5, -6, -7, -15, -23, -31, -38]), -- 2400
		(8, 8, array[-1, -2, -2, -3, -4, -4, -4, -5, -5, -6, -15, -22, -30, -37]), -- 3000
		(9, 8, array[-1, -2, -2, -3, -4, -4, -4, -4, -5, -6, -14, -20, -27, -34]), -- 4000
		-- Таблица 2, положитеьные значения
		(1, 9, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 200
		(2, 9, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 400
		(3, 9, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 800
		(4, 9, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 1200
		(5, 9, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 1600
		(6, 9, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 2000
		(7, 9, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 2400
		(8, 9, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 3000
		(9, 9, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 4000
		-- Таблица 3, Скорость среднего ветра (ВР)
		(1, 4, array[3, 4, 5, 6, 7, 7, 8, 9, 10, 11, 12, 12]), -- 200
		(2, 4, array[4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 ,15]), -- 400
		(3, 4, array[4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 ,16]), -- 800
		(4, 4, array[4, 5, 7, 8, 8, 9, 11, 12, 13, 15 ,15, 16]), -- 1200
		(5, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14, 15, 17, 17]), -- 1600
		(6, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14 ,16, 17, 18]), -- 2000
		(7, 4, array[4, 6, 8, 9, 9, 10, 12, 14, 15 ,16, 18, 19]), -- 2400
		(8, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 16, 18, 19, 20]), -- 3000
		(9, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 16, 18, 19, 20]), -- 4000
		-- Таблица 3, Направление среднего ветра (ВР)
		(1, 5, array[0]), -- 200
		(2, 5, array[1]), -- 400
		(3, 5, array[2]), -- 800
		(4, 5, array[2]), -- 1200
		(5, 5, array[3]), -- 1600
		(6, 5, array[3]), -- 2000
		(7, 5, array[3]), -- 2400
		(8, 5, array[4]), -- 3000
		(9, 5, array[4]), -- 4000
		-- Таблица 3,Скорость среднего ветра (ДМК)
		(1, 6, array[4,6,8,9,10,12,14,15,16,18,20,21,22]), -- 200
		(2, 6, array[5,7,10,11,12,14,17,18,20,22,23,25,27]), -- 400
		(3, 6, array[5,8,10,11,13,15,18,19,21,23,25,27,28]), -- 800
		(4, 6, array[5,8,11,12,13,16,19,20,23,24,26,28,30]), -- 1200
		(5, 6, array[6,8,11,13,14,17,20,21,23,25,27,29,32]), -- 1600
		(6, 6, array[6,9,11,13,14,17,20,21,24,26,28,30,32]), -- 2000
		(7, 6, array[6,9,12,14,15,18,21,22,25,27,29,32,34]), -- 2400
		(8, 6, array[6,9,12,14,15,18,21,23,25,28,30,32,36]), -- 3000
		(9, 6, array[6,10,12,14,16,19,22,24,26,29,32,34,36]), -- 4000
		-- 'Таблица 3, Направление среднего ветра (ДМК)
		(1, 7, array[1]), -- 200
		(2, 7, array[2]), -- 400
		(3, 7, array[3]), -- 800
		(4, 7, array[3]), -- 1200
		(5, 7, array[4]), -- 1600
		(6, 7, array[4]), -- 2000
		(7, 7, array[4]), -- 2400
		(8, 7, array[5]), -- 3000
		(9, 7, array[5]); -- 4000
		
	end;

	begin
		update temp_cor set correction = 1.5 where temperature = 20; -- Заметил что я прошлом скрипте сделал опечатку в данных

		create procedure calculations (p_pack_id int, p_eq_type text, inout p_result refcursor)
		as $fn$
		declare
			v_temp numeric;
			v_wind_dir numeric;
			v_wind_val numeric;
			v_eq_id int;
			v_t0 numeric;
			v_dt int;
			v_tt int;
			v_idx_tens int;
			v_idx_units int;
			v_cc int;
			v_hh int;
			v_idx_wind int;
			v_zero boolean;
			v_header_tt int[];
		begin
		
			select id into v_eq_id from types_equipment where name = p_eq_type;
			if v_eq_id is null then
				raise exception 'Оборудование не найдено';
			end if;


			select max(value) filter (where par_id = 2) into v_temp from pack_values where pack_id = p_pack_id;
			
			select max(value) filter (where par_id = 4) into v_wind_dir from pack_values where pack_id = p_pack_id;
			
			if v_eq_id = 1 then
				select max(value) filter (where par_id = 5) into v_wind_val from pack_values where pack_id = p_pack_id;
			else
				select max(value) filter (where par_id = 6) into v_wind_val from pack_values where pack_id = p_pack_id;
			end if;


			if v_temp >= 0 then
                v_t0 := v_temp + calculation_temp(v_temp, definition_temp_inter(v_temp));
            else
                v_t0 := v_temp;
            end if;

            v_dt := round(v_t0 - const_value('surface_virtual_temperature'))::int;
			v_tt := case 
						when v_dt < 0 then 8 
						when v_dt >= 0 then 9 
					end;
			

			select ch.header_values into v_header_tt
			from calc_correction_types ct
			join calc_correction_headers ch on ct.header_id = ch.id
			where ct.id = 1;

			v_idx_tens := array_position(v_header_tt, (abs(v_dt)/10)*10);
			v_idx_units := array_position(v_header_tt, abs(v_dt)%10);

			if v_eq_id = 1 then
				v_cc := 6;
				v_hh := 7;
				if v_wind_val < 3 then
					v_zero := true;
				else
					v_zero := false;
				end if;
				v_idx_wind := array_position((select header_values from calc_correction_headers where id = 3), least(round(v_wind_val)::int, 15));
			else
				v_cc := 4;
				v_hh := 5;
				if v_wind_val < 40 then
					v_zero := true;
				else
					v_zero := false;
				end if;
				v_idx_wind := array_position((select header_values from calc_correction_headers where id = 2), least((round(v_wind_val/10.0) * 10)::int, 150));
			end if;
		
			open p_result for
			select 
				lpad((h.height / 100)::text, 2, '0') as h_code,
				lpad((case 
						when (coalesce(tt.row_values[v_idx_tens], 0) + coalesce(tt.row_values[v_idx_units], 0)) < 0 
							 then abs(coalesce(tt.row_values[v_idx_tens], 0) + coalesce(tt.row_values[v_idx_units], 0)) + const_value('encoding_negative_temperature_values')::int
						else coalesce(tt.row_values[v_idx_tens], 0) + coalesce(tt.row_values[v_idx_units], 0)
					end)::text, 
				2, '0') as tt,
				
				case 
					when v_zero then '00'
					else lpad(((v_wind_dir::int + coalesce(hh.row_values[v_idx_wind], hh.row_values[1], 0) + 60) % 60)::text, 2, '0')
				end as hh,

				case 
					when v_zero then '00'
					else lpad(coalesce(cc.row_values[v_idx_wind], 0)::text, 2, '0')
				end as cc
				
			from calc_correction_heights h
			left join calc_correction tt on tt.height_id = h.id and tt.type_id = v_tt
			left join calc_correction cc on cc.height_id = h.id and cc.type_id = v_cc
			left join calc_correction hh on hh.height_id = h.id and hh.type_id = v_hh
			order by h.height;

		end;
		$fn$ language plpgsql;
		
	end;
	
end $$;
