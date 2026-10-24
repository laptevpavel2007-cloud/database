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
            error_desc text
        );
        create sequence if not exists errors_id_seq start 1;
        alter table errors alter column id set default nextval('errors_id_seq');
        comment on table errors is 'Возможные ошибки в данных';

        insert into errors (par_id, error_name, error_desc) values
            (1, 'Вне диапазона', 'height: > 0 и <= 5000'),
            (2, 'Вне диапазона', 'temperature: от -60 до 60'),
            (3, 'Вне диапазона', 'pres: от 600 до 800'),
            (4, 'Вне диапазона', 'wind_dir: от 0 до 360'),
            (5, 'Вне диапазона', 'wind_speed: от 0 до 60'),
            (6, 'Вне диапазона', 'drift: от 0 до 1000');
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
            begin
                if (p.height is null) then
                    e := 'Есть'; res := res || 'height: NULL; ';
                elsif (p.height <= 0 or p.height > 5000) then
                    e := 'Есть'; res := res || 'height: Вне диапазона (' || p.height || '); ';
                end if;

                if (p.temperature is null) then
                    e := 'Есть'; res := res || 'temperature: NULL; ';
                elsif (p.temperature < -60 or p.temperature > 60) then
                    e := 'Есть'; res := res || 'temperature: Вне диапазона (' || p.temperature || '); ';
                end if;

                if (p.pres is null) then
                    e := 'Есть'; res := res || 'pres: NULL; ';
                elsif (p.pres < 600 or p.pres > 800) then
                    e := 'Есть'; res := res || 'pres: Вне диапазона (' || p.pres || '); ';
                end if;

                if (p.wind_dir is null) then
                    e := 'Есть'; res := res || 'wind_dir: NULL; ';
                elsif (p.wind_dir < 0 or p.wind_dir > 360) then
                    e := 'Есть'; res := res || 'wind_dir: Вне диапазона (' || p.wind_dir || '); ';
                end if;

                if (p.wind_speed is null) then
                    e := 'Есть'; res := res || 'wind_speed: NULL; ';
                elsif (p.wind_speed < 0 or p.wind_speed > 60) then
                    e := 'Есть'; res := res || 'wind_speed: Вне диапазона (' || p.wind_speed || '); ';
                end if;

                if (p.drift is null) then
                    e := 'Есть'; res := res || 'drift: NULL; ';
                elsif (p.drift < 0 or p.drift > 1000) then
                    e := 'Есть'; res := res || 'drift: Вне диапазона (' || p.drift || '); ';
                end if;

                return query select e, res;
            end;
        $fn$ language plpgsql;
		comment on function check_errors(list_par) is 'Функция нахождения ошибок';
		
    end;
end $$;