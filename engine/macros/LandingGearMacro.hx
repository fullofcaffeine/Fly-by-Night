/*
  Automatically includes some important 'import' and 'using' statements to subclasses 
  to enable common functionality without having to always include it. 
  
  finds the package name; and adds statements after it.
  
  TODO: recurse into subdirectories
  
  this used to be called RunwayMacro
  the term Runway will now be referencing tests
*/
package macros;
import haxe.macro.Expr;
class LandingGearMacro {
  
  private static inline var APPEND_TO_CONTROLLER = "    using AeroModel; using AeroPath; using FlyByNightMixins;/*LandingGear*/";
  private static inline var APPEND_TO_MODEL = "    using AeroModel; using FlyByNightMixins;/*LandingGear*/";
  private static inline var APPEND_TO_HELPER = "    using AeroModel; using AeroPath; using FlyByNightMixins;/*LandingGear*/";
  
  @:macro public static function stage() : Expr {
    var file: neko.io.FileOutput;
    var code: String;
    var newcode: String;
    var lines: Array<String>;
    var modified = false;
    var directory_contents = neko.FileSystem.readDirectory("./app/controllers/");
    for(controller_file_name in directory_contents){
      if(!StringTools.startsWith(controller_file_name, ".")){
        code = neko.io.File.getContent('./app/controllers/'+controller_file_name);
        
        // StringTools.replace() might be faster?
        lines = code.split('\n');
        newcode = "";
        for(line in lines){
          if(StringTools.startsWith(StringTools.ltrim(line), "package controllers;") && !StringTools.endsWith(StringTools.rtrim(line),"/*LandingGear*/")){
            line += APPEND_TO_CONTROLLER;
            modified = true;
          }
          newcode += line+"\n";
        }
        
        if(modified){
          file = neko.io.File.write('./app/controllers/'+controller_file_name, false);
          file.writeString(newcode);
          file.close();
        }
      }
    }

    directory_contents = neko.FileSystem.readDirectory("./app/models/");
    for(model_file_name in directory_contents){
      if(!StringTools.startsWith(model_file_name, ".")){
        code = neko.io.File.getContent('./app/models/'+model_file_name);


        lines = code.split('\n');
        newcode = "";
        for(line in lines){
          if(StringTools.startsWith(StringTools.ltrim(line), "package models;") && !StringTools.endsWith(StringTools.rtrim(line),"/*LandingGear*/")){
            line += APPEND_TO_MODEL;
            modified = true;
          }
          newcode += line+"\n";
        }

        if(modified){
          file = neko.io.File.write('./app/models/'+model_file_name, false);
          file.writeString(newcode);
          file.close();
        }
      }
    }
    
    directory_contents = neko.FileSystem.readDirectory("./app/helpers/");
    for(helper_file_name in directory_contents){
      if(!StringTools.startsWith(helper_file_name,".")){
        code = neko.io.File.getContent('./app/helpers/'+helper_file_name);


        lines = code.split('\n');
        newcode = "";
        for(line in lines){
          if(StringTools.startsWith(StringTools.ltrim(line), "package helpers;") && !StringTools.endsWith(StringTools.rtrim(line),"/*LandingGear*/")){
            line += APPEND_TO_HELPER;
            modified = true;
          }
          newcode += line+"\n";
        }

        if(modified){
          file = neko.io.File.write('./app/helpers/'+helper_file_name, false);
          file.writeString(newcode);
          file.close();
        }
      }
    }
    

    return { expr : EConst(CString("")), pos : haxe.macro.Context.currentPos() };
  }
}