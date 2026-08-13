from flask import Flask, render_template_string
import os
import redis

app = Flask(__name__)

redis_client = redis.Redis(
    host=os.getenv("REDIS_HOST", "redis-db"),
    port=int(os.getenv("REDIS_PORT", "6379")),
    decode_responses=True,
)

PAGE = """
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Docker Visitor Counter</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            font-family: Arial, sans-serif;
            background: #0f172a;
            color: #e2e8f0;
        }
        .card {
            width: min(90%, 520px);
            padding: 40px;
            border-radius: 18px;
            background: #1e293b;
            box-shadow: 0 20px 60px rgba(0, 0, 0, .35);
            text-align: center;
        }
        h1 { margin-bottom: 10px; }
        .count {
            font-size: 64px;
            font-weight: 700;
            margin: 24px 0;
            color: #38bdf8;
        }
        p { line-height: 1.6; color: #cbd5e1; }
    </style>
</head>
<body>
    <main class="card">
        <h1>Docker Visitor Counter</h1>
        <p>This page is served by Flask and the counter is stored in Redis.</p>
        <div class="count">{{ visits }}</div>
        <p>Refresh the page to increase the counter.</p>
    </main>
</body>
</html>
"""

@app.get("/")
def home():
    visits = redis_client.incr("visits")
    return render_template_string(PAGE, visits=visits)

@app.get("/health")
def health():
    redis_client.ping()
    return {"status": "ok"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
