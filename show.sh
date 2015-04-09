#!/bin/bash

source openrc.yyc

userUUID=$(openstack user list | grep "$1" | awk '{print $2}')
username=$(openstack user list | grep "$1" | awk '{print $4}')
echo "===================="
echo "User Name: $username"
echo "User UUID: $userUUID"

echo "===================="
projectname=$( openstack user show $userUUID | grep " name " | awk '{print $4}')
echo "Project Name: $projectname"
projectUUID=$( openstack user show $userUUID | grep "project_id" | awk '{print $4}')
echo "Project UUID: $projectUUID"
echo -e "\n"

echo "List All Users for user Project:"
#keystone user-list --tenant-id $projectUUID
openstack user list --project $projectUUID

echo "==== Updating user password ===="
sleep 1
UserNewPassword=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
openstack user set --password $UserNewPassword $userUUID
echo "Password has been updated! New password: $UserNewPassword"
sleep 3

source openrc.yyc.user
export OS_TENANT_ID="$projectUUID"
export OS_TENANT_NAME="$projectname"
export OS_USERNAME="$username"
export OS_PASSWORD="$UserNewPassword"

echo -e "\n"
echo "Project Instances : Calgary"
nova list --field=tenant_id,name,status
source openrc.yeg.user
echo "Project Instances : Edmonton"
nova list --field=tenant_id,name,status


source openrc.yyc.user
echo -e "\n"
echo "Project Security Groups : Calgary"
nova secgroup-list
source openrc.yeg.user
echo "Project Security Groups : Edmonton"
nova secgroup-list


source openrc.yyc.user
echo -e "\n"
echo "Project Volumes : Calgary"
nova volume-list
source openrc.yeg.user
echo "Project Volumes : Edmonton"
nova volume-list


source openrc.yyc.user
echo -e "\n"
echo "Project Volumes Snapshots : Calgary"
cinder snapshot-list
source openrc.yeg.user
echo "Project Volumes Snapshots : Edmonton"
cinder snapshot-list

source openrc.yyc.user
echo -e "\n"
echo "User Key-Pairs : Calgary"
nova keypair-list
source openrc.yeg.user
echo "User Key-Pairs : Edmonton"
nova keypair-list


source openrc.yyc.user
echo -e "\n"
echo "Project Floating IPs : Calgary"
nova floating-ip-list
source openrc.yeg.user
echo "Project Floating IPs : Edmonton"
nova floating-ip-list


source openrc.yyc.user
echo -e "\n"
echo "Project Images and Snapshots"
glance image-list --owner $projectUUID


echo -e "\n"
echo "Swift Objects"
echo "=============================="
swift list
echo -e "\n"

