# CICD with Jenkins

- [CICD with Jenkins](#cicd-with-jenkins)
    - [SDLC - The Software Development Life Cycle](#sdlc---the-software-development-life-cycle)
    - [What is CI/CD?](#what-is-cicd)
    - [What is CI/CDE and how is it different?](#what-is-cicde-and-how-is-it-different)
    - [What is Jenkins?](#what-is-jenkins)
    - [What are the stages of Jenkins?](#what-are-the-stages-of-jenkins)
    - [What other tools are available?](#what-other-tools-are-available)
  - [Webhooks](#webhooks)

### <a id="sdlc-the-software-development-life-cycle">SDLC - The Software Development Life Cycle</a>



### <a id="what-is-cicd">What is CI/CD?</a>

CI/CD stands for Continuous Integration and Continuous Delivery (or Continuous Deployment). It is a software development approach that emphasizes automating the process of building, testing, and deploying applications.

**Continuous Integration (CI)** refers to the practice of frequently integrating code changes from multiple developers into a shared repository.

**Continuous Delivery (CD)** extends the concept of CI by automating the entire release process, from building and testing to deployment.

### <a id="what-is-cicde-and-how-is-it-different">What is CI/CDE and how is it different?</a>

CI/CDE includes **Continuous Deployment (CDE)** in CI/CD.

**Continuous Deployment (CDE)** refers to automatically deploying the application to production after passing all the necessary tests and quality checks.

### <a id="what-is-jenkins">What is Jenkins?</a>

Jenkins is an open-source automation server that facilitates continuous integration (CI) and continuous delivery (CD) of software projects. It helps automate the build, test, and deployment processes, allowing teams to rapidly and reliably deliver software applications.

### <a id="what-are-the-stages-of-jenkins">What are the stages of Jenkins?</a>

In Jenkins, a job represents a specific task or workflow that needs to be executed. Jobs are composed of stages, which are the logical divisions of the overall process. Each stage represents a specific phase or step in the software delivery pipeline. Stages are used to break down complex tasks into smaller, more manageable units.

![Jenkins stages](/images/jenkins-stages.png)

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

[Blazemeter - Set up a Webhook with GitHub and Jenkins](https://www.blazemeter.com/blog/how-to-integrate-your-github-repository-to-your-jenkins-project)