# To do

- [ ] Implement a Python [Curses CLI interface](https://docs.python.org/3/howto/curses.html) to make this app even better to use
- [ ] Implement bash scripting to... 
    - [ ] handle installation in `installer/main.sh`
    - [ ] run the `.dc` transpiler in the CLI
- [ ] Call necessary APIs from SSO (Penal Code, POFMA etc.) and scrape webpage for relevant statute information
- [ ] Web scrape for similar common law cases that have the given charge
    - [ ] Assuming feeding material facts to GPT API and obtaining relevant statutes as result, can format accordingly and also find case law by webscraping, implement a **rudimentary accuracy test** by matching the number of shared words between material facts of the case and each common law case.
- [ ] Possible future front-end implementation in Dart
- [ ] Integrate this [legislation parser](https://github.com/YongJieYongJie/SSOjs) if possible
- [x] Create a sample `.dc` file that I can use to test `lexer.py` and `interpreter.py`
- [x] Implement syntax to split multiple draft charges on --- such that multipe draft charges can be created from one `.dc` file
