import sqlite3
import random


names_file = open("data/names2.txt", "r")
bloodtypes_file = open("data/bloodtypes.txt", "r")
dob_file = open("data/DOB_inputs.txt")
contact_file = open("data/ph_numbers.txt")
last_donation_file = open("data/last_donation_input.txt")

if names_file.mode == 'r':
    names = names_file.readlines()
    types = bloodtypes_file.readlines()
    dob = dob_file.readlines()
    contact = contact_file.readlines()
    last_don = last_donation_file.readlines()

    for i in range(0, len(names)):
        rand_int = random.randint(0, 7)

        name = names[i].strip()
        date_of_birth = dob[i].strip()
        contact_info = contact[i].strip()
        blood_type = types[rand_int].strip()
        date_last_donated = last_don[i].strip()

        try:
            conn = sqlite3.connect("database/anticrash.db")
            cur = conn.cursor()
            sql = """insert into donors (name, dob, contact_info, blood_type, date_last_donated)
                     values (?, ?, ?, ?, ?)"""

            cur.execute(sql, (name, date_of_birth, contact_info, blood_type, date_last_donated))
            conn.commit()

        except (Exception) as error:
            print(error)


names_file.close()
bloodtypes_file.close()
dob_file.close()
contact_file.close()
last_donation_file.close()
