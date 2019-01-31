--check total number of themes/sets/parts--
select count(*) from themes;
select count(*) from sets;
select count(*) from parts;

--For themes--
--1. find themes with most num of sets--
select themes.theme_id, themes.theme_name, count(*)as no_of_sets from themes join sets on themes.theme_id=sets.theme_id
group by themes.theme_id, themes.theme_name
order by no_of_sets desc;
--2. check what sets are contained in each theme--
select themes.theme_id, themes.theme_name, set_id, set_name, extract(year from sets.year)as year
from themes join sets on themes.theme_id=sets.theme_id
order by themes.theme_id, year;
--3. find themes with longest history--
select themes.theme_id, themes.theme_name, 2018-min(extract(year from sets.year))as exist_year
from themes join sets on themes.theme_id=sets.theme_id
group by themes.theme_id, themes.theme_name
order by exist_year desc;

--Sets--
--1. find sets with longest history--
select set_id, set_name, extract(year from sets.year) as year
from sets
order by year asc;
--2. find sets with most types of parts--
select sets.set_id, sets.set_name, count(part_id) as types_of_part
from sets join setpart on sets.set_id=setpart.set_id
group by sets.set_id, sets.set_name
order by types_of_part desc;
--3. find sets with most num of parts--
select sets.set_id, sets.set_name, sum(quantity) as no_of_part
from sets join setpart on sets.set_id=setpart.set_id
group by sets.set_id, sets.set_name
order by no_of_part desc;
--4. check if top 5 in Q2 also top 5 in Q3--
with 
t1 as (select sets.set_id, sets.set_name, count(part_id) as types_of_part
from sets join setpart on sets.set_id=setpart.set_id
group by sets.set_id, sets.set_name
order by types_of_part desc
fetch first 5 rows only),
t2 as (select sets.set_id, sets.set_name, sum(quantity) as no_of_part
from sets join setpart on sets.set_id=setpart.set_id
group by sets.set_id, sets.set_name
order by no_of_part desc
fetch first 5 rows only)
select t1. set_id, t1.set_name, types_of_part, no_of_part
from t1 inner join t2 on t1.set_id=t2.set_id
order by types_of_part desc;
--5. find what colors are cotained in each set--
select distinct sets.set_id, sets.set_name, colors.color_name
from sets, setpart, parts, colors
where sets.set_id=setpart.set_id and setpart.part_id=parts.part_id and colors.color_id=parts.color_id
order by sets.set_id;

--Parts--
--1. find the part category with most parts--
select partcat.part_cat_id, part_cat_name, count(part_id) as no_of_part
from parts join partcat on parts.part_cat_id=partcat.part_cat_id
group by partcat.part_cat_id, part_cat_name
order by no_of_part desc;
--2. find how many colors are cotained in each part category--
select partcat.part_cat_id, part_cat_name, count(unique(color_id)) as no_of_color
from partcat, parts
where partcat.part_cat_id=parts.part_cat_id
group by partcat.part_cat_id, part_cat_name
order by no_of_color desc;
--3. find the sets in which this type of part is used most--
with t3 as
(select sets.set_id, set_name, max(quantity) as maxnum
from setpart, sets
where setpart.set_id=sets.set_id
group by sets.set_id, set_name)
select parts.part_id, parts.part_name, t3.set_id, t3.set_name
from parts, setpart, sets, t3
where parts.part_id=setpart.part_id and sets.set_id=setpart.set_id and sets.set_id=t3.set_id
and quantity=t3.maxnum
order by parts.part_id asc;
--4. find the sets that contain most this part--
with t4 as
(select part_id, max(quantity) as maxnum
from setpart
group by part_id)
select parts.part_id, parts.part_name, sets.set_name
from parts, setpart, sets, t4
where parts.part_id=setpart.part_id and sets.set_id=setpart.set_id and parts.part_id=t4.part_id
and quantity=t4.maxnum
order by parts.part_id asc;