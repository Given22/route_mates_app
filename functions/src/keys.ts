const CHARS = "QWERTYUIOPASDFGHJKLZXCVBNM1234567890";

/** create random key
 * @param {number} length
 * @return {string}
 */
export function makeid(length: number): string {
  let result = "";
  const characters = CHARS;
  const charactersLength = characters.length;
  let counter = 0;
  while (counter < length) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
    counter += 1;
  }
  return result;
}

/** increase key by one
 * @param {string} key
 * @return {string}
 */
export function increaseKey(key: string): string {
  const code = key;
  if (code === "00000") return "QQQQQ";

  const codeList = code.split("");

  let codeIndex = 4;
  while (codeIndex >= 0 && codeIndex < 5) {
    const char = code.at(codeIndex)!;
    const index = CHARS.indexOf(char);

    if (index === CHARS.length - 1) {
      codeList[codeIndex] = CHARS[0];
      codeIndex--;
    } else {
      codeList[codeIndex] = CHARS[index + 1];
      codeIndex = -1;
    }
  }

  return codeList.join("");
}
