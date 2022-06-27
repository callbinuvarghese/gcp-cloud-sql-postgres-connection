#!/bin/bash
set -x
export CLOUD_RUN_SERVICE_NAME="sb-postgres-ex"
export CLOUD_RUN_IMAGE_TAG="us-east4-docker.pkg.dev/acn-highmark-health-odh/quickstart-docker-repo/${CLOUD_RUN_SERVICE_NAME}:latest"
export REGION=us-east4
export PROJECT_ID=$(gcloud config get project)
### build
### gcloud builds submit --region=us-east4 --tag us-east4-docker.pkg.dev/acn-highmark-health-odh/quickstart-docker-repo/sb-postgres-ex:latest

### deploy
gcloud run deploy $CLOUD_RUN_SERVICE_NAME \
    --image="$CLOUD_RUN_IMAGE_TAG" \
    --allow-unauthenticated \
    --platform managed \
    --project=$PROJECT_ID \
    --region=$REGION \
    --vpc-connector=conctor-us-east4-lcef \
    --impersonate-service-account=sa-lcef-highmark-user@acn-highmark-health-odh.iam.gserviceaccount.com \
    --set-env-vars "spring_datasource_url=jdbc:postgresql://10.235.156.3:5432/test?sslmode=verify-ca&sslrootcert=./server-ca.pem&sslcert=./client-cert.pem&sslkey=./client-key.pk8" \
    --set-env-vars "spring.datasource.username=lcef_application" \
    --set-env-vars "spring.datasource.password=owuhf8#x8LL"




