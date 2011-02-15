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
  public static inline function to_underscore( camelCasedWord:String ):String
  {
    var word = camelCasedWord.split(" ").join("_");
    var r = ~/(.)([A-Z])/g;
    return(r.replace(word,"$1_$2").toLowerCase());
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
    for(t in tmp){
      if(t != tmp[0] && !titleSkipCapitalize(t))
        t = capitalize(t);
    }
    return tmp.join(" ");
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
    if(StringTools.endsWith(plural, "s")) return plural.substr(0,-1);
    else return plural;
  }
  public static inline function timestamp(  ):String
  {
    return Date.now().toString().split(" ").join("").split("-").join("").split(":").join("");
  }
}