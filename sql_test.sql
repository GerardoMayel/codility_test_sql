--SQL

create database codity_test;

use codity_test;

create table test_groups (

    name varchar(40) NOT NULL,
    test_value integer NOT NULL,
    UNIQUE(name)

);

create table test_cases (

    id integer NOT NULL,
    group_name varchar(40) NOT NULL,
    status varchar(5) NOT NULL,
    UNIQUE(id)

);

insert into test_groups values ('performance', 15);
insert into test_groups values ('corner cases', 10);
insert into test_groups values ('numerical stability', 20);
insert into test_groups values ('memory usage', 10);
insert into test_cases values (13, 'memory usage', 'OK');
insert into test_cases values (14, 'numerical stability', 'OK');
insert into test_cases values (15, 'memory usage', 'ERROR');
insert into test_cases values (16, 'numerical stability', 'OK');
insert into test_cases values (17, 'numerical stability', 'OK');
insert into test_cases values (18, 'performance', 'ERROR');
insert into test_cases values (19, 'performance', 'ERROR');
insert into test_cases values (20, 'memory usage', 'OK');
insert into test_cases values (21, 'numerical stability', 'OK');


create table all_test_cases
select group_name, count(*) as all_test_cases
from test_cases
group by group_name;

create table passed_test_cases
select group_name, count(*) as passed_test_cases
from test_cases
where status = 'OK'
group by group_name;


create table pre_final
select a.name, a.test_value, b.all_test_cases
from test_groups as a
left join all_test_cases as b
on a.name = b.group_name;

create table final_1
select a.name, a.test_value, a.all_test_cases, b.passed_test_cases
from pre_final as a
left join passed_test_cases as b
on a.name = b.group_name;

create table final_2
select name, test_value, all_test_cases, passed_test_cases, (test_value*passed_test_cases) as total_value
from final_1
order by total_value desc, name;

create table final_summary
select name, coalesce(all_test_cases,0) as all_test_cases, coalesce(passed_test_cases,0) as passed_test_cases, coalesce(total_value,0) as total_value
from final_2;

select * from final_summary;
