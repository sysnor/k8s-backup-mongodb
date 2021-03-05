FROM mongo:latest

RUN apt-get update && apt-get install --autoremove -y awscli

WORKDIR /scripts

COPY backup-mongodb.sh .
RUN chmod +x backup-mongodb.sh

ENV MONGODB_URI ""
ENV BUCKET_NAME ""
ENV BUCKET_PREFIX ""
ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""
ENV AWS_DEFAULT_REGION ""
ENV AWS_ENDPOINT ""
ENV ISTIO_META_APP_CONTAINERS ""
ENV OBJECT_LOCK_DAYS ""

CMD ["/scripts/backup-mongodb.sh"]
