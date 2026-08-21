create database AcademyDB;
use AcademyDB;
-------------------------------------------------------------------
create table dbo.Students
(
    student_id int identity(1,1) primary key,
    full_name nvarchar(100) not null,
    email varchar(150) unique not null,
    enrollment_date date default getdate(),
    city nvarchar(100) null
);


insert into dbo.Students
(full_name,email,city)
values
(N'Mahmoud Ashrey','mahmoud@gmail.com',N'Fayoum'),
(N'Ahmed Ali','ahmed@gmail.com',N'Cairo'),
(N'Sara Mohamed','sara@gmail.com',N'Alexandria'),
(N'Omar Hassan','omar@gmail.com',N'Giza'),
(N'Mona Adel','mona@gmail.com',N'Mansoura'),
(N'Ali Mohamed','ali@gmail.com',N'Cairo'),
(N'Nada Hassan','nada@gmail.com',N'Giza'),
(N'Youssef Ali','youssef@gmail.com',NULL),
(N'Mariam Ahmed','mariam@gmail.com',N'Luxor'),
(N'Karim Mohamed','karim@gmail.com',N'Aswan');

-------------------------------------------------------------------

create table dbo.Courses
(
    course_id int identity(1,1) primary key,
    course_name nvarchar(150) not null,
    price decimal(10,2) not null,
    duration_hrs int,
    instructor nvarchar(100),
    is_active bit default 1
);

insert into dbo.Courses
(course_name,price,duration_hrs,instructor)
values
(N'SQL Server Basics',1500,30,N'Ahmed Hassan'),
(N'Python for Beginners',2000,40,N'Mohamed Ali'),
(N'Machine Learning',3500,60,N'Sara Mahmoud'),
(N'Web Development',2500,50,N'Omar Khaled'),
(N'Data Analysis with Python',3000,45,N'Mona Adel'),
(N'Power BI',2200,35,N'Ahmed Mostafa'),
(N'Cloud Computing',4000,55,N'Yasser Ali');

-------------------------------------------------------------------

create table dbo.Campaigns
(
    campaign_id int identity(1,1) primary key,
    campaign_name nvarchar(150) not null,
    channel nvarchar(100),
    budget decimal(12,2),
    start_date date
);


insert into dbo.Campaigns
(campaign_name,channel,budget,start_date)
values
(N'Summer Offer',N'Facebook',10000,'2026-06-01'),
(N'Back To School',N'Instagram',15000,'2026-07-01'),
(N'AI Bootcamp',N'LinkedIn',20000,'2026-08-01'),
(N'Winter Discount',N'Google Ads',12000,'2026-11-15'),
(N'New Year Campaign',N'YouTube',18000,'2026-12-20');

-------------------------------------------------------------------

create table dbo.SalesAgents
(
    agent_id int identity(1,1) primary key,
    agent_name nvarchar(100) not null,
    email varchar(150) unique,
    region nvarchar(100),
    is_active bit default 1
);

insert into dbo.SalesAgents
(agent_name,email,region)
values
(N'Ahmed Hassan','agent1@gmail.com',N'Cairo'),
(N'Mohamed Ali','agent2@gmail.com',N'Alexandria'),
(N'Sara Mahmoud','agent3@gmail.com',N'Fayoum'),
(N'Omar Khaled','agent4@gmail.com',N'Giza'),
(N'Mona Adel','agent5@gmail.com',N'Mansoura');

-------------------------------------------------------------------

create table dbo.Leads
(
    lead_id int identity(1,1) primary key,

    campaign_id int not null,
    agent_id int not null,

    lead_name nvarchar(100) not null,
    phone varchar(20),

    city nvarchar(100),

    source varchar(100),

    status varchar(30),

    created_at datetime default getdate(),

    is_enrolled bit default 0,

    constraint fk_campaign
        foreign key(campaign_id)
        references Campaigns(campaign_id),

    constraint fk_agent
        foreign key(agent_id)
        references SalesAgents(agent_id)
);

insert into dbo.Leads
(campaign_id,agent_id,lead_name,phone,city,source,status,created_at,is_enrolled)
values
(1,1,N'Khaled Ahmed','01011111111',N'Cairo','Facebook','New','2026-07-02',1),
(1,1,N'Ahmed Mohamed','01012121212',N'Cairo','Facebook','Interested','2026-07-10',1),
(1,2,N'Mostafa Ali','01098989898',N'Giza','Facebook','Lost','2026-07-12',0),
(2,2,N'Mariam Ali','01022222222',N'Giza','Instagram','Contacted','2026-07-08',1),
(2,3,N'Ahmed Mostafa','01066666666',N'Cairo','Instagram','Interested','2026-07-20',0),
(3,3,N'Youssef Mohamed','01033333333',N'Alexandria','LinkedIn','Interested','2026-08-03',1),
(3,3,N'Salma Hassan','01044444444',N'Alexandria','LinkedIn','Converted','2026-08-05',1),
(4,4,N'Omar Ibrahim','01077777777',N'Giza','Google','Lost','2026-11-16',0),
(5,5,N'Ahmed Adel','01055555555',N'Fayoum','YouTube','Converted','2026-12-22',1),
(5,5,N'Mahmoud Samy','01088888888',N'Cairo','YouTube','New','2026-12-25',0);

-------------------------------------------------------------------

create table dbo.Enrollments
(
    enrollment_id int identity(1,1) primary key,

    student_id int not null,

    course_id int not null,

    lead_id int null,

    enrolled_at datetime default getdate(),

    status varchar(20) default 'Active',

    constraint fk_students
        foreign key(student_id)
        references Students(student_id),

    constraint fk_courses
        foreign key(course_id)
        references Courses(course_id),

    constraint fk_leads
        foreign key(lead_id)
        references Leads(lead_id)
);

insert into dbo.Enrollments
(student_id,course_id,lead_id)
values
(1,1,1),
(1,3,2),
(2,2,4),
(3,1,6),
(4,4,7),
(5,5,9),
(6,6,null),
(7,2,null);

-------------------------------------------------------------------

create table dbo.Payments
(
    payment_id int identity(1,1) primary key,

    enrollment_id int not null,

    amount decimal(10,2) not null,

    payment_date date null,

    method varchar(30),

    status varchar(20),

    constraint fk_payments_enrollments
        foreign key(enrollment_id)
        references Enrollments(enrollment_id)
);

insert into dbo.Payments
(enrollment_id,amount,payment_date,method,status)
values
(1,1500,'2026-07-01','Cash','Paid'),
(2,3500,'2026-07-02','Visa','Paid'),
(3,2000,null,'Cash','Pending'),
(4,1500,'2026-07-04','Vodafone Cash','Paid'),
(5,2500,'2026-07-05','Visa','Paid'),
(6,3000,'2026-07-06','Cash','Pending');

-------------------------------------------------------------------

create table dbo.Attendance
(
    attendance_id int identity(1,1) primary key,

    enrollment_id int not null,

    session_date date not null,

    is_present bit default 1,

    constraint fk_attendance_enrollments
        foreign key(enrollment_id)
        references Enrollments(enrollment_id)
);

insert into dbo.Attendance
(enrollment_id,session_date,is_present)
values
(1,'2026-06-02',1),
(2,'2026-06-05',1),
(3,'2026-06-10',0),
(4,'2026-06-14',1),
(5,'2026-07-10',1),
(6,'2026-07-15',0),
(7,'2026-06-12',1),
(8,'2026-06-08',1);
-------------------------------------------------------------------
-- ===========================================
-- Session 2
-- ===========================================

-- Task 1
alter table Students
add nationality nvarchar(50);

-- Task 2
alter table Students
drop column nationality;

-- Task 3
drop table if exists OldLeads;

-- Task 4
update Students
set city='Giza'
where student_id=1;

-- Task 5
select *
from Leads;

-- Task 6
select top 10 *
from Leads
order by created_at desc;

-- Task 7
select distinct source
from Leads;

-- Task 8
select *
from Students
order by enrollment_date;

-------------------------------------------------------------------

-- ===========================================
-- Session 3
-- ===========================================

-- Task 1
select *
from Leads
where city='Cairo';

-- Task 2
select *
from Leads
where city in ('Cairo','Giza');

-- Task 3
select *
from Leads
where source='Facebook'
and created_at>='2026-07-01'
and created_at<'2026-08-01';

-- Task 4
select *
from Students
where city is null;

-- Task 5
select *
from Payments
where payment_date is null;

-- Task 6
select *
from Students
where full_name like '%Mohamed%';

-- Task 7
select *
from Payments
order by payment_date desc;

-- Task 8
select *
from Attendance
where session_date between '2026-06-01' and '2026-06-15';

-------------------------------------------------------------------

-- ===========================================
-- Session 4
-- ===========================================

-- Task 1
select
count(*) as total_leads
from Leads;

-- Task 2
select
source,
count(*) as total_leads
from Leads
group by source
order by total_leads desc;

-- Task 3
select
campaign_id,
count(*) as total_leads
from Leads
group by campaign_id
order by total_leads desc;

-- Task 4
select
status,
sum(amount) as total_amount
from Payments
group by status;

-- Task 5
select
status,
avg(amount) as avg_amount
from Payments
group by status;

-- Task 6
select
campaign_id,
count(*) as total_campaigns
from Leads
group by campaign_id
having count(*) > 1;

-- Task 7
select
campaign_id,
sum(case
        when is_enrolled=1 then 1
        else 0
    end)*1.0/count(*) as conversion_rate
from Leads
group by campaign_id;

-- Task 8
select top 1
agent_id,
count(*) as total_leads
from Leads
group by agent_id
order by total_leads desc;

-------------------------------------------------------------------

-- ===========================================
-- Session 5
-- ===========================================

-- Task 1
select
s.full_name,
s.enrollment_date
from Students s
inner join Enrollments e
on s.student_id=e.student_id;

-- Task 2
select
c.course_name,
e.enrolled_at
from Enrollments e
inner join Courses c
on e.course_id=c.course_id;

-- Task 3
select
s.full_name,
p.amount,
p.payment_date
from Students s
left join Enrollments e
on s.student_id=e.student_id
left join Payments p
on e.enrollment_id=p.enrollment_id;

-- Task 4
select
s.full_name
from Students s
left join Enrollments e
on s.student_id=e.student_id
left join Payments p
on e.enrollment_id=p.enrollment_id
where p.payment_id is null;

-- Task 5
select
l.*
from Leads l
left join Enrollments e
on l.lead_id=e.lead_id
where e.enrollment_id is null;

-- Task 6
select
c.course_name,
count(e.enrollment_id) as total_enrollments
from Courses c
left join Enrollments e
on c.course_id=e.course_id
group by c.course_name
order by total_enrollments desc;

-- Task 7
select
c.course_name,
sum(p.amount) as total_revenue
from Courses c
join Enrollments e
on c.course_id=e.course_id
join Payments p
on e.enrollment_id=p.enrollment_id
group by c.course_name
order by total_revenue desc;

-- Task 8
select
sa.agent_name,
count(e.enrollment_id) as converted_students
from SalesAgents sa
left join Leads l
on sa.agent_id=l.agent_id
left join Enrollments e
on l.lead_id=e.lead_id
group by sa.agent_name
order by converted_students desc;

