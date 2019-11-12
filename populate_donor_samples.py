import sqlite3
import random
import datetime
from datetime import date


clinics = open("data/clinic_addresses.txt")
clinics_list = []

if clinics.mode == 'r':
    clinic_addresses = clinics.readlines()

    for i in range(0, len(clinic_addresses)):
        c = clinic_addresses[i].strip()
        clinics_list.append(c)

conn = sqlite3.connect("database/anticrash.db")
cur = conn.cursor()

sql_donors = "select name, blood_type, donor_id from donors"
cur.execute(sql_donors)
donors = cur.fetchmany(size=20)

for name, blood_type, donor_id in donors:
    r_clinic = random.randint(0, len(clinics_list) - 1)
    r_abnormal = random.randint(0, 100)
    r_blood_amount = random.randint(450, 550)

    abn = False

    if r_abnormal > 95:
        abn = True

    location = clinics_list[r_clinic]
    today = date.today()

    use_by = today + datetime.timedelta(days=42)

    day, month, year = use_by.day, use_by.month, use_by.year
    use_by = str(day) + "/" + str(month) + "/" + str(year)

    # print(donor_id, name, blood_type, r_blood_amount, location, use_by, abn)

    sql_insert_sample = """insert into donor_samples(donor_id, blood_type, location_of_donation, use_by_date, abnormalities, blood_amount)
                           values(?, ?, ?, ?, ?, ?)"""
    cur.execute(sql_insert_sample, (donor_id, blood_type, location, use_by, abn, r_blood_amount))
    conn.commit()

conn.close()
clinics.close()
