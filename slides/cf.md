# Cloud Foundry

&nbsp;

## A miscellaneous collection of Cloud Foundry information

---

# What is cloud foundry?

--

## Question: 

I've written this web app and I want it on the internet.  
What do I do?

## Answer: 

Cloud foundry!

--

Software as a Service

&varr;

## Platform as a Service

&varr;

Infrastructure as a Service

---

# Managing your apps

* command line
* [pivotal app manager](https://apps.system.staging.digital.gov.au/)
* [18F app manager](https://app-manager-staging.apps.staging.digital.gov.au/)

---

# Structure

--

<img src="https://www.lucidchart.com/publicSegments/view/cb86352a-98dd-4873-a7fd-098d568c488a/image.png" class="stretch"></img>

Note:
Source: 
https://www.lucidchart.com/documents/edit/993bff1e-2d95-413f-8b57-1516a58d0699

---

# CF CLI

[https://github.com/cloudfoundry/cli#downloads](https://github.com/cloudfoundry/cli#downloads)

```bash
cf --help
cf <command> --help
```

--

# Login and target

```bash
cf login -a https://api.system.staging.digital.gov.au \
  -u <email> -o <org> -s <space>
```

`cf login` will prompt for information you don't provide

```bash
cf target # show current target
cf target -o <org> -s <space>
```

---

# Create an app

```bash
cd <repo-directory>
cf push <app-name>
```

* Will use `./manifest.yml` by default 
    * override with `-f`
* Uploads all files in the current directory
* Use `.cfignore` to ignore files (`bundle/vendor` etc)

```bash
ln -s .gitignore .cfignore
```

---

# manifest.yml

Set all the things!

[https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html)

```yaml
buildpack: staticfile_buildpack
memory: 512M
disk_quota: 256M
applications:
- name: <name>
```

* `cf buildpacks` - list builtin buildpacks
* `cf app <name>` - show current memory/disk usage

--

# Inheritance

`mainfest.yml`

```yaml
buildpack: staticfile_buildpack
memory: 512M
disk_quota: 256M
```

`manifest-prod.yml`

```yaml
inherit: manifest.yml
applications:
- name: app-blue
- name: app-green
```

---

# Services

Backing services for your app. Includes:

* Databases
* Redis
* etc, etc...

Persist between app updates

Live in a particular space

--

# Manage services

List service types

```bash
cf marketplace
```

List service instances

```bash
cf services
```

Create a service instance

```bash
cf create-service <service-type> <service-plan> <service-name>
```

--

# Bind services

Bind to your app

```bash
cf bind-service <app-name> <service-name>
```

with `manifest.yml`

```yaml
services:
  - <service-name>
```

Access service info (eg credentials) with the VCAP_SERVICES environment variable

```ruby
services = JSON.parse(ENV['VCAP_SERVICES'])
```

--

# Manage services

with the [pivotal app manager](https://apps.system.staging.digital.gov.au/)

with the [18F app manager](https://app-manager-staging.apps.staging.digital.gov.au/)

---

# Environment variables

with the command line

```bash
cf set-env <app-name> <variable-name> <variable-value>
```

with `manifest.yml`

```yaml
env:
  <variable-name>: <variable-value>
```

with the [pivotal app manager](https://apps.system.staging.digital.gov.au/)

--

# Environment variables

with [user provided services](https://docs.cloudfoundry.org/devguide/services/user-provided.html)

```
cf cups <service-name> -p '{"<variable-name>":"<variable-value>"}'
cf bind-service <app-name> <service-name>
```

* `cups == create-user-provided-service`
* Access via `VCAP_SERVICES` envar

```ruby
s = JSON.parse(ENV['VCAP_SERVICES'])
value = s['user-provided'][0]['credentials']['<variable-name>']
```

---

# User Management

Creating and deleting users &rarr; done by an admin

Managing permissions &rarr; done by you

--

# Roles

[https://docs.cloudfoundry.org/concepts/roles.html](https://docs.cloudfoundry.org/concepts/roles.html)

* OrgManager
* OrgAuditor
* SpaceManager
* SpaceDeveloper
* SpaceAuditor

Managers grant and revoke roles

Developers manage apps and services

Auditors have read-only access

--

# Manage roles

with the command line ([cloud docs](http://docs.cloud.gov.au/deployment_configuration/user_management/))

```bash
cf org-users
cf [un]set-org-role
cf space-users
cf [un]set-space-role
```

with the [18F app manager](https://app-manager-staging.apps.staging.digital.gov.au/)

---

# Next time

Routes and domains
