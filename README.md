# low resource renew script for Let's Encrypt
 
## Introduction
Let's Encrypt is extremely popular when it comes to generating a certificate. This makes secure communication within everyone's reach.
Let's-Encrypt certificates have a validity of 90 days. It is possible to renew the certificate from 30 days before it expires.
This collection of scripts ensures that, unlike checking daily with crontab, a renew request is made 25 days before the expiration.

## Efficient renewal
> Certbot is a free, open source software tool for automatically using Let's Encrypt certificates on manually-administered websites to enable HTTPS.

This is according to the certbot site. This great tool has a renew-command that takes care of the renewal of your certificate. Certbot allows you to renew the certificate even 30 days before it expires. The renewal is the responsibility of the user, i.e. YOU. On the internet the common method for renewal is to call certbot renewal with crontab. I admit: this is a very simple and straightforward approach, since certbot will skip the renewal if it is not yet due. However, *if you check it daily after creation, it is likely that your attempt will be skipped about 60 times*. I have no insight into the precise operation of certbot's renew command, but when the renewal is skipped, the renew command does show a spike in both CPU load and I/O activity. 

Certbot can inform you about the validity period of a certificate. This allows you to calculate the earliest moment the certificate can be renewed. As stated, this can be a maximum of 30 days before the certificate expires. If you know when the earliest moment is that the renew command actually has an effect, you can schedule a renew job at that specific time, which is much more efficient and just as effective.

## Installation
### Used tools
Apart from cron and certbot this script uses the following tools:

- `at` -> to schedule a job (script) at a specific time
- `uuidgen` -> to generate a unique string

Both can be installed with 
```
sudo apt -y install at uuid-runtime
```
### Installation instructions
As sudo-er take the following steps:

1. copy the `renew.sh` script into the directory /etc/letsencrypt
2. with your favorite editor replace the line `mydomain.example.com` with your own domain 
3. set the execution flag for the script:
```
chmod +x renew.sh
```
4. add this line to crontab to repeat the job
```
0 13,19 * * * /bin/bash -c /etc/letsencrypt/renew.sh
```
## Remarks
1. With the above line in crontab the script runs twice a day, i.e. twice as much as the most  certbot renewal scripts. It is however very fast and generates hardly any load. You can adapt the crontab line to reduce the frequency to once a day or even once a week. The side effect is that the initiation of the script may take longer to happen.
2. you can - of course as sudo-er - start the renew script manually. That will result in a scheduled job. You can always check if the job is there with `atq`.
3. if you use m/monit to monitor your processes, you can use monit instead of cron. The monit- configuration looks like this:
```
check file renew-due with path /etc/letsencrypt/renewisdue
   every 5 cycles
   start program = "/bin/bash -c '/etc/letsencrypt/renew.sh'"
   if does not exist then start
```
4. Enjoy, --Edgar 
