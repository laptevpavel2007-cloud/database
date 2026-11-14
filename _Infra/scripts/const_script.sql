do $$
begin
    begin
        drop table if exists const cascade;
        drop function if exists const_value(text) cascade;
    end;

    begin
        create table const (
            id int,
            code_const text,
            name text,
            mean numeric(5, 2)
        );
        create sequence if not exists const_id_seq start 1;
        alter table const alter column id set default nextval('const_id_seq');
        comment on table const is 'Константы';

        insert into const(code_const, name, mean) values
            ('ground_pressure', 'наземное давление', 750.00),
            ('surface_virtual_temperature', 'приземная виртуальная температура', 15.90),
            ('encoding_negative_temperature_values', 'кодирование отрицательных значений температуры', 50.00);
    end;

    begin
        create function const_value(p_code text) returns numeric
        stable
        as $fn$
        declare
            v_val numeric(5, 2);
        begin
            if p_code is null then
                raise exception 'Код константы не может быть NULL';
            end if;
       
            select c.mean into v_val from const c where c.code_const = p_code;

            if not found then
                raise exception 'Константа с кодом "%" не найдена в БД', p_code;
            end if;

            return v_val;
        end;
        $fn$ language 'plpgsql';

        comment on function const_value(text) is 'Функция для получения значения константы';
    end;
end $$;