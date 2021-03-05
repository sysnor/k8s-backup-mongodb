#!/bin/bash

set -e

if [ -z "$ISTIO_META_APP_CONTAINERS" ]
then
	until curl -fsI http://localhost:15021/healthz/ready; do echo \"Waiting for Sidecar...\"; sleep 3; done;
	echo \"Sidecar available. Running the command...\";
fi

SCRIPT_NAME=backup-mongodb
ARCHIVE_NAME=mongodump_$(date +%Y%m%d_%H%M%S).gz
ENPOINTPARAM=
S3_PATH=

echo "[$SCRIPT_NAME] Dumping all MongoDB databases to compressed archive..."
mongodump --oplog \
	--archive="$ARCHIVE_NAME" \
	--gzip \
	--uri "$MONGODB_URI"

echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."

if [ -z "$AWS_ENDPOINT" ]
then
	ENDPOINTPARAM="--endpoint-url=\"$AWS_ENDPOINT\""
fi

if [ -z "$BUCKET_PREFIX" ]
then
	S3_PATH="${BUCKET_PREFIX}/"
fi

if [ -z "$OBJECT_LOCK_DAYS" ]
then
	aws s3api put-object --bucket "${BUCKET_NAME}" --key "${S3_PATH}${ARCHIVE_NAME}" --body "$ARCHIVE_NAME" --object-lock-mode COMPLIANCE --object-lock-retain-until-date "$(date -d "+${OBJECT_LOCK_DAYS} days" "+%Y-%m-%d %H:%M:%S")" "$ENDPOINTPARAM"
else
	aws s3 cp "$ARCHIVE_NAME" "s3://$BUCKET_NAME/$S3_PATH" --no-progress $ENDPOINTPARAM
fi

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$ARCHIVE_NAME"

echo "[$SCRIPT_NAME] Backup complete!"

if [ -z "$ISTIO_META_APP_CONTAINERS" ]
then
	curl -fsI -X POST http://localhost:15020/quitquitquit
fi
