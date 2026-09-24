import json
import random
import time
from datetime import datetime
from kafka import KafkaProducer

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda value: json.dumps(value).encode("utf-8")
)

while True:
    transaction = {
        "transaction_id": f"TX{random.randint(1000, 9999)}",
        "user_id": f"USER{random.randint(100, 999)}",
        "amount": round(random.uniform(10, 1000), 2),
        "timestamp": datetime.now().isoformat(),
        "status": random.choice(["success", "failed"])
    }

    producer.send("checkout-telemetry", transaction)
    producer.flush()

    print("Sent:", transaction)

    time.sleep(2)