
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

method test_is_expired()
{
    var today:int;
    var expiry:int;
    var retval:bool;
    // check in date
    today := 10;
    expiry := 11;
    retval := is_expired(expiry, today);
    assert(retval == false);

    // check same date
    today := 11;
    expiry := 11;
    retval := is_expired(expiry, today);
    assert(retval == true);

    // check out of date
    today := 12;
    expiry := 11;
    retval := is_expired(expiry, today);
    assert(retval == true);

    // check negative date
        // causes assertion error as is_expires requires dates>0
    // today := -11;
    // expiry := 11;
    // retval := is_expired(expiry, today);
    // assert(retval == true);

}