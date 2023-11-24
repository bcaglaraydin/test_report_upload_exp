# File: test_simple_calculator.py
from program import add_numbers

def test_add_numbers():
    assert add_numbers(2, 3) == 5
    assert add_numbers(-1, 1) == 0
    assert add_numbers(0, 0) == 0
    assert add_numbers(-5, -7) == -12
    assert add_numbers(2.5, 1.5) == 4.0
