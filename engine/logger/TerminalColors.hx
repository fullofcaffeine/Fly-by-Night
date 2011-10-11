package logger;
class TerminalColors
{
  public static inline var BLACK="\033[0;30m";
  public static inline var DARK_GRAY="\033[1;30m";
  public static inline var LIGHT_GRAY="\033[0;37m";
  public static inline var BLUE="\033[0;34m";
  public static inline var LIGHT_BLUE="\033[1;34m";
  public static inline var GREEN="\033[0;32m";
  public static inline var LIGHT_GREEN="\033[1;32m";
  public static inline var CYAN="\033[0;36m";
  public static inline var LIGHT_CYAN="\033[1;36m";
  public static inline var RED="\033[01;31;31m";
  public static inline var LIGHT_RED="\033[1;31m";
  public static inline var GREYBG_RED="\033[31;47m";
  public static inline var PURPLE="\033[0;35m";
  public static inline var LIGHT_PURPLE="\033[1;35m";
  public static inline var BROWN="\033[0;33m";
  public static inline var YELLOW="\033[1;33m";
  public static inline var WHITE="\033[1;37m";
  public static inline var REDBG_WHITE = "\033[1;37;41m";
  public static inline var BLACKBG_WHITE = "\033[01;37;40m";
  public static inline var DEFAULT_COLOR="\033[01;00;0m";
  
  public static inline function value(color:TerminalColor):String
  {
    return Reflect.field(TerminalColors, Std.string(color));
  }
}