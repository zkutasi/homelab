#!/bin/bash

ansible -i inventory/hosts.yaml -m ping all
