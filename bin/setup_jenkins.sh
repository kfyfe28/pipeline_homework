#!/bin/bash
# Setup Jenkins Project
if [ "$#" -ne 3 ]; then
    echo "Usage:"
    echo "  $0 GUID REPO CLUSTER"
    echo "  Example: $0 wkha https://github.com/redhat-gpte-devopsautomation/advdev_homework_template.git na311.openshift.opentlc.com"
    exit 1
fi

GUID=$1
REPO=$2
CLUSTER=$3
echo "Setting up Jenkins in project ${GUID}-jenkins from Git Repo ${REPO} for Cluster ${CLUSTER}"

#Create The Jenkins App
oc -n ${GUID}-jenkins new-app jenkins-persistent \
    --param ENABLE_OAUTH=true \
    --param MEMORY_LIMIT=4Gi \
    --param VOLUME_CAPACITY=4Gi \
    --param DISABLE_ADMINISTRATIVE_MONITORS=true
    
# Create custom agent container image with skopeo
# TBD

# Create pipeline build config pointing to the ${REPO} with contextDir `openshift-tasks`
# TBD

# Make sure that Jenkins is fully up and running before proceeding!
while : ; do
  echo "Checking if Jenkins is Ready..."
  AVAILABLE_REPLICAS=$(oc get dc jenkins -n ${GUID}-jenkins -o=jsonpath='{.status.availableReplicas}')
  if [[ "$AVAILABLE_REPLICAS" == "1" ]]; then
    echo "...Yes. Jenkins is ready."
    break
  fi
  echo "...no. Sleeping 10 seconds."
  sleep 10
done
