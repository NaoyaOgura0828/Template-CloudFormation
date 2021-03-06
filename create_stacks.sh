#!/bin/bash

. ./.env_vars

if [ $# -ne 1 ]; then
    echo "      $0 <ENV_TYPE(dev|stg|prod)>"
    exit 1
elif [ "$1" != "dev" -a "$1" != "stg" -a "$1" != "prod" ]; then
    echo "      $0 <ENV_TYPE(dev|stg|prod)>"
    exit 1
fi

cd `dirname $0`

SYSTEM_NAME=Template
ENV_TYPE=$1

create_stack () {
    STACK_NAME=$1
    aws cloudformation create-stack \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --template-body file://./${SYSTEM_NAME}/${STACK_NAME}/${STACK_NAME}.yml \
    --cli-input-json file://./${SYSTEM_NAME}/${STACK_NAME}/${ENV_TYPE}-parameters.json \
    --profile ${SYSTEM_NAME}-${ENV_TYPE}

    aws cloudformation wait stack-create-complete \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --profile ${SYSTEM_NAME}-${ENV_TYPE}
}

#####################################
# 共通
#####################################
# create_stack iam
# create_stack network
# create_stack sg
# create_stack endpoint
# create_stack ami-build
# aws imagebuilder start-image-pipeline-execution --image-pipeline-arn $(aws imagebuilder list-image-pipelines --query 'imagePipelineList[].arn' --output text --profile ${SYSTEM_NAME}-${ENV_TYPE}) --profile ${SYSTEM_NAME}-${ENV_TYPE}
# create_stack bastion
# create_stack efs-build
# create_stack efs-bk
# create_stack db
# create_stack redis
# create_stack vpn
# create_stack route53
# aws ses verify-domain-dkim --domain $(eval echo '$'${ENV_TYPE^^}'_DOMAIN') --profile ${SYSTEM_NAME}-${ENV_TYPE}
# aws ses verify-email-identity --email-address $(eval echo '$'${ENV_TYPE^^}'_EMAIL_ADDRESS') --profile ${SYSTEM_NAME}-${ENV_TYPE}
# create_stack s3

#####################################
# WEB/AP
#####################################
# create_stack alb-web
# create_stack waf-web

#####################################
# API
#####################################
# create_stack alb-api
# create_stack apigw
# create_stack waf-api

#####################################
# Container
#####################################
# create_stack ecr
# create_stack ecs
# create_stack step-functions
# create_stack event-bridge

#####################################
# CI/CD
#####################################
# create_stack sns
# create_stack code-commit
# create_stack code-build
# create_stack code-pipeline

exit 0