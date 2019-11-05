


class BloodBank:
    def __init__(self):
        self.blood = {
            "O+": 0,
            "O-": 0,
            "A+": 0,
            "A-": 0,
            "B+": 0,
            "B-": 0,
            "AB+": 0,
            "AB-": 0
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

        self.threshold = 300
        self.critical = True


    def getBloodLevel(self, blood_type):
        return self.blood[blood_type]

    def getReserveLevel(self, blood_type):
        return self.reserve[blood_type]

    def isCritical(self):
        return self.critical

    def check_quantities(self):
        critical_levels = []
        for key in self.blood:
            if self.blood[key] < self.threshold:
                critical_levels.append(key)

    def check_quantities_bool(self):
        retval = True
        for key in self.blood:
            if self.blood[key] < self.threshold:
                retval = False
        return retval

    def load_reserve(self):
        for key in self.reserve:
            self.blood[key] += self.reserve[key]
            self.reserve[key] = 0

    def adjust_level_donation(self, key, quantity):
        self.blood[key] += quantity

    def check_freshness(self):








