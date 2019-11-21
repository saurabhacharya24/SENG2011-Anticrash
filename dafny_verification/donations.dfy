class Donations{
   
    var donor_id_list: array<int> := new int[150];
    
    var blood_type_list: array<string> := new string[0];

    var btypes: array<string> := new string[8];
    btypes[0], btypes[1], btypes[2], btypes[3], btypes[4], btypes[5], btypes[6], btypes[7]:= "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-";

    var abnormalities: array<bool> := new bool[0];

    var blood_amount: array<int> := new int[0];

    var added_to_bank: array<bool> := new bool[0];

    method IndexArray (donor_id_list: array<int>)
    modifies donor_id_list
    ensures donor_id_list.Length <= 150
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


    predicate Valid()
    reads this{
        /*class invariant goes here, possibly about donor_ids, as other class   variables all change without conditions*/ 
        forall i :: i in donor_id ==> donor_id_list[i]<=150;
    }    

    predicate valid_blood_type(str: string)
    reads this{
        i:=0;
        while i< btypes.Length
        invariant 0 <= i< btypes.Length
        invariant forall k::0<=k<i ==> btypes[k] != str
        {
             if btypes[i] == str
                 {return true;} 
             else 
                 {return false;}
        }
    }

    predicate validate_donor_id(id: int)
    reads this
    {
        i:=0;
        while i< donor_id_list.Length
        invariant 0 <= i< donor_id_list.Length
        invariant forall k::0<=k<i ==> donor_id_list[k] != id
        {
             if donor_id_list[i] == id
                 {return true;} 
             else 
                 {return false;}
        }
    }

    predicate validate_blood_amount(amount: int)
    reads this{
        if (amount>450&&amount<550) {return true;} else {return false;};
    }

    constructor()
    modifies this
    ensures Valid()
    {
        //?
    }

    method Accept_donation(b_type:string, abnormal:bool, amount:int)
    modifies blood_type_list
    modifies abnormalities
    modifies blood_amount
    modifies added_to_bank
    requires Valid()
    requires validate_donor_id()
    requires validate_blood_amount()
    requires validate_blood_type()
    ensures blood_type_list.Length == old(blood_type_list).Length +1
    ensures abnormalities.Length == old(abnormalities).Length +1
    ensures blood_amount.Length == old(blood_amount).Length +1
    ensures added_to_bank.Length == old(added_to_bank).Length +1
    ensures Valid()
    {
        blood_type_list.Length := blood_type_list.Length+1;
        blood_type_list[blood_type_list.Length] := b_type;
        abnormalities.Length := abnormalities.Length+1;
        abnormalities[abnormalities.Length] := abnormal;
        blood_amount.Length := blood_amount.Length+1;
        blood_amount[blood_amount.Length] := amount;
        added_to_bank.Length := added_to_bank.Length+1;
        added_to_bank[added_to_bank.Length] := false;
    }
}

method Main(){
    var donate:= new Donations();
    donate.Accept_donation("A+", false, 500);
}
