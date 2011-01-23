class Utils
{
  public static inline function to_underscore( camelCasedWord:String ):String
  {
    var r = ~/(.)([A-Z])/g;
    return(r.replace(camelCasedWord,"$1_$2").toLowerCase());
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
  public static inline function capitalize( word:String ):String
  {
    return word.charAt(0).toUpperCase() + word.substr(1);
  }
}