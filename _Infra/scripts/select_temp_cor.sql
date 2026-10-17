do $$
begin

	begin
		
		drop function if exists calculation_temp(numeric, interp_params) cascade;
		drop function if exists definition_temp_inter(int) cascade;
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

		create function definition_temp_inter(in target_temp int) returns interp_params as  (
			$fn$
				(select max(tc.temperature) from temp_cor tc where tc.temperature <= target_temp) as x0,

				(select tc.correction from temp_cor tc where tc.temperature = (select max(tc2.temperature) from temp_cor tc2
				                           where tc2.temperature <= target_temp)) as y0,

				(select min(tc.temperature) from temp_cor tc where tc.temperature >= target_temp) as x1,

				(select tc.correction from temp_cor tc where tc.temperature = (select min(tc2.temperature) from temp_cor tc2
				                           where tc2.temperature >= target_temp)) as y1 
		$fn$ language 'sql';

	end;
	commit;

	begin

		create function calculation_temp (in temperature numeric, in ip interp_params) returns numeric as (
		select case
			when ip.x1 = ip.x0 then ip.y0

			else ip.y0 + (ip.y1 - ip.y0) * (temperature - ip.x0) / (ip.x1 - ip.x0)
		end;
		) language 'sql';

	end;
	commit;

end $$;
