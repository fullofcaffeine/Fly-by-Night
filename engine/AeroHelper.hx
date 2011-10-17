/*
  To see a full list of auto imported classes for all subclasses of AeroHelper
  See LandingGearMacro.APPEND_TO_HELPER 
*/
#if php
import php.FileSystem;
import php.io.File;
#elseif neko
import neko.FileSystem;
import neko.io.File;
#end
import haml_crate.HamlHX;
class AeroHelper
{
  public var controller: AeroController;
  public var yield: String;
  /* if  private var load_helpers: Array<Dynamic>  exists
   each is loaded 
   by HamlHX */
  
  public function new( controller:AeroController )
  {
    this.controller = controller;
  }
  
  public function render_partial( partial_path:String ):String
  {
    var partial_filename = "";
    var partial = "";
    if(partial_path.indexOf("/") == -1){
      // check if partial path is valid
      if(StringTools.startsWith(partial_path,"_")){
        throw "Invalid Partial template name '"+partial_path+"' must not begin with underscore '_', for "+controller.name+":"+controller.action;
      }
      partial_path = Utils.to_underscore(controller.name)+"/_"+partial_path;
    }else{
      
      var partial_path_parts = partial_path.split("/");
      partial_filename = partial_path_parts.pop();
      
      // check if partial path is valid
      if(StringTools.startsWith(partial_filename,"_")){
        throw "Invalid Partial template name '"+partial_filename+"' must not begin with underscore '_', for "+controller.name+":"+controller.action;
      }
      
      // add the underscore _
      partial_path = partial_path_parts.join("/")+"/_"+partial_filename;
    }
    
    // extension is not included
    if(partial_path.indexOf(".") == -1){
      var partial_file_found = false;
      for(ext in Template.types.keys()){
        if(!partial_file_found){
          
          partial_filename = Settings.get("FBN_ROOT")+"app/views/"+partial_path+"."+ext;
          if(FileSystem.exists(partial_filename)){
            partial_file_found = true;
            break;
          }
        }
      }
      
      if(!partial_file_found){
        throw "Partial template for "+controller.name+":"+controller.action+" not found at "+Settings.get("FBN_ROOT")+"app/views/"+partial_path+"<br />Must be a supported template type: "+Template.types.toString();
      }
      
    }else{
      partial_filename = partial_path;
    }
    
    if(FileSystem.exists(partial_filename)){
      partial = File.getContent(partial_filename);
    }else{
      throw "Template for "+controller.name+":"+controller.action+" not found at "+Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(controller.name)+"/"+Utils.to_underscore(partial_filename)+"<br />Must be a supported template type: "+Template.types.toString();
    }
    
    
    
    
    return HamlHX.haml2html(partial, partial_filename, controller.content, this);
  }
}