import sqlite3


class blood_bank:
    def __init__(self):
        # amount in litres, maybe change it to ml
        self.threshold = {
            "O+": 400,
            "O-": 200,
            "A+": 400,
            "A-": 200,
            "B+": 300,
            "B-": 100,
            "AB+": 100,
            "AB-": 100
        }

        self.blood_amounts = {}
        self.refresh_blood_amounts()

        # self.blood = {
        #     "O+": 0,
        #     "O-": 0,
        #     "A+": 0,
        #     "A-": 0,
        #     "B+": 0,
        #     "B-": 0,
        #     "AB+": 0,
        #     "AB-": 0
        # }

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

    # def load_reserve(self):
    #     for key in self.reserve:
    #         self.blood[key] += self.threshold[key]
    #         self.reserve[key] = 0

    def update_blood_amounts(self, b_type, quantity):
        # add donation in litres
        self.refresh_blood_amounts()

        updated_blood = self.blood_amounts[b_type] + quantity

        conn = sqlite3.connect("database/anticrash.db")
        cur = conn.cursor()

        sql_adjust_level = """update blood_bank set blood_amount = ? where blood_type = ?"""
        cur.execute(sql_adjust_level, (updated_blood, b_type))
        conn.commit()
        conn.close()

        self.refresh_blood_amounts()

    def refresh_blood_amounts(self):
        conn = sqlite3.connect("database/anticrash.db")
        cur = conn.cursor()

        sql_blood_amount = """select * from blood_bank"""
        cur.execute(sql_blood_amount)
        blood_type_and_amount = cur.fetchall()

        for b_type, b_amount in blood_type_and_amount:
            self.blood_amounts[b_type] = b_amount

        conn.close()

    # INCOMPLETE
    def check_freshness(self):
        conn = sqlite3.connect("database/anticrash.db")
        cur = conn.cursor()

        sql_donor_samples = """select sample_id, blood_type, blood_amount, use_by_date, abnormalities
                               from donor_samples"""
        cur.execute(sql_donor_samples)
        donor_samples = cur.fetchall()

        conn.close()

        return donor_samples

    # def connect_db():
    #     conn = sqlite3.connect("database/anticrash.db")
    #     return

# Test Case

# bank = blood_bank()
# print("Initial Blood Levels:\n")
# bank.get_all_blood_amounts()
# print("\n---")
# print("\n Updated Blood:\n")
# bank.update_blood_amounts("O+", 200)
# print("\n")
# bank.get_all_blood_amounts()
