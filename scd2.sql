CREATE TABLE bronze (
  id SERIAL PRIMARY KEY,
  key int,
  name VARCHAR(100),
  status VARCHAR(255),
  extract_day date
);

INSERT INTO bronze(key, name, status, extract_day) VALUES (1, 'Jon', 'Active', '2025-08-01');
INSERT INTO bronze(key, name, status, extract_day) VALUES (1, 'John', 'Active', '2025-08-05');
INSERT INTO bronze(key, name, status, extract_day) VALUES (1, 'Jon', 'Active', '2025-08-07');
INSERT INTO bronze(key, name, status, extract_day) VALUES (1, null, 'Deleted', '2025-08-10');
INSERT INTO bronze(key, name, status, extract_day) VALUES (1, 'Jon', 'Active', '2025-08-15');
INSERT INTO bronze(key, name, status, extract_day) VALUES (2, 'Bjarne', 'Active', '2025-08-10');

select * from bronze;

with base as (
    select
        key,
        name,
        status,
        extract_day as valid_from,
        coalesce(
            lead(extract_day) over (partition by key order by extract_day asc),
            '9999-12-31'
        ) as valid_to,
        case 
            when lead(status) over (partition by key order by extract_day asc) is null
            then 1
            else 0
        end as is_valid
    from bronze
)
select 
    key, 
    name, 
    valid_from, 
    valid_to, 
    is_valid
from base
where status = 'Active';
