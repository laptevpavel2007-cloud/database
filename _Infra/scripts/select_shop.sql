
-- Поставщики
select
    isnull(v.firstname, 'Поставщик ' + cast(v.id as varchar)) as vendorname,
    count(distinct so.documentid) as total_docs,
    sum(try_cast(so.amount as decimal(18,2))) as total_amount
from [dbo].[bm_storageoperations] so
join [dbo].[vendors] v on so.vendorid = v.id
where so.operationid = 1
group by v.id, v.firstname
order by total_amount desc;


-- Товары
select
    p.description as product_name,
    sum(try_cast(jd.quantity as decimal(18,2))) as total_sold,
    sum(try_cast(jd.sbrutto as decimal(18,2))) as total_revenue
from [dbo].[bm_journal_details] jd
join [dbo].[product] p on jd.productid = p.id
group by p.description
order by total_revenue desc;


-- Взаимоотношение с поставщиками
select 
    isnull(vg.description, 'Без группы') as group_name,
    count(distinct v.id) as vendors_count,
    sum(try_cast(so.amount as decimal(18,2))) as total_amount
from [dbo].[vendors] v
left join [dbo].[vendorgroup] vg on v.clientgroup = vg.vendorgroupid
left join [dbo].[bm_storageoperations] so on v.id = so.vendorid and so.operationid = 1
group by vg.description
order by total_amount desc;

-- Анализ работы персонала
select
    p.lastname + ' ' + p.firstname as employee_name,
    count(j.id) as receipts_count,
    sum(try_cast(j.amount as decimal(18,2))) as total_revenue
from [dbo].[personnel] p
join [dbo].[journal] j on p.personid = j.loginid
group by p.lastname, p.firstname
order by total_revenue desc;


-- Остатки товаров
select top 20
    p.description as product_name,
    try_cast(p.onhand as decimal(18,2)) as current_stock,
    try_cast(sp.quantityclose as decimal(18,2)) as last_period_stock,
    sp.datefinish as last_period_date
from [dbo].[product] p
left join [dbo].[stockperiod] sp on p.id = sp.productid
order by current_stock desc;