create table colors(
color_id integer primary key,
color_name varchar(100),
color_rgb varchar(26),
color_is_trans varchar(26));

create table partcat(
part_cat_id integer primary key,
part_cat_name varchar(1000));

create table themes(
theme_id integer primary key,
theme_name varchar(100),
theme_parent_id integer);

create table parts(
part_id varchar(26) primary key,
part_name varchar(1000),
part_cat_id integer,
color_id integer,
constraint FK1 foreign key (part_cat_id) references partcat (part_cat_id),
constraint FK2 foreign key (color_id) references colors (color_id));

create table sets(
set_id varchar(26) primary key,
set_name varchar(128),
year timestamp(6),
theme_id integer,
constraint FK3 foreign key (theme_id) references themes(theme_id));

create table setpart(
set_id varchar(100),
part_id varchar(26),
quantity integer,
constraint PK1 primary key (set_id, part_id),
constraint FK4 foreign key (set_id) references sets(set_id),
constraint FK5 foreign key (part_id) references parts(part_id));