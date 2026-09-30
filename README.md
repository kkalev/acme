mod_md reference based on `httpd:2.4-trixie` official Docker image.

* Build: `docker compose build`
* Edit environment variables
* Run: `docker compose up -d` (listens on ports `80` and `443`)
* Read `md-status`: `curl http://<site>/.well-known/md-status | jq`
* Certificates will be in `/usr/local/apache2/md/domains/<domain>`:
```
# ls /usr/local/apache2/md/domains/<domain>/
job.json  md.json  privkey.pem  pubcert.pem
```

## Renewal
* mod_md will place the new certificate in `md/staging/<domain>`
* It will call the `MDMessageCmd`. The first argument will be the [action](https://httpd.apache.org/docs/2.4/mod/mod_md.html#mdmessagecmd):
  - `renewed`: A new certificate has been obtained and is stored in the `staging` area in the MD store.
  - `installed`: is triggered when a new certificate has been transferred from staging into the domains location in MD store. This happens at server startup/reload.
  - `renewing`: is triggered before starting renew process for the managed domain.
* We have setup a script (`md-notify.sh`) that will check for the `renewed` event and trigger a server reload by sending a `USR1` signal. Since the script is run by the Apache children (which don't run as root) we do some gymnastics by adding a `CAP_KILL` to `/bin/kill`