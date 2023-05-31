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
  - [Set up Jenkins-GitHub automation test](#set-up-jenkins-github-automation-test)
    - [Create a Jenkins SSH key:](#create-a-jenkins-ssh-key)
  - [Set up Jenkins-GitHub merge](#set-up-jenkins-github-merge)

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

Follow the steps outlined in step 3 [here](#set-up-jenkins-github-automation-test)

Alternatively follow the steps outlined in this link to set up a webhook on GitHub and Jenkins:
[Blazemeter - Set up a Webhook with GitHub and Jenkins](https://www.blazemeter.com/blog/how-to-integrate-your-github-repository-to-your-jenkins-project)

### <a id="stopping-jenkins-on-aws">Stopping Jenkins on AWS</a>

If you stop the EC2 instance for Jenkins you need to get the new Public IP for your webhook. (It will not trigger and will show the errors on GitHub by your webhook if the EC2 instance for Jenkins is stopped or terminated.) If the webhook IP for Jenkins is correct and running then it will have a check mark next to it on GitHub. I finactive it will have a grey dot next to it.

You need both endpoints available and correct for the webhook to trigger the jobs.

## <a id="set-up-jenkins-github-automation-test">Set up Jenkins-GitHub automation test</a>

1. Create SSH key pair on your device:
   1. Open a terminal on your device and in the terminal use `cd ~/.ssh` to navigate to the hidden .ssh folder.

   2. Generate a Key Pair: Use `ssh-keygen -t rsa -b 4096 -C "git_hub_email_address@gmail.com` and replace the email with your GitHub one.

   3. Follow the instructions in your terminal to `Enter file in which to save the key (/c/Users/Name/.ssh/id_rsa):` as `name-jenkins` (name of key) or similar and `Enter`. Then `Enter a passphrase:` and enter it again.

2. Link SSH key pair to GitHub repo:
   1. To get the public key to put into your GitHub repo use `cat name-jenkins.pub` (replace with name of key) in your terminal. Select what is returned in the terminal and copy it. (*Note: you must navigate to the .ssh folder in your terminal*)

   2. On GitHub in your web browser go to the repository you desire to link with Jenkins. Navigate to 'Settings' > 'Deploy keys' then click on 'Add deploy key'.
   
   ![Add deploy key](/images/GitHub_public_ssh.png)
   
   3. Add the name of your key (`name-jenkins`) as the 'Title' and paste your public SSH key from your terminal as 'Key'. Then add the key. You may be asked for your GitHub password, if so enter it.

3. Create a webhook on GitHub:
   1. Navigate to your GitHub repo > 'Settings' > 'Webhooks'. Click 'Add webhook'.

   2. In the 'Payroll URL' enter your Jenkins url followed by `/github-webhook/`.

   3. Select `application/json` as the 'Content Type'.

   ![Add webhook](/images/jenkins-github-webhook1.png)

   4. Under 'Which events would you like to trigger this webhook?' either select 'Just the push event' or customise it by selecting 'Let me select individual events' for this webhook and then check the 'Pushes' option if it is not already selected.

   ![Webhook trigger1](/images/jenkins-github-webhook2.png)
   ![Webhook trigger2](/images/jenkins-github-webhook3.png)

   5. Ensure 'Active' is checked.

   ![Active webhook](/images/jenkins-github-webhook4.png)

   6. Click 'Add webhook'. You may be asked for your GitHub password, if so enter it. (You can edit the webhook later to make it not active if you no longer want it to trigger.)

4. Create a project on Jenkins:
   1. Navigate to Jenkins in your web browser and log in.

   2. Click on 'New item'. 
   
   ![Jenkins new item](/images/new-item.png)

   3. Name your job and select which kind you would like it to be. Then click 'OK'.

   ![Jenkins name project](/images/name-project.png)
   
   4. Change the configurations under the 'General' block check 'Discard old builds' and enter `3` for 'Max # of builds to keep'. Then add the GitHub repo (containing the app to be tested) HTTPS url.

   ![Jenkins](/images/GitHub_project_url_https.png)

   5. Change the configurations under the 'Office 365 Connector' block and check 'Restrict where this project can be run'. Then add `sparta-ubuntu-node` in the 'Label Expression' box.

   6. Change the configurations under the 'Source Code Management' block and select 'Git'. Under the 'Repositories' section add the SSH url from your GitHub repo where it asks for 'Repository URL'. Then where it says credentials click the dropdown and select the appropriate SSH key that you have created/been assigned. If you do not have one yet follow the steps [here](#create-a-jenkins-ssh-key) to create one before continuing. Then change the 'Branches to build' section to have the correct branch name (i.e. `*/main`).
   
   ![Jenkins Source Code Management](/images/Git_SourceCode_ssh.png)
   
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

   (Note: You may use 'Post-build actions' to run another build on successful completion of current build by selecting the 'Add post-build action' drop down and selecting 'Build other projects' then specifying the name of the project in the 'Projects to build' box.)

   10. Click 'Save' at the bottom of the screen.

   11. Run the testing manually by clicking 'Build Now' from the page of your Jenkins project. Alternatively you can push to your GitHub repo and allow your automation webhook to run the tests. This will spin up the necessary EC2 instances to complete the testing and will return the outcomes in the 'Console Output' under your 'Build History' in Jenkins under your project. The Console Output should display the following/similar if it was successful:

   ![Console Output1](/images/console_output1.png)
   ![Console Output2](/images/console_output2.png)
   ![Console Output3](/images/console_output3.png)

Note: You can see what resources Jenkins copies over under the project's 'Workspace'.

Additional Note: To check what triggered the build to run if we click 'Polling Log' to see the build log.

[More documentation on SSH](https://github.com/EstherSlabbert/tech230_github_ssh/blob/main/README.md)

### <a id="create-a-jenkins-ssh-key">Create a Jenkins SSH key:</a>

1. Navigate to the correct place (skip this step if you are in the configuration settings already). Find your Jenkins project and click on it, then navigate to edit the configuration settings by clicking 'Configure' on the side bar.

2. Navigate to the 'Source Code Management' block and select 'Git'. Click the 'Add' drop down next to  'Credentials' and click 'Jenkins'. This will take you to the 'Add Credentials' page.

3. On the 'Add Credentials' page click the 'Kind' drop down and select 'SSH Username with private key'. Name your key under 'Username'. You may choose to give it a description (optional). 'ID' you can leave blank as it is not essential.

4. Select 'Enter directly' under 'Private Key', then click 'Add'. This should allow you to paste in your private key to match the GitHub public key stored in your .ssh folder. To get the private key to put into your Jenkins configurations use `cat name-jenkins` (replace with name of key) in your terminal. Select everything returned in the terminal and copy it. (*Note: you must navigate to the .ssh folder in your terminal*) You may also choose to add a passphrase (optional).

![Add SSH private key to Jenkins](/images/add-private-key-ssh-jenkins.png)

5. Then click 'Add' at the bottom of your page to add the new SSH credentials so they can be used.

## <a id="set-up-jenkins-github-merge">Set up Jenkins-GitHub merge</a>

[Git merge on Jenkins steps](https://andrewtarry.com/posts/jenkins_git_merges/)

Test1