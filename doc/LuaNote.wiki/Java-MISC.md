```
String hv = String.format("%02x", b);
String hv = String.format("%02d", b);// 格式化前面补充0
```
```
/**
	 * java包名是否合法
	 * @return
	 */
	static boolean matchJavePackegeName(String target) {
		//Pattern p = Pattern.compile("^[a-zA-Z_\\$][\\w\\$]*(?:\\.[a-zA-Z_\\$][\\w\\$]*)*$");
		String p = "^([\\p{Letter}_$][\\p{Letter}\\p{Number}_$]*\\.)*[\\p{Letter}_$][\\p{Letter}\\p{Number}_$]*$";
		//or, for short
		p = "^([\\p{L}_$][\\p{L}\\p{N}_$]*\\.)*[\\p{L}_$][\\p{L}\\p{N}_$]*$";
		
		Pattern compile = Pattern.compile(p);
		Matcher m = compile.matcher(target);
		
		return m.find();
	}
	


	The Unicode standard defines what counts as a letter.

	From the Java Language Specification, section 3.8:
	
	Letters and digits may be drawn from the entire Unicode character set, which supports most writing scripts in use in the world today, including the large sets for Chinese, Japanese, and Korean. This allows programmers to use identifiers in their programs that are written in their native languages.
	
	A "Java letter" is a character for which the method Character.isJavaIdentifierStart(int) returns true. A "Java letter-or-digit" is a character for which the method Character.isJavaIdentifierPart(int) returns true.
	
	From the Character documenation for isJavaIdentifierPart:
	
	Determines if the character (Unicode code point) may be part of a Java identifier as other than the first character. A character may be part of a Java identifier if any of the following are true:
	
```
	it is a letter
	it is a currency symbol (such as '$')
	it is a connecting punctuation character (such as '_')
	it is a digit
	it is a numeric letter (such as a Roman numeral character)
	it is a combining mark
	it is a non-spacing mark
	isIdentifierIgnorable(codePoint) returns true for the character
```

	 A Java fully qualified class name (lets say "N") has the structure

		N.N.N.N
	
	The "N" part must be a Java identifier. Java identifiers cannot start with a number, but after the initial character they may use any combination of letters and digits, underscores or dollar signs:
	
	([a-zA-Z_$][a-zA-Z\d_$]*\.)*[a-zA-Z_$][a-zA-Z\d_$]*
	------------------------    -----------------------
	          N                           N
	They can also not be a reserved word (like import, true or null). If you want to check plausibility only, the above is enough. If you also want to check validity, you must check against a list of reserved words as well.
	
	Java identifiers may contain any Unicode letter instead of "latin only". If you want to check for this as well, use Unicode character classes:
	
	([\p{Letter}_$][\p{Letter}\p{Number}_$]*\.)*[\p{Letter}_$][\p{Letter}\p{Number}_$]*
	or, for short
	
	([\p{L}_$][\p{L}\p{N}_$]*\.)*[\p{L}_$][\p{L}\p{N}_$]*
	The Java Language Specification, (section 3.8) has all details about valid identifier names.

	Also see the answer to this question: Java Unicode variable names

	 * http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#3.8
	 * http://stackoverflow.com/questions/1422655/java-unicode-variable-names/1422681#1422681
	
```

```
/**
	 * 文件大小转换
	 * @param size
	 * @return
	 */
	public static String readableFileSize(long size) {
	    if(size <= 0) return "0";
	    final String[] units = new String[] { "B", "KB", "MB", "GB", "TB" };
	    int digitGroups = (int) (Math.log10(size)/Math.log10(1024));
	    return new DecimalFormat("#,##0.#").format(size/Math.pow(1024, digitGroups)) + " " + units[digitGroups];
	}
```