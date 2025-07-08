"""
checksum.py
Utility to calculate checksum of a string (simple sum of bytes modulo 256).
"""
def calculate_checksum(data: str) -> int:
    """Calculate checksum for the given string."""
    return sum(data.encode()) % 256

if __name__ == "__main__":
    test_data = "Hello, LI-FI!"
    checksum = calculate_checksum(test_data)
    print(f"Checksum for '{test_data}': {checksum}")
