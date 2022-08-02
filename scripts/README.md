This directory contains any scripts that should be used for bootstrapping.

`startup.sh`
> This script is used to ssh and check external network connectivity on the private hosts that are available during provisioning.
> The script receives various variable that are passed in through terraform, and are referenced in order to complete the testing.

`${SERVER_ADDRESSES}` is an example of a variable that is passed in via the terraform configuration.
