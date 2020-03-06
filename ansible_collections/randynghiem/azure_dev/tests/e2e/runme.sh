#!/usr/bin/env bash

set -eux

# Set path to collections
export ANSIBLE_COLLECTIONS_PATHS=/home/edward/clouddrive/iac

ansible-playbook role_prerequisites.yml
