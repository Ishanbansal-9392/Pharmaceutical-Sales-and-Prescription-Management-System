set sql_safe_updates = 0;

create database pharma;
use pharma;
create table Medicines(
Medicine_id varchar(50) primary key,
Medicine_name varchar(50),
Category varchar(50),
Price_per_unit float,
Stock_quantity int,
expiry_date date);
create table doctors(
Doctor_id varchar(50) primary key,
Name varchar(50),
Specialization varchar(50),
Hospital_name varchar(100));
create table Patients(
Patient_id varchar(50) primary key,
Name varchar(50),
Gender varchar(50),
Dob date,
city varchar(50));
create table prescription(
Prescription_id varchar(50) primary key,
Doctor_id varchar(50),
patient_id varchar(50),
prescription_date date,
diagnosis varchar(100),
constraint fk_did foreign key (doctor_id) references doctors(doctor_id),
constraint fk_pid foreign key (patient_id) references patients(patient_id));
create table prescription_details(
Prescription_detail_id varchar(50) primary key,
prescription_id varchar(50),
medicine_id varchar(50),
Dosage varchar(50),
diagnosis varchar(50),
constraint fk_prid foreign key (prescription_id) references prescription(prescription_id),
constraint fk_mid foreign key (medicine_id) references medicines(medicine_id));
Create table sales(
Sale_id varchar(50) primary key,
patient_id varchar(50),
medicine_id varchar(50),
Quantity int,
Sale_date date,
Payment_method varchar(50),
constraint fk_paid foreign key (patient_id) references patients(patient_id),
constraint fk_meid foreign key (medicine_id) references medicines(medicine_id));
create table suppliers(
supplier_id varchar(50) primary key,
Supplier_name varchar(50),
contact_number bigint,
location varchar(50));
create table restock_alerts(
alert_id varchar(50) primary key,
medicine_id varchar(50),
Alert_date date,
note varchar(100),
constraint fk_medid foreign key (medicine_id) references medicines(medicine_id));
create table deleted_prescriptions(
Prescription_id varchar(50),
doctor_id varchar(50),
patient_id varchar(50),
prescription_date date,
deletion_time varchar(50),
constraint fk_presid foreign key (prescription_id) references prescription_details(prescription_id),
constraint fk_docid foreign key (doctor_id) references doctors(doctor_id),
constraint fk_patid foreign key (patient_id) references patients(patient_id));
create table expired_medicine_log(
log_id varchar(50) primary key,
medicine_id varchar(50),
expired_on varchar(50),
logged_on varchar(50),
constraint fk_mediid foreign key (medicine_id) references medicines(medicine_id));

insert into medicines values
("M001","Paracetamol","Analgesic",1.5,200,"2026-03-05"),
("M002","Amoxicillin","Antibiotic",3.2,150,"2025-12-01"),
("M003","Cetirizine","Antihistamine",2,80,"2024-11-30"),
("M004","Metformin","Antidiabetic",5,50,"2027-05-20"),
("M005","Ibuprofen","Analgesic",1.75,0,"2024-08-01");
insert into doctors values
("D101","Dr. Anjali Verma","General","City care hospital"),
("D102","Dr. Rakesh Nair","Pediatrics","Rainbow clinic"),
("D103","Dr. Kavita Shah","ENT","Health first hospital");
insert  into patients values
("P001","Rohit Mehra","Male","1985-06-15","Delhi"),
("P002","Neha Sharma","Female","1992-09-21","Mumbai"),
("P003","Suresh Iyer","Male","1978-12-03","Bengaluru");
insert into prescription values
("PR001","D101","P001","2024-10-12","Fever"),
("PR002","D102","P002","2024-11-5","Cold"),
("PR003","D101","P003","2025-01-18","Diabeties");
insert into prescription_details values
("PD001","PR001","M001","2 tablets/day","5"),
("PD002","PR002","M003","1 tablet/day","3"),
("PD003","PR003","M004","1 tablet/day","30");
insert into sales values
("S001","P001","M001",10,"2024-10-12","Cash"),
("S002","P002","M003",5,"2024-11-05","Card"),
("S003","P003","M004",30,"2025-01-18","UPI");
insert into Suppliers values
("S001","Medico Distributors",9876543210,"Mumbai"),
("S002","Healthplus Pharma",9123456780,"Delhi"),
("S003","Lifecare Suppliers",9988776655,"Bengaluru"),
("S004","Apollo Wholesalers",9001122334,"Chennai"),
("S005","Zenith Pharma Corp",8866442200,"Hydreabad");

select * from medicines;
select * from doctors;
select * from patients;
Select * from prescription;
Select * from prescription_details;
Select * from sales;
select * from suppliers;

Describe medicines;
Describe doctors;
Describe patients;
Describe prescription;
Describe prescription_details;
Describe sales;
Describe suppliers;
Describe restock_alerts;
Describe deleted_prescriptions;
Describe Expired_medicine_log;

#Tasks
#1- List medicines that are below minimum stock level (e.g., stock_quantity < 10).
select medicine_id,Medicine_name,Stock_quantity
from medicines
where stock_quantity<10;

#2- Identify medicines that have expired as of today
Select medicine_id,medicine_name,expiry_date
from medicines
where expiry_date < "2025-05-15";

#3- Reterive the top 3 most sold medicines by total quantity
select m.medicine_name,s.quantity
from medicines m 
join (select medicine_id, quantity from sales order by quantity desc limit 3) s 
on m.medicine_id=s.medicine_id;

#4- Calculate total revenue generated per medicine
Select m.medicine_name,m.medicine_id,sum(price_per_unit*quantity)as total_revenue
from sales s
join medicines m
on s.medicine_id=m.medicine_id
group by m.medicine_id,m.medicine_name;

#5- Find the number of distinct patients each doctor has treated.
select d.Doctor_id,d.name,count(p.patient_id)
from doctors d
join prescription p
on d.doctor_id=p.doctor_id
group by d.doctor_id,d.name;

#6-	Show daily sales totals for the last 30 days.
select s.sale_date,m.medicine_id,m.medicine_name,sum(m.price_per_unit*s.quantity)
from sales s
join medicines m
on m.medicine_id=s.medicine_id
where sale_date >"2025-05-15"-interval 30 day
group by s.sale_date,m.medicine_id
order by s.sale_date desc;

#7-	Identify medicines that have never been sold but were prescribed.
Select medicine_name
from medicines
where medicine_id not in (Select medicine_id from sales);

#8-	Retrieve the number of prescriptions issued by each doctor in the last 6 months.
select d.doctor_id,d.name,count(p.prescription_id)
from doctors d
join prescription p
on d.doctor_id=p.doctor_id
group by d.doctor_id,d.name;

#9-	Find medicines that are sold but never prescribed.
Select medicine_name
from medicines
where medicine_id in (Select medicine_id from sales);

#10- List prescriptions that contain more than 3 different medicines.
Select prescription_id,count(medicine_id) as medicine_count
from prescription_details
group by prescription_id having count(medicine_id)>3;

#11- Find patients who have purchased medicines from more than one city.
select s.patient_id
from sales s
join patients p
on s.patient_id=p.patient_id
group by p.patient_id
having count(distinct city)>1;

#12- List suppliers supplying medicines that are currently out of stock.
Select Supplier_id,supplier_name 
from suppliers;

#13- Find the most commonly prescribed medicine for each diagnosis.
select diagnosis,medicine_id,count(*) as prescription_count
from prescription_details
group by diagnosis, medicine_id;

#14- Show total quantity of each medicine sold in each city.
select m.medicine_name,p.city,sum(s.quantity) as total_quantity_sold
from sales s
join patients p
on s.patient_id=p.patient_id
join medicines m
on s.medicine_id=m.medicine_id
group by m.medicine_name, p.city
order by m.medicine_name, p.city;

#15- Identify doctors who have never prescribed any medicine.
Select d.doctor_id,d.name
from doctors d
left join prescription p
on d.doctor_id=p.doctor_id
where p.prescription_id is null;

#16- Get a list of medicines that are both prescribed and sold on the same day to the same patient.
select s.patient_id,s.medicine_id,m.medicine_name, s.sale_date
from sales s
join prescription p
on s.patient_id=p.patient_id and s.sale_date=p.prescription_date
join prescription_details pd on p.prescription_id=pd.prescription_id and s.medicine_id=pd.medicine_id
join medicines m on s.medicine_id=m.medicine_id 
order by s.patient_id, s.sale_date;

#17- Identify patients who purchased a medicine more than 15 days after it was prescribed.
select s.patient_id, m.medicine_name, p.prescription_date,s.sale_date,DATEDIFF(s.sale_date, p.prescription_date) as days_after_prescription
from sales s
join prescription p
on s.patient_id=p.patient_id
join prescription_details pd
on p.prescription_id=pd.prescription_id and s.medicine_id=pd.medicine_id
join medicines m
on s.medicine_id=m.medicine_id
where DATEDIFF(s.sale_date, p.prescription_date)>15
order by s.patient_id, s.sale_date;

#18- Find doctors who prescribed the most medicines overall.
select d.doctor_id, d.name as doctor_name,count(pd.medicine_id) as total_medicines_prescribed
from doctors d
join prescription p
on d.doctor_id=p.doctor_id
join prescription_details pd
on p.prescription_id=pd.prescription_id
group by d.doctor_id, d.name
order by total_medicines_prescribed desc;

#19- Identify patients who purchased a medicine not prescribed to them.
select s.patient_id, s.medicine_id, m.medicine_name, s.sale_date
from sales s
join medicines m 
on s.medicine_id = m.medicine_id
where not exists(
        select 1
        from prescription p
        join prescription_details pd 
        on p.prescription_id = pd.prescription_id
        where p.patient_id = s.patient_id and pd.medicine_id = s.medicine_id);

#20- Create a trigger that reduces stock_quantity from the Medicines table after each insertion into the Sales table.
DELIMITER $$
create trigger reduce_stock_after_sale
after insert on sales
for each row
begin
    update medicines
    set stock_quantity = stock_quantity - new.quantity
    where medicine_id = new.medicine_id;
end$$
DELIMITER ;

#21- Write a trigger to update a last_prescribed_date column in the Medicines table whenever that medicine is added to a new prescription.
alter table  medicines
add column last_prescribed_date date;
DELIMITER $$
create trigger update_last_prescribed_date
after insert on prescription_details
for each row
begin
    declare presc_date date;
    select prescription_date into presc_date
    from prescription
    where prescription_id = new.prescription_id;
    update medicines
    set last_prescribed_date = presc_date
    where medicine_id = new.medicine_id;
end$$
DELIMITER ;

#22- Create a trigger to send a restock alert (insert into Restock_Alerts table) when stock_quantity falls below 10.
DELIMITER $$
create trigger trigger_restock_alert
after update on medicines
for each row
begin
    if new.stock_quantity<10 and old.stock_quantity>=10 then
        insert into restock_alerts(
            alert_id,
            medicine_id,
            alert_date,
            note)
        values(
            concat('A',UUID()),
            new.medicine_id,
            curdate(),
            'Stock below 10 units');
    end if;
end$$
DELIMITER ;

#23- Write a stored procedure to add a new prescription, including the doctor, patient, and multiple medicines.
DELIMITER $$
create procedure AddPrescription(
    in in_prescription_id varchar(50),
    in in_doctor_id varchar(50),
    in in_patient_id varchar(50),
    in in_prescription_date date,
    in in_diagnosis varchar(100),
    in in_medicine_ids text,
    in in_dosages text,
    in in_diag_per_med text)
begin
    declare i int default 1;
    declare total int;
    declare med_id varchar(50);
    declare dose varchar(50);
    declare med_diag varchar(50);
    declare med_detail_id varchar(50);
    insert into prescription (prescription_id, doctor_id, patient_id, prescription_date, diagnosis)
    values (in_prescription_id, in_doctor_id, in_patient_id, in_prescription_date, in_diagnosis);
    set total = length(in_medicine_ids) - length(replace(in_medicine_ids, ',', '')) + 1;
    while i<=total do
        set med_id = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(in_medicine_ids, ',', i), ',', -1));
        set dose = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(in_dosages, ',', i), ',', -1));
        set med_diag = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(in_diag_per_med, ',', i), ',', -1));
        set med_detail_id = CONCAT('PD', in_prescription_id, '_', i);
        insert into prescription_details(
            prescription_detail_id,
            prescription_id,
            medicine_id,
            dosage,
            diagnosis)
		values(
            med_detail_id,
            in_prescription_id,
            med_id,
            dose,
            med_diag);
        set i = i + 1;
    end while;
end$$
DELIMITER ;

#24- Create a procedure to generate a bill for a patient by calculating the total amount for all medicines purchased on a specific date.
DELIMITER $$
create procedure GeneratePatientBill(
    in in_patient_id varchar(50),
    in in_sale_date date)
begin
    select s.medicine_id,
        m.medicine_name,
        s.quantity,
        m.price_per_unit,
        (s.quantity * m.price_per_unit) as line_total
    from sales s
    join medicines m 
    on s.medicine_id = m.medicine_id
    where s.patient_id = in_patient_id and s.sale_date = in_sale_date;
    select sum(s.quantity * m.price_per_unit) as total_amount
    from sales s
    join medicines m 
    on s.medicine_id = m.medicine_id
    where s.patient_id = in_patient_id and s.sale_date = in_sale_date;
end$$
DELIMITER ;

#25- Write a stored procedure that takes a doctor’s ID and returns the list of all patients they’ve treated, with total prescriptions.
DELIMITER $$
create procedure GetDoctorPatientSummary(
    in in_doctor_id varchar(50))
begin
    select p.patient_id,
        pt.name as patient_name,
        pt.city,
        count(pr.prescription_id) as total_prescriptions
    from prescription pr
    join patients pt 
    on pr.patient_id = pt.patient_id
    where pr.doctor_id = in_doctor_id
    group by p.patient_id, pt.name, pt.city;
end$$
DELIMITER ;

#26- Create a stored procedure to expire medicines: move all expired medicines from Medicines to Expired_Stock table.
create table expired_stock(
    medicine_id varchar(50) primary key,
    medicine_name varchar(50),
    category varchar(50),
    price_per_unit float,
    stock_quantity int,
    expiry_date date,
    expired_on date);
DELIMITER $$
create procedure ExpireMedicines()
begin
    insert into Expired_Stock(
        Medicine_id,
        Medicine_name,
        Category,
        Price_per_unit,
        Stock_quantity,
        Expiry_date,
        Expired_on)
    select Medicine_id,
        Medicine_name,
        Category,
        Price_per_unit,
        Stock_quantity,
        Expiry_date,
        CURDATE()
    from Medicines
    where Expiry_date < CURDATE();
    delete from Medicines
    where Expiry_date < CURDATE();
end$$
DELIMITER ;
ALTER TABLE medicines ADD COLUMN is_expired BOOLEAN DEFAULT 0;
UPDATE medicines
SET is_expired = 1
WHERE expiry_date < CURDATE();

#27- Write a procedure that returns the sales summary (total quantity, total revenue) for a given date range and medicine category.
DELIMITER $$
create procedure Get_Sales_Summary_By_Category(
    in in_start_date date,
    in in_end_date date,
    in in_category varchar(50))
begin
    select m.category,
        m.medicine_name,
        sum(s.quantity) as total_quantity_sold,
        sum(s.quantity * m.price_per_unit) as total_revenue
    from sales s
    join medicines m 
    on s.medicine_id = m.medicine_id
    where s.sale_date between in_start_date and in_end_date and m.category = in_category
    group by m.medicine_id, m.medicine_name, m.category
    order by total_revenue desc;
end$$
DELIMITER ;