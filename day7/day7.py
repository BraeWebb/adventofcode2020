def test(fun, file, expected):
    with open(file) as f:
        result = fun(f.read())
        assert result == expected, f"expected: {expected}, found: {result}"

def run(fun, file):
    with open(file) as f:
        result = fun(f.read())
        print(result)

def preprocess(stdin: str):
    for line in stdin.split("\n"):
        linne = line.trim(".")
        bag, _, rule = line.partition(" bags contain ")
        rules = rule.split(", ")


def task1(input: str):
    pass

test(task1, "example.in", 2)
run(task1, "task.in")
# test(task1, "task.in", 182)

def task2(input: str):
    pass

test(task2, "example2.in", 4)
run(task2, "task.in")
# test(task2, "task.in", 182)
