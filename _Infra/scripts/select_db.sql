select "Наименование", "Тип"
from (
    select
        table_name as "Наименование",
        case table_type
            when 'BASE TABLE' then 'Таблица'
            when 'VIEW' then 'Представление'
            when 'FOREIGN' then 'Внешняя таблица'
        end as "Тип"
    from information_schema.tables
    where table_schema = 'public'

    union all

    select sequence_name, 'Счётчик'
    from information_schema.sequences
    where sequence_schema = 'public'
)