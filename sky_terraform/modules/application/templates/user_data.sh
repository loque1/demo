#!/bin/bash
echo "ECS_CLUSTER=${cluster_name}" > /etc/ecs/ecs.config
# Register Artifactory using S3 bucket
echo "$(sudo aws s3 cp s3://${bucket_name}/ecs.config - | head)" >> /etc/ecs/ecs.config
