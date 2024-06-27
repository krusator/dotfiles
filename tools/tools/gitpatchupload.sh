#!/usr/bin/env bash
ISSUE_NAME=$1
BRANCH_NAME=$2
if [[ "$ISSUE_NAME" != "" ]]; then
	CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
	if [[ "$BRANCH_NAME" != "" ]]; then
		git diff origin/"${BRANCH_NAME}" > "${ISSUE_NAME}.patch"
	else
		git diff origin/"${CURRENT_BRANCH}" > "${ISSUE_NAME}.patch"
	fi
	gsutil cp "${ISSUE_NAME}.patch" gs://drupal-patches
	gsutil setmeta -h "Content-Type:text/plain" -h "Cache-Control:public" "gs://drupal-patches/${ISSUE_NAME}.patch"
	gsutil acl ch -u AllUsers:R "gs://drupal-patches/${ISSUE_NAME}.patch"
	curl "https://storage.googleapis.com/drupal-patches/${ISSUE_NAME}.patch"
else
	echo No issue name provided
fi
