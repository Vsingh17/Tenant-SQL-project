Create database tenant;
use tenant;
 create table TENANT_HISTORY
 (
 ID int identity not null, profile_id int not null, house_id int not null, move_in_date date not null,move_out_date date null,rent int not null,bedtype varchar(255) null, move_out_reason varchar(255) null
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
Profile_id int identity not null, first_name varchar (255) null, last_name varchar(255) null, email varchar(255) not null, phone varchar (255) not null,
city_hometown varchar(255) null,pancard varchar(255) null, Created_at date not null, Gender varchar(255) not null, Referral_code varchar (255) null, Marital_status varchar (255) null
);

alter table profiles
add constraint pk_profiles
primary key (Profile_id);

create table houses   
(
house_id int identity not null constraint pk_houses primary key (house_id), house_type varchar(255) null, bhk_details varchar(255) null, bed_count int not null,furnishing_type varchar(255) null,
beds_vacant int not null);

ALTER TABLE TENANT_HISTORY ADD CONSTRAINT fkhouse_id FOREIGN KEY (house_id) REFERENCES houses (house_id);  




create table addresses
(
ad_id int identity not null constraint pk_addresses primary key (ad_id), name varchar (255) null, description text null, pincode int null,city varchar(255) null,
house_id int not null
);
alter table addresses
add constraint fk_house_id 
foreign key (house_id) references houses (house_id)

   create table Referrals
 (
 ref_id int identity not null constraint pk_Referrals primary key (ref_id), referrer_id_same_as_profile_id  int not null, referrer_bonus_amount float null,referral_valid tinyint
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


commands:
select * from employment_details;
















