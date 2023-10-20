# Interpreter --> implements dc language syntax and runs checks before compiling to diff output formats

# FUA:
    # - debug accordingly
    # - use a match case statement for language syntax of output format
    # - use a match case statement for each item type in the token_array and adding to the final string
    # - implement error messages and language syntax checking
    # - test, test and retest to ensure that there are no issues with the interpreter accepting invalid input
    # - work on respective outputs for each token
    # - comments to be ignored
    # - the format of each other match case statement aside from splitting by ; and accounting for invalid matching syntax and invalid number of arguments --> then run another individual match case statement for the output format

def parser_interpreter(overall_token_array:list[tuple]):

    draft_charge_count:int = 0
    final_draft_charge_array:list[tuple] = []

    for token_array in overall_token_array:
        print(token_array)
        draft_charge_count += 1

        # each of these is written to for each output, allowing output format to be specified in the end
        final_pdf:str = "" # for pdf output
        final_html:str = "" # for html output with included boilerplate
        final_txt:str = "" # for txt output
        final_md:str = "" # for md output
        final_doc:str = "" # for doc output

        vital_information_dict:dict = {} # used to record important information
        match_stack:list[str]= [] # used to determine active stack of unmatched symbols

        for i in range(len(token_array[1])):
            print(token_array[1][i])

            match token_array[1][i]["type"]:
                
# --------------------

                # DONE ✅ 
                # - should only occur once
                case "OUTPUT_FORMAT":

                    # print(vital_information_dict)

                    if "OUTPUT_FORMAT" in vital_information_dict and "OUTPUT_FORMAT" not in match_stack:
                        print(f"Syntax error detected in Draft Charge {draft_charge_count}! Multiple output formats provided. Please provide one only.")
                        return None

                    else:
                        if "OUTPUT_FORMAT" not in match_stack:
                            match_stack.append("OUTPUT_FORMAT") 
                            output_format:str= token_array[1][i+1]["value"]
                            match output_format:
                                case "PDF":
                                    vital_information_dict["OUTPUT_FORMAT"] = "PDF"
                                case "HTML":
                                    vital_information_dict["OUTPUT_FORMAT"] = "HTML"
                                case "TXT":
                                    vital_information_dict["OUTPUT_FORMAT"] = "TXT"
                                case "MD":
                                    vital_information_dict["OUTPUT_FORMAT"] = "MD"
                                case "DOC":
                                    vital_information_dict["OUTPUT_FORMAT"] = "DOC"
                                case _:
                                    print(f"Unrecognised output format detected in Draft Charge {draft_charge_count}! DC currently supports one of the following [PDF/HTML/TXT/MD/DOC].")
                                    return None
                            if token_array[1][i+2]["type"] == "OUTPUT_FORMAT":
                                pass
                            else:
                                print(f"Syntax error detected in Draft Charge {draft_charge_count}! Unmatched output format characters (`) found.")
                                return None
                        
                        elif "OUTPUT_FORMAT" in match_stack:
                            match_stack.remove("OUTPUT_FORMAT")

                        else:
                            print("Error Code 0001. Drop me a message on Github @gongahkia.")
                            return None

# --------------------

                case "L_SUSPECT_INFO":
                    pass

# --------------------

                case "R_SUSPECT_INFO":
                    pass

# --------------------

                case "L_CHARGE_INFO":
                    pass

# --------------------

                case "R_CHARGE_INFO":
                    pass

# --------------------

                case "L_STATUTE_INFO":
                    pass
                    
# --------------------

                case "R_STATUTE_INFO":
                    pass

# --------------------

                case "CHARGING_OFFICER_INFO":
                    pass

# --------------------

                case "COMMENT":
                    pass

# --------------------

                case "WORD":
                    pass

# --------------------

                # DONE ✅ 
                case _:
                    print("Error Code 0003. Drop me a message on @gongahkia.")

        # checking for vital required information for each draft charge 

        # DONE ✅ 
        # last check before returning the values --> for output format of each draft charge 
        if "OUTPUT_FORMAT" not in vital_information_dict:
            print(f"Syntax error detected in Draft Charge {draft_charge_count}! Output format not provided. Please provide one.")
            return None
        else:
            match vital_information_dict["OUTPUT_FORMAT"]:
                case "PDF":
                    final_draft_charge_array.append((token_array[0],final_pdf))
                case "HTML":
                    final_draft_charge_array.append((token_array[0],final_html))
                case "TXT":
                    final_draft_charge_array.append((token_array[0],final_txt))
                case "MD":
                    final_draft_charge_array.append((token_array[0],final_md))
                case "DOC":
                    final_draft_charge_array.append((token_array[0],final_doc))
                case _:
                    print("Error Code 0002. Drop me a message on @gongahkia.")
                    return None
    return final_draft_charge_array
