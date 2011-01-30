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
  public static inline function timestamp(  ):String
  {
    return Date.now().toString().split(" ").join("").split("-").join("").split(":").join("");
  }
}