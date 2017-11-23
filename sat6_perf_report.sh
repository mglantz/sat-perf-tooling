#!/bin/bash 
#script to measure timings for satellite tasks

USER=
PASS=
CONTENTVIEW_ID=

# Publish a new version of the content view
hammer -u $USER -p $PASS content-view publish --id $CONTENTVIEW_ID --organization "Default Organization" --description "Automatic promote"

# Extract version ID of new content view version
VERSION=$(hammer -u $USER -p $PASS content-view version list --content-view-id $CONTENTVIEW_ID|head -4|tail -1|awk '{ print $1 }')

# Publish new version to dev
hammer -u $USER -p $PASS content-view version promote --content-view-id $CONTENTVIEW_ID --id $VERSION --to-lifecycle-environment-id 2

