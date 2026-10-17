do $$
declare
	v_ip interp_params;
begin

	v_ip := row(20, 1.5, 25, 2)::interp_params;
	raise notice 'calculation_temp(23) = % (ожидалось 1.80)', calculation_temp(23, v_ip);

	v_ip := row(25, 2, 30, 3.5)::interp_params;
	raise notice 'calculation_temp(25) = % (ожидалось 2.00)', calculation_temp(25, v_ip);
end $$;
commit;
