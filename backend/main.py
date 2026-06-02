from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd

app = FastAPI(title="Wine Quality API")

# Esto permite que Flutter pueda consumir la API sin problema
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def load_data():
    red = pd.read_csv("winequality-red.csv", sep=";")
    white = pd.read_csv("winequality-white.csv", sep=";")

    red["type"] = "Red"
    white["type"] = "White"

    data = pd.concat([red, white], ignore_index=True)
    data["id"] = data.index + 1

    return data

@app.get("/")
def home():
    return {"message": "Wine Quality API funcionando"}

@app.get("/wines")
def get_wines():
    data = load_data()

    wines = []

    for _, row in data.iterrows():
        wines.append({
            "id": int(row["id"]),
            "alcohol": float(row["alcohol"]),
            "ph": float(row["pH"]),
            "acidity": float(row["fixed acidity"]),
            "sulphates": float(row["sulphates"]),
            "quality": int(row["quality"]),
            "type": row["type"],
        })

    return wines

@app.get("/metrics")
def get_metrics():
    data = load_data()

    return {
        "total_wines": len(data),
        "average_quality": round(float(data["quality"].mean()), 2),
        "best_quality": int(data["quality"].max()),
        "good_wines": int((data["quality"] >= 7).sum()),
    }

@app.get("/ranking")
def get_ranking():
    data = load_data()

    ranking = data.sort_values(
        by=["quality", "alcohol"],
        ascending=[False, False]
    ).head(10)

    result = []

    for _, row in ranking.iterrows():
        result.append({
            "id": int(row["id"]),
            "alcohol": float(row["alcohol"]),
            "ph": float(row["pH"]),
            "acidity": float(row["fixed acidity"]),
            "sulphates": float(row["sulphates"]),
            "quality": int(row["quality"]),
            "type": row["type"],
        })

    return result