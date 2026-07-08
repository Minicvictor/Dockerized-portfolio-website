# Portfolio Website — Jenkins CI Pipeline

Automated CI pipeline that builds, tests, and deploys a Dockerized portfolio
website using Jenkins, triggered automatically on every push to `main` via a
GitHub webhook.

**Student:** Egwu Chidiebere Agha
**GitHub:** [@minicvictor](https://github.com/minicvictor)
**Course:** Cloud & DevOps Engineering

-----

## Objective

Configure Jenkins to automatically build and run the portfolio website using
a `Jenkinsfile` stored in this repository, with builds triggered on every
`git push` — no manual “Build Now” required.

-----

## Repository Contents

|File                     |Purpose                                           |
|-------------------------|--------------------------------------------------|
|`Jenkinsfile`            |Defines the CI/CD pipeline stages                 |
|`Dockerfile`             |Builds the nginx:alpine image that serves the site|
|`index.html`, CSS, assets|The portfolio website itself                      |

-----

## Pipeline Stages

The `Jenkinsfile` defines six stages, executed sequentially on every
triggered build:

1. **Checkout** — Pulls the latest commit from the `main` branch of the
   GitHub repository.
1. **Install Dependencies** — Verifies the Docker toolchain is available on
   the Jenkins agent. (This is a static HTML/CSS site, so there are no
   package manager dependencies to install; this stage stands in for where
   `npm install` or similar would go for a non-static app.)
1. **Build** — Builds the Docker image from the `Dockerfile` and tags it
   with the Jenkins build number and `latest`.
1. **Test** *(extra credit)* — Runs the freshly built image on a temporary
   port and `curl`s it as a smoke test before deploying.
1. **Run Application** — Stops any previous container and deploys the new
   image on port 80.
1. **Cleanup** *(extra credit)* — Removes dangling Docker images to reclaim
   disk space on the Jenkins host.

-----

## Tools Used

- **Jenkins** — orchestrates the pipeline: pulls the `Jenkinsfile` from
  GitHub, runs each stage, reports build status.
- **Docker** — builds the nginx:alpine-based image and runs the portfolio
  site as a container.
- **GitHub** — hosts the source repository and `Jenkinsfile`; a webhook
  notifies Jenkins on every push.
- **Blue Ocean** — visual pipeline view for monitoring stage-by-stage
  progress and status.
- **Git Plugin / Pipeline Plugin / Docker Pipeline Plugin** — Jenkins
  plugins that enable Git integration and Docker-based pipeline steps.
- **nginx:alpine** — lightweight web server base image that serves the
  static HTML/CSS portfolio.

-----

## Setup Instructions

### 1. Install and configure Jenkins

Install Jenkins (see course setup guide for the full EC2/apt install), then:

- **Manage Jenkins → Plugins → Available**, install:
  - `Git`
  - `Pipeline`
  - `Blue Ocean`
  - `Docker Pipeline`
- Restart Jenkins after install.
- Ensure the `jenkins` user can run Docker: add it to the `docker` group and
  restart the service.

### 2. Connect GitHub to Jenkins

- **Manage Jenkins → System → GitHub → Add GitHub Server**, and add a
  Personal Access Token so Jenkins can authenticate against the repo and
  webhook API.

### 3. Create the Pipeline Job

- **New Item → Pipeline**, name it `portfolio-ci`.
- Pipeline → Definition: `Pipeline script from SCM`
- SCM: `Git`
- Repository URL: `https://github.com/minicvictor/portfolio-jenkins-ci.git`
- Branch Specifier: `*/main`
- Script Path: `Jenkinsfile`
- Save, then run once manually (**Build Now**) to confirm a clean pass.

### 4. Configure the GitHub Webhook

- In the Jenkins job config, enable **GitHub hook trigger for GITScm
  polling**.
- In the GitHub repo: **Settings → Webhooks → Add webhook**
  - Payload URL: `http://<JENKINS-IP>:8080/github-webhook/`
  - Content type: `application/json`
  - Events: `Just the push event`
- Push a commit to `main`. Under **GitHub → Webhooks → Recent Deliveries**
  it should show `200 OK` — this proves the pipeline triggers automatically,
  with no manual click needed.

### 5. Verify the deployed app

After the pipeline finishes, visit `http://<SERVER-IP>` (port 80) in a
browser. The portfolio site should load.

-----

## Submission Screenshots

- [ ] Jenkins Blue Ocean pipeline graph, all stages green, `Finished: SUCCESS`
- [ ] GitHub Webhook → Recent Deliveries showing a green checkmark / `200 OK`
- [ ] Running portfolio site in a browser

-----

## Challenges Encountered

|Challenge                     |Cause                                                                                                                  |Resolution                                                                                                                             |
|------------------------------|-----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|
|Jenkins couldn’t access Docker|The `jenkins` user wasn’t in the `docker` group / socket wasn’t mounted, so it lacked permission to run Docker commands|Added the `jenkins` user to the `docker` group (or mounted `/var/run/docker.sock` when running Jenkins in Docker) and restarted Jenkins|
|Webhook not triggering builds |Jenkins port 8080 wasn’t reachable from GitHub, or the payload URL was incorrect                                       |Made port 8080 reachable and set the correct payload URL; verified with `200 OK` in Recent Deliveries                                  |
|Port already in use on re-run |A container from a previous build was still bound to the port                                                          |Added `docker stop` / `docker rm` (with `                                                                                              |

**How resolved:** Checked Jenkins console/build logs for each failing stage,
used Docker CLI commands directly on the host to reproduce and debug issues,
and confirmed network/firewall rules allowed the required ports before
retrying the pipeline.

-----

## Conclusion

This pipeline demonstrates a complete Jenkins-based CI/CD workflow: a push
to GitHub automatically triggers a build, the application is containerized
and smoke-tested, and a successful build is deployed live without manual
intervention.
