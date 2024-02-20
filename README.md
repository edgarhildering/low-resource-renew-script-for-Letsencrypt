# renew script for Letsencrypt
 renew script for Letsencrypt
 
 # Introduction
 Let's Encrypt is extremely popular when it comes to generating a certificate. This makes secure communication within everyone's reach.
Let's-Encrypt certificates have a validity of 90 days. It is possible to renew the certificate from 30 days before it expires.
This collection of scripts ensures that, unlike checking daily with crontab, a renew request is made 25 days before the expiration.

# How it works
> Certbot is a free, open source software tool for automatically using Let's Encrypt certificates on manually-administered websites to enable HTTPS.
This is according to the certbot site. I also chose this tool. With certbot it is possible to request the validity period of a certificate. This allows you to calculate at what time the certificate can be renewed (this can be a maximum of 30 days before the certificate expires. I chose 25 days, but the choice is arbitrary between 0 and 30. 


