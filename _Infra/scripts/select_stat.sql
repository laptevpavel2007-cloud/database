do $$
begin
    begin
        drop function if exists check_errors(list_par) cascade;
        drop table if exists errors cascade;
        drop type if exists list_par cascade;
    end;

    begin
		create table errors (
		    id         int,
		    par_id     int,
		    error_name text, 
		    error_desc text,
		    min_val    numeric(12,2),
		    max_val    numeric(12,2),
		    strict_min boolean default false
		);
        create sequence if not exists errors_id_seq start 1;
        alter table errors alter column id set default nextval('errors_id_seq');
        comment on table errors is 'Возможные ошибки в данных';

		insert into errors (par_id, error_name, error_desc, min_val, max_val, strict_min) values
		    (1, 'Вне диапазона', 'height',      0,    5000, true),
		    (2, 'Вне диапазона', 'temperature', -60,  60,   false),
		    (3, 'Вне диапазона', 'pres',        600,  800,  false),
		    (4, 'Вне диапазона', 'wind_dir',    0,    360,  false),
		    (5, 'Вне диапазона', 'wind_speed',  0,    60,   false),
		    (6, 'Вне диапазона', 'drift',       0,    1000, false);
    end;

    begin
        create type list_par as (
            height      numeric(12,2),
            temperature numeric(12,2),
            pres        numeric(12,2),
            wind_dir    numeric(12,2),
            wind_speed  numeric(12,2),
            drift       numeric(12,2)
        );
        comment on type list_par is 'Список параметров';
    end;

    begin
        create function check_errors(p list_par)
        returns table (error_flag text, errors_list text)
        as $fn$
            declare
                res text := '';
                e   text := 'Нет';
                rec record;
                v_val numeric;
            begin

                for rec in select * from errors order by par_id loop
        
                    v_val := case rec.par_id
                        when 1 then p.height
                        when 2 then p.temperature
                        when 3 then p.pres
                        when 4 then p.wind_dir
                        when 5 then p.wind_speed
                        when 6 then p.drift
                    end;

                    if (v_val is null) then
                        e := 'Есть';
                        res := res || rec.error_desc || ': NULL; ';

                    elsif (rec.strict_min and v_val <= rec.min_val) 
                       or (not rec.strict_min and v_val < rec.min_val) 
                       or v_val > rec.max_val then
                       
                        e := 'Есть';
                        res := res || rec.error_desc || ': Вне диапазона (' || v_val || '); ';
                    end if;
                    
                end loop;

                return query select e, res;
                
            end;
        $fn$ language plpgsql;
        
        comment on function check_errors(list_par) is 'Функция нахождения ошибок';
    end;

end $$;