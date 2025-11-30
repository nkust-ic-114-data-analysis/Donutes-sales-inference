# 環境建置與訓練手冊

## 🧰 1. 事前準備

請先安裝以下基礎工具：

* **Git**：用於版本控制與下載專案原始碼。
* **Python (3.11 以上版本)**：作為主要執行環境。
* **uv 套件管理工具**：用於快速建立隔離環境與安裝依賴。
* **Docker Desktop**：用於建立、管理與運行容器化環境。

### 1.1 設定系統環境變數

安裝完成 Python 後，請確認以下步驟：

1. 安裝時**勾選「Add Python to PATH」**。
2. 開啟 **終端機**，執行以下指令確認版本：
   
   ```powershell
   python --version
   ```
3. 安裝 **uv 套件管理工具**：
   
   ```powershell
   pip install uv
   ```
4. 驗證安裝是否成功：
   
   ```powershell
   uv --version
   ```

### 1.2 下載專案及快取伺服器原始碼

請使用 **Git** 下載主要服務專案：

1. 開啟終端機並切換至欲存放專案的資料夾。
2. 執行以下指令以下載 **Sales AutoML** 專案：
   
   ```powershell
   git clone https://github.com/your-org/sales-auto-ml.git
   ```
3. 接著下載 **Inference Server** 專案：
   
   ```powershell
   git clone https://github.com/your-org/inference-server.git
   ```
4. 接著下載 **open-meteo-proxy** 專案：
   
   ```powershell
   git clone https://github.com/your-org/open-meteo-proxy.git
   ```
4. 下載完成後，請確認三個資料夾皆存在：
   
   ```
   sales-auto-ml/
   inference-server/
   open-meteo-proxy/
   ```

這兩個專案將分別負責：

* **sales-auto-ml**：模型訓練、AutoML、自動排程與結果分析。
* **inference-server**：模型推論 API，供外部應用呼叫預測。
* **open-meteo-proxy**：open-meteo 的結果快取 12 小時並進行請求去重，避免超過 open-meteo 的使用限制。


  
---

## 🖥️ 2. 設定 PowerShell 腳本執行權限

在第一次執行前，需允許 PowerShell 腳本執行：

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

此命令允許當前使用者執行本地簽署的 PowerShell 腳本。

---

## 🌱 3. 設定環境變數與啟動服務

### 3.1 設定環境變數

在首次啟動前，請先設定環境參數檔 .env。
請在專案根目錄建立 .env 檔案（若已存在則可直接修改

## 3.2 設定server 憑證

進入 inference-server資料夾
請在專案根目錄建立 accounts.toml 檔案（若已存在則可直接修改

### 3.3 啟動服務

進入專案目錄後執行：

```powershell
.\build_and_run.ps1
```

此腳本將自動：

- 安裝依賴套件。
- 啟動 MLflow、Inference Server 與 PostgreSQL。
- 建立預設資料表與結構。

系統將自動建置以下服務：

- **MLflow**：模型訓練與實驗管理平台。
- **Inference Server**：模型推論 API 伺服器。
- **PostgreSQL**：資料庫服務，用於儲存訓練紀錄與系統設定。

### 3.4 申請金鑰和設定空間

請將以下剛設定的環境變數，填入 Rufs 平台對應的金鑰與 Bucket 配置欄位：
```powershell
AWS_ACCESS_KEY_ID=xxxxxxx
AWS_SECRET_ACCESS_KEY=xxxxxxx
BUCKET_NAME=xxxxxxx
```

```powershell
若偵測到以下服務連線異常，請重新啟動 inference-server 與 mlflow：

docker compose up -d --build inference-server
docker compose up -d --build mlflow
```


📌 **執行完成後，所有主要服務將自動運作。**

接下來只需將資料灌入資料庫即可進行訓練。

---

## 🧠 4. 設定 AutoML 排程任務

為確保模型定期訓練，請設定自動化排程：

### 步驟：

1. 開啟 **Windows 工作排程器 (Task Scheduler)**。
2. 選擇 **建立工作 (Create Task)**。
3. 在「觸發程序 (Triggers)」頁籤中：
   
   - 點選「新增 (New)」。
   - 選擇「每天 (Daily)」執行。
   - 設定執行時間，例如每日 01:00。
4. 在「動作 (Actions)」頁籤中：
   
   - 點選「新增 (New)」。
   - 在「程式或指令碼」欄位中輸入：
     ```powershell
     #根據環境位置選擇
     D:\Donutes\sales-auto-ml\automl-start.bat
     ```
   - 在「開始位置」欄位中輸入：
     ```
     D:\Donutes\sales-auto-ml
     ```
5. 儲存並啟用該任務。

### ✅ 成功驗證

- 可在排程執行後檢查訓練紀錄：
  - **MLflow UI** 會更新新的實驗。
  - **Log 檔案** 會生成於 `training_logs/` 目錄下。

---

## 🧩5 . 問題排除

| 問題                    | 可能原因       | 解決方式                              |
| ----------------------- | -------------- | ------------------------------------- |
| PowerShell 無法執行腳本 | 執行政策未設定 | 重新執行 `Set-ExecutionPolicy` 指令 |
| PostgreSQL 無法啟動     | Port 被占用    | 停用其他使用 5432 埠的服務            |

---

## 💾 6. 備份說明

### 1. 關鍵資料表備份

> ⚠️ **重要提醒：請務必定期備份 `item_status` 與 `model_registry` 兩張資料表！**
> 這兩張表直接影響訓練排程、模型版本管理，若遺失將無法還原模型狀態。

為確保訓練狀態與模型版本安全，請定期備份下列關鍵資料表：

| 資料表名稱 | 用途說明 |
| :--- | :--- |
| `item_status` | 儲存各品項當前狀態（如 cold_start、active 等），影響訓練排程判定。 |
| `model_registry` | 保存模型版本與對應實驗紀錄，用於 MLflow 對應與回溯。 |

### 2. 核心模型備份

| 備份項目 | 用途說明 |
| :--- | :--- |
| **`rustf` 儲存庫模型** | **儲存核心 `rustf` 模型檔案，確保模型本身可以快速還原與部署。** |

