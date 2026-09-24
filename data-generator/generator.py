import json
import random
import time
from datetime import datetime

while True:
    transaction = {
        "transaction_id": f"TX{random.randint(1000, 9999)}",
        "user_id": f"USER{random.randint(100, 999)}",
        "amount": round(random.uniform(10, 1000), 2),
        "timestamp": datetime.now().isoformat(),
        "status": random.choice(["success", "failed"])
    }

    print(json.dumps(transaction))
    time.sleep(2)