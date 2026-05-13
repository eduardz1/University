import base64

INPUT = "flag123"

# Encode to base64
encoded = base64.b64encode(INPUT.encode()).decode()
print(f"Base64 encoded: {encoded}")
