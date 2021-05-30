create user 'bamtri'@'%' identified by 'Bamtri625';

create database if not exists prod_mes default character set utf8mb4 collate utf8mb4_general_ci;
create database if not exists test_mes default character set utf8mb4 collate utf8mb4_general_ci;
create database if not exists dev_mes  default character set utf8mb4 collate utf8mb4_general_ci;

grant all privileges on `prod_%`.* to 'bamtri'@'%';
grant all privileges on `test_%`.* to 'bamtri'@'%';
grant all privileges on `dev_%`.*  to 'bamtri'@'%';

flush privileges;

show grants for bamtri;
