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
    modifies this
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

    method Accept_donation(id: int, b_type:string, amount:int) returns (added: bool, retAbn: bool)
    modifies this
    requires Valid()
    ensures Valid()
    ensures validBloodAmount(amount) && validBloodType(b_type) ==> added == true
    ensures !validBloodAmount(amount) && !validBloodType(b_type) ==> added == false
    {
        var test: int;
        var hasAbn := testBlood(test);
        
        if amount >= 450 && amount <=550 {
            added := true;
            retAbn := hasAbn;
        } 
        else {
            added := false;
            retAbn := hasAbn;
        }
    }

    method testBlood(randomNum: int) returns (b: bool)
    modifies this`abn
    requires Valid()
    ensures Valid()
    ensures 95>randomNum>=100 ==> abn == b == true
    ensures 0<=randomNum<=95 ==> abn == b ==false
    {
        if randomNum>95 && randomNum<=100 {
            abn := true;
            b := true;
        }
        else {
            abn := false;
            b := false;
        }
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

    btype := "A+";
    amount := 501;
    var d3 := new Donations(donorid, btype, "A", amount, 20);

    var hasAdded, abn := d3.Accept_donation(donorid, btype, amount);

    assert hasAdded;

}
