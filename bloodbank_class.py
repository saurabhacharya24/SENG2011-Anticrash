

class BloodBank:
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

        self.reserve = {
            "O+": 0,
            "O-": 0,
            "A+": 0,
            "A-": 0,
            "B+": 0,
            "B-": 0,
            "AB+": 0,
            "AB-": 0
        }

        self.critical = True


    def get_blood_level(self, blood_type):
        return self.blood[blood_type]

    def get_threshold_level(self, blood_type):
        return self.threshold[blood_type]

    def is_critical(self):
        return self.critical

    def check_quantities(self):
        critical_levels = []
        for key in self.blood:
            if self.blood[key] < self.threshold[key]:
                critical_levels.append(key)
        return critical_levels

    def check_quantities_bool(self):
        retval = True
        for key in self.blood:
            if self.blood[key] < self.threshold[key]:
                retval = False
        return retval

    def load_reserve(self):
        for key in self.reserve:
            self.blood[key] += self.threshold[key]
            self.reserve[key] = 0

    def adjust_level_donation(self, key, quantity):
        # add donation in litres
        self.blood[key] += quantity*1E-3

    def check_freshness(self):








