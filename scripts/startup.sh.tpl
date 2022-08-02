#!/bin/bash

# for each host check if we are able to curl google
HOSTS=${SERVER_ADDRESSES}

# modify private key permissions
chmod 400 ${SSH_KEY_PATH}

for i in $${HOSTS//,/ }
do
    ssh -o "StrictHostKeyChecking no" -i ${SSH_KEY_PATH} ${USERNAME}@$${i} 'curl https://google.com'
done
