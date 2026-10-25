# nexus-artifacts-lab

Sonatype Nexus Repository on an Azure VM for one session: my Gradle and Maven builds published to it, and the app deployed from it. Lab work from week 4 of my Azure and DevOps training.

## How it runs
- The VM comes from my Bicep file in azure-linux-vm-bicep: a Standard_B4ms (4 vCPUs, 16 GiB, Sonatype's smallest supported size) with SSH from my IP only.
- install-nexus.sh installs Nexus as a systemd service under its own nexus account.
- Port 8081 stays closed to the internet. I reach Nexus through an SSH tunnel: ssh -f -N -L 8081:localhost:8081
- A deployer user can only write to maven-snapshots; anonymous users can read.

## Publish
- Gradle (gradle-app): the maven-publish plugin in build.gradle, credentials from ~/.gradle/gradle.properties, then ./gradlew publish
- Maven (maven-app): distributionManagement in pom.xml, credentials from ~/.m2/settings.xml, then ./mvnw deploy

## Deploy from Nexus
deploy-app.sh from my scripting-toolbox repo, given Nexus's search API URL (sort=version), pulls the newest jar onto the server and runs it as a service.

## Nexus, Azure Artifacts or Azure Container Registry
| | Nexus | Azure Artifacts | Azure Container Registry |
|---|---|---|---|
| Stores | Maven, npm, NuGet, PyPI, Docker and more | Maven, npm, NuGet, Python, Cargo and Universal Packages | Container images, Helm charts and other OCI artifacts |
| Who runs it | You: the server, upgrades and backups | Microsoft, as part of Azure DevOps | Microsoft, as an Azure resource |
| Cost | The VM and its disk | 2 GiB free per organisation, then per GiB | A daily rate per tier (Basic, Standard, Premium) |

## When I'd pick each
- 
- 
- 

## Cost
About 15p an hour in UK South while it runs; the resource group is deleted after each session.

## What I learned
- 
- 
- 
