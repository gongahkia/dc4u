# To do

- [ ] `lexer.py`
    - [ ] add relevant syntax for `.dc`
    - [ ] implement splitting of the draft charges with `---` at an early stage in this file(?)
- [ ] `interpreter.py`
    - [ ] implement error messages and language syntax checking
    - [ ] ensure output format is correct
- [ ] `main.py`
    - [ ] split input accordingly
    - [ ] ensure no issues with event loop
- [ ] Implement syntax to split multiple draft charges on --- such that multipe draft charges can be created from one `.dc` file
- [ ] Implement bash scripting to... 
    - [ ] handle installation 
    - [ ] run the `.dc` transpiler in the CLI
- [ ] Call necessary APIs from SSO (Penal Code, POFMA etc.) and scrape webpage for relevant statute information
- [ ] Web scrape for similar common law cases that have the given charge
    - [ ] Assuming feeding material facts to GPT API and obtaining relevant statutes as result, can format accordingly and also find case law by webscraping, implement a **rudimentary accuracy test** by matching the number of shared words between material facts of the case and each common law case.
- [ ] Possible future front-end implementation in Dart
- [ ] Integrate this [legislation parser](https://github.com/YongJieYongJie/SSOjs) if possible
