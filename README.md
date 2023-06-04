# CICD with Jenkins

- [CICD with Jenkins](#cicd-with-jenkins)
    - [SDLC - The Software Development Life Cycle](#sdlc---the-software-development-life-cycle)
  - [What is CI/CD?](#what-is-cicd)
    - [How is CI/CDE different?](#how-is-cicde-different)
    - [Benefits of CI/CD](#benefits-of-cicd)
  - [What is Jenkins?](#what-is-jenkins)
    - [What are the stages of a Jenkins pipeline?](#what-are-the-stages-of-a-jenkins-pipeline)
    - [Agent node vs Master node](#agent-node-vs-master-node)
    - [What other tools are available?](#what-other-tools-are-available)
  - [Webhooks](#webhooks)
    - [Stopping Jenkins on AWS](#stopping-jenkins-on-aws)
- [Steps to set up a Jenkins CICD Pipeline](#steps-to-set-up-a-jenkins-cicd-pipeline)
  - [1. Create SSH key pair](#1-create-ssh-key-pair)
  - [2. Link SSH key to GitHub](#2-link-ssh-key-to-github)
  - [3. Create Webhook](#3-create-webhook)
  - [4. Create CI job](#4-create-ci-job)
    - [Create/Add a Jenkins SSH key:](#createadd-a-jenkins-ssh-key)
  - [5. Create Merge Job](#5-create-merge-job)
  - [6. Create EC2 production environment](#6-create-ec2-production-environment)
  - [7. Create CD Job](#7-create-cd-job)
  - [8. Trigger](#8-trigger)
- [Steps to build a Jenkins server](#steps-to-build-a-jenkins-server)
  - [1. Create EC2](#1-create-ec2)
  - [2. Set up dependencies required](#2-set-up-dependencies-required)
  - [3. Getting Started](#3-getting-started)
  - [4. Setting up required](#4-setting-up-required)

### <a id="sdlc-the-software-development-life-cycle">SDLC - The Software Development Life Cycle</a>

The Software Development Life Cycle (SDLC) consists of several stages or phases that describe the process of software development from conception to deployment and maintenance. There are many different variations. A basic overview includes planning, designing, developing, testing, then deploying. We hope to receive feedback throughout the SDLC to adapt to the changing needs and requirements for a project. 

![Basic SDLC](/images/basic-sdlc.png)

- **Plan**: This phase is used to gather and analyse requirements for the project, then break down the requirements into managable tasks, estimate the effort required and create a schedule.
- **Design**: This phase is used to create system architecture; design software components or modules; define data structures, algorithms, interfaces, other system specifications; user interface design (optional).
- **Develop**: The actual coding or programming of the software is done in this stage.
- **Test**: This stage is where the software undergoes various levels of testing to identify defects and ensure quality. The test cases are executed and issues are reported and fixed.
- **Deploy**: Once software has successfully passed the testing phase it is deployed to the target or production environment where users can access it. This phase also involves maintenance, monitoring, addressing user feedback and resolving issues that arise.

## <a id="what-is-cicd">What is CI/CD?</a>

CI/CD stands for Continuous Integration and Continuous Delivery (or Continuous Deployment). It is a software development approach that emphasizes automating the process of building, testing, and deploying applications. CI/CD workflows are known as **pipelines**. It is the **backbone of DevOps**.

**Continuous Integration (CI)** refers to the practice of frequently integrating code changes from multiple developers into a shared repository.

**Continuous Delivery (CD)** extends the concept of CI by automating certain steps in the release process, from building to testing. CD focuses on making sure that the application is always in a releasable state, but is not yet sent to the production environment (i.e. to users).
CD helps streamline the release process, reduce manual errors, and enable faster and more reliable software delivery.

### <a id="how-is-cicde-different">How is CI/CDE different?</a>

![CI/CD vs CI/CDE](https://www.softwaretestinghelp.com/wp-content/qa/uploads/2019/09/Difference.png)

CI/CDE is Continuous Integration and **Continuous Deployment (CDE)** rather than just Continuous Delivery.

**Continuous Deployment (CDE)** refers to automatically deploying the application (product) to production (i.e. to users) after passing all the necessary tests and quality checks (done in the CD stage).

### <a id="benefits-of-cicd">Benefits of CI/CD</a>

- Faster Time to Market
- Early Bug Detection
- Increased Developer Productivity
- Higher Software Quality
- Continuous Feedback and Collaboration
- Greater Deployment Stability
- Scalability and Agility
- To release software more efficiently
- save time and money with automation (scripting)

## <a id="what-is-jenkins">What is Jenkins?</a>

Jenkins is an open-source automation server that facilitates continuous integration (CI) and continuous delivery (CD) of software projects. It helps automate the build, test, and deployment processes, allowing teams to rapidly and reliably deliver software applications.

Jenkins is built with Java and requires latest (or a specific) version of Java to run. It listens at default port 8080. It integrates with AWS.

### <a id="what-are-the-stages-of-a-jenkins-pipeline">What are the stages of a Jenkins pipeline?</a>

In Jenkins, a job represents a specific task or workflow that needs to be executed. Jobs are composed of stages, which are the logical divisions of the overall process. Each stage represents a specific phase or step in the software delivery pipeline. Stages are used to break down complex tasks into smaller, more manageable units.

![Jenkins stages](/images/jenkins-stages.png)

1. An **SSH connection** must be established between **GitHub** and **Jenkins** so Jenkins can copy the updated code from GitHub automatically using a **Webhook Trigger**. This connection must be between Jenkins and a centralised GitHub repo (which allows for **continuous integratation** of different parts of projects, but **before merging** it **must be tested** (manual or automated)).
2. When the webhook is triggered, the code that Jenkins copies from GitHub undergoes automated testing which is taken care of by the **Agent Node**. If the tests are successful, the **Master Node** that is orchestrating this process will continuously deliver that code to the staging area or immediately deploy it to Production, in this case on AWS, depending on the CI/CD configuration.
3. If any tests fail, the **Agent Node** sends feedback back to the **developers via GitHub** so they can update the code for the next iteration.

Typically, a CI/CD pipeline in Jenkins consists of the following stages:

Checkout: This stage involves retrieving the latest source code from a version control system (e.g., Git) to ensure the subsequent stages operate on the most up-to-date codebase.

Build: In this stage, the code is compiled, dependencies are resolved, and artifacts (e.g., binaries or executable files) are generated. It ensures that the codebase is successfully built and ready for testing.

Test: The test stage involves running various types of tests to verify the correctness and quality of the code. This can include unit tests, integration tests, and system tests. The goal is to detect any issues or bugs early in the development process.

Analysis: In this stage, static code analysis tools can be used to identify code smells, potential bugs, or other issues in the codebase. It helps maintain code quality and adherence to coding standards.

Package: In this stage, the build artifacts, along with any required configurations or dependencies, are packaged into a deployable format. This could be a deployable archive or container image.

Deploy: The deployment stage involves taking the packaged artifacts and deploying them to the target environment, such as development, staging, or production. This can include activities like setting up infrastructure, configuring servers, and deploying the application.

Verify: After the deployment, this stage typically involves running additional tests or checks to ensure the application is functioning correctly in the target environment. It may include smoke tests, integration tests, or user acceptance testing (UAT).

Release: The release stage is responsible for promoting the application to the final production environment. It involves finalizing any necessary configurations, updating version numbers, and making the application available to end-users.

[Jenkins documentation - Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)

### <a id="agent-node-vs-master-node">Agent node vs Master node</a>

The **Master node** in Jenkins is the central coordination point of the Jenkins environment. It manages the system, schedules and coordinates jobs, and provides the web interface for managing Jenkins and viewing build results.

The **Agent node(s)** are additional machines or virtual environments that are connected to the Jenkins Master node. These nodes handle the actual build and testing tasks, separating them from the Master node to avoid resource conflicts.

Together, the Master node and the Agent node(s), form the foundation for Jenkins' distributed build capabilities and enhance the scalability and flexibility of the CI/CD pipeline.

### <a id="what-other-tools-are-available">What other tools are available?</a>

There are several alternative tools available that can be used for similar purposes as Jenkins.

Some popular ones include:

- GitLab CI/CD
- Travis CI
- CircleCI
- Bamboo (from Atlassian)
- Azure DevOps
- TeamCity (by JetBrains)

## <a id="webhooks">Webhooks</a>

A webhook is a mechanism that allows two applications or systems to communicate with each other in a real-time or near real-time manner. It is a way for one application to send a notification or trigger an action in another application when a specific event occurs.

Webhooks are commonly used for integrating and automating processes between different systems or services. Like between GitHub and Jenkins.

Webhook endpoints can be understood as URLs or web addresses that receive data from other applications or systems. They act as a destination where data is sent when a specific event or trigger occurs in the sending application.

You can see the actions taken by the webhooks on GitHub 'Manage webhook', 'Recent Deliveries'.

Follow the steps outlined [here](#create-webhook).

Alternatively follow the steps outlined in this link to set up a webhook on GitHub and Jenkins:
[Blazemeter - Set up a Webhook with GitHub and Jenkins](https://www.blazemeter.com/blog/how-to-integrate-your-github-repository-to-your-jenkins-project)

[Smee - proxy payloads from the webhook source](https://smee.io/)

### <a id="stopping-jenkins-on-aws">Stopping Jenkins on AWS</a>

If you stop the EC2 instance for Jenkins you need to get the new Public IP for your webhook. (It will not trigger and will show the errors on GitHub by your webhook if the EC2 instance for Jenkins is stopped or terminated.) If the webhook IP for Jenkins is correct and running then it will have a check mark next to it on GitHub. I finactive it will have a grey dot next to it.

You need both endpoints available and correct for the webhook to trigger the jobs.

# <a id="steps-to-set-up-a-jenkins-cicd-pipeline">Steps to set up a Jenkins CICD Pipeline</a>

## <a id="create-ssh-key-pair">1. Create SSH key pair</a>

Create SSH key pair on your device:
1. Open a terminal on your device and in the terminal use `cd ~/.ssh` to navigate to the hidden .ssh folder.

2. Generate a Key Pair: Use `ssh-keygen -t rsa -b 4096 -C "git_hub_email_address@gmail.com"` and replace the email with your GitHub one.

3. Follow the instructions in your terminal to `Enter file in which to save the key (/c/Users/Name/.ssh/id_rsa):` as `name-jenkins` (name of key) or similar and `Enter`. Then `Enter a passphrase:` and enter it again.

[More documentation on creating SSH keys](https://github.com/EstherSlabbert/tech230_github_ssh/blob/main/README.md)

## <a id="link-ssh-key-to-github">2. Link SSH key to GitHub</a>

Link SSH key pair to GitHub repo:
1. To get the public key to put into your GitHub repo use `cat name-jenkins.pub` (replace with name of key) in your terminal. Select what is returned in the terminal and copy it. (*Note: you must navigate to the .ssh folder in your terminal*)

2. On GitHub in your web browser go to the repository you desire to link with Jenkins. Navigate to 'Settings' > 'Deploy keys' then click on 'Add deploy key'. Ensure you check the box to allow write permissions.
   
![Add deploy key](/images/GitHub_public_ssh.png)
   
3. Add the name of your key (`name-jenkins`) as the 'Title' and paste your public SSH key from your terminal as 'Key'. Then add the key. You may be asked for your GitHub password, if so enter it.

## <a id="create-webhook">3. Create Webhook</a>

Create a webhook on GitHub:
1. Navigate to your GitHub repo > 'Settings' > 'Webhooks'. Click 'Add webhook'.

2. In the 'Payroll URL' enter your Jenkins url followed by `/github-webhook/` (e.g. `http://3.8.6.44:8080/github-webhook/`).

3. Select `application/json` as the 'Content Type'.

![Add webhook](/images/jenkins-github-webhook1.png)

4. Under 'Which events would you like to trigger this webhook?' either select 'Just the push event' or customise it by selecting 'Let me select individual events' for this webhook and then check the 'Pushes' option if it is not already selected.

![Webhook trigger1](/images/jenkins-github-webhook2.png)
![Webhook trigger2](/images/jenkins-github-webhook3.png)

1. Ensure 'Active' is checked.

![Active webhook](/images/jenkins-github-webhook4.png)

6. Click 'Add webhook'. You may be asked for your GitHub password, if so enter it. (You can edit the webhook later to make it not active if you no longer want it to trigger.)

## <a id="create-ci-job">4. Create CI job</a>

Create a project for CI job on Jenkins:

1. Navigate to Jenkins in your web browser and log in.

2. Click on 'New item'. 
   
![Jenkins new item](/images/new-item.png)

3. Name your job and select which kind you would like it to be. Then click 'OK'.

![Jenkins name project](/images/name-project.png)
   
4. Change the configurations under the 'General' block check 'Discard old builds' and enter `3` for 'Max # of builds to keep'. Then add the GitHub repo (containing the app to be tested) HTTPS url.

![Jenkins](/images/GitHub_project_url_https.png)

5. Change the configurations under the 'Office 365 Connector' block and check 'Restrict where this project can be run'. Then add `sparta-ubuntu-node` in the 'Label Expression' box.

![Jenkins Office 365 Connector](/images/ci-office-365.png)

6. Change the configurations under the 'Source Code Management' block and select 'Git'. Under the 'Repositories' section add the SSH url from your GitHub repo where it asks for 'Repository URL'. Then where it says credentials click the dropdown and select the appropriate SSH key that you have created/been assigned. If you do not have one yet follow the steps [here](#create-a-jenkins-ssh-key) to add one before continuing. Then change the 'Branches to build' section to have the correct branch name (i.e. `*/dev`).
   
![Jenkins Source Code Management](/images/updated-ci-source-code-management.png)
   
7. Change the configurations under the 'Build Triggers' and check 'GitHub hook trigger for GITScm polling'.

![Jenkins hook trigger](/images/jenkins-github_hook_trigger.png)

8. Change the configurations under the 'Build Environment' section and check 'Provide Node & npm bin/ folder to PATH'. It should fill out the selected environment settings as shown in the image below:

![Jenkins node environment](/images/node_env.png)

9. Change the configurations under the 'Build' section by clicking on the 'Add build step' drop down and selecting 'Execute shell'. Then add the required commands in the 'Command' box for testing eg.:
```shell
cd app
npm install
npm test
```
This specific testing will run 3 tests. (To check the time your system is running from use the `date` command. To check the OS of your system use the `uname -a` command.)

(Note: For any job you may use 'Post-build actions' to run another build on successful completion of current build by selecting the 'Add post-build action' drop down and selecting 'Build other projects' then specifying the name of the project in the 'Projects to build' box.)

10. Click 'Save' at the bottom of the screen.

11. Run the testing manually by clicking 'Build Now' from the page of your Jenkins project. Alternatively you can push to your GitHub repo and allow your webhook to automatically run the tests. This will spin up the necessary EC2 instances to complete the testing and will return the outcomes in the 'Console Output' under your 'Build History' in Jenkins under your project. The Console Output should display the following/similar if it was successful:

![Console Output1](/images/ci-console_output1.png)
![Console Output2](/images/ci-console_output2.png)
![Console Output3](/images/ci-console_output3.png)

Note: You can see what resources Jenkins copies over under the project's 'Workspace'. And clicking 'Build Now' will manually run any Jenkins job.

Additional Note: To check what triggered the build to run if we click 'Polling Log' to see the build log.

12. After setting up your Merge job you need to add the Merge job to this CI job in your 'Post-build Actions' by clicking on the 'Add post-build action' dropdown and selecting 'Build other Projects' and then adding the name of the Merge job in the 'Projects to build' box and ensuring that only 'Trigger only if build is stable' is selected.

![Post Build Automating Merge Job](/images/ci-post-build.png)

13. Save the configurations.

### <a id="create-a-jenkins-ssh-key">Create/Add a Jenkins SSH key:</a>

Add an SSH key to Jenkins inside a job:

1. Navigate to the correct place (skip this step if you are in the configuration settings already). Find your Jenkins project and click on it, then navigate to edit the configuration settings by clicking 'Configure' on the side bar.

2. Navigate to the 'Source Code Management' block and select 'Git'. Click the 'Add' drop down next to  'Credentials' and click 'Jenkins'. This will take you to the 'Add Credentials' page.

3. On the 'Add Credentials' page click the 'Kind' drop down and select 'SSH Username with private key'. Name your key under 'Username'. You may choose to give it a description (optional). 'ID' you can leave blank as it is not essential.

4. Select 'Enter directly' under 'Private Key', then click 'Add'. This should allow you to paste in your private key to match the GitHub public key stored in your .ssh folder. To get the private key to put into your Jenkins configurations use `cat name-jenkins` (replace with name of key) in your terminal. Select everything returned in the terminal and copy it. (*Note: you must navigate to the .ssh folder in your terminal*) You may also choose to add a passphrase (optional).

![Add SSH private key to Jenkins](/images/add-private-key-ssh-jenkins.png)

5. Then click 'Add' at the bottom of your page to add the new SSH credentials so they can be used.

## <a id="create-merge-job">5. Create Merge Job</a>

Create a Merge job on Jenkins:

1. Navigate to Jenkins in your web browser and log in.

2. Click on 'New item'.

3. Name your job and select which kind you would like it to be. Then click 'OK'.

![Name Merge Job](/images/merge-job1.png)

4. Change the configurations under the 'General' block check 'Discard old builds' and enter `2` for 'Max # of builds to keep'. Then add the GitHub repo (containing the app to be tested) HTTPS url.

![General config Merge](/images/jenkins-ci-merge1.png)

5. Change the configurations under the 'Office 365 Connector' block and check 'Restrict where this project can be run'. Then add `sparta-ubuntu-node` in the 'Label Expression' box.

![Office 365 Connector config Merge](/images/jenkins-ci-merge2.png)

6. Change the configurations under the 'Source Code Management' block and select 'Git'. Under the 'Repositories' section add the SSH url from your GitHub repo where it asks for 'Repository URL'. Then where it says credentials click the dropdown and select the appropriate SSH key that you have created/been assigned. If you do not have one yet follow the steps [here](#create-a-jenkins-ssh-key) to create one before continuing. Then change the 'Branches to build' section to have the correct branch name (i.e. `*/dev`).

![Office 365 Connector config Merge](/images/jenkins-ci-merge3.png)

8. Change the configurations under the 'Build Environment' section and check 'Provide Node & npm bin/ folder to PATH'.

![Build Environment config Merge](/images/jenkins-ci-merge4.png)

9. Change the configurations under the 'Post-build Actions' section by clicking on the 'Add post-build action' dropdown and selecting 'Git Publisher'. Check 'Push Only If Build Succeeds', then click 'Add Branch' in 'Branches' section and type `main` in the 'Branch to push' box and `origin` in the Target remote name box.

![Post-build Actions config Merge](/images/jenkins-ci-merge5.png)

10. Save the configurations. Test them.

11. After setting up your CD job you need to add the CD job to this Merge job in your 'Post-build Actions' by clicking on the 'Add post-build action' dropdown and selecting 'Build other Projects' and then adding the name of the CD job in the 'Projects to build' box and ensuring that only 'Trigger only if build is stable' is selected.

![Post-build Actions config Merge add CD job](/images/merge-post-build-cd-job.png)

12. Save the configurations.

[Link to steps for merge on Jenkins](https://andrewtarry.com/posts/jenkins_git_merges/)

## <a id="create-ec2-production-environment">6. Create EC2 production environment</a>

Create an EC2 production environment:

1. Go to AWS and log in.

2. Create an EC2 instance (`Ubuntu 18.04 LTS` or `Ubuntu 20.04` with `t2.micro` instance type).

Select `tech230` key pair.

Create/select a Security Group with the following permissions:
- SSH port `22` for Jenkins with 'Jenkins-IP/32' (eg. `3.8.6.44/32`)
- SSH port `22` for you to access with your IP (Select 'My IP' option)
- HTTP port `80` for 'Anywhere' to access (i.e. `0.0.0.0/0`)
- Custom TCP port `3000` for 'Anywhere' to access (i.e. `0.0.0.0/0`)

3. Set up the prerequisites for the Sparta Provisioning App. You can do this one of 3 ways: 1. Use an existing AMI of the App. 2. Use 'User Data'. 3. SSH into the EC2 instance and set it up using the commands manually after launch. See documentation [here](https://github.com/EstherSlabbert/tech230_AWS).

The important commands for setting the app EC2 up without a DB can be found below:
```
#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y

sudo apt install sed
sudo sed -i "s/try_files \$uri \$uri\/ =404;/proxy_pass http:\/\/localhost:3000\/;/" /etc/nginx/sites-available/default
sudo systemctl restart nginx

sudo apt-get install python-software-common
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs -y

git clone https://github.com/EstherSlabbert/app.git ~/app
cd ~/app
npm install
sudo npm install pm2 -g
pm2 kill
pm2 start app.js
```

4. Review the configurations and 'Launch'.

## <a id="create-cd-job">7. Create CD Job</a>

Create CD Job:

1. Navigate to Jenkins in your web browser and log in.

2. Click on 'New item'.

3. Name your job and select which kind you would like it to be. Then click 'OK'.

4. Change the configurations under the 'General' block check 'Discard old builds' and enter `2` for 'Max # of builds to keep'. Then add the GitHub repo (containing the app to be tested) HTTPS url.

![CD General config](/images/cd-config1.png)

5. Change the configurations under the 'Office 365 Connector' block and check 'Restrict where this project can be run'. Then add `sparta-ubuntu-node` in the 'Label Expression' box.

![CD Office 365 Connector config](/images/cd-config2.png)

6. Change the configurations under the 'Source Code Management' block and select 'Git'. Under the 'Repositories' section add the SSH url from your GitHub repo where it asks for 'Repository URL'. Then where it says credentials click the dropdown and select the appropriate SSH key that you have created/been assigned. If you do not have one yet follow the steps [here](#create-a-jenkins-ssh-key) to add one before continuing. Then change the 'Branches to build' section to have the correct branch name (i.e. `*/main`).

![CD Source Code Management config](/images/cd-config3.png)

7. Change the configurations under the 'Build Environment' section and check 'Provide Node & npm bin/ folder to PATH' and check 'SSH Agent', select 'Specific Credentials' and select the appropriate one for SSH into the EC2 instance (in this case `tech230.pem`). If you do not have the SSH key yet follow the steps [here](#create-a-jenkins-ssh-key) to add one to Jenkins before continuing.

![CD Source Code Management config](/images/cd-config5.png)

8. Change the configurations under the 'Build' section by clicking on the 'Add build step' drop down and selecting 'Execute shell'. Then add the required commands in the 'Command' box as follows, you must replace `ec2-public-ip` with the actual EC2 instance's public IP address:
```shell
# copies/replaces app folder from Jenkins Workspace onto the EC2 instance
scp -o "StrictHostKeyChecking=no" -r app ubuntu@ec2-public-ip:/home/ubuntu
# creates and runs a list of provision commands to deploy the Sparta app
ssh -o "StrictHostKeyChecking=no" ubuntu@ec2-public-ip <<EOF
cd /home/ubuntu/app
pm2 kill
pm2 start app.js
EOF
```
![CD Build config](/images/cd-config6.png)

9. Save the configurations.

## <a id="trigger">8. Trigger</a>

Trigger the Jenkins CICD pipeline:

1. Open a terminal and navigate using `cd` to the git repo on your local device.

2. Switch over to your `dev` branch with the command `git checkout dev`. (Your branch may be named something different, replace it with the correct name).

3. Make any change to a file in your repo. (Note: If you wish to change the message displayed like the provisioning page shown below step 5 you can go into 'app' > 'views' > open 'index.ejs' and change the line containing this: "The app is running correctly." to be "The app is running correctly. - Jenkins". _Be careful not to change anything else so you do not mess up the app's display._)

4. Complete the following commands to update and push the change made:
```shell
git add .
git commit -m "Your own message here"
git push -u origin dev
```

5. This push will trigger the CI job in Jenkins if the webhook is active and in place. If the CI job is successful it will trigger the Merge job, which upon success will trigger the CD job and will have merged the changes made to the dev branch to the main branch. If the CD job is successful and the EC2 instance had all the prerequisites needed installed then, upon success, the Sparta Provisioning App page should be accessible in your web browser through the public IP of your EC2 instance (You may need to add port 3000 to see if the reverse proxy is not set up in your EC2 instance).

![Sparta Provisioning Page](/images/Jenkins-success-app-page.png)

# <a id="steps-to-build-a-jenkins-server">Steps to build a Jenkins server</a>

[Jenkins - Installing Jenkins](https://www.jenkins.io/doc/book/installing/linux/)

[Hashnode - Install Jenkins on AWS](https://hashnode.com/post/installing-jenkins-on-linux-server-using-aws-ec2-ubuntu-1804-second-month-into-the-shecodeafrica-cloud-school-ckuf2qgep01fkvps1bd07fnu5)

[DigitalOcean - How to install Jenkins Ubuntu 18.04 LTS](https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04)

[Hostinger - Install Jenkins](https://www.hostinger.co.uk/tutorials/how-to-install-jenkins-on-ubuntu/)

[GitHub repo](https://github.com/aveshsri2005/install-jenkins-on-aws-ec2)

https://brain2life.hashnode.dev/how-to-add-jenkins-remote-build-agent-based-on-ubuntu-1804
https://devopscube.com/setup-slaves-on-jenkins-2/
https://adamtheautomator.com/jenkins-agent/

[DevOps Article - Install Jenkins on AWS EC2](https://devopsarticle.com/how-to-install-jenkins-on-aws-ec2-ubuntu-20-04/)

[Agent node](https://brain2life.hashnode.dev/how-to-add-jenkins-remote-build-agent-based-on-ubuntu-1804)

## <a id="create-ec2">1. Create EC2</a>

Specs:
Ubuntu 18.04 LTS (used this ami: ami-0a7493ba2bc35c1e9)
t2.micro

User Data:
```bash
#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y

# install git
sudo apt-get install git -y

# install nodejs
sudo apt-get install python-software-common
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs -y
```

Security Group rules = Allow needed access to port 8080, HTTP port 80, HTTPS port 443 and SSH port 22.
<!--- port 1433 for agent node --->

[Jenkins - Webhook Firewalls](https://www.jenkins.io/blog/2019/01/07/webhook-firewalls/)

[GitHub IPs](https://api.github.com/meta)

## <a id="set-up-dependencies-required">2. Set up dependencies required</a>

Install Java:

```bash
# gets necessary updates
sudo apt update
# install java 11
sudo apt-get install openjdk-11-jdk -y
# check version to verify installation - expect: openjdk version "11.0.19"
java -version
```

Install Jenkins (put in a 'provision.sh' script and run):
```bash
#!/bin/bash
# add repository key to system
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# add package repository
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# gets necessary updates
sudo apt-get update

# installs jenkins with necessary updates
sudo apt-get install jenkins
```

Start Jenkins:
```bash
# starts Jenkins
sudo systemctl start jenkins.service

# checks status of Jenkins
sudo systemctl status jenkins

# get password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# check firewall status
#sudo ufw status
```

![Jenkins Setup](/images/jenkins-github_hook_trigger.png)

## <a id="getting-started">3. Getting Started</a>

1. Go to the Public IP of your EC2 instance in your web browser, then enter your password from using `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`.

![Jenkins Setup Password](/images/jenkins-github_hook_trigger.png)

2. Follow the instructions on-screen to set up (Confirm url, create an Admin user and add additional/needed Plugins).

![URL](/images/url.png)

![Create Admin](/images/create-admin.png)

![Plugins 1](/images/plugins1.png)

![Plugins 2](/images/plugins2.png)

![Plugins 3](/images/plugins3.png)

![Plugins 4](/images/plugins4.png)

![Plugins 5](/images/plugins5.png)

![Plugins 6](/images/plugins6.png)

![Plugins 7](/images/plugins7.png)

![Plugins 8](/images/plugins8.png)

Click install. Wait until complete.

![Plugins installations](/images/installation-plugins.png.png)

Click 'Start using Jenkins'.

![Set up complete](/images/setup-complete.png)

You should be taken to the homepage:

![homepage](/images/start-page.png)

## <a id="getting-started">4. Setting up required</a>

1. Add NodeJS environment. Go to 'Manage Jenkins' > 'Tools' > 'Add NodeJS'. Give a name and select the required version of NodeJS and keep the rest the default settings.

![NodeJS 1](/images/npm-packager.png)

![NodeJS 2](/images/nodejs.png)

2. Allow a connection to GitHub. Go to 'Manage Jenkins' > 'Security' > 'Git Host Key Verification Configuration' and change to 'Accept first connection'.

![Allow git connection](/images/github-allow.png)

3. Create Jenkins Jobs for CI/CD pipeline.

4. Remember to change and activate your webhook on GitHub and to add the neccessary SSH keys to your Jenkins server.