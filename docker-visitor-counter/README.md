# Docker Visitor Counter

## 1. Application Description

Docker Visitor Counter is a small two-service web application created for the CCS3308 Virtualization and Containers assignment.

The application has:

1. A **Flask web service** that serves a webpage on port `5000`.
2. A **Redis service** that stores the visitor count on port `6379`.

Every time the home page is refreshed, Flask sends an `INCR` command to Redis. Redis stores the count in a Docker named volume, so the value remains available after the containers are stopped and started again.

---

## 2. Deployment Requirements

Install the following before running the application:

- Docker Engine / Docker Desktop
- Bash shell
  - Linux/macOS terminal, or
  - Git Bash / WSL on Windows
- Git, if the repository will be cloned from GitHub

Docker Compose is not required because the application is managed using Bash scripts and Docker CLI commands.

Check Docker:

```bash
docker --version
```

---

## 3. Project Structure

```text
docker-visitor-counter/
├── app.py
├── Dockerfile
├── requirements.txt
├── prepare-app.sh
├── start-app.sh
├── stop-app.sh
├── remove-app.sh
├── README.md
└── .gitignore
```

---

## 4. Network and Volume Details

### Docker Network

Network name:

```text
visitor-counter-network
```

The Flask and Redis containers are attached to this bridge network.

The Flask application communicates with Redis using the Redis container name:

```text
visitor-counter-redis
```

### Persistent Volume

Volume name:

```text
visitor-counter-data
```

The volume is mounted into the Redis container at:

```text
/data
```

Redis runs with AOF persistence enabled:

```text
redis-server --appendonly yes
```

Therefore, visitor-count data is stored persistently and is not lost when `stop-app.sh` is used.

---

## 5. Container Configuration

### Flask Web Container

Container name:

```text
visitor-counter-web
```

Configuration:

- Custom image: `visitor-counter-web`
- Container port: `5000`
- Host port: `5000`
- Environment variable `REDIS_HOST=visitor-counter-redis`
- Environment variable `REDIS_PORT=6379`
- Connected to `visitor-counter-network`
- Restart policy: `unless-stopped`

### Redis Container

Container name:

```text
visitor-counter-redis
```

Configuration:

- Image: `redis:7-alpine`
- Container port: `6379`
- Host port: `6379`
- Named volume: `visitor-counter-data:/data`
- Connected to `visitor-counter-network`
- AOF persistence enabled
- Restart policy: `unless-stopped`

---

## 6. Container List

| Container | Service | Port | Role |
|---|---|---:|---|
| `visitor-counter-web` | Flask | 5000 | Serves the web application |
| `visitor-counter-redis` | Redis | 6379 | Stores the persistent visitor counter |

---

## 7. How to Prepare the Application

Give execute permission to the scripts:

```bash
chmod +x prepare-app.sh start-app.sh stop-app.sh remove-app.sh
```

Prepare the Docker resources:

```bash
./prepare-app.sh
```

This script:

- Pulls the Redis image.
- Builds the custom Flask image.
- Creates the Docker bridge network.
- Creates the named persistent volume.

---

## 8. How to Run the Application

Start all containers:

```bash
./start-app.sh
```

Expected message:

```text
Running app ...
The app is available at http://localhost:5000
Redis is available on localhost:6379
```

Open a web browser and visit:

```text
http://localhost:5000
```

Refresh the page several times. The displayed number should increase.

---

## 9. How to Pause the Application

Run:

```bash
./stop-app.sh
```

This stops both containers but does **not** delete the named volume.

Start the application again:

```bash
./start-app.sh
```

Open `http://localhost:5000` again. The counter should continue from its previous value instead of returning to zero.

---

## 10. How to Delete the Application

Run:

```bash
./remove-app.sh
```

This removes:

- Flask container
- Redis container
- Docker network
- Named volume
- Custom Flask image

Because the named volume is removed, the saved visitor count is intentionally deleted by this command.

---

## 11. Example Workflow

```bash
# Create application resources
./prepare-app.sh
```

Example output:

```text
Preparing app ...
Application resources are ready.
```

```bash
# Run the application
./start-app.sh
```

Example output:

```text
Running app ...
The app is available at http://localhost:5000
Redis is available on localhost:6379
```

Open:

```text
http://localhost:5000
```

Refresh the webpage a few times and remember the counter value.

```bash
# Pause the application
./stop-app.sh
```

Example output:

```text
Stopping app ...
Application stopped.
Persistent Redis data has been preserved.
```

Restart:

```bash
./start-app.sh
```

The counter continues from the previously saved value.

Finally:

```bash
# Delete all application resources
./remove-app.sh
```

Example output:

```text
Removing application resources ...
Removed app.
```

---

## 12. Useful Verification Commands

List running containers:

```bash
docker ps
```

List all containers:

```bash
docker ps -a
```

Inspect the network:

```bash
docker network inspect visitor-counter-network
```

Inspect the volume:

```bash
docker volume inspect visitor-counter-data
```

View Flask logs:

```bash
docker logs visitor-counter-web
```

View Redis logs:

```bash
docker logs visitor-counter-redis
```

Test Flask health endpoint:

```bash
curl http://localhost:5000/health
```

Expected response:

```json
{"status":"ok"}
```

---

## 13. Persistent Data Test

1. Start the application.
2. Refresh the webpage until the counter reaches a value such as `5`.
3. Run:

```bash
./stop-app.sh
```

4. Restart:

```bash
./start-app.sh
```

5. Refresh the webpage.

The displayed count should become `6` or higher, demonstrating that Redis data survived the container recreation because it was stored in the named Docker volume.

---

## 14. GitHub Submission

Create a **public GitHub repository using your registration number as the repository name**.

Example:

```text
ITXXXXXXXX
```

Then upload all project files to that repository.

Example Git commands:

```bash
git init
git add .
git commit -m "Complete Docker visitor counter assignment"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REGISTRATION_NUMBER.git
git push -u origin main
```

Submit the public repository link through the LMS.

---

## 15. External Images and Sources

- Redis Docker image: official `redis:7-alpine` image from Docker Hub.
- Python Docker image: official `python:3.12-slim` image from Docker Hub.
- Flask and Redis Python packages are installed from PyPI.

The application logic, Docker configuration, shell scripts, and documentation are prepared specifically for this assignment.
