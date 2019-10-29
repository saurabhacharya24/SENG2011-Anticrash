-- Notes:
-- blood_amount is in LITRES
-- reserve_amount is in LITRES

create table donors (
    name string,
    dob Date,
    contact_info string,
    blood_type string,
    date_last_donated Date,
    donor_id integer auto_increment,
    primary key (donor_id)
);


create table donor_samples (
    sample_id integer auto_increment,
    donor_id integer,
    blood_type string,
    location_of_donation string,
    use_by_date Date,
    abnormalities boolean,
    primary key (sample_id),
    foreign key (donor_id) references donors(donor_id),
    foreign key (blood_type) references donors(blood_type)
);


create table blood_bank (
    blood_type string,
    blood_amount integer, 
    reserve_amount integer,
    threshold_crossed_warning boolean,
    primary key (blood_type)
);


create table requests (
    blood_type string,
    quantity_needed integer,
    date_of_request Date,
    req_id integer auto_increment,
    med_facility_id integer,
    primary key (req_id),
    foreign key (med_facility_id) references medical_facilities(med_facility_id),
    foreign key (blood_type) references blood_bank(blood_type)
);


create table medical_facilities (
    med_facility_name string,
    med_facility_id integer auto increment,
    validated boolean,
    primary key (med_facility_id)
);