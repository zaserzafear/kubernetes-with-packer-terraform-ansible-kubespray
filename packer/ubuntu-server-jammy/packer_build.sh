#!/bin/bash
packer build -var-file=../credentials.pkrvars.hcl \
    -var-file=./variables.pkrvars.hcl \
    template.pkr.hcl
