do $$
begin

	begin
		
		drop function if exists calculation_temp(numeric, interp_params) cascade;
		drop function if exists definition_temp_inter(numeric) cascade;
		drop type if exists interp_params cascade;

	end;
	commit;

	
	begin
	
		create type interp_params as (
		    x0 numeric(4, 2),
		    y0 numeric(4, 2),
		    x1 numeric(4, 2),
		    y1 numeric(4, 2));

		comment on type interp_params is 'Параметры для линейной интерполяции';

	end;
	commit;


	begin


		create function definition_temp_inter(in target_temp numeric) returns interp_params as
			$fn$
			declare
					x0 numeric;
					y0 numeric;
					x1 numeric;
					y1 numeric;
			begin
			
				select max(tc.temperature) into x0 from temp_cor tc where tc.temperature <= target_temp;

				select tc.correction into y0 from temp_cor tc where tc.temperature = x0;

				select min(tc.temperature) into x1 from temp_cor tc where tc.temperature >= target_temp;

				select tc.correction into y1 from temp_cor tc where tc.temperature = x1;
				
				if x0 is null then
					x0 := x1;
					y0 := y1;
				end if;
				
				if x1 is null then
					x1 := x0;
					y1 := y0;
				end if;
				
				return row(x0, y0, x1, y1)::interp_params;
			end;
			$fn$ language 'plpgsql';
		
		comment on function definition_temp_inter(numeric) is 'Функция для нахождения пограничных значений';
		
	end;
	commit;

	begin

		create function calculation_temp (in temperature numeric, in ip interp_params) returns numeric as 
			$fn$
			begin
				if ip.x1 = ip.x0 then
					return ip.y0;
				
				else 
					return ip.y0 + (ip.y1 - ip.y0) * (temperature - ip.x0) / (ip.x1 - ip.x0);
				end if;
			end;
			$fn$ language 'plpgsql';
		
		comment on function calculation_temp(numeric, interp_params) is 'Функция для расчета параметра температуры';
	
	end;
	commit;

end $$;
