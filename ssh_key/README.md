# SSH Key

This directory should contain the private/public key combination which will be used for sshing onto the public hosts.
The ssh keys are also used to ssh to the private server from the ssh bastion.

Place your public ssh key here, it will be used for sshing onto the public ec2 instance.
Generating an ssh on mac
```
ssh-keygen -t rsa -b 4096
```
