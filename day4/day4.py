def test(fun, file, expected):
    with open(file) as f:
        result = fun(f.read())
        assert result == expected, f"expected: {expected}, found: {result}"

def run(fun, file):
    with open(file) as f:
        result = fun(f.read())
        print(result)

def preprocess(stdin: str):
    for line in stdin.split("\n\n"):
        yield dict([field.split(":") for field in line.split()])

def task1(input: str):
    data = preprocess(input)
    expected = set(("ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"))
    
    valid = 0
    for passport in data:
        if passport.keys() - {"cid"} == expected:
            valid += 1
    return valid

test(task1, "example.in", 2)
test(task1, "task.in", 182)

def validate_height(height):
    unit = height[-2:]
    if unit not in ("in", "cm"):
        return False
    number = height[:-2]
    if not number.isdigit():
        return False

    if unit == "cm":
        return 150 <= int(number) <= 193
    if unit == "in":
        return 59 <= int(number) <= 76

RULES = {
    "byr": lambda year: len(year) == 4 and year.isdigit() and 1920 <= int(year) <= 2002,
    "iyr": lambda year: len(year) == 4 and year.isdigit() and 2010 <= int(year) <= 2020,
    "eyr": lambda year: len(year) == 4 and year.isdigit() and 2020 <= int(year) <= 2030,
    "hgt": validate_height,
    "hcl": lambda colour: colour[0] == "#" and all([char in tuple("0123456789abcdef") for char in colour[1:]]),
    "ecl": lambda colour: colour in "amb blu brn gry grn hzl oth".split(),
    "pid": lambda pid: len(pid) == 9 and pid.isdigit(),
    "cid": lambda cid: True,
}

def task2(input: str):
    data = preprocess(input)
    expected = set(("ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"))
    
    valid = 0
    for passport in data:
        if passport.keys() - {"cid"} == expected:
            is_valid = True
            for key, value in passport.items():
                if not RULES[key](value):
                    is_valid = False
            if is_valid:
                valid += 1
    return valid

test(task2, "example2.in", 4)
test(task2, "task.in", 109)
