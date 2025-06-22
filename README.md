# Visist Tracker API
   A simple FastAPI application that tracks visits, health, and uptime, designed for DevOps deployment and containerization.

## Local Dev Setup
### 1. Clone Repo
   ```bash
   git clone https://github.com/Sniwolf/visit-tracker-api.git
   ```
### 2. Create and activate a virtual environment
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate 
   ```
### 3. Install Dependencies
   `pip install -r requirements.txt`

   Key packages used:
   - fastapi
   - uvicorn
   - pydantic
   - pydantic-settings

### 4. Run the app
   `uvicorn app.main:app --reload`

## 🧩 Project Structure
<pre><code> 
app/ 
├── main.py # Entrypoint 
├── api/ 
│ └── routes.py # All API endpoints 
├── services/ 
│ ├── visits.py 
│ └── info.py 
├── models/ 
│ └── responses.py # Pydantic response models 
├── core/ 
│ ├── config.py # App config via BaseSettings 
│ └── state.py # App-level state (e.g., start_time)
</code></pre>

## API Endpoints
### ```GET /health```
Simple health check. Returns ```{"status": "ok}```

### ```GET /visits```
Returns visit count. Returns ```{"count": 3}```

### ```GET /info```
Returns metadata about the app, like uptime, version, etc.
```json
{
  "app_name": "Visit Tracker",
  "version": "1.0.0",
  "author": "Sni",
  "uptime": 243
}
```

