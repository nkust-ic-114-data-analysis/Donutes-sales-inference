# 環境建置與訓練手冊

## 🧰 1. 事前準備

請先安裝以下基礎工具：

* **Git**：用於版本控制與下載專案原始碼。
* **Python (3.11 以上版本)**：作為主要執行環境。
* **uv 套件管理工具**：用於快速建立隔離環境與安裝依賴。
* **Visual Studio Code (VSCode)**：用於程式開發與偵錯。

### 1.1 設定系統環境變數

安裝完成 Python 後，請確認以下步驟：

1. 安裝時**勾選「Add Python to PATH」**。
2. 開啟 **VSCode 終端機**，執行以下指令確認版本：

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

---


## 🖥️ 2. 設定 PowerShell 腳本執行權限

在第一次執行前，需允許 PowerShell 腳本執行：

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

此命令允許當前使用者執行本地簽署的 PowerShell 腳本。

---

## 🌱 3. 設定環境變數與啟動服務

進入專案目錄後執行：

```powershell
.\build_and_run.ps1
```

此腳本將自動：

- 建立 conda 環境與安裝依賴套件。
- 啟動 MLflow、Inference Server 與 PostgreSQL。
- 建立預設資料表與結構。

系統將自動建置以下服務：

- **MLflow**：模型訓練與實驗管理平台。
- **Inference Server**：模型推論 API 伺服器。
- **PostgreSQL**：資料庫服務，用於儲存訓練紀錄與系統設定。

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

## 🧩 6. 問題排除

| 問題                    | 可能原因         | 解決方式                              |
| ----------------------- | ---------------- | ------------------------------------- |
| PowerShell 無法執行腳本 | 執行政策未設定   | 重新執行 `Set-ExecutionPolicy` 指令 |
| PostgreSQL 無法啟動     | Port 被占用      | 停用其他使用 5432 埠的服務            |
| MLflow 無法連線         | Conda 環境未啟動 | 重新執行 `conda activate `          |

---