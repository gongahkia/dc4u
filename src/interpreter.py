# Interpreter --> implements dc language syntax and runs checks before compiling to diff output formats

# FUA:
    # - use a match case statement for language syntax of output format
    # - use a match case statement for each item type in the token_array and adding to the final string
    # - implement error messages and language syntax checking
    # - test, test and retest to ensure that there are no issues with the interpreter accepting invalid input
    # - still implement new line count if needed to determine where the error is in which line

def parser_interpreter(overall_token_array:list[tuple]):
    for token_array in overall_token_array:
        for i in range(len(token_array[1])):
            print(token_array[1][i])

            match token_array[1][i]["type"]:

                # DONE
                case _:
                    print("edge case detected") # error logging"""
