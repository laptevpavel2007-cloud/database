with agg as (
    select
        p.id as 'N',
        p.started as 'Дата измерения',
		public.fn_calc_header_period(p.started) as 'Высота метеопоста',
		fn_calc_header_temperature(p.par_temperature) as 'Температура',
		meteorological_forecast as 'ДДЧЧММ ВВВВ БББТТ'
		from 
    left join measurment_input_params ms on ms.measurment_bath_id = p.id
    group by p.id, p.eq_id)