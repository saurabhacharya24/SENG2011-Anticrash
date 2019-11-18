# import sqlite3
import bloodbank_class
from helper_methods import *


class Make_requests(bloodbank_class.Blood_bank):

    def __init__(self, medical_facility_id: str, amount, blood_type, emergency: bool, bloodbank_class):
        super().__init__()
        self.medical_facility_id = medical_facility_id
        if self.validate_medical_facilityID(medical_facility_id) is False:
            print("The medical facility id is not validated")
            exit
        self.emergency = emergency
        self.blood_type = blood_type
        self.amount = amount
        self.can_complete = True
        self.processed = False
        self.check_freshness()
        # self.bloodbank = blood_bank.init()

    def validate_medical_facilityID(self, medical_facility_id):
        files = open("medical_facility_ids.txt", "r")
        found = False
        for ids in files.readlines():
            m_id = str(ids).strip()
            if m_id == medical_facility_id:
                found = True
                break
        return found

    def process_normal_request(self):
        blood_left = self.blood_amounts[self.blood_type] - self.amount
        if blood_left < self.threshold[self.blood_type]:
            self.can_complete = False
            self.issuewarning
        # blood_left == self.threshold[self.blood_type]:
        else:
            self.can_complete = True
            self.decrease_inventory(self.blood_type, self.amount)

            if blood_left == self.threshold[self.blood_type]:
                self.critical = True
                self.issuecriticalwarning()

        self.check_freshness()

    def process_emergency_request(self):
        blood_left = self.blood_amounts[self.blood_type] - self.amount

        if blood_left > 0:
            self.can_complete = True
            self.decrease_inventory(self.blood_type, self.amount)

            if blood_left <= self.threshold[self.blood_type]:
                self.critical = True
                self.issuecriticalwarning()
        else:
            self.can_complete = False
            self.issuewarning()

        self.check_freshness()

    def decrease_inventory(self, blood_type, blood_amount):
        self.discard_blood(blood_type, blood_amount)
        # self.disconnect_db(conn)

    # These are the functions which have to be used with a frontend, to manipulate buttons and issue warnings
    # This function is a front end button which shifts things from pending requests to completed request
    # (as in the website design, refer the front end home page on messenger)
    def manage_processed(self):
        self.processed = True

    # this function issue the warning when there isnt enough blood to cover a request, so a warning is issued
    # (on the frontend) saying request couldnt be completed, add more blood to samples
    def issuewarning(self):
        pass

    def issuecriticalwarning(self):
        pass
