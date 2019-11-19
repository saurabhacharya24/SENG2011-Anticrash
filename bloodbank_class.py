import sqlite3
from helper_methods import *
# from datetime import date


class Blood_bank:
    def __init__(self):
        # amount in ml
        self.threshold = {
            "O+": 400000,
            "O-": 200000,
            "A+": 400000,
            "A-": 200000,
            "B+": 300000,
            "B-": 100000,
            "AB+": 100000,
            "AB-": 100000
        }

        self.critical_dict = {
            "O+": False,
            "O-": False,
            "A+": False,
            "A-": False,
            "B+": False,
            "B-": False,
            "AB+": False,
            "AB-": False
        }

        self.blood_amounts = {}
        self.check_freshness()

    def get_all_blood_amounts(self):
        # self.check_freshness()
        return self.blood_amounts

    def get_blood_amount_by_type(self, b_type):
        self.check_freshness()
        return self.blood_amounts[b_type]

    def get_threshold_level(self, blood_type):
        return self.threshold[blood_type]

    def is_critical(self):
        return self.critical

        # Should probably call donation class (ie. get_donations or something)
        # and after getting donations, update_blood_amounts
        # based on type (which is in critical_levels)

    def isCritical(self, b_type):
        self.check_freshness()

        return self.critical_dict[b_type]

    def check_critical(self):
        self.check_freshness()

        for b_type in self.critical_dict:
            if self.blood_amounts[b_type] < self.threshold[b_type]:
                self.critical_dict[b_type] = True
            else
                self.critical_dict[b_type] = False



    def add_blood(self, b_type, quantity):
        self.check_freshness()

        updated_blood = self.blood_amounts[b_type] + quantity

        conn = self.connect_to_db()
        cur = conn.cursor()

        sql_adjust_level = """update blood_bank set blood_amount = ? where blood_type = ?"""
        cur.execute(sql_adjust_level, (updated_blood, b_type))
        conn.commit()


        self.check_critical()
        self.disconnect_db(conn)

        # self.check_freshness()

    def contains_type(b_type):
        if b_type in self.threshold && b_type in self.blood_amounts && b_type in self.critical_dict:
            return True
        else:
            return False

    def discard_blood(self, b_type, quantity):
        self.check_freshness()

        updated_blood = self.blood_amounts[b_type] - quantity

        conn = self.connect_to_db()
        cur = conn.cursor()

        sql_adjust_level = """update blood_bank set blood_amount = ? where blood_type = ?"""
        cur.execute(sql_adjust_level, (updated_blood, b_type))
        conn.commit()

        self.check_critical()
        self.disconnect_db(conn)

        # self.check_freshness()

    def refresh_blood_amounts(self):
        conn = self.connect_to_db()
        cur = conn.cursor()

        sql_blood_amount = """select * from blood_bank"""
        cur.execute(sql_blood_amount)
        blood_type_and_amount = cur.fetchall()

        for b_type, b_amount in blood_type_and_amount:
            self.blood_amounts[b_type] = b_amount

        # self.check_quantities_bool()
        # self.check_quantities()

        self.disconnect_db(conn)

    # Do need to check if this makes sense
    def check_freshness(self):
        self.refresh_blood_amounts()
        conn = self.connect_to_db()
        cur = conn.cursor()

        today = date.today()

        sql_donor_samples = """select *
                               from donor_samples"""
        cur.execute(sql_donor_samples)
        donor_samples = cur.fetchall()
        for i in donor_samples:
            print(i)

        for sample in donor_samples:
            sid = sample[0]
            b_type = sample[2]
            use_by = sample[4]
            abn = sample[5]
            b_amount = sample[6]
            added = sample[7]

            expired = is_expired(use_by, today)

            if not expired and not abn:
                if not added:
                    self.add_blood(b_type, b_amount)
                    print("Adding " + b_type, "Amount: " + str(b_amount))
                    sql_has_added = """update donor_samples set added_to_bank = ? where sample_id = ?"""
                    cur.execute(sql_has_added, (1, sid))
                    conn.commit()
            else:
                if added:
                    self.discard_blood(b_type, b_amount)

        self.refresh_blood_amounts()
        self.disconnect_db(conn)

    # Helper method to connect to db
    def connect_to_db(self):
        conn = sqlite3.connect("database/anticrash.db")
        return conn

    # Helper method to close db
    def disconnect_db(self, conn):
        conn.close()

# Test Case

# bank = blood_bank()
# check = bank.check_freshness()

# print("Initial Blood Levels:\n")
# bank.get_all_blood_amounts()
# print("\n---")
# print("\n Updated Blood:\n")
# bank.update_blood_amounts("O+", 200)
# print("\n")
# bank.get_all_blood_amounts()
# 
