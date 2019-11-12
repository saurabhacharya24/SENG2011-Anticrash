class BloodBank {
    var blood:map<string, int>
    var threshold:map<string, int>;
    var critical:bool

    predicate Valid()
    reads this
    { 
        forall i :: i in blood ==> blood[i] >= 0
        &&
        forall i :: i in blood && i in threshold && critical == true ==> blood[i] < threshold[i]
        &&
        forall i :: i in blood && i in threshold && critical == false ==> blood[i] >= threshold[i]


    }

    constructor ()
    // modifies this;
    ensures Valid()
    {
        critical := true;
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
    }

    method addBlood(key:string, quantity:int)
    modifies this;
    requires Valid()
    requires key in blood && key in threshold
    requires quantity > 0
    ensures Valid()
    ensures key in blood ==> blood[key] == old(blood[key]) + quantity
    ensures key in blood && key in threshold && blood[key] >= threshold[key] ==> critical == false
    {
        if key in blood && key in threshold{
            var amount:int := blood[key];
            var newAmount:int := amount + quantity;
            blood := blood[key := newAmount];

            if newAmount >= threshold[key]{
                critical := false;
            }
        }
    }

    // method discardBlood(key:string, quantity:int)
    // modifies this;
    // requires Valid()
    // ensures Valid()
    // requires key in blood && key in threshold
    // requires quantity > 0
    // ensures key in blood ==> blood[key] >= 0
    // ensures key in blood && (old(blood[key]) - quantity) > 0 ==> (blood[key] == old(blood[key]) - quantity)
    // ensures key in blood && blood[key] == old(blood[key]) ==> critical == old(critical)
    // ensures key in blood && key in threshold && (old(blood[key]) - quantity) < threshold[key] ==> critical == true
    // ensures key in blood && key in threshold && blood[key] < threshold[key] ==> critical == true
    // ensures key in blood && key in threshold && blood[key] >= threshold[key] ==> critical == false
    // {
    //     if key in blood && key in threshold{
    //         var amount:int := blood[key];
    //         var newAmount:int := amount - quantity;
    //         if (newAmount > 0) {
    //             blood := blood[key := newAmount];
    //         }

    //         if blood[key] < threshold[key] {
    //             critical := true;
    //         }
            
    //     }
    // }


   
}