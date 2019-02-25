#!/bin/bash

source setup_env.sh
if ( ! [ -f ../terraform/infrastructure/terraform-ec2-ssh-key ] ); then {
 echo "Creating ssh keys for infrastructure deployments"
 rm -f ../terraform/infrastructure/terraform-ec2-ssh-key*
 echo | ssh-keygen -qf ../terraform/infrastructure/terraform-ec2-ssh-key
}
fi
