import sqlite3
from datetime import timedelta, date, datetime
import random

class Donations:

    def __init__(self, donor_id:int, blood_type:str, location_of_donation:str, blood_amount:int, date_of_donation):
        self.donor_id = donor_id
        self.blood_type = blood_type
        self.location_of_donation = location_of_donation
        self.date_of_donation = datetime.strptime(date_of_donation, "%Y-%m-%d")
        self.use_by_date = self.date_of_donation + timedelta(days=42) #unsure about date.today()
        self.abnormalities = False
        self.blood_amount = blood_amount
        self.added_to_bank = False

    #accepts donation as a sample only (not to bloodbank)
    def accept_donation(self):
        valid_donor = self.validate_donor_ID(self.donor_id)
        valid_blood_amt = self.validate_blood_amt(self.blood_amount)
        if valid_donor and valid_blood_amt:
            #test blood for abnormalities
            test = random.randint(0, 100)
            self.test_blood(test)
            #change date format
            day, month, year = self.use_by_date.day, self.use_by_date.month, self.use_by_date.year
            self.use_by_date = str(day) + "/" + str(month) + "/" + str(year)
            sql_insert_sample = """insert into donor_samples(donor_id, blood_type, location_of_donation, use_by_date, abnormalities, blood_amount, added_to_bank) values (?, ?, ?, ?, ?, ?, ?)"""
            print(self.donor_id, self.blood_type, self.location_of_donation, self.use_by_date, self.abnormalities, self.blood_amount, self.added_to_bank, self.use_by_date)       
            conn = self.connect_to_db()
            cur = conn.cursor()
            cur.execute(sql_insert_sample, (self.donor_id, self.blood_type, self.location_of_donation, self.use_by_date, self.abnormalities, self.blood_amount, self.added_to_bank))
            conn.commit()            
        else:
            print("Not a registered donor")

    def validate_donor_ID(self, donor_id):
        conn = self.connect_to_db()
        cur = conn.cursor()
        cur.execute(f"select * from donors where donor_id={donor_id};")
        #assumption that id's are unique
        row = cur.fetchall()
        if(row):
            return True
        else:
            return False

    def validate_blood_amt(self, blood_amount):
        if 450 <= int(blood_amount) <= 550:
            return True
        else:
            return False

    def test_blood(self, test):
        # test = random.randint(0, 100)
        if(test > 95):
            self.abnormalities = True
        else:
            self.abnormalities = False

    # Method to generate samples based on blood_type
    def generate_sample(self,blood_t):
        conn = self.connect_to_db()
        cur = conn.cursor()
        query = "SELECT * FROM donor_samples WHERE blood_type=?"
        cur.execute(query, blood_t)
        rows = list(cur.fetchall())
        i=0
        if not rows:
            print ("No samples")
        else:
            for row in rows:
                 return row
                 i+=1
                 if i == 1000:
                     break

  # Method to generate list of donors with abnormalities
    def abnormal_donors(self):
        conn = self.connect_to_db()
        cur = conn.cursor()
        cur.execute("SELECT donor_id FROM donor_samples WHERE abnormalities=1;")
        id_list = list(cur.fetchall())
        if not id_list:
            print ("No donors with abnormalities")
        else:
            for single_id in id_list:
                print(single_id)
                query = "Select name from donors where donor_id=?"
                cur.execute(query, single_id) 
                abnormal_donors.append(cur.fetchone())
        return abnormal_donors

    # Method to generate list of donation sample details
    def list_donation_samples(self):
        conn = self.connect_to_db()
        cur = conn.cursor()


    # Helper method to connect to db
    def connect_to_db(self):
        conn = sqlite3.connect("database/anticrash.db")
        return conn

    # Helper method to close db
    def disconnect_db(self, conn):
        conn.close()


# test = Donations(1, "A+", "15 Alice St", 500)
# a = test.accept_donation()
