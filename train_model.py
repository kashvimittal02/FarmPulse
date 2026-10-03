import pandas as pd
import joblib

from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score, classification_report


# Load dataset
df = pd.read_csv("data/farm_risk_data.csv")

# Features
X = df[
    [
        "herd_size",
        "vaccination_rate",
        "previous_cases",
        "mortality_rate",
        "biosecurity_score",
        "nearby_outbreak"
    ]
]

# Target
y = df["risk_level"]


# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42,
    stratify=y
)


# Create model
model = DecisionTreeClassifier(
    max_depth=4,
    random_state=42
)


# Train
model.fit(X_train, y_train)


# Predict on test data
y_pred = model.predict(X_test)


# Evaluate
accuracy = accuracy_score(y_test, y_pred)

print("Accuracy:", accuracy)
print("\nClassification Report:")
print(classification_report(y_test, y_pred))


# Save model
joblib.dump(model, "farm_risk_model.pkl")

print("\nModel saved successfully!")