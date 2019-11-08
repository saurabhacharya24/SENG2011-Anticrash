import sqlite3

class blood_bank:
    def __init__(self):
        self.threshold = {
        # amount in litres
            "O+": 400,
            "O-": 200,
            "A+": 400,
            "A-": 200,
            "B+": 300,
            "B-": 100,
            "AB+": 100,
            "AB-": 100
        }

        self.blood = {}
        self.refresh_blood_levels()

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

    def return_all_blood_amounts(self):
        self.refresh_blood_levels()
        print(self.blood)

    def get_blood_level(self, blood_type):
        self.refresh_blood_levels()
        return self.blood[blood_type]

    def get_threshold_level(self, blood_type):
        return self.threshold[blood_type]

    def is_critical(self):
        return self.critical

    def check_quantities(self):
        self.refresh_blood_levels()
        critical_levels = []
        for b_type in self.blood:
            if self.blood[b_type] < self.threshold[b_type]:
                critical_levels.append(b_type)
        return critical_levels

    def check_quantities_bool(self):
        self.refresh_blood_levels()
        retval = True
        for b_type in self.blood:
            if self.blood[b_type] < self.threshold[b_type]:
                retval = False
        return retval

    # def load_reserve(self):
    #     for key in self.reserve:
    #         self.blood[key] += self.threshold[key]
    #         self.reserve[key] = 0

    def update_blood_amount(self, b_type, quantity):
        # add donation in litres
        self.refresh_blood_levels()
        updated_blood = self.blood[b_type] + quantity
        conn = sqlite3.connect("database/anticrash.db")
        cur = conn.cursor()

        sql_adjust_level = """update blood_bank set blood_amount = ? where blood_type = ?"""
        cur.execute(sql_adjust_level, (updated_blood, b_type))
        conn.commit()

        self.refresh_blood_levels()


    # def check_freshness(self):

    def refresh_blood_levels(self):
        conn = sqlite3.connect("database/anticrash.db")
        cur = conn.cursor()
        sql_blood_amount = """select * from blood_bank"""

        blood_amount = cur.execute(sql_blood_amount)
        blood = cur.fetchall()

        for b_type, b_amount in blood:
            self.blood[b_type] = b_amount

    # def connect_db():
    #     conn = sqlite3.connect("database/anticrash.db")
    #     return

# Test Case

# bank = blood_bank()
# print("Initial Blood Levels:\n")
# bank.return_all_blood_amounts()
# print("\n---")
# print("\n Updated Blood:\n")
# bank.update_blood_amount("O+", 200)
# print("\n")
# bank.return_all_blood_amounts()
