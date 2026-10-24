do $$
begin

	begin

		drop table if exists const cascade;
		drop function if exists const_value(p_id int) cascade;

	end;
	commit;

	begin

		create table const (
			id int,
			name text,
			mean numeric(5, 2)
		);
		create sequence if not exists const_id_seq start 1;
	    alter table const alter column id set default nextval('const_id_seq');
	   	comment on table const is 'Константы';

		insert into const(id, name, mean) values
		    (1, 'наземное давление', 750.00),
		    (2, 'приземная виртуальная температура', 15.90),
		    (3, 'кодирование отрицательных значений температуры', 50.00);
		   
	end;
	commit;

	begin
		create function const_value(p_id int) returns numeric
		stable
		as $fn$
		begin
		
		    select mean from const where id = p_id;
		end;
		$fn$ language 'plpgsql';
	comment on function const_value(p_id int) is 'Функция для получения значения константы';
		
	end;
	commit;

end $$;