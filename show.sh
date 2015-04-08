#!/bin/bash

userUUID=$(openstack user list | grep "$1" | awk '{print $2}')
username=$(openstack user list | grep "$1" | awk '{print $4}')
echo "================"
echo "User Name: $username"
echo "User UUID: $userUUID"
echo -e "\n"

echo "================"
projectname=$( openstack user show $userUUID | grep " name " | awk '{print $4}')
echo "Project Name: $projectname"
projectUUID=$( openstack user show $userUUID | grep "project_id" | awk '{print $4}')
echo "Project UUID: $projectUUID"
echo -e "\n"

echo "======= List Users ========="
keystone user-list --tenant-id $projectUUID

echo -e "\n"
"========= Project Instances ======"
nova list --all-tenants --field=tenant_id,name,status | grep $projectUUID

echo -e "\n"
echo "========= Project Security Groups ======"
nova secgroup-list --all-tenants | grep $projectUUID

echo -e "\n"
echo "========= Project Volumes ======"
nova volume-list --all-tenants | grep $projectUUID

echo -e "\n"
echo "========= Project Volumes Snapshots ======"
cinder snapshot-list --all-tenants | grep $projectUUID

echo -e "\n"
echo "========= Project Images and Snapshots ======"
glance --os-image-api-version 2 image-list --owner $projectUUID


