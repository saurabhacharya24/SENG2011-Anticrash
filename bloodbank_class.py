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

        self.blood_amounts = {}
        self.refresh_blood_amounts()
        self.critical = False

    def get_all_blood_amounts(self):
        self.check_freshness()
        return self.blood_amounts

    def get_blood_amount_by_type(self, b_type):
        self.check_freshness()
        return self.blood_amounts[b_type]

    def get_threshold_level(self, blood_type):
        return self.threshold[blood_type]

    def is_critical(self):
        return self.critical

    def check_quantities(self):
        self.check_freshness()

        critical_levels = []

        for b_type in self.blood_amounts:
            if self.blood_amounts[b_type] < self.threshold[b_type]:
                critical_levels.append(b_type)

        return critical_levels
        # Should probably call donation class (ie. get_donations or something)
        # and after getting donations, update_blood_amounts
        # based on type (which is in critical_levels)

    def check_quantities_bool(self):
        self.check_freshness()
        retval = True

        for b_type in self.blood_amounts:
            if self.blood_amounts[b_type] < self.threshold[b_type]:
                retval = False
                self.critical = retval
                return retval

        return retval

    def add_blood(self, b_type, quantity):
        self.check_freshness()

        updated_blood = self.blood_amounts[b_type] + quantity

        conn = self.connect_to_db()
        cur = conn.cursor()

        sql_adjust_level = """update blood_bank set blood_amount = ? where blood_type = ?"""
        cur.execute(sql_adjust_level, (updated_blood, b_type))
        conn.commit()

        self.disconnect_db(conn)

        self.check_freshness()

    def discard_blood(self, b_type, quantity):
        self.check_freshness()

        updated_blood = self.blood_amounts[b_type] - quantity

        conn = self.connect_to_db()
        cur = conn.cursor()

        sql_adjust_level = """update blood_bank set blood_amount = ? where blood_type = ?"""
        cur.execute(sql_adjust_level, (updated_blood, b_type))
        conn.commit()

        self.disconnect_db(conn)

        self.check_freshness()

    def refresh_blood_amounts(self):
        conn = self.connect_to_db()
        cur = conn.cursor()

        sql_blood_amount = """select * from blood_bank"""
        cur.execute(sql_blood_amount)
        blood_type_and_amount = cur.fetchall()

        for b_type, b_amount in blood_type_and_amount:
            self.blood_amounts[b_type] = b_amount

        self.check_quantities_bool()
        self.check_quantities()

        self.disconnect_db(conn)

    # Do need to check if this makes sense
    def check_freshness(self):
        conn = self.connect_to_db()
        cur = conn.cursor()

        today = date.today()

        sql_donor_samples = """select blood_type, blood_amount, use_by_date, abnormalities, added_to_bank
                               from donor_samples"""
        cur.execute(sql_donor_samples)
        donor_samples = cur.fetchall()

        for blood_type, blood_amount, use_by_date, abnormalities, added_to_bank in donor_samples:
            expired = is_expired(use_by_date, today)

            if not expired and not abnormalities:
                if not added_to_bank:
                    self.add_blood(blood_type, blood_amount)
            else:
                if added_to_bank:
                    self.discard_blood(blood_type, blood_amount)

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
