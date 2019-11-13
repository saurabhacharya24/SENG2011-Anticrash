import sqlite3
import bloodbank_class

class make_requests:
    def __init__(self,medical_facility_id:str,emergency: bool):
        self._medical_facility_id = medical_facility_id
        if self.validate_medical_facilityID(medical_facility_id) == False:
            print("The medical facility id is not validated")
            exit
        self._emergency = emergency
        self._blood_needs = ()
    
 
    def validate_medical_facilityID(self,medical_facility_id):
        files = open("medical_facility_ids.txt","r")
        found = False
        for ids in files:
            if ids == medical_facility_id:
                found = True
                break
        return found
