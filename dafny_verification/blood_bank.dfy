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

    // predicate onlyModifies(btype:string)
    // reads this
    // {
    //     forall i :: containsType(i)
    // }

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
    ensures containsType(key) && blood[key] >= threshold[key] ==> critical[key] == false
    ensures containsType(key) && blood[key] < threshold[key] ==> critical[key] == true
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










    // method discardBlood(btype:string, quantity:int):
    // modifies this;
    // requires Valid()



    // method discardBlood(key:string, quantity:int)
    // modifies this;
    // requires Valid()
    // ensures Valid()
    // requires containsType(key)
    // ensures key in blood ==> blood[key] == old(blood[key]) - quantity
    // ensures containsType(key) && blood[key] >= threshold[key] ==> critical[key] == false
    // ensures containsType(key) && blood[key] < threshold[key] ==> critical[key] == true
    // requires quantity > 0 && quantity < blood[key]

    // {
    //     var amount:int := blood[key];
    //     var newAmount:int := amount - quantity;
    //     blood := blood[key := newAmount];

    //     if blood[key] >= threshold[key] {
    //         critical := critical[key := false];
    //     } else {
    //         critical := critical[key := true];
    //     }
        
        
    // }


   
}