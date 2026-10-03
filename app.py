from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd
import joblib

app = FastAPI(title="FarmPulse Risk Assessment API")

# Load the trained ML model
model = joblib.load("farm_risk_model.pkl")


# Define the expected input structure
class FarmData(BaseModel):
    herd_size: int
    vaccination_rate: float
    previous_cases: int
    mortality_rate: float
    biosecurity_score: float
    nearby_outbreak: int


@app.get("/")
def home():
    return {"message": "FarmPulse Risk Assessment API is running"}


@app.post("/predict")
def predict_risk(data: FarmData):

    # Convert validated input into a DataFrame
    farm_data = pd.DataFrame([data.model_dump()])

    # Generate prediction
    prediction = model.predict(farm_data)

    return {
        "risk_level": prediction[0]
    }
