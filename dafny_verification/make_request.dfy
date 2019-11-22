class Make_request {
    var inventory:map<string, int>
    var threshold:map<string, int>;
    var critical:map<string, bool>;

    predicate Valid()
    reads this
    { 
        forall i :: i in inventory ==> inventory[i] >= 0
        &&
        forall i :: containsType(i) ==> if inventory[i] < threshold[i] then critical[i] == true else critical[i] == false
     }

    predicate containsType(btype:string)
    reads this
    {
        btype in inventory && btype in threshold && btype in critical &&
        "A+" in inventory && "A+" in threshold && "A+" in critical &&
        "A-" in inventory && "A-" in threshold && "A-" in critical &&
        "B+" in inventory && "B+" in threshold && "B+" in critical &&
        "B-" in inventory && "B-" in threshold && "B-" in critical &&
        "O+" in inventory && "O+" in threshold && "O+" in critical &&
        "O-" in inventory && "O-" in threshold && "O-" in critical &&
        "AB+" in inventory && "AB+" in threshold && "AB+" in critical &&
        "AB-" in inventory && "AB-" in threshold && "AB-" in critical
    }

    predicate isCritical(btype:string)
    reads this
    {
        btype in critical && critical[btype]
    }
    
  	constructor ()
    modifies this
    ensures Valid()
    ensures "A+" in inventory && "A+" in threshold && "A+" in critical
    ensures "A-" in inventory && "A-" in threshold && "A-" in critical
    ensures "B+" in inventory && "B+" in threshold && "B+" in critical
    ensures "B-" in inventory && "B-" in threshold && "B-" in critical
    ensures "O+" in inventory && "O+" in threshold && "O+" in critical
    ensures "O-" in inventory && "O-" in threshold && "O-" in critical
    ensures "AB+" in inventory && "AB+" in threshold && "AB+" in critical
    ensures "AB-" in inventory && "AB-" in threshold && "AB-" in critical

    {
        inventory := map["A+" := 1000000,  "A-":=1000000,
                     "B+" := 1000000,  "B-":=1000000,
                     "O+" := 1000000,  "O-":=1000000,
                     "AB+" := 1000000, "AB-":=1000000
                    ];
        threshold := map["A+" := 400000,  "A-":=200000,
                     "B+" := 300000,  "B-":=100000,
                     "O+" := 400000,  "O-":=200000,
                     "AB+" := 100000, "AB-":=100000
                    ];
        critical := map["A+" := false,  "A-":=false,
                     "B+" := false,  "B-":=false,
                     "O+" := false,  "O-":=false,
                     "AB+" := false, "AB-":=false
      				];
	}
    method process_normal_request(key:string, quantity:int) returns(completed: bool)
    modifies this
    requires Valid()
    requires containsType(key)
    requires quantity > 0 //&& inventory[key] - quantity > 0
    requires threshold[key] > 0
    ensures Valid()
    ensures containsType(key)
    ensures (key in inventory && inventory[key] - quantity > threshold[key]) ==> inventory[key] == old(inventory[key]) - quantity
    ensures old(inventory[key]) - quantity <= threshold[key] ==> completed == false
    ensures old(inventory[key]) - quantity > threshold[key] ==> completed == true    
    ensures forall i :: containsType(i) && old(containsType(i)) && i != key ==> inventory[i] == old(inventory[i])
                                                                         && critical[i] == old(critical[i])
                                                                         && threshold[i] == old(threshold[i])
    {
        var amount:int := inventory[key];
        var newAmount:int := amount - quantity;

        if newAmount <= threshold[key]
        {
        	completed := false;
        }
        else
        {
        	completed := true;
        	inventory := inventory[key := newAmount];
        }

    }
    method process_emergency_request(key:string, quantity:int) returns(completed: bool)
    modifies this
    requires Valid()
    requires containsType(key)
    requires quantity > 0 //&& inventory[key] - quantity > 0
    ensures Valid()
    ensures old(inventory[key]) - quantity > 0 ==> completed == true
    ensures old(inventory[key]) - quantity <= 0 ==> completed == false
    ensures containsType(key) && inventory[key] >= 0
    ensures (key in inventory && old(inventory[key]) - quantity > 0)==> inventory[key] == old(inventory[key]) - quantity
    ensures forall i :: containsType(i) && old(containsType(i)) && i != key ==> inventory[i] == old(inventory[i])
                                                                         && critical[i] == old(critical[i])
                                                                         && threshold[i] == old(threshold[i])
    ensures containsType(key) && inventory[key] >= threshold[key] ==> !isCritical(key)
    ensures containsType(key) && inventory[key] < threshold[key] ==> isCritical(key)
    {
        var amount:int := inventory[key];
        var newAmount:int := amount - quantity;
        if(inventory[key] - quantity > 0)
        {
        	inventory := inventory[key := newAmount];
		
        	if inventory[key] >= threshold[key]{
        	    critical := critical[key := false];
        	} else {
        	    critical := critical[key := true];
        	}
        	completed := true;
        }
        else
        {
        	completed := false;
        }
    }
}