class Donations{
    var donor_id:int
    var blood_type:string
    var location:string
    var donation_date:int
    var useby_date:int
    var abn:bool
    var amount:int
    var added:bool


    predicate Valid()
    reads this
    {
        useby_date - donation_date == 42
        && donor_id >=0 
        && validBloodType(blood_type)
        && validBloodAmount(amount)
    }    

    predicate validBloodType(str: string)
    {
        str == "A+" ||
        str == "A-" ||
        str == "B+" ||
        str == "B-" ||
        str == "O+" ||
        str == "O-" ||
        str == "AB+" ||
        str == "AB-"
    }

    predicate validBloodAmount(amount: int)
    {
        amount >= 450 && amount <= 550
    }

    constructor(donorid:int, bloodtype:string, location_of_donation:string, blood_amount:int, date_of_donation:int)
    // modifies this
    ensures Valid()
    requires donorid>=0
    requires blood_amount >= 450 && blood_amount <= 550
    requires bloodtype == "A+" ||
        bloodtype == "A-" ||
        bloodtype == "B+" ||
        bloodtype == "B-" ||
        bloodtype == "O+" ||
        bloodtype == "O-" ||
        bloodtype == "AB+" ||
        bloodtype == "AB-"    
    {
        donor_id := donorid;
        blood_type := bloodtype;
        location := location_of_donation;
        donation_date := date_of_donation;
        useby_date := date_of_donation + 42;
        abn := false;
        amount := blood_amount;
        added := false;
    }

    method Accept_donation(id: int, b_type:string, abnormal:bool, amount:int)
    modifies this
    requires Valid()
    ensures Valid()
    {

    }
}

method Main(){
    var donorid:int, btype:string, location:string, amount:int, date:int;
    donorid := 1;
    btype := "A+";
    location := "123 Fake St";
    amount := 500;
    date := 10;
    var d1 := new Donations(donorid, btype, location, amount, date);

    // invalid id
    donorid := -1;
    // var d2 := new Donations(donorid, btype, location, amount, date);


    // invalid type
    donorid := 1;
    btype := "P+";
    // var d2 := new Donations(donorid, btype, location, amount, date);

    // invalid amount
    btype := "A+";
    amount := 50;
    // var d2 := new Donations(donorid, btype, location, amount, date);

}
