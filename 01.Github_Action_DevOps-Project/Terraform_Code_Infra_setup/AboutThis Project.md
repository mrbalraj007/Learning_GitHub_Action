sudo rm /etc/apt/sources.list.d/trivy.list
✅ Step-by-step Fix:
1. Check for Duplicate Sources
Run this to find duplicate entries:

bash
Copy
Edit
grep -r "aquasecurity.github.io" /etc/apt/sources.list /etc/apt/sources.list.d/
You'll likely see multiple entries for Trivy, possibly with different Signed-By values.

2. Remove the Conflicting Entry/Entries
Remove the Trivy source files causing the conflict:

bash
Copy
Edit
sudo rm /etc/apt/sources.list.d/trivy.list
(Adjust the filename if different based on the output of step 1.)

 that's the root cause right there. You have two conflicting lines in the same file (/etc/apt/sources.list.d/trivy.list):

One line includes signed-by=/usr/share/keyrings/trivy.gpg

The other does not — and that creates the conflict.

🔧 Fix It
You just need to clean up that file and leave only one valid line. Here's how:

Option 1: Clean manually (quick edit)
bash
Copy
Edit
sudo nano /etc/apt/sources.list.d/trivy.list
Change this:

bash
Copy
Edit
deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb noble main
deb https://aquasecurity.github.io/trivy-repo/deb noble main
To this (just keep one line):

bash
Copy
Edit
deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb noble main
Then save and exit (Ctrl+O, Enter, Ctrl+X).

Option 2: Or delete the file entirely (if you're removing Trivy anyway)
bash
Copy
Edit
sudo rm /etc/apt/sources.list.d/trivy.list



# Note: 
# a. First create a pem-key manually from the AWS console
# b. Copy it in the same directory as your terraform code
