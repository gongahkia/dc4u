# Interpreter --> implements dc language syntax and runs checks before compiling to diff output formats

# FUA:
    # - use a match case statement for language syntax of output format
    # - use a match case statement for each item type in the token_array and adding to the final string
    # - implement error messages and language syntax checking
    # - test, test and retest to ensure that there are no issues with the interpreter accepting invalid input

def parser_interpreter(input_tuple:tuple, output_format:str):
    # print(token_array)
    for i in range((len(token_array)):
        match token_array[i]["type"]:
            case "":
