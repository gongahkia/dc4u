# Interpreter --> implements dc language syntax and runs checks before compiling to diff output formats

# FUA:

    # BE AWARE FUA!!!
        # - implement logic for charge, statute and charging officer
        # - with all values from vital_information_dict, create each file's relevant syntax (abstracted into functions) at the bottom of the parser_interpeter function
        # - do i want to implement checks for string values in vital_information_dict at the bottom? if yes for certain values, implement at bottom of the parser_interpeter function AFTER checking whether the key has any relevant value at all --> perhaps for date?

    # DEBUG GENERAL
        # - implement error messages and language syntax checking
        # - test, test and retest to ensure that there are no issues with the interpreter accepting invalid input
        # - debug carefully

    # THINK ABOUT WITH REGARD TO COMMENTS
        # - is there any real distinction between commented text and text with no comments? since both are technically ignored?
        # - ensure that i can easily comment out large chunks of relevant text with a set of #comments#, otherwise i can remove any mention of comments as well if functionality will be entirely the same regardless

# --------------------

def parser_interpreter(overall_token_array:list[tuple]):

    draft_charge_count:int = 0
    final_draft_charge_array:list[tuple] = []

    for token_array in overall_token_array:

        # print(token_array[1])

        draft_charge_count += 1

        # each of these is written to for each output, allowing output format to be specified in the end
        final_pdf:str = "" # for pdf output
        final_html:str = "" # for html output with included boilerplate
        final_txt:str = "" # for txt output
        final_md:str = "" # for md output
        final_doc:str = "" # for doc output

        vital_information_dict:dict = { "OUTPUT_FORMAT":"", 
                                        "SUSPECT_NAME":"", 
                                        "SUSPECT_NRIC":"", 
                                        "SUSPECT_RACE":"", 
                                        "SUSPECT_AGE":0, 
                                        "SUSPECT_GENDER":"", 
                                        "SUSPECT_NATIONALITY":"",
                                        "CHARGE_TITLE":"",
                                        "OFFENSE_DATE":"",
                                        "CHARGE_EXPLANATION":"",
                                        "STATUTE":"",
                                        "CHARGING_OFFICER":"",
                                        "ROLE_DIV":"",
                                        "CHARGING_DATE":""
                                    } # used to record important information
        match_stack:list[str]= [] # used to determine active stack of unmatched symbols
        suspect_info:str = ""

        for i in range(len(token_array[1])):

            print(token_array[1][i])

            match token_array[1][i]["type"]:
                
# --------------------

                # DONE ✅ 
                # - should only occur once
                case "OUTPUT_FORMAT":

                    # print(vital_information_dict)

                    if vital_information_dict["OUTPUT_FORMAT"] != "" and "OUTPUT_FORMAT" not in match_stack:
                        print(f"Syntax error detected in Draft Charge {draft_charge_count}. Multiple output formats provided. Please provide one only.")
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
                                print(f"Syntax error detected in Draft Charge {draft_charge_count}. Unmatched output format characters (`) found.")
                                return None
                        
                        elif "OUTPUT_FORMAT" in match_stack:
                            match_stack.remove("OUTPUT_FORMAT")

                        else:
                            print("Error Code 0001. Drop me a message on Github @gongahkia.")
                            return None

# --------------------

# FUA: add edge case checking for any issues with syntax, and if info is not provided at all --> add the latter check below
                # DONE ✅ 
                case "L_SUSPECT_INFO":

                    if "R_SUSPECT_INFO" not in [list(token.values())[0] for token in token_array[1][i+1:]]:
                        print(f"Syntax error detected in Draft Charge {draft_charge_count}. Unmatched suspect infromation character (<) found.")
                        return None

                    elif "R_SUSPECT_INFO" in [list(token.values())[0] for token in token_array[1][i+1:]]:
                        match_stack.append("L_SUSPECT_INFO")

                    else:
                        print("Error code 0005. Drop me a message on Github @gongahkia.")
                        return None

# --------------------

                # DONE ✅ 
                case "R_SUSPECT_INFO":

                    if "L_SUSPECT_INFO" not in [list(token.values())[0] for token in token_array[1][:i+1]]:
                        print(f"Syntax error detected in Draft Charge {draft_charge_count}. Unmatched suspect infromation character (>) found.")
                        return None

                    elif "L_SUSPECT_INFO" in [list(token.values())[0] for token in token_array[1][:i+1]] and "L_SUSPECT_INFO" in match_stack:
                        match_stack.remove("L_SUSPECT_INFO")
                        # print(suspect_info)
                        
                        if len(suspect_info.split(";")) != 6:
                            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Wrong number of arguments provided for suspect information. Please provide 6, seperated by semicolons (;).")
                            return None

                        vital_information_dict["SUSPECT_NAME"] = suspect_info.split(";")[0]
                        vital_information_dict["SUSPECT_NRIC"] = suspect_info.split(";")[1]
                        vital_information_dict["SUSPECT_RACE"] = suspect_info.split(";")[2]

                        try:
                            vital_information_dict["SUSPECT_AGE"] = int(suspect_info.split(";")[3])
                        except:
                            print(f"Incorrect information detected in Draft Charge {draft_charge_count}. Please provide a valid integer value for suspect age.")
                            return None

                        vital_information_dict["SUSPECT_GENDER"] = suspect_info.split(";")[4]
                        vital_information_dict["SUSPECT_NATIONALITY"] = suspect_info.split(";")[5]

                    else:
                        print("Error code 0006. Drop me a message on Github @gongahkia.")
                        return None

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

                # DONE ✅ 
                case "COMMENT":

                    if "COMMENT" not in match_stack: # opening comment character 
                        match_stack.append("COMMENT")     
                        # print([list(token.values())[0] for token in token_array[1][i+1:]])
                        if "COMMENT" not in [list(token.values())[0] for token in token_array[1][i+1:]]:
                            print(f"Syntax error detected in Draft Charge {draft_charge_count}. Unmatched comment character (#) found.")
                            return None

                        else:
                            pass

                    elif "COMMENT" in match_stack: # closing comment character
                        match_stack.remove("COMMENT")

                    else:
                        print("Error code 0004. Drop me a message on Github @gongahkia.")
                        return None
                    pass

# --------------------

                case "WORD":
                    if "L_SUSPECT_INFO" in match_stack:
                        suspect_info += token_array[1][i]["value"]
                    # elif blah blah
                        # add code here
                    pass

# --------------------

                # DONE ✅ 
                case _:
                    print("Error Code 0003. Drop me a message on @gongahkia.")

# --------------------

        # DONE ✅ 
        # checking for vital required suspect information for each draft charge 
        if vital_information_dict["SUSPECT_NAME"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Suspect Name not provided. Please provide one.")
            return None
        elif vital_information_dict["SUSPECT_NRIC"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Suspect NRIC not provided. Please provide one.")
            return None
        elif vital_information_dict["SUSPECT_RACE"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Suspect Race not provided. Please provide one.")
            return None
        elif vital_information_dict["SUSPECT_AGE"] == 0:
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Suspect Age not provided. Please provide one.")
            return None
        elif vital_information_dict["SUSPECT_GENDER"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Suspect Gender not provided. Please provide one.")
            return None
        elif vital_information_dict["SUSPECT_NATIONALITY"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Suspect Nationality not provided. Please provide one.")
            return None

        # DONE ✅ 
        # checking for vital required charge information for each draft charge
        if vital_information_dict["CHARGE_TITLE"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Charge title not provided. Please provide one.")
            return None
        elif vital_information_dict["OFFENSE_DATE"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Date of offense not provided. Please provide one.")
            return None
        elif vital_information_dict["CHARGE_EXPLANATION"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Material facts of Charge not provided. Please provide them.")
            return None

        # DONE ✅ 
        # checking for vital required statute information for each draft charge
        if vital_information_dict["STATUTE"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Statute not provided. Please provide one.")
            return None

        # DONE ✅ 
        # checking for vital required charging officer information for each draft charge
        if vital_information_dict["CHARGING_OFFICER"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Charging Officer name not provided. Please provide one.")
            return None
        elif vital_information_dict["ROLE_DIV"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Charging Officer appointment and division not specified. Please provide them.")
            return None
        elif vital_information_dict["CHARGING_DATE"] == "":
            print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Date of Charge not specified. Please provide one.")
            return None

# --------------------

        # ~!FUA!~
            # - add functions here for each file format, to create the relevant file content for each file format from the vital_information_dict data structure
        # final_pdf:str = "" # for pdf output
        # final_html:str = "" # for html output with included boilerplate
        # final_txt:str = "" # for txt output
        # final_md:str = "" # for md output
        # final_doc:str = "" # for doc output

# --------------------

        # DONE ✅ 
        # checks for incomplete output format and formats respective file type
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
            case "":
                print(f"Incomplete information detected in Draft Charge {draft_charge_count}. Output format not provided. Please provide one.")
                return None
            case _:
                print("Error Code 0002. Drop me a message on @gongahkia.")
                return None

# --------------------

    return final_draft_charge_array
