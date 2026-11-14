import csv
import random

first_names = ["Ava", "Liam", "Noah", "Mia", "Eli", "Zoe"]
last_names = ["Carter", "Nguyen", "Patel", "Brooks", "Reyes", "Kim"]
departments = ["IT", "Sales", "HR"]

rows = []
used = set()
while len(rows) < 20:
    first = random.choice(first_names)
    last = random.choice(last_names)
    username = (first[0] + last).lower()
    if username in used:
        continue
    used.add(username)
    rows.append([first, last, username, random.choice(departments)])

with open("newhires.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["First", "Last", "Username", "Department"])
    writer.writerows(rows)