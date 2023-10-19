# handles lexical analysis of dc files

import re 

# defines the grammer rules for the markup language
 # order of patterns matters since they're checked from top to bottom. Place more specific patterns before generic ones.

grammer_pattern:list = [
    ('OUTPUT_FORMAT', r'')
    ('ITAL', r'\`'),
    ('BOLD', r'\*'),
    ('UNDER', r'\_'),
    ('HIGH', r'\&'),
    ('QUOTE', r'\@'),
    ('HEADER',r'\+{1,6}'),
    ('TABLE', r'\%'),
    ('BULLIST', r'\-'),
    ('NUMLIST', r'\!'),
    ('NEWLINE', r'\^\^'),
    ('WORD', r'[A-Za-z0-9;,.?$]+'),
        ]

def lexer(input_string:str):
    token_array:list = []
    while input_string: # iterates over each 1,2,4 byte character in input string
        match_val = None # variable initialisation and assignment 
        for data_type, regex_pattern in grammer_pattern:
            regex_1 = re.compile(regex_pattern) # .compile() method takes in a string and converts it to a machine readable regular expression pattern which can be applied to a string
            match_val = regex_1.match(input_string)
            if match_val:
                matched_token = match_val.group(0)
                token_array.append({"type": data_type, "value": matched_token}) # returns a list of dictionaries that contain the data type and value of each token
                input_string = input_string[len(matched_token):].lstrip() # iterating after each character / chunk that matches regex
                break
        if not match_val:
            raise ValueError(f"cb follow the syntax: {input_string}")
    return token_array
