grammar testLang;
exports silver:extension:treesitter;

parser parse :: Top_c
{
  testLang;
}

function main
IOVal<Integer> ::= args::[String]  ioIn::IO
{
  local filename :: String = head(args);
  local fileExists :: IOVal<Boolean> = isFile(filename, ioIn);
  local text :: IOVal<String> = readFile(filename, fileExists.io);
  local result :: ParseResult<Top_c> = parse(text.iovalue, filename);

  local rootCST :: Top_c = result.parseTree;

  local printSuccess :: IO = print(rootCST.pp ++ "\n" ++ rootCST.altPP ++ "\n",
                                   text.io);

  return if !fileExists.iovalue
         then ioval(print("File not found.\n", fileExists.io), 1)
         else if !result.parseSuccess
         then ioval(print("Parse error:\n" ++ result.parseErrors ++ "\n",
                          text.io), 2)
         else ioval(printSuccess, 0);
}

