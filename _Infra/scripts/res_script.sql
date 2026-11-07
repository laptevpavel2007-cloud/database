delete from packs;
insert into packs (id, user_id, eq_id, meas_at, appr) values 
	(1, 1, 1, NOW(), false);

delete from pack_values;
insert into pack_values (pack_id, par_id, value) values
	(1, 1, 181.00), 
	(1, 2, 23.00), 
	(1, 3, 760.00), 
	(1, 4, 20.00), 
	(1, 5, 6.00); 



begin;

-- call calculations(2, 'дмк', 'my_cursor');  
-- fetch all from my_cursor;
-- commit;

call calculations(1, 'дмк', 'my_cursor');  
fetch all from my_cursor;
commit;
