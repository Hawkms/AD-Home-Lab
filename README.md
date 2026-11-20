# AD-Home-Lab

A home lab that models a small company network with Active Directory, plus PowerShell and Python scripts to automate some of the work help desk handles every day.

## The lab

Two virtual machines in VirtualBox on a private NAT Network:

| Machine | Role |
| --- | --- |
| **DC01** | Windows Server domain controller for `lab.local`, also running DNS, with a static IP |
| **Windows client** | Joined to the `LAB` domain and used to sign in as test users |

### Domain setup

- **OUs:** `Company`, containing `IT`, `Sales`, `HR` and `Disabled`
- **Security groups:** `IT-Staff`, `Sales-Staff` and `HR-Staff`, one per department
- **Password policy:** 12-character minimum, complexity required, account lockout after 5 failed attempts
- **Department policy:** a GPO linked to the Sales OU that blocks Control Panel and PC Settings for Sales users

### Help desk tasks practiced

- Unlocking an account after a lockout
- Resetting a password and forcing a change at next sign-in
- Disabling a leaver and moving them to the `Disabled` OU
- Checking which policies applied to a user with `gpresult /r`

## Scripts

All scripts are in the [`Scripts`](Scripts) folder.

| File | Language | What it does |
| --- | --- | --- |
| `newhires.ps1` | PowerShell | Reads `newhires.csv`, creates each user in their department OU with a temporary password, adds them to their department group, and skips anyone who already exists so it can be re-run safely |
| `dailylog.ps1` | PowerShell | Finds locked-out accounts and accounts inactive for 90 days, and saves each list to a dated CSV |
| `Offboard.ps1` | PowerShell | Disables a user's account and moves it to the `Disabled` OU. Prompts for the username if one isn't given |
| `genhires.py` | Python | Generates `newhires.csv` with randomly built sample employees for testing |
| `newhires.csv` | Data | Sample input for `newhires.ps1` |

## How to run

The PowerShell scripts run on the domain controller in PowerShell as administrator. They need the ActiveDirectory module, and the OUs and groups above must already exist.

```powershell
cd C:\Scripts

# Create users from newhires.csv
powershell -ExecutionPolicy Bypass -File .\newhires.ps1

# Report locked and inactive accounts
powershell -ExecutionPolicy Bypass -File .\dailylog.ps1

# Disable a leaver and move them to the Disabled OU
powershell -ExecutionPolicy Bypass -File .\Offboard.ps1 -Username jprice
```

`-ExecutionPolicy Bypass` lets a script downloaded from the internet run once without changing the system's execution policy.

The Python script runs on any machine with Python 3. I run it on my laptop, push the CSV to GitHub, and download only the CSV to the server, so the domain controller doesn't need Python installed.

```powershell
python genhires.py
```

### Workflow

1. Write and edit scripts on my laptop in VS Code
2. Push them to this repository with Git
3. Download them onto DC01 from GitHub and run them there

## Screenshots

### OU structure and IT users
![OU structure in Active Directory Users and Computers](screenshots/01-aduc-ous.png)

### Sales group, members and linked GPO
![Sales-Staff members and the GPO linked to the Sales OU](screenshots/02-sales-group-gpo.png)

### Domain password policy
![Password policy with a 12-character minimum](screenshots/03-password-policy.png)

### Sales Group Policy blocking Control Panel
![GPO setting that prohibits access to Control Panel and PC settings](screenshots/04-sales-gpo-setting.png)

### Domain sign-in on the client
![Windows sign-in screen showing "Sign in to: LAB"](screenshots/05-domain-signin.png)

### Running the scripts
![Onboarding script skipping existing users, and offboarding a user](screenshots/06-script-output.png)

## Notes

- Every name in this repository is made up.
- The temporary password in `newhires.ps1` is a lab-only value, and new users must change it at first sign-in.
- The lab is isolated and not connected to any real network.

## What I learned

- How the domain controller, DNS and domain-joined PCs depend on each other. A client pointed at the wrong DNS server can't find the domain.
- How OUs and groups organize users, and how linking a GPO to an OU targets rules at one department
- How user policies apply at sign-in, and how Enforced and Block Inheritance change GPO precedence
- Writing PowerShell that reads a CSV, checks before it acts, and can be re-run safely
- Debugging scripts: a parameter value split onto the next line made the move step fail while the script still printed success, so I now have scripts report the real result
- Using Git and GitHub to move scripts from my laptop to the lab server

## Next steps

- Remove a leaver from all groups during offboarding
- Schedule `dailylog.ps1` to run each morning with Task Scheduler
- Add `try`/`catch` error handling to the onboarding script