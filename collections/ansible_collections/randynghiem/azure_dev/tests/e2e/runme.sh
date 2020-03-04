#!/usr/bin/env bash

set -eux

# Set path to collections
export ANSIBLE_COLLECTIONS_PATHS=/home/edward/clouddrive/ws/iac/collections

ansible-playbook role_health_check.yml
