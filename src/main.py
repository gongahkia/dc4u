# FUA: 
    # - read each value in the returned list, and write the content to the respective filename of argument index [0]
    # - make event loop clearer if necessary
    # - refactor and rework line 30 to accomodate different output formats
    # - refactor and add a split() based on --- to detect the relevant split draft charges

import lexer as lx
import interpreter as inter

# --- 

def debug_print_original():
    fhand = open(f"../samples/sample1.dc", "r")
    for line in fhand:
        print(line,end="")
    
def main():
    overall_token_array:list[tuple] = []
    file_str:str = ""
    file_name:str = input("Name of dc file: ").split(".")[0]
    fhand = open(f"../samples/{file_name}.dc", "r") 
    for line in fhand:
        file_str += f"{line.strip()}"
    dc_array:list[str]= file_str.split("---")
    fhand.close()
    # print(dc_array)

    for dc in dc_array:

        try:
            each_token_array = lx.lexer(dc)
            overall_token_array.append((file_name, each_token_array))
        except ValueError as e:
            print(f"Error log: {e}") # error logging 
    return overall_token_array

# ---

debug_print_original()
dc_array:list[tuple] | None = inter.parser_interpreter(main()) # expressing the possible enums
if dc_array is not None:
    for dc in dc_array:
        dc_file_name:str = dc[0] 
        dc_file_contents:str = dc[1]

        if "|" in dc_file_name:
            match dc_file_name.split("|")[-1]:
                case "PDF":
                    dc_file_name = dc_file_name.split("|")[0]
                case "DOCX":
                    dc_file_name = dc_file_name.split("|")[0]
        fhand = open(dc_file_name,"w")
        fhand.write(dc_file_contents)
        fhand.close()

"""parsed_tuple_output:tuple = inter.parser_interpreter(main())
file_name, output_src = parsed_tuple_output[0], parsed_tuple_output[1]

fhand = open(f"{file_name}.html", "w")
fhand.write(output_src)
fhand.close()"""
