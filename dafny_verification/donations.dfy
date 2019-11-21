class Donations{
   
    var donor_id_list: array<int> := new int[150];
    
    var blood_type_list: array<string>;

    var btypes: array<string> := new string[8];
    btypes[0], btypes[1], btypes[2], btypes[3], btypes[4], btypes[5], btypes[6], btypes[7]:= "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-";

    var abnormalities: bool;

    var blood_amount: int;

    var added_to_bank: bool := false;

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
        //what goes here?
    }

    method Accept_donation()
    modifies this
    requires Valid()
    requires validate_donor_id()
    requires validate_blood_amount()
    requires validate_blood_type()
    ensures Valid()
    {

    }
    
    method Test_blood()
    ensures Valid(){
        if randint >95 {return true} else {return false};
    } 
}

method Main(){
//for testing by creating a new object of Donations class
}
