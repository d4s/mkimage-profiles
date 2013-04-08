#!/bin/sh

echo SSH keys generation

ssh-keygen -A

echo "StrictHostKeyChecking no" >> /etc/openssh/ssh_config
