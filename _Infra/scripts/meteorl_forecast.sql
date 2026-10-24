do $$
begin

	begin

		drop function if exists calc_meteo_header(p_at timestamp, p_h numeric, p_pres numeric, p_temp numeric) cascade;
		drop function if exists calc_tt(p_temp numeric) cascade;

	end;
	commit;


	begin

		create function calc_tt(p_temp numeric) returns text
		as $fn$
		declare
		    v_dt numeric;
		begin
		    if p_temp is null then
		        return null;
		    end if;
		
		    if p_temp >= 0 then
		        p_temp := p_temp + calculation_temp(p_temp, definition_temp_inter(p_temp));
		    end if;
		
		    v_dt := round(p_temp - const_value(2));
			
		    if v_dt < 0 then
		        v_dt := const_value(3) + abs(v_dt);
		    end if;
		
		    return lpad(v_dt::int::text, 2, '0');
		end;
		$fn$ language 'plpgsql';
		comment on function calc_tt(p_temp numeric) is 'Функция расчета отклонение приземной виртуальной температуры';

		
		create function calc_meteo_header(p_at timestamp, p_h numeric, p_pres numeric, p_temp numeric) returns text
		as $fn$
		declare
		    bbb  text;
		    vvvv text;
		    dh   numeric;
		begin
		    dh := round(p_pres - const_value(1));
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
		
		    return to_char(p_at, 'DDHH24') || (extract(minute from p_at)::int / 10) || ' ' || vvvv || ' ' || bbb || calc_tt(p_temp);
		end;
		$fn$ language 'plpgsql';
		comment on function calc_meteo_header(p_at timestamp, p_h numeric, p_pres numeric, p_temp numeric) is 'Функция расчета отклонение приземной виртуальной температуры';
		
	end;
	commit;

end $$;