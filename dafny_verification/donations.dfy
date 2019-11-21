class Donations{
   
    var donor_id_list: array<int>;
    
    var blood_type_list: array<string>;
    var new_blood_type : array<string>;
    var btypes: array<string>;

    var abnormalities: array<bool>;
    var new_abnormalities: array<bool>;
    var blood_amount: array<int>;
    var new_blood_amount : array<int>;
    var added_to_bank: array<bool>;
    var new_added_to_bank: array<bool>;

 /*   method IndexArray (donor_id_list: array<int>)
    modifies donor_id_list
    ensures donor_id_list.Length = 150
    ensures forall j::0<=j<donor_id_list.Length ==> donor_id_list[j]==j+1;
    {
        var i:=0;
        while i<donor_id_list.Length
        invariant 0<=i<donor_id_list.Length
        invariant forall j::0<=j<i ==> donor_id_list[j]==j+1;
        {
            donor_id_list[i]:=i+1;
            i:=i+1;
        }
    }
 */

    predicate Valid()
    reads this
    reads donor_id_list
    {
        if donor_id_list != null then forall i ::0<=i<donor_id_list.Length ==> donor_id_list[i]<=150 else false
    }    

    predicate validate_blood_type(str: string)
    reads this
    reads btypes
    requires btypes != null
    requires btypes.Length != 0
    requires str != []
    {
        exists i::0<=i<btypes.Length && btypes[i]==str
    }

    predicate validate_donor_id(id: int)
    reads this
    reads donor_id_list
    requires donor_id_list != null
    requires donor_id_list.Length != 0
    {
        exists i::0<=i<donor_id_list.Length && donor_id_list[i]==id
    }

    predicate validate_blood_amount(amount: int)
    reads this
    requires amount != 0
    {
        amount > 450 && amount < 550
    }

    constructor()
    modifies this
    modifies donor_id_list
    modifies blood_type_list 
    modifies btypes
    //requires Valid()
    ensures Valid()
    ensures 0 < donor_id_list.Length <= 150
    ensures forall j::0<=j<donor_id_list.Length ==> donor_id_list[j]==j+1;
    {
        donor_id_list:= new int[150];
        assert donor_id_list != null;
        var t := donor_id_list.Length;
        var i:=0;
        while i < t
        invariant 0 <= i <= t
        invariant if donor_id_list != null then forall j::0<=j<i ==> donor_id_list[j]==j+1 else false;
        {
            donor_id_list[i]:=i+1;
            i:=i+1;
        }

        blood_type_list:= new string[0];
        btypes := new string[8];
        btypes[0], btypes[1], btypes[2], btypes[3], btypes[4], btypes[5], btypes[6], btypes[7]:= "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-";
        abnormalities := new bool[0];
        blood_amount := new int[0];
        added_to_bank := new bool[0];
    }

    method Accept_donation(id: int, b_type:string, abnormal:bool, amount:int)
    modifies blood_type_list
    modifies abnormalities
    modifies blood_amount
    modifies added_to_bank
    requires Valid()
    requires validate_donor_id(id)
    requires validate_blood_amount(amount)
    requires validate_blood_type(b_type)
    ensures new_blood_type.Length == blood_type_list.Length +1
    ensures new_abnormalities.Length == abnormalities.Length +1
    ensures new_blood_amount.Length == blood_amount.Length +1
    ensures new_added_to_bank.Length == added_to_bank.Length +1
    ensures Valid()
    {
        new_blood_type := new string[blood_type_list.Length+1];
        new_blood_type := blood_type_list;
        new_blood_type[blood_type_list.Length] := b_type;

        new_abnormalities := new bool[abnormalities.Length+1];
        new_abnormalities := abnormalities;
        new_abnormalities[abnormalities.Length] := abnormal;

        new_blood_amount := new int[blood_amount.Length+1];
        new_blood_amount := blood_amount;
        new_blood_amount[blood_amount.Length] := amount;

        new_added_to_bank := new bool[added_to_bank.Length+1];
        new_added_to_bank := added_to_bank;
        new_added_to_bank[added_to_bank.Length] := false;
    }
}

method Main(){
    var donate:= new Donations();
    donate.Accept_donation(5, "A+", false, 500);
}

