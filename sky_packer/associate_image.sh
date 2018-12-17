#!/bin/bash
# After images are built we can diseminate them to other accounts
vpcNamePrefix="sky_"
profile_prefix="sky-"

#Add other environments here 
declare -a envs=(dev sys-test uat sit)
declare -A  acc_ami_assoc 


for env in "${envs[@]}"
do
    acc_ami_assoc[${env}]=$(aws sts get-caller-identity --query 'Account' --output text --profile ${profile_prefix}${env})
done

for account in "${acc_ami_assoc[@]}"
do
    for build_ami_id in $(cat manifest.json | jq -r '.builds[] | select(.name == "baseSkyAnsibleECSDocker")| .artifact_id' | awk  -F ':' '{print $NF}')
    #for build_ami_id in $(cat manifest.json | jq -r '.builds[] | [.name,.artifact_id] | @tsv' | awk -F':' '{ print $NF }')
    do
      aws ec2 modify-image-attribute --image-id ${build_ami_id} --launch-permission "{\"Add\":[{\"UserId\":\"${account}\"}]}" --profile ${profile_prefix}management
    done
done
