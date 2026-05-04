from fastapi import FastAPI
import random

app = FastAPI()

@app.get("/status")
def get_status():
    return {
        "tool": "LITHO-01",
        "state": random.choice(["Batch Queue", "Load Wafer", "Align", "Expose", "Inspect", "Complete"]),
        "dose": round(random.uniform(32.0, 33.0), 2),
        "overlay_error": round(random.uniform(1.5, 2.0), 2),
        "focus_offset": round(random.uniform(-0.02, 0.02), 3),
        "progress": random.randint(0, 100)
    }