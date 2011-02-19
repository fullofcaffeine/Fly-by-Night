/*
  All this does is adds some important 'import' and 'using' statements to subclasses 
  to enable more functionality. 
  
  Copies original files to ./runway/
  prepends imports and usings to the original files
  compiles
  then replaces the originals with the "good" copy in ./runway/
  then cleans out ./runway when finished
*/
import haxe.macro.Expr;
class RunwayMacro {
  
  private static inline var PREPEND_TO_CONTROLLER = "package controllers;\nusing AeroModel;\n";
  private static inline var PREPEND_TO_MODEL = "package models;\nusing AeroModel;\n";
  private static inline var PREPEND_TO_HELPER = "package helpers;\nusing AeroModel;\n";
  
  @:macro public static function stage() : Expr {
   /* var p:neko.io.Process;
       p = new neko.io.Process("/bin/bash", ["cp","-a","./app/controllers","./runway/"]);
       p.close(); // close the process I/O
       
       p = new neko.io.Process("/bin/bash", ["cp", "-a","./app/models","./runway/"]);
       p.close(); // close the process I/O*/
    
    var file: neko.io.FileOutput;
    var code: String;
    var controller_files = neko.FileSystem.readDirectory("./app/controllers/");
    for(controller_file_name in controller_files){
        code = neko.io.File.getContent('./app/controllers/'+controller_file_name);
        
        if(!neko.FileSystem.exists("./runway/controllers"))
          neko.FileSystem.createDirectory("./runway/controllers");
          
        file = neko.io.File.write("./runway/controllers/"+controller_file_name, false);
        file.writeString(code);
        file.close();
        /*neko.FileSystem.rename('./app/controllers/'+controller_file_name, './runway/controllers'+controller_file_name);*/
        
        file = neko.io.File.write("./app/controllers/"+controller_file_name, false);
        file.writeString(PREPEND_TO_CONTROLLER+code);
        file.close();
    }

    var model_files = neko.FileSystem.readDirectory("./app/models/");
    for(model_file_name in model_files){
      code = neko.io.File.getContent('./app/models/'+model_file_name);
      
      if(!neko.FileSystem.exists("./runway/models"))
        neko.FileSystem.createDirectory("./runway/models");
        
      file = neko.io.File.write("./runway/models/"+model_file_name, false);
      file.writeString(code);
      file.close();
    
      file = neko.io.File.write("./app/models/"+model_file_name, false);
      file.writeString(PREPEND_TO_MODEL+code);
      file.close();
    }
    
    var helper_files = neko.FileSystem.readDirectory("./app/helpers/");
    for(helper_file_name in helper_files){
      code = neko.io.File.getContent('./app/helpers/'+helper_file_name);
      
      if(!neko.FileSystem.exists("./runway/helpers"))
        neko.FileSystem.createDirectory("./runway/helpers");
        
      file = neko.io.File.write("./runway/helpers/"+helper_file_name, false);
      file.writeString(code);
      file.close();
      
      file = neko.io.File.write("./app/helpers/"+helper_file_name, false);
      file.writeString(PREPEND_TO_HELPER+code);
      file.close();
    }
    

    return { expr : EConst(CString("")), pos : haxe.macro.Context.currentPos() };
  }
  
  @:macro public static function restore() : Expr {
    /*new Process("rm", ["-Rf","./app/controllers","./app/models"]);
        new Process("cp", ["-a","./runway/controllers","./app/"]);
        new Process("cp", ["-a","./runway/models", "./app/"]);*/
/*    new Process("rm", ["-Rf","./runway/*"]);*/

    var file: neko.io.FileOutput;
    var code: String;

    var controller_files = neko.FileSystem.readDirectory("./runway/controllers/");
    for(controller_file_name in controller_files){
        code = neko.io.File.getContent('./runway/controllers/'+controller_file_name);
/*        neko.FileSystem.rename('./runway/controllers/'+controller_file_name, './app/controllers'+controller_file_name);*/
        file = neko.io.File.write("./app/controllers/"+controller_file_name, false);
        file.writeString(code);
        file.close();
        neko.FileSystem.deleteFile('./runway/controllers/'+controller_file_name);
    }
    
    var model_files = neko.FileSystem.readDirectory("./runway/models/");
    for(model_file_name in model_files){
        code = neko.io.File.getContent('./runway/models/'+model_file_name);
        file = neko.io.File.write("./app/models/"+model_file_name, false);
        file.writeString(code);
        file.close();
        neko.FileSystem.deleteFile('./runway/models/'+model_file_name);
    }
    
    var helper_files = neko.FileSystem.readDirectory("./runway/helpers/");
    for(helper_file_name in helper_files){
        code = neko.io.File.getContent('./runway/helpers/'+helper_file_name);
        file = neko.io.File.write("./app/helpers/"+helper_file_name, false);
        file.writeString(code);
        file.close();
        neko.FileSystem.deleteFile('./runway/helpers/'+helper_file_name);
    }
    
    if(neko.FileSystem.exists("./runway/controllers"))
      neko.FileSystem.deleteDirectory("./runway/controllers");
    if(neko.FileSystem.exists("./runway/models"))
      neko.FileSystem.deleteDirectory("./runway/models");
    if(neko.FileSystem.exists("./runway/helpers"))
      neko.FileSystem.deleteDirectory("./runway/helpers");

    return { expr : EConst(CString("")), pos : haxe.macro.Context.currentPos() };
  }
}