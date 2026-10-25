do $$
begin
    begin
        drop function if exists calc_meteo_header(p_at timestamp, p_h numeric, p_pres numeric, p_temp numeric) cascade;
        drop function if exists calc_tt(p_temp numeric) cascade;
    end;

    begin
        create function calc_tt(p_temp numeric) returns text
        as $fn$
        declare
            v_t0 numeric;
            v_dt numeric;
        begin
            if p_temp is null then
                return null;
            end if;
        
            if p_temp >= 0 then
                v_t0 := p_temp + calculation_temp(p_temp, definition_temp_inter(p_temp));
            else
                v_t0 := p_temp;
            end if;

            v_dt := round(v_t0 - const_value('surface_virtual_temperature'));

            if v_dt < 0 then
                v_dt := const_value('encoding_negative_temperature_values') + abs(v_dt);
            end if;
        
            return lpad(v_dt::int::text, 2, '0');
        end;
        $fn$ language 'plpgsql';
        
        comment on function calc_tt(p_temp numeric) is 'Функция расчета отклонения приземной виртуальной температуры';
    
        create function calc_meteo_header(p_at timestamp, p_h numeric, p_pres numeric, p_temp numeric) returns text
        as $fn$
        declare
            bbb  text;
            vvvv text;
            dh   numeric;
            v_min text;
        begin

            dh := round(p_pres - const_value('ground_pressure'));
            if dh < 0 then
                dh := 500 + abs(dh);
            end if;
            bbb := lpad(dh::int::text, 3, '0');

            vvvv := case
                when p_h < 0 then
                    '-' || lpad(abs(round(p_h))::int::text, 3, '0')
                else
                    lpad(round(p_h)::int::text, 4, '0')
            end;

            v_min := ((extract(minute from p_at)::int / 10))::text;
 
            return to_char(p_at, 'DDHH24') || v_min || ' ' || vvvv || ' ' || bbb || calc_tt(p_temp);
        end;
        $fn$ language 'plpgsql';
        
        comment on function calc_meteo_header(timestamp, numeric, numeric, numeric) is 'Функция расчета заголовка метеобюллетеня';
    end;
end $$;