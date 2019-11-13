import sqlite3
from helper_methods import *
# from datetime import date

# NOTE: 
# Maybe add another column in donor_samples called 'is_sent'
# which would show if the sample has been sent to a medical facility
class Blood_bank:
    def __init__(self):
        # amount in litres, maybe change it to ml
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
        self.refresh_blood_amounts()
        return self.blood_amounts

    def get_blood_amount_by_type(self, b_type):
        self.refresh_blood_amounts()
        return self.blood_amounts[b_type]

    def get_threshold_level(self, blood_type):
        return self.threshold[blood_type]

    def is_critical(self):
        return self.critical

    def check_quantities(self):
        self.refresh_blood_amounts()

        critical_levels = []

        for b_type in self.blood_amounts:
            if self.blood_amounts[b_type] < self.threshold[b_type]:
                critical_levels.append(b_type)

        return critical_levels
        # Should probably call donation class (ie. get_donations or something)
        # and after getting donations, update_blood_amounts
        # based on type (which is in critical_levels)

    def check_quantities_bool(self):
        self.refresh_blood_amounts()
        retval = True

        for b_type in self.blood_amounts:
            if self.blood_amounts[b_type] < self.threshold[b_type]:
                retval = False

        # Maybe self.critical = retval?
        # Do we need self.critical?
        return retval

    def add_blood(self, b_type, quantity):
        self.refresh_blood_amounts()

        updated_blood = self.blood_amounts[b_type] + quantity

        conn = self.connect_to_db()
        cur = conn.cursor()

        sql_adjust_level = """update blood_bank set blood_amount = ? where blood_type = ?"""
        cur.execute(sql_adjust_level, (updated_blood, b_type))
        conn.commit()

        self.disconnect_db(conn)

        self.check_quantities_bool()
        self.check_quantities()
        self.refresh_blood_amounts()

    def discard_blood(self, b_type, quantity):
        self.refresh_blood_amounts()

        updated_blood = self.blood_amounts[b_type] - quantity

        conn = self.connect_to_db()
        cur = conn.cursor()

        sql_adjust_level = """update blood_bank set blood_amount = ? where blood_type = ?"""
        cur.execute(sql_adjust_level, (updated_blood, b_type))
        conn.commit()

        self.disconnect_db(conn)

        self.check_quantities_bool()
        self.check_quantities()
        self.refresh_blood_amounts()

    def refresh_blood_amounts(self):
        conn = self.connect_to_db()
        cur = conn.cursor()

        # Most probably it should get blood from donor_samples
        sql_blood_amount = """select * from blood_bank"""
        cur.execute(sql_blood_amount)
        blood_type_and_amount = cur.fetchall()

        for b_type, b_amount in blood_type_and_amount:
            self.blood_amounts[b_type] = b_amount

        self.disconnect_db(conn)

    # INCOMPLETE
    # ALSO: Maybe add another column in donor_samples called 'is_sent'
    # which would show if the sample has been sent to a medical facility
    def check_freshness(self):
        conn = self.connect_to_db()
        cur = conn.cursor()

        today = date.today()

       # fresh_blood_dict = {}

        sql_donor_samples = """select blood_type, blood_amount, use_by_date, abnormalities, added_to_bank
                               from donor_samples"""
        cur.execute(sql_donor_samples)
        donor_samples = cur.fetchall()

        for blood_type, blood_amount, use_by_date, abnormalities, added_to_bank in donor_samples:
            expired = is_expired(use_by_date, today)
            # Need to check if it's already added to bank
            if not expired and not abnormalities:
                # print(blood_type, blood_amount, use_by_date, abnormalities, added_to_bank)
                if not added_to_bank:
                    self.blood_amounts[blood_type] += blood_amount
            else:
                if added_to_bank:
                    self.discard_blood(blood_type,blood_amount)

        # for k in sorted(fresh_blood_dict.keys()):
        #     print(k, fresh_blood_dict[k])

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