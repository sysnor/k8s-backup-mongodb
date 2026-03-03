FROM mongo:latest

RUN apt-get update && apt-get install --autoremove -y unzip curl && apt-get clean && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && rm -fr ./aws

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
ENV ISTIO ""
ENV OBJECT_LOCK_DAYS ""

CMD ["/scripts/backup-mongodb.sh"]
