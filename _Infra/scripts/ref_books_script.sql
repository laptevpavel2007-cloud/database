do $$
begin

    begin
	
        drop table if exists temp_deviation cascade;
        drop table if exists dmk_wind cascade;
        drop table if exists vr_wind cascade;
        drop table if exists stand_height cascade;
        
        drop sequence if exists temp_deviation_id_seq cascade;
        drop sequence if exists stand_height_id_seq cascade;
		
    end;
    
    begin 
	
        create table stand_height (
            id int,
            meas int not null unique,
            code text not null
        );
		
        create sequence stand_height_id_seq start 1;
        alter table stand_height alter column id set default nextval('stand_height_id_seq');
        comment on table stand_height is 'Константы высоты';
				
        alter table stand_height add constraint pk_stand_height primary key (id);
		
        insert into stand_height (meas, code) values
            (200, '02'), (400, '04'), (800, '08'), (1200, '12'),
            (1600, '16'), (2000, '20'), (2400, '24'), (3000, '30'), (4000, '40');
			
    end;

    begin 
	
        create table temp_deviation (
		    id int,
            eq_id int not null,
            height_meas int not null,
            component_magnitude int not null,
            numerator int,
            denominator int
        );
        
        create sequence temp_deviation_id_seq start 1;
        alter table temp_deviation alter column id set default nextval('temp_deviation_id_seq');
        comment on table temp_deviation is 'Отклонение температуры';

        alter table temp_deviation add constraint pk_temp_deviation primary key (id);
        
        alter table temp_deviation add constraint fk_temp_dev_height 
        foreign key (height_meas) references stand_height(meas);
            

        insert into temp_deviation(eq_id, height_meas, component_magnitude, numerator, denominator) values
            (1, 200, 1, -1, 1), (1, 200, 2, -2, 2), (1, 200, 3, -3, 3), (1, 200, 4, -4, 4),
            (1, 200, 5, -5, 5), (1, 200, 6, -6, 6), (1, 200, 7, -7, 7), (1, 200, 8, -8, 8),
            (1, 200, 9, -8, 9), (1, 200, 10, -9, 10), (1, 200, 20, -20, 20), (1, 200, 30, -29, 30),
            (1, 200, 40, -39, null), (1, 200, 50, -49, null), 
            (1, 4000, 1, -1, 1), (1, 4000, 2, -2, 2), (1, 4000, 3, -2, 3), (1, 4000, 4, -3, 4),
            (1, 4000, 5, -4, 5), (1, 4000, 6, -4, 6), (1, 4000, 7, -4, 7), (1, 4000, 8, -4, 8),
            (1, 4000, 9, -5, 9), (1, 4000, 10, -6, 10), (1, 4000, 20, -14, 20), (1, 4000, 30, -20, 30),
            (1, 4000, 40, -27, null), (1, 4000, 50, -34, null);
			
    end;


    begin
	
        create table dmk_wind (
            height_meas int not null,
            v0 int not null,
            speed_w int not null,
            direction int not null
        );
        comment on table dmk_wind is 'Таблица ветра для ДМК';

        alter table dmk_wind add constraint pk_dmk_wind primary key (height_meas, v0);
        
        alter table dmk_wind add constraint fk_dmk_wind_height 
        foreign key (height_meas) references stand_height(meas);


        insert into dmk_wind (height_meas, v0, speed_w, direction) values
            (200, 3, 4, 1), (200, 4, 6, 1), (200, 5, 8, 1), (200, 6, 9, 1), (200, 7, 10, 1),
            (200, 8, 12, 1), (200, 9, 14, 1), (200, 10, 15, 1), (200, 11, 16, 1), (200, 12, 18, 1),
            (200, 13, 20, 1), (200, 14, 21, 1), (200, 15, 22, 1),
            (4000, 3, 6, 5), (4000, 4, 10, 5), (4000, 5, 12, 5), (4000, 6, 14, 5), (4000, 7, 16, 5),
            (4000, 8, 19, 5), (4000, 9, 22, 5), (4000, 10, 24, 5), (4000, 11, 26, 5), (4000, 12, 29, 5),
            (4000, 13, 32, 5), (4000, 14, 34, 5), (4000, 15, 36, 5);
			
    end;

    begin
	
        create table vr_wind (
            height_meas int not null,
            drift int not null,
            speed_w int not null,
            direction int not null
        );
        comment on table vr_wind is 'Таблица ветра для ВР';

        alter table vr_wind add constraint pk_vr_wind primary key (height_meas, drift);
        
        alter table vr_wind add constraint fk_vr_wind_height 
        foreign key (height_meas) references stand_height(meas);


        insert into vr_wind (height_meas, drift, speed_w, direction) values
            (200, 40, 3, 0), (200, 50, 4, 0), (200, 60, 5, 0), (200, 70, 6, 0), (200, 80, 7, 0),
            (200, 90, 7, 0), (200, 100, 8, 0), (200, 110, 9, 0), (200, 120, 10, 0), (200, 130, 11, 0),
            (200, 140, 12, 0), (200, 150, 12, 0),
            (4000, 40, 5, 4), (4000, 50, 6, 4), (4000, 60, 8, 4), (4000, 70, 9, 4), (4000, 80, 10, 4),
            (4000, 90, 11, 4), (4000, 100, 12, 4), (4000, 110, 14, 4), (4000, 120, 16, 4), (4000, 130, 18, 4),
            (4000, 140, 19, 4), (4000, 150, 20, 4);
			
    end;
    
end $$;