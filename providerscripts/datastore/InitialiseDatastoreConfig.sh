
export HOME="`/bin/cat /home/homedir.dat`"

if ( [ "`${HOME}/providerscripts/utilities/CheckBuildStyle.sh 'DATASTORETOOL:s3cmd'`" = "1" ] )
then

    S3_ACCESS_KEY="`${HOME}/providerscripts/utilities/ExtractConfigValue.sh 'S3ACCESSKEY'`"
    S3_SECRET_KEY="`${HOME}/providerscripts/utilities/ExtractConfigValue.sh 'S3SECRETKEY'`"
    S3_LOCATION="`${HOME}/providerscripts/utilities/ExtractConfigValue.sh 'S3LOCATION'`"
    S3_HOST_BASE="`${HOME}/providerscripts/utilities/ExtractConfigValue.sh 'S3HOSTBASE'`"

    if ( [ -f ${HOME}/.s3cfg ] )
    then
        /bin/rm ${HOME}/.s3cfg
    fi

    /bin/cp ${HOME}/providerscripts/datastore/configfiles/s3-cfg.tmpl ${HOME}/.s3cfg

    if ( [ "${S3_ACCESS_KEY}" != "" ] )
    then
        /bin/sed -i "s/XXXXACCESSKEYXXXX/${S3_ACCESS_KEY}/" ${HOME}/.s3cfg
    else
        /bin/echo "${0} Couldn't find the S3_ACCESS_KEY setting" >> ${HOME}/logs/initialbuild/BUILD_PROCESS_MONITORING.log  
    fi

    if ( [ "${S3_SECRET_KEY}" != "" ] )
    then
        /bin/sed -i "s/XXXXSECRETKEYXXXX/${S3_SECRET_KEY}/" ${HOME}/.s3cfg
    else
        /bin/echo "${0} Couldn't find the S3_SECRET_KEY setting" >> ${HOME}/logs/initialbuild/BUILD_PROCESS_MONITORING.log     
    fi

    if ( [ "${S3_LOCATION}" != "" ] )
    then
        /bin/sed -i "s/XXXXLOCATIONXXXX/${S3_LOCATION}/" ${HOME}/.s3cfg
    else
        /bin/echo "${0} Couldn't find the S3_LOCATION setting" >> ${HOME}/logs/initialbuild/BUILD_PROCESS_MONITORING.log    
    fi

    if ( [ "${S3_HOST_BASE}" != "" ] )
    then
        /bin/sed -i "s/XXXXHOSTBASEXXXX/${S3_HOST_BASE}/" ${HOME}/.s3cfg
    else
        /bin/echo "${0} Couldn't find the S3_HOST_BASE setting" >> ${HOME}/logs/initialbuild/BUILD_PROCESS_MONITORING.log  
    fi

    if ( [ -f /root/.s3cfg ] )
    then
        /bin/rm /root/.s3cfg
    fi

    /bin/cp ${HOME}/.s3cfg /root/.s3cfg

    /usr/bin/s3cmd mb s3://1$$agile 3>&1 2>/dev/null
    /usr/bin/s3cmd rb s3://1$$agile 3>&1 2>/dev/null

    if ( [ "$?" != "0" ] )
    then
         /bin/echo "${0} Your datastore didn't configure correctly on this machine and that will cause the deployment to break" >> ${HOME}/logs/initialbuild/BUILD_PROCESS_MONITORING.log  
    fi
fi

