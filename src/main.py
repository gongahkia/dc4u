# FUA: 
    # - refactor and add a split() based on --- to detect the relevant split draft charges
    # - refactor and rework line 30 to accomodate different output formats
    # - make event loop clearer if necessary

import lexer as lx
import interpreter as inter

# --- 

"""def debug_print_original():
    fhand = open(f"../samples/eg.dc", "r")
    for line in fhand:
        print(line,end="")"""
    
def main():
    file_name:str = input("Name of dc file: ").split(".")[0]
    fhand = open(f"../samples/{file_name}.dc", "r") 
    file_str:str = ""
    for line in fhand:
        file_str += f"{line.strip()} ^^ "
    fhand.close()
    # print(file_str, end="")
    try:
        token_array_1 = lx.lexer(file_str)
        return (file_name, token_array_1)
    except ValueError as e:
        print(f"Error log: {e}") # error logging zzz

# ---

parsed_tuple_output:tuple = inter.parser_interpreter(main())
file_name, output_src = parsed_tuple_output[0], parsed_tuple_output[1]

fhand = open(f"{file_name}.html", "w")
fhand.write(output_src)
fhand.close()
