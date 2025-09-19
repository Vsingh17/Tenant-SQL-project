# Tenant-SQL-project
“I created a tenant database in SQL for a real estate system to manage tenant details. I designed normalized tables, set up relationships using primary and foreign keys, and implemented constraints to ensure data integrity. I generated insights like occupancy rates, price trends . This helped in improving property management decisions.

[PROJECT SQL - Copy.sql](https://github.com/user-attachments/files/22433207/PROJECT.SQL.-.Copy.sql)
Create database tenant;
use tenant;
 create table TENANT_HISTORY
 (
 ID int identity not null, profile_id int not null,
 house_id int not null, move_in_date date not null,move_out_date date null,
 rent int not null,bedtype varchar(255) null, move_out_reason varchar(255) null
 );

 alter table 
 tenancyhistories
 add constraint pk_TENANT_HISTORY
primary key (id);
 alter table TENANT_HISTORY
 add constraint fk_profile_id
foreign key (profile_id) references profiles
 (Profile_id)


create table profiles
(
Profile_id int identity not null, first_name varchar (255) null,
last_name varchar(255) null, email varchar(255) not null, phone varchar (255) not null,
city_hometown varchar(255) null,pancard varchar(255) null,
Created_at date not null, Gender varchar(255) not null, Referral_code 
varchar (255) null, Marital_status varchar (255) null
);

alter table profiles
add constraint pk_profiles
primary key (Profile_id);

create table houses   
(
house_id int identity not null constraint pk_houses 
primary key (house_id),
house_type varchar(255) null, bhk_details varchar(255) null,
bed_count int
not null,furnishing_type varchar(255) null,
beds_vacant int not null);

ALTER TABLE TENANT_HISTORY ADD CONSTRAINT fkhouse_id 
FOREIGN KEY (house_id) REFERENCES houses (house_id);  




create table addresses
(
ad_id int identity not null constraint pk_addresses primary key (ad_id),
name varchar (255) null, description text null, pincode int null,
city varchar(255) null,
house_id int not null
);
alter table addresses
add constraint fk_house_id 
foreign key (house_id) references 
houses (house_id)

   create table Referrals
 (
 ref_id int identity not null constraint pk_Referrals
 primary key (ref_id),
 referrer_id_same_as_profile_id  int not null, 
 referrer_bonus_amount float null,referral_valid 
 tinyint
 null,valid_from date null, valid_till date null);

 alter table Referrals
add constraint fk_referrer_id_same_as_profile_id
foreign key (referrer_id_same_as_profile_id) references profiles (profile_id)


  Create table employment_details
 (
 id int identity not null constraint pk_employment_details  primary key (id), profile_id int not null, latest_employer varchar (255) null, 
 official_mail_id varchar(255) null, yrs_experience int null, Occupational_category varchar (255) null
 );
alter table employment_details
add constraint fk_profileid
foreign key (profile_id) references profiles (profile_id)


select* from [Tenancy History];
/* QUES 1 Write a query to get Profile ID, Full Name and Contact Number of the tenant who has stayed 
 with us for the longest time period in the past*/

SELECT Profile_id,fullname,phone from
(
select TOP 1 pr.Profile_id,pr.first_name+' '+pr.last_name as fullname,pr.phone as phone,
case 
when th.move_out_date is null then DATEDIFF(DAY,th.move_in_date,GETDATE())
else 
DATEDIFF(DAY,th.move_in_date,th.move_out_date)
end as  stay_duration
from dbo.profiles as pr
inner join dbo.[Tenancy History] as th
ON th.Profile_id=pr.Profile_id
order by stay_duration desc) as x


 






 /* QUES 2_Write a query to get the Full name, email id, phone of tenants who are married and paying 
 rent > 9000 using subqueries


*/


SELECT distinct Profile_id,first_name+' '+last_name as fullname,phone as phone
from dbo.profiles where [Profile_id] IN 
((
select pr.[Profile_id]
from [dbo].[profiles] as pr
where pr.Marital_status='Y' )
union (select [profile_id]
from [dbo].[Tenancy History]
where [rent]>'9000'
));



/* QUES 3_ Write a query to display profile id, full name, phone, email id, city , house id, move_in_date , 
move_out date, rent, total number of referrals made, latest employer and the occupational 
category of all the tenants living in Bangalore or Pune in the time period of jan 2015 to jan 
3 2016 sorted by their rent in descending order


*/
select 
profiles.Profile_id
,profiles.first_name+' '+profiles.last_name as fullname
,profiles.phone,profiles.email,profiles.[city_hometown],[Tenancy History].house_id
,[Tenancy History].move_in_date
,[Tenancy History].move_out_date,[Tenancy History].rent 
,dbo.[employment_details].[latest_employer],[dbo].[employment_details].[Occupational_category]
,count(profiles.Referral_code) as referral_count
from [dbo].[profiles] 
inner join [dbo].[Referral]
on [dbo].[profiles].Profile_id=[dbo].[Referral].Profile_id
inner join [dbo].[Tenancy History]
on [dbo].[profiles].Profile_id=[dbo].[Tenancy History].[profile_id]
inner join [dbo].[employment_details]
ON [dbo].[employment_details].[profile_id]=[dbo].[profiles].Profile_id
where Lower([dbo].[profiles].[city_hometown]) IN ('bangalore','pune')
AND [move_in_date] BETWEEN '2015-01-01' AND '2016-01-03'
group by profiles.Profile_id,profiles.first_name+' '+profiles.last_name,profiles.phone,
profiles.email,profiles.[city_hometown]
,profiles.phone,profiles.email,profiles.[city_hometown],[Tenancy History].house_id
,[Tenancy History].move_in_date
,[Tenancy History].move_out_date,[Tenancy History].rent 
,dbo.[employment_details].[latest_employer],[dbo].[employment_details].[Occupational_category]
;





/* QUES 4 _Write a sql snippet to find the full_name, email_id, phone number and referral code of all 
the tenants who have referred more than once. 
 Also find the total bonus amount they should receive given that the bonus gets calculated 
only for valid referrals.*/


select 
profiles.Profile_id
,profiles.first_name+' '+profiles.last_name as fullname
,profiles.phone,profiles.email
,profiles.phone,profiles.Referral_code
from [dbo].[profiles] 
inner join [dbo].[Referral]
on [dbo].[profiles].Profile_id=[dbo].[Referral].Profile_id
group by profiles.Profile_id
,profiles.first_name+' '+profiles.last_name
,profiles.phone,profiles.email
,profiles.phone,profiles.Referral_code
having count(profiles.Referral_code)>1;

SELECT a.*,SUM([dbo].[Referral].referrer_bonus_amount) as bonus_amount FROM 
(select 
profiles.Profile_id
,profiles.first_name+' '+profiles.last_name as fullname
,profiles.phone,profiles.email
,profiles.Referral_code
from [dbo].[profiles] 
inner join [dbo].[Referral]
on [dbo].[profiles].Profile_id=[dbo].[Referral].Profile_id
group by profiles.Profile_id
,profiles.first_name+' '+profiles.last_name
,profiles.phone,profiles.email
,profiles.phone,profiles.Referral_code
having count(profiles.Referral_code)>1) as a
LEFT JOIN [dbo].[Referral] 
ON a.Profile_id=[dbo].[Referral].Profile_id
where [dbo].[Referral].referral_valid=1
group by a.Profile_id,a.fullname,a.phone,a.email,a.Referral_code

;

/* QUEST 5 Write a query to find the rent generated from each city and also the total of all cities.
*/

select DISTINCT 
[dbo].[profiles].city_hometown,

SUM([dbo].[Tenancy History].[rent])

FROM [dbo].[Tenancy History]
Inner join [dbo].[profiles]
on [dbo].[profiles].Profile_id=
[dbo].[Tenancy History].Profile_id 

Group by city_hometown;





select 

SUM([dbo].[Tenancy History].[rent]) as total_sum

FROM [dbo].[Tenancy History]
Inner join [dbo].[profiles]
on [dbo].[profiles].Profile_id=
[dbo].[Tenancy History].Profile_id 



/*Quest 6_Create a view 'vw_tenant' find 
profile_id,rent,move_in_date,house_type,beds_vacant,description and city of tenants who 
 shifted on/after 30th april 2015 and are living in houses having vacant beds and its address.*/


CREATE VIEW [VW_TENANT]
AS
select  pr.Profile_id,tena.rent,
tena.move_in_date,ho.house_type,ho.beds_vacant,
addr.description,pr.city_hometown from profiles as pr
inner join [dbo].[Tenancy History] as tena
on tena.profile_id=pr.Profile_id
inner join [dbo].[houses] as ho on ho.house_id
=tena.house_id
inner join [dbo].[addresses] as addr on addr.house_id=tena.house_id
where beds_vacant>=1 and move_in_date>='04-30-2015';


/*Ques 7_.Write a code to extend the valid_till date for a month of
tenants who have referred more
than two times*/

SELECT *,DATEADD(month,1,valid_till) as extended_date FROM 
[dbo].[Referral] WHERE  [referral_valid]  IN(
select  DISTINCT [referral_valid]
from [dbo].[Referral]
group by  [referral_valid]
having count([referral_valid])>2);

/* Ques 8_Write a query to get Profile ID, Full Name , Contact Number of the tenants along with a new 
column 'Customer Segment' wherein if the tenant pays rent greater than 10000, tenant falls 
- in Grade A segment, if rent is between 7500 to 10000, tenant falls in Grade B else in Grade C*/

--if or case staement


 SELECT dbo.profiles.Profile_id,[first_name]+ ' '+[last_name] as fullname,[phone]
as contact_number,
case 
when dbo.[Tenancy History].[rent]>10000 THEN 'Grade A'
  WHEN dbo.[Tenancy History].[rent] BETWEEN 7500 AND 10000 THEN 'Grade B'
else 
'Grade C'
end as  customer_segment
from dbo.profiles 
inner join dbo.[Tenancy History] 
ON [dbo].[profiles].[Profile_id]=[dbo].[Tenancy History].[profile_id];




/*QUES9_Write a query to get Fullname, Contact, City and House Details of the tenants who have not 
referred even once*/

select 
pr.first_name+' '+pr.last_name as fullname
,pr.phone,pr.email,ho.bed_count,house_type,ho.bed_count,ho.bhk_details,ho.furnishing_type,
ho.beds_vacant
,pr.city_hometown as city
--add house details column
,pr.Referral_code
from [dbo].[profiles] as pr
join [Tenancy History] as ten on pr.Profile_id=ten.profile_id
join [dbo].[houses] as ho on ho.house_id=ten.house_id
WHERE pr.Profile_id NOT IN (SELECT distinct Profile_id
from [dbo].[Referral])

/* QUES 10_Write a query to get the house details of the house having highest occupancy*/

SELECT * FROM dbo.houses
where (bed_count-beds_vacant) IN (SELECT MAX((bed_count-beds_vacant) ) FROM  dbo.houses);



 



