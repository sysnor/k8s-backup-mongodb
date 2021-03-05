# Schedule MongoDB Backup  to S3 using Kubernetes CronJob

## Forked from [tuladhar/k8s-backup-mongodb](https://github.com/tuladhar/k8s-backup-mongodb)

 * Added support for AWS endpoint URL to support other S3 compatible providers.
 * Added fixes for Istio.
 * Added support for object lock.

## Usage

Example in kubernetes/cronjob.yaml.

### S3 compatible providers

To use an S3 compatible provider, set AWS_ENDPOINT to the S3 URL, e.g. *https://s3.REGION.backblazeb2.com*

### Object lock

If you have an S3 provider that supports object lock, make sure it is enabled on the bucket and add the days you want the object to be locked for in OBJECT_LOCK_DAYS.

### Istio

If running under Istio, add the ISTIO environment variable with any content (*e.g. ISTIO: "true"*). This will wait for the sidecar container when starting the job to make sure networking is ok and on completion send the quit command to the sidecar, otherwise the job will stay running waiting for the sidecar to finish.

## Acknowledgements

 * forked from [tuladhar/k8s-backup-mongodb](https://github.com/tuladhar/k8s-backup-mongodb)
