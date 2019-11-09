-- Notes:
-- blood_amount is in LITRES
-- reserve_amount is in LITRES

create table donors (
    name string,
    dob Date,
    contact_info string,
    blood_type string,
    date_last_donated Date,
    donor_id integer primary key autoincrement
);


create table donor_samples (
    sample_id integer primary key autoincrement,
    donor_id integer,
    blood_type string,
    location_of_donation string,
    use_by_date Date,
    abnormalities boolean,
    blood_amount integer,
    foreign key (donor_id) references donors(donor_id),
    foreign key (blood_type) references donors(blood_type)
);


create table blood_bank (
    blood_type string,
    blood_amount integer, 
    primary key (blood_type)
);


create table requests (
    blood_type string,
    quantity_needed integer,
    date_of_request Date,
    req_id integer primary key autoincrement,
    med_facility_id integer,
    foreign key (med_facility_id) references medical_facilities(med_facility_id),
    foreign key (blood_type) references blood_bank(blood_type)
);


create table medical_facilities (
    med_facility_name string,
    med_facility_id integer primary key autoincrement,
    validated boolean
);