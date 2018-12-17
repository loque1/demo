#!/bin/bash
# Build Ubuntu image and update terraform AMI_ID variable 
# This can be used in conjunction with sc21-terraform-ecs-dev-1 repository
vpcName="sky_management"
snName="bastion1-sky_management"
sgName="sgOpen"
centos7OwnerId="679593333241"
amazonOwnerId="801119661308"
profile="sky-management"


vpcId=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$vpcName" --profile ${profile} | jq -r '.Vpcs[].VpcId')
snId=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcId" --filters "Name=tag-value,Values=$snName" --profile ${profile} | jq -r '.Subnets[0].SubnetId')
sgId=$(aws ec2 describe-security-groups --filters Name=group-name,Values=$sgName Name=vpc-id,Values=${vpcId} --profile ${profile} | jq -r '.SecurityGroups[].GroupId')

export AWS_PROFILE=sc21-management


packer build --var "vpc_id=${vpcId}" --var "subnet_id=${snId}"  --var "security_group_id=${sgId}" --var "centos_owner_id=${centos7OwnerId}" --only=ansibleBase,baseAnsibleSKY ./templates/build.json

if [[ $? -eq 0 ]]
then
packer build --var "vpc_id=${vpcId}" --var "subnet_id=${snId}"  --var "security_group_id=${sgId}" --var "centos_owner_id=${centos7OwnerId}" --only=ansibleBastion,baseSKYAnsibleDocker ./templates/build.json
packer build --var "vpc_id=${vpcId}" --var "subnet_id=${snId}"  --var "security_group_id=${sgId}" --var "centos_owner_id=${centos7OwnerId}" --only=ansibleRepo,baseSKYAnsibleECSDocker ./templates/build.json
else
 echo "build filed to create new base image so not building dependent images"
fi


# Link the ami's to the other accounts 
./associate_image.sh
