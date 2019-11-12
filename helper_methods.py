from datetime import date
from dateutil.parser import parse

# today is of the form today = date.today() using datetime package
def is_expired(date_string, today):
    day, month, year = date_string.split("/")
    expiry = month + "/" + day + "/" + year
    todayf = today.strftime("%m/%d/%Y")

    expiry = parse(expiry)
    todayf = parse(todayf)


    if (expiry > todayf):
        return False
    else:
        return True

