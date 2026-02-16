from fastapi import FastAPI
import os, socket, time

app = FastAPI()

@app.get("/health")
def health():
    return {
        "status": "ok",
        "host": socket.gethostname(),
        "time": time.time(),
        "env": os.getenv("ENV", "unset"),
        "message": os.getenv("MESSAGE", "unset")
    }

@app.get("/items")
def items():
    return {"items": ["apple", "banana", "orange"]}
