#!/bin/bash
## renewal script for Let's Encrypt certificates
## =============================================
# 2024-02-21 EdHi - initial release
## =============================================
# this script is called from:
# 1. cron - no parameter, to initiate/check the renewal process
# 2. at - with parameter, to actually perform the renewal
#
## settings
#
DMN=mydomain.example.com   # the domain
WD=/etc/letsencrypt        # the working directory containing this script
FLAG=${WD}/renewisdue      # the name of the flag
IAM=${WD}/$(basename $0)   # path/name of the script
SAFETY=25                  # number of days before expiration to allow renewal (10-29)
#
if [ -f ${FLAG} ]; then
#  The flag exists -> is it mine?
	if ! grep -Fxq "$1" ${FLAG}; then
	# not mine, but is there a job connected to this FLAG?
		if grep -Fq "`cat ${FLAG}`" `ls -1 /var/spool/cron/atjobs/*`; then 
#		   yes, found a job, no further action required
			exit 1;
#		else 
#			no, job not found, this FLAG is invalid, create a new one
#			rm -f ${FLAG} 
		fi
	fi
fi
#
## here in case of one of these conditions:
# - flag does not exist
# - flag does exist and is connected to this job
# - flag does exist, but without a connecting job
# 
## steps:
# 1. retrieve number of days until expiration
# 2. substract 'safety' days
# 3. convert negative days to zero
# 4. if zero days left, then 
# 4.a.1 RENEW
# 4.a.2 remove the FLAG: job is done!
# 4. else
# 4.b.1 create a new FLAG with a unique ID
# 4.b.1 schedule job @ now + days left
#
DAYS=`certbot certificates -d ${DMN} 2>&1 | egrep -o '\(.+\)' | cut -d" " -f2`
DAYS=$(( ${DAYS}-${SAFETY} ))
DAYS=$(( DAYS < 0 ? 0 : DAYS ))
if (( ${DAYS} == 0 )); then
#	echo "renew"
	certbot renew
	rm -f ${FLAG}
else
#	echo "reschedule in " ${DAYS}
	MYID=`uuidgen -t`
	echo ${MYID} > ${FLAG}
	echo ${IAM} ${MYID} | at -M `date -d"now + ${DAYS} day" +%H:%M\ %Y-%m-%d` > /dev/null 2>&1
fi
exit 0;

