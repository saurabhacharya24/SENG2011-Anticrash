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
        btype in blood && btype in threshold && btype in critical &&
        "A+" in blood && "A+" in threshold && "A+" in critical &&
        "A-" in blood && "A-" in threshold && "A-" in critical &&
        "B+" in blood && "B+" in threshold && "B+" in critical &&
        "B-" in blood && "B-" in threshold && "B-" in critical &&
        "O+" in blood && "O+" in threshold && "O+" in critical &&
        "O-" in blood && "O-" in threshold && "O-" in critical &&
        "AB+" in blood && "AB+" in threshold && "AB+" in critical &&
        "AB-" in blood && "AB-" in threshold && "AB-" in critical
    }

    predicate isCritical(btype:string)
    reads this
    {
        btype in critical && critical[btype]
    }


    constructor ()
    // modifies this;
    ensures Valid()
    ensures "A+" in blood && "A+" in threshold && "A+" in critical
    ensures "A-" in blood && "A-" in threshold && "A-" in critical
    ensures "B+" in blood && "B+" in threshold && "B+" in critical
    ensures "B-" in blood && "B-" in threshold && "B-" in critical
    ensures "O+" in blood && "O+" in threshold && "O+" in critical
    ensures "O-" in blood && "O-" in threshold && "O-" in critical
    ensures "AB+" in blood && "AB+" in threshold && "AB+" in critical
    ensures "AB-" in blood && "AB-" in threshold && "AB-" in critical
    ensures forall i :: containsType(i) ==> blood[i] == 0 && critical[i] == true
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
    ensures containsType(key) && blood[key] == old(blood[key]) + quantity
    ensures containsType(key) && blood[key] >= threshold[key] ==> !isCritical(key)
    ensures containsType(key) && blood[key] < threshold[key] ==> isCritical(key)
    ensures containsType(key)
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
    // requires Valid()
    // requires forall i :: i in blood ==> blood[i] >= 0
    // requires forall i :: containsType(i) ==> if blood[i] < threshold[i] then critical[i] == true else critical[i] == false
    // ensures Valid()
    // // ensures forall i :: i in blood ==> blood[i] >= 0
    // // ensures forall i :: containsType(i) ==> if blood[i] < threshold[i] then critical[i] == true else critical[i] == false

    // {
    //     var blood' := blood;
    //     var threshold' := threshold;
    //     while blood'.Keys != {} && threshold'.Keys != {} 
    //     invariant blood'.Keys <= blood.Keys && threshold'.Keys <= threshold.Keys
    //     invariant forall k | k in blood' :: blood'[k] == blood[k]
    //     invariant forall k | k in threshold' :: threshold'[k] == threshold[k]
    //     decreases blood'.Keys
    //     decreases threshold'.Keys
    //     {
    //         var key :| key in blood';
    //         var threshKey :| threshKey in threshold';
    //         if blood[key] < threshold[threshKey] {
    //             critical := critical[key := true];
    //         } else {
    //             critical := critical[key := false];
    //         }

    //         blood' := map key' | key' in blood' && key' != key :: blood'[key']; 
    //         threshold' := map threshKey' | threshKey' in threshold' && threshKey' != threshKey :: threshold'[threshKey']; 
    //     }
    // }


    method checkFreshness(today:int, btype:string, use_by:int, abn:bool, b_amount:int, added:bool) 
    modifies this
    requires use_by > 0 && today > 0
    requires Valid()
    requires containsType(btype) && b_amount > 0
    ensures Valid()
    ensures containsType(btype) && b_amount > 0
    ensures containsType(btype) && use_by > today && !abn && !added ==> blood[btype] == old(blood[btype]) + b_amount
    ensures containsType(btype) && old(blood[btype]) - b_amount > 0 && (use_by <= today || abn)
            ==> blood[btype] == old(blood[btype]) - b_amount

    {
        var expired:bool := is_expired(use_by, today);

        if !expired && !abn{
            if !added {
                addBlood(btype, b_amount);
            }
        } else if blood[btype] - b_amount > 0 {
                discardBlood(btype, b_amount);
        }

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


method Main(){
    var b := new BloodBank();

    // test inital conditions for blood bank
    assert b.blood["A+"] == 0;
    assert b.critical["A+"];

    // test adding 300ml into A+ bank
    b.addBlood("A+", 300);
    assert b.blood["A+"] == 300;
    
    // test discarding 290ml into A+ bank
    b.discardBlood("A+", 290);
    assert b.blood["A+"] == 10;

    // test adding 5000ml into A+ bank
    b.addBlood("A+", 5000);
    assert b.blood["A+"] == 5010;

    // test discarding more blood than available
    // b.discardBlood("A+", 5011); 
    // -----> nb. Fails since we're trying to discard more blood than is available


    // test check freshness (If expired, remove. If not expired and not abnormal, add to bank.)
    var today:int, use_by:int, abn:bool, b_amount:int, added:bool;
    today := 5;
    use_by := 10;
    abn := false;
    b_amount := 90;
    added := false;

    b.checkFreshness(today, "A+", use_by, abn, b_amount, added);
    assert b.blood["A+"] == 5100;


    // test check freshness (If expired, remove. If not expired and not abnormal, add to bank.)
    today := 5;
    use_by := 1;
    abn := false;
    b_amount := 100;
    added := true;

    b.checkFreshness(today, "A+", use_by, abn, b_amount, added);
    assert b.blood["A+"] == 5000;



}
