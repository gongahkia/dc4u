# FUA: 
    # - refactor and add a split() based on --- to detect the relevant split draft charges
    # - refactor and rework line 30 to accomodate different output formats
    # - make event loop clearer if necessary

import lexer as lx
import interpreter as inter

# --- 

def debug_print_original():
    fhand = open(f"../samples/eg.dc", "r")
    for line in fhand:
        print(line,end="")
    
def main():
    file_str:str = ""
    dc_array:list = []
    file_name:str = input("Name of dc file: ").split(".")[0]
    fhand = open(f"../samples/{file_name}.dc", "r") 
    for line in fhand:
        if line.strip() == "---":
            dc_array.append(file_str)
            file_str = ""
        else:
            file_str += f"{line.strip()} ^^"
    fhand.close()
    print(dc_array)

    for dc in dc_array:
        # print(dc)
        for line in dc:
            file_str += f"{line.strip()} ^^ "

    # print(file_str, end="")
    try:
        token_array = lx.lexer(file_str)
        return (file_name, token_array)
    except ValueError as e:
        print(f"Error log: {e}") # error logging zzz

# ---

inter.parser_interpreter(main())

"""parsed_tuple_output:tuple = inter.parser_interpreter(main())
file_name, output_src = parsed_tuple_output[0], parsed_tuple_output[1]

fhand = open(f"{file_name}.html", "w")
fhand.write(output_src)
fhand.close()"""
