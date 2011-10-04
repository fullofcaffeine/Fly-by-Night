class Utils
{
  public static inline var SUCCESS_CODES = [
  "The fox is in the hen house.",
  "The eagle left the nest.",
  "The eagle has landed.",
  "The duck flies at midnight.",
  "The sparrow flies at midnight.",
  "The cheese is in the trunk.",
  "The hawks are circling the carcass.",
  "The plane is full of snakes.",
  "LEEEERRROOOOYYYYYYYYYYY JEEENNNKKIINNNNNNNNSSSSSS!!!!!",
  "The rooster crows at midnight.",
  "The bird is in the oven."
  ];
  public static inline function strip_slashes( backslashed:String ):String
  {
    var word = backslashed;
#if php
    untyped __php__("$word = stripslashes((string)$backslashed)");
#end
    return word;
  }
  public static inline function strip_input_val( input_val:String ):String
  {
    return strip_slashes(input_val).split("<").join("&lt;").split(">").join("&gt;").split("'").join("&#039;").split('"').join("&quot;");
  }
  public static inline function to_underscore( camelCasedWord:String ):String
  {
    var word = strip_slashes(camelCasedWord).split(" ").join("_").split("\"").join("").split("\'").join("");
    var r = ~/(.)([A-Z])/g;
    word = r.replace(word,"$1_$2").toLowerCase();
    return(word.split("__").join("_"));
  }
  /**
  Escape HTML special characters of the string.
  **/
  public static function htmlEscape( s : String ) : String {
    return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;").split("'").join("&#039;").split('"').join("&quot;");
  }

  /**
  Unescape HTML special characters of the string.
  **/
  public #if php inline #end static function htmlUnescape( s : String ) : String {
  return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&").split("&#039;").join("'").split("&quot;").join('"');
  }
  public static inline function toCamelCase( underscored_word:String ):String
  {
    var words = underscored_word.split("_");
    var out = "";
    for(word in words){
      out += capitalize(word);
    }
    return(out);
  }
  public static inline function titleize( words:String ):String
  {
    var tmp = to_underscore(words).split("_");
    var out = new List<String>();
    for(t in tmp){
      if(t == tmp[0] || !titleSkipCapitalize(t))
        t = capitalize(t);
      out.add(t);
    }
    return out.join(" ");
  }
  private static inline function titleSkipCapitalize( word:String ):Bool
  {
    word = word.toLowerCase();
    var skip = false;
    if(word.length < 3 || word == "and" || word == "or" || word == "be"){
      skip = true;
    }
    return skip;
  }
  public static inline function capitalize( word:String ):String
  {
    return word.charAt(0).toUpperCase() + word.substr(1);
  }
  public static inline function singularize( plural:String ):String
  {
    // need to grab rails' inflections
    plural = StringTools.trim(plural);
    if(StringTools.endsWith(plural, "s")) plural = plural.substr(0,-1);
    if(StringTools.endsWith(plural, "ie")) plural = plural.substr(0,-2)+"y";
    return plural;
  }
  public static inline function pluralize( singular:String ):String
  {
    // need to grab rails' methods
    singular = StringTools.trim(singular);
/*    if(StringTools.endsWith(singular, "s")) return plural.substr(0,-1);*/
    return singular+"s";
  }
  public static inline function timestamp(  ):String
  {
    return Date.now().toString().split(" ").join("").split("-").join("").split(":").join("");
  }
}