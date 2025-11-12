FROM ghcr.io/mlflow/mlflow:v3.6.0

RUN pip install --no-cache-dir psycopg2-binary boto3

ENV AWS_ACCESS_KEY_ID=GYfqlkDptWBQShwaird8
ENV AWS_SECRET_ACCESS_KEY=srKegSlTiCIF5Vwyo9MWE31GhzRf2Z6OutHJLjYq
ENV AWS_REGION=auto
ENV MLFLOW_S3_ENDPOINT_URL=http://rustfs:9000

EXPOSE 5000

CMD ["mlflow", "server","--host", "0.0.0.0","--backend-store-uri", "postgresql://root:postgres@postgresql:5432/mlflow","--default-artifact-root", "s3://nkust-ic-models/mlflow-blobs/"]
