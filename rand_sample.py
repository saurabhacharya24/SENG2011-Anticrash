#!/usr/bin/env python3.6

from datetime import date, timedelta

donor_id = None
blood_type = None
abornormalities = None
sample_id = None
today = date.today()+timedelta(days=42)
use_by_date = today.strftime("%d/%m/%Y")


print(use_by_date)
