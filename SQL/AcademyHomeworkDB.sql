create database AcademyHomeworkDB;

use AcademyHomeworkDB;

create table Students
(
	student_id int identity(1, 1) primary key,
	full_name nvarchar(100) not null,
	email varchar(150) unique,
	phone varchar(20),
	city nvarchar(100),
	created_at datetime default getdate()
);

insert into students (full_name, email, phone, city)
values
('Ahmed Mohamed', 'ahmed.mohamed@example.com', '01012345678', N'Cairo'),
('Sara Ali', 'sara.ali@example.com', '01123456789', N'Alexandria'),
('Omar Hassan', 'omar.hassan@example.com', '01234567890', N'Giza'),
('Mona Ibrahim', 'mona.ibrahim@example.com', '01545678901', N'Mansoura'),
('Youssef Adel', 'youssef.adel@example.com', '01056789012', N'Fayoum'),
('Nour Hany', 'nour.hany@example.com', '01167890123', N'Tanta'),
('Khaled Mostafa', 'khaled.mostafa@example.com', '01278901234', N'Aswan'),
('Fatma Gamal', 'fatma.gamal@example.com', '01589012345', N'Luxor'),
('Mahmoud Samir', 'mahmoud.samir@example.com', '01090123456', N'Zagazig'),
('Aya Tarek', 'aya.tarek@example.com', '01101234567', N'Ismailia');


create table Courses
(
	course_id int identity(1, 1) primary key,
	course_name nvarchar(100) not null,
	price decimal(10, 2) not null,
	duration_hrs int,
	is_active bit default 1
);

insert into courses (course_name, price, duration_hrs)
values
(N'SQL Server', 1500.00, 40),
(N'Python Programming', 2000.00, 60),
(N'C++ Fundamentals', 1800.00, 50),
(N'Web Development', 2500.00, 70),
(N'Machine Learning', 3500.00, 80);

create table Enrollments
(
	enrollment_id int identity(1, 1) primary key,
	student_id int not null,
	course_id int not null,
	enrolled_at datetime default getdate(),
	status varchar(50) default 'Active',

	constraint fk_Enrollments_Students
		foreign key(student_id)
		references Students(student_id),

	constraint fk_Enrollments_Courses
		foreign key(course_id)
		references Courses(course_id)
);

insert into enrollments (student_id, course_id)
values
(1, 1),
(1, 3),
(2, 2),
(3, 5),
(4, 1),
(5, 4);

create table Payments
(
	payment_id int identity(1, 1) primary key,
	enrollment_id int not null,
	amount decimal(10, 2),
	payment_date date default getdate(),
	method varchar(50),
	status varchar(50) default 'Pending',

	constraint fk_Payments_Enrollments
		foreign key(enrollment_id)
		references Enrollments(enrollment_id)
);

insert into payments (enrollment_id, amount, method)
values
(1, 1500.00, 'Cash'),
(2, 2000.00, 'Credit Card'),
(3, 1800.00, 'Vodafone Cash'),
(4, 3500.00, 'Bank Transfer'),
(5, 1500.00, 'Cash'),
(6, 2500.00, 'Instapay');

alter table Students add nationality nvarchar(50);