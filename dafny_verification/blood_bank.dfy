class BloodBank {
    var blood:map<string, int>
    var threshold:map<string, int>;
    var critical:map<string, bool>;

    predicate Valid()
    reads this
    { 
        forall i :: i in blood ==> blood[i] >= 0
        &&
        forall i :: containsType(i) ==> if blood[i] < threshold[i] then critical[i] == true else critical[i] == false
     }

    predicate containsType(btype:string)
    reads this
    {
        btype in blood && btype in threshold && btype in critical
    }

    predicate isCritical(btype:string)
    reads this
    {
        btype in critical && critical[btype]
    }


    constructor ()
    // modifies this;
    ensures Valid()
    {
        blood := map["A+" := 0,  "A-":=0,
                     "B+" := 0,  "B-":=0,
                     "O+" := 0,  "O-":=0,
                     "AB+" := 0, "AB-":=0
                    ];
        threshold := map["A+" := 400000,  "A-":=200000,
                     "B+" := 300000,  "B-":=100000,
                     "O+" := 400000,  "O-":=200000,
                     "AB+" := 100000, "AB-":=100000
                    ];
        critical := map["A+" := true,  "A-":=true,
                     "B+" := true,  "B-":=true,
                     "O+" := true,  "O-":=true,
                     "AB+" := true, "AB-":=true
                    ];
    }

    method addBlood(key:string, quantity:int)
    modifies this;
    requires Valid()
    requires containsType(key)
    requires quantity > 0
    ensures Valid()
    ensures key in blood ==> blood[key] == old(blood[key]) + quantity
    ensures containsType(key) && blood[key] >= threshold[key] ==> !isCritical(key)
    ensures containsType(key) && blood[key] < threshold[key] ==> isCritical(key)
    {
        var amount:int := blood[key];
        var newAmount:int := amount + quantity;
        blood := blood[key := newAmount];

        if newAmount >= threshold[key]{
            critical := critical[key := false];
        } else {
            critical := critical[key := true];
        }
    }



    method discardBlood(key:string, quantity:int)
    modifies this
    requires Valid()
    requires containsType(key)
    requires quantity > 0 && blood[key] - quantity > 0
    ensures Valid()
    ensures containsType(key) && blood[key] > 0
    ensures key in blood ==> blood[key] == old(blood[key]) - quantity
    ensures forall i :: containsType(i) && old(containsType(i)) && i != key ==> blood[i] == old(blood[i])
                                                                         && critical[i] == old(critical[i])
                                                                         && threshold[i] == old(threshold[i])
    ensures containsType(key) && blood[key] >= threshold[key] ==> !isCritical(key)
    ensures containsType(key) && blood[key] < threshold[key] ==> isCritical(key)
    {
        var amount:int := blood[key];
        var newAmount:int := amount - quantity;
        blood := blood[key := newAmount];

        if blood[key] >= threshold[key]{
            critical := critical[key := false];
        } else {
            critical := critical[key := true];
        }
    }


    // method checkCritical()
    // modifies this
    // requires forall i :: i in blood ==> blood[i] >= 0
    // // requires forall i :: containsType(i) ==> if blood[i] < threshold[i] then critical[i] == true else critical[i] == false
    // ensures Valid()
    // // ensures forall i :: i in blood ==> blood[i] >= 0
    // // ensures forall i :: containsType(i) ==> if blood[i] < threshold[i] then critical[i] == true else critical[i] == false

    // {
    //     var key :| containsType(key);
    //     if blood[key] >= threshold[key] {
    //         critical := critical[key := false];
    //     } else {
    //         critical := critical[key := true];
    //     }
    // }


    method checkFreshness(today:int, sample_id:int, btype:string, use_by:int, abn:bool, b_amount:int, added:bool) 
    modifies this
    requires use_by > 0 && today > 0
    requires Valid()
    ensures Valid()
    requires containsType(btype) && b_amount > 0
    {
        var expired:bool := is_expired(use_by, today);

        if !expired && !abn{
            if !added {
                addBlood(btype, b_amount);
            } else if blood[btype] - b_amount > 0 {
                discardBlood(btype, b_amount);
            }
        }
    }

    method testBloodBank()
    {
        var b := new BloodBank();
        var blood_type:string := "A+";
        var retval:bool;
        // retval := b.isCritical(blood_type);
        b.addBlood(blood_type, 1000000);
    }

}


method is_expired(expiry:int, today:int) returns (expired:bool)
requires expiry > 0 && today > 0
ensures expiry > today ==> expired == false
ensures expiry <= today ==> expired == true
{
    if (expiry > today){
        expired := false;
    } else {
        expired := true;
    }

}



