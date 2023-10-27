// Handles lexical analysis of dc files

// defines the grammer rules for the markup language
// order of patterns matters since they're checked from top to bottom. Place more specific patterns before generic ones.
const regexPatterns: [string, RegExp][] = [
  ['OUTPUT_FORMAT', /\`/],
  ['L_SUSPECT_INFO', /</],
  ['R_SUSPECT_INFO', />/],
  ['L_CHARGE_INFO', /\[/],
  ['R_CHARGE_INFO', /\]/],
  ['STATUTE_INFO', /\@/],
  ['L_CHARGING_OFFICER_INFO', /\{/],
  ['R_CHARGING_OFFICER_INFO', /\}/],
  ['COMMENT', /\#/],
  ['WORD', /[A-Za-z0-9;,.?$!%-+*_/()]+/],
];

// create the token array, which contains objects of the data type and value of each token
function lexer(inputString: string): { type: string; value: string }[] {
  const tokenArray: { type: string; value: string }[] = [];
  while (inputString) {
    let matchVal: RegExpMatchArray | null = null;
    for (const [dataType, regexPattern] of regexPatterns) {
      const regex = new RegExp(`^${regexPattern.source}`);
      matchVal = inputString.match(regex);
      if (matchVal) {
        const matchedToken = matchVal[0];
        tokenArray.push({ type: dataType, value: matchedToken });
        inputString = inputString.slice(matchedToken.length).replace(/^\s+/,''); // Uses regular expression to trim leading whitespace
        break;
      }
    }
    if (!matchVal) {
      throw new Error(`Please follow the specified syntax: ${inputString}`);
    }
  }
  return tokenArray;
}
