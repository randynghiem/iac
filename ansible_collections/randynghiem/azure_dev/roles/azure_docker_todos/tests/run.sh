#!/usr/bin/env bash

set -eux

#export ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/edward/clouddrive/iac/ansible-azure/roles
export ANSIBLE_COLLECTIONS_PATHS=/home/edward/clouddrive/iac

ansible-playbook $1
