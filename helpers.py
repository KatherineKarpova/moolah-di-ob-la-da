# convert money data type to float for mathematical calculations
def money_to_float(money_str):
    return float(money_str.translate(str.maketrans("", "", "$,")))
