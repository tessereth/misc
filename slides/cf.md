# Cloud Foundry

&nbsp;

## A miscellaneous collection of Cloud Foundry information

---

# Structure

--

<img src="https://www.lucidchart.com/publicSegments/view/11858677-0236-4f3c-b363-1af93fa058b2/image.png" class="stretch"></img>

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
cf target # show current target
cf target -o <org> -s <space>
```

`cf login` will prompt for information you don't provide

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

        ln -s .gitignore .cfignore

---

# manifest.yml

Set all the things!

[https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html)

```yaml
inherit: manifest-base.yml
buildpack: staticfile_buildpack
memory: 512M
disk_quota: 256M
```

* `cf buildpacks` - list builtin buildpacks
* `cf app <name>` - show current memory/disk usage

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

With [user provided services](https://docs.cloudfoundry.org/devguide/services/user-provided.html)

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

Creating and deleting users -> done by an admin

Managing permissions -> done by you

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

with the [18F app manager dashboard](https://app-manager-staging.apps.staging.digital.gov.au/)
