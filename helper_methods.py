from datetime import date
from dateutil.parser import parse

def is_expired(date_string):
    day, month, year = date_string.split("/")
    expiry = month + "/" + day + "/" + year

    today = date.today()
    todayf = today.strftime("%m/%d/%Y")

    expiry = parse(expiry)
    todayf = parse(todayf)


    if (expiry > todayf):
        return False
    else:
        return True

