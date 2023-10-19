# handles lexical analysis of dc files

# FUA 
    # --- separator is implemented elsewhere in main.py FOR NOW
    # are newlines really relevant? otherwise remove the newline token entirely

import re 

# defines the grammer rules for the markup language
# order of patterns matters since they're checked from top to bottom. Place more specific patterns before generic ones.
grammer_pattern:list = [
    ('OUTPUT_FORMAT', r'\`'),
    ('SUSPECT_INFO', r'\<'),
    ('CHARGE_INFO', r'\['),
    ('STATUTE_INFO', r'\{'),
    ('CHARGING_OFFICER_INFO', r'\@'),
    ('COMMENT', r'\#'),
    ('NEWLINE', r'\^\^'),
    ('WORD', r'[A-Za-z0-9;,.?$!%-+*_()]+'),
        ]

# create the token array, which contains dictionaries of the data type and value of each token
def lexer(input_string:str):
    token_array:list = []
    while input_string: 
        match_val = None 
        for data_type, regex_pattern in grammer_pattern:
            regex_1 = re.compile(regex_pattern) # .compile() method takes in a string and converts it to a machine readable regular expression pattern which can be applied to a string
            match_val = regex_1.match(input_string)
            if match_val:
                matched_token = match_val.group(0)
                token_array.append({"type": data_type, "value": matched_token}) 
                input_string = input_string[len(matched_token):].lstrip() 
                break
        if not match_val:
            raise ValueError(f"Please follow the specified syntax: {input_string}")
    return token_array
