# SEPARATOR = "========================================================================================================"
SEPARATOR = "\n"


class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def pretty_print(text, color=Colors.OKCYAN):
    print(color + text + Colors.ENDC)


def pretty_print_separator():
    # pretty_print(SEPARATOR, Colors.HEADER)
    print(SEPARATOR)
