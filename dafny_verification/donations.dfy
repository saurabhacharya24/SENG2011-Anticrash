class Donations{
   
    var donor_id_list: array<int>;
    
    var blood_type_list: array<string>;

    var btypes: array<string>;

    var abnormalities: array<bool>;

    var blood_amount: array<int>;

    var added_to_bank: array<bool>;

 /*   method IndexArray (donor_id_list: array<int>)
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
 */

    predicate Valid()
    reads this{
        forall i ::0<=i<150 ==> donor_id_list[i]<=150
    }    

    predicate validate_blood_type(str: string)
    reads this{
        exists i::0<=i<btypes.Length && btypes[i]==str
    }

    predicate validate_donor_id(id: int)
    reads this
    {
        exists i::0<=i<donor_id_list.Length && donor_id_list[i]==id
    }

    predicate validate_blood_amount(amount: int)
    reads this{
        amount > 450 && amount < 550
    }

    constructor()
    modifies this
    ensures Valid()
    ensures donor_id_list.Length <= 150
    ensures forall j::0<=j<donor_id_list.Length ==> donor_id_list[j]==j+1;
    {
        donor_id_list:= new int[150];

        var i:=0;
        while i<donor_id_list.Length
        invariant 0<=i<donor_id_list.Length
        invariant forall j::0<=j<i ==> donor_id_list[j]==j+1;
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
    donate.Accept_donation(5, "A+", false, 500);
}

