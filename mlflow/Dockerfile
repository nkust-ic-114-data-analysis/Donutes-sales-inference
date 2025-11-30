# mlflow/Dockerfile
FROM ghcr.io/mlflow/mlflow:v3.6.0

# 安裝資料庫驅動與 S3 支援
RUN pip install --no-cache-dir psycopg2-binary boto3

# 設定工作目錄
WORKDIR /app

CMD mlflow server \
    --host 0.0.0.0 \
    --port 5000 \
    --backend-store-uri ${MLFLOW_BACKEND_URI} \
    --default-artifact-root ${MLFLOW_ARTIFACT_ROOT} \
    --allowed-hosts '*'