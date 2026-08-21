create database academydb_2;
go

use academydb_2;
go

create table leads
(
    lead_id int identity(1,1) primary key,
    full_name nvarchar(100) not null,
    email varchar(100) unique,
    phone varchar(20),
    city nvarchar(100),
    source varchar(50),
    created_at date
);

insert into leads
(
    full_name,
    email,
    phone,
    city,
    source,
    created_at
)
values
(
    'anas emad',
    'anas@gmail.com',
    '01011111111',
    'cairo',
    'facebook',
    '2026-06-05'
),
(
    'ali ahmed',
    'ali@gmail.com',
    '01122222222',
    'giza',
    'google',
    '2026-06-12'
),
(
    'mohamed saad',
    'mohamed@gmail.com',
    '01233333333',
    'cairo',
    'facebook',
    '2026-06-18'
),
(
    'sara adel',
    'sara@gmail.com',
    '01544444444',
    'alexandria',
    'instagram',
    '2026-05-20'
),
(
    'nour hassan',
    'nour@gmail.com',
    '01055555555',
    null,
    'facebook',
    '2026-06-25'
);

select * from leads;

select * from leads where city = 'cairo';

select * from leads where city in ('cairo', 'giza');

select * from leads where source = 'facebook' and created_at >= '2026-06-01';


create table payments
(
    payment_id int identity(1,1) primary key,
    lead_id int,
    amount decimal(10,2),
    payment_date date,

    foreign key (lead_id)
    references leads(lead_id)
);


insert into payments
(
    lead_id,
    amount,
    payment_date
)
values
(1, 2500, '2026-06-10'),
(2, 3000, null),
(3, 2000, '2026-06-18'),
(4, 1500, '2026-05-25'),
(5, 2800, null);


create table attendance
(
    attendance_id int identity(1,1) primary key,
    lead_id int,
    attendance_date date,

    foreign key (lead_id)
    references leads(lead_id)
);


insert into attendance
(
    lead_id,
    attendance_date
)
values
(1, '2026-06-01'),
(2, '2026-06-03'),
(3, '2026-06-05'),
(4, '2026-06-10'),
(5, '2026-06-07');


select * from payments where payment_date is null;

select * from leads where full_name like '%mohamed%';

select * from payments order by payment_date desc;

select * from attendance where attendance_date between '2026-06-01' and '2026-06-07';

alter table leads add campaign_id int, is_enrolled bit;

update leads
set campaign_id = 101, is_enrolled = 1
where lead_id = 1;

update leads
set campaign_id = 101, is_enrolled = 0
where lead_id = 2;

update leads
set campaign_id = 102, is_enrolled = 1
where lead_id = 3;

update leads
set campaign_id = 102, is_enrolled = 1
where lead_id = 4;

update leads
set campaign_id = 103, is_enrolled = 0
where lead_id = 5;

alter table payments
add status varchar(30);

update payments
set status = 'paid'
where payment_id in (1,3,4);

update payments
set status = 'pending'
where payment_id in (2,5);

create table enrollments
(
    enrollment_id int identity(1,1) primary key,
    lead_id int,
    sales_agent_id int,

    foreign key (lead_id)
    references leads(lead_id)
);

insert into enrollments
(
    lead_id,
    sales_agent_id
)
values
(1,101),
(2,102),
(3,101),
(4,103),
(5,101);



select count(*) as total_leads from leads;

select source, count(*) as lead_count from leads group by source order by lead_count desc;

select campaign_id, count(*) as lead_count from leads group by campaign_id order by lead_count desc;

select status, sum(amount) as total_revenue from payments group by status;

select status, avg(amount) as avg_payment from payments group by status;

select campaign_id, count(*) as lead_count from leads group by campaign_id having count(*) > 50 order by lead_count desc;

select campaign_id, sum(case when is_enrolled = 1 then 1 else 0 end) * 1.0 / count(*) as conversion_rate from leads group by campaign_id;

select sales_agent_id, 
    count(*) as enrollment_count from enrollments 
    group by sales_agent_id having 
    count(*) = (select max(enrollment_count) from (select count(*) as enrollment_count from enrollments 
    group by sales_agent_id) as t);





select s.student_name, e.enrollment_date from students s
inner join enrollments e on s.student_id = e.student_id;

select c.course_name, e.enrollment_date from enrollments e 
inner join courses c on e.course_id = c.course_id;

select s.student_name, p.amount, p.payment_date from students s
left join payments p on s.student_id = p.student_id;

select s.student_name, p.amount, p.payment_date from students s
left join enrollments e on s.student_id = e.student_id
left join payments p on e.enrollment_id = p.enrollment_id;

select s.student_name from students s
left join enrollments e on s.student_id = e.student_id
left join payments p on e.enrollment_id = p.enrollment_id
where p.payment_id is null;

select l.lead_name from leads l
left join enrollments e on l.lead_id = e.lead_id 
where e.enrollment_id is null;

select c.course_name, count(e.enrollment_id) as count from courses c
left join enrollments e on c.course_id = e.course_id
group by c.course_name order by count desc 

select c.course_name, sum(p.amount) as total_revenue from payments p
inner join enrollments e on p.enrollment_id = e.enrollment_id
inner join courses c on e.course_id = c.course_id
group by c.course_name;

select sa.agent_name, count(e.enrollment_id) as converted_students from salesagents sa
left join leads l on sa.agent_id = l.agent_id
left join enrollments e on l.lead_id = e.lead_id
group by sa.agent_name;