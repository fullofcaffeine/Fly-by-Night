#if php
  import php.FileSystem;
  import php.io.File;
  import php.Lib;
#elseif neko
  import neko.FileSystem;
  import neko.io.File;
  import neko.Lib;
#elseif nodejs
  import js.Node;
  import nodejs.FileSystem;
  import nodejs.File;
#end
import haml_crate.HamlHX;
class AeroView
{
  private var controller: AeroController;
  private var layout: String;
  private var template: String;
  private var content: Hash<Dynamic>;
  private var helper: AeroHelper;
  
  private var rendered: Bool;
  
  public function new( controller:AeroController )
  {
    this.controller = controller;
  }
  
  public function render( ?custom_layout:String, ?custom_template:String, ?custom_content:Hash<Dynamic>, ?custom_helper:AeroHelper ):Void
  {
    var type_ext = ".haml"; // TODO cycle through default types for matching file
    var layout_filename = "";
    var template_filename = "";
    if(!rendered){
      if(custom_layout == null){
        
        
        // check for default layout template by controller name
        var default_layout_found = false;
        for(ext in Template.types.keys()){
          if(!default_layout_found){
            layout_filename = Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(controller.name)+"."+ext;
            if(FileSystem.exists(layout_filename)){
              layout = File.getContent(layout_filename);
              default_layout_found = true;
              break;
            }
          }
        }
        
        // fallback to application layout
        if(!default_layout_found){
          
          var application_layout_found = false;
          for(ext in Template.types.keys()){
            if(!application_layout_found){
              layout_filename = Settings.get("FBN_ROOT")+"app/views/layouts/application."+ext;
              if(FileSystem.exists(layout_filename)){
                layout = File.getContent(layout_filename);
                application_layout_found = true;
                break;
              }
            }
          }
          
          if(!application_layout_found){
            throw "Default Layout for "+controller.name+":"+controller.action+" is missing at: "+Settings.get("FBN_ROOT")+"app/views/layouts/application<br />Must be a supported template type: "+Template.types.toString();
          }
        }
        
      }else if(custom_layout == "false" || custom_layout == "none" || custom_layout == "null"){
        layout_filename = "[none]";
        layout = "= yield";
      }else{
        
        // check for custom layout
        if(custom_layout.indexOf(".")>0){ 
          // defines template type by ext
          layout_filename = Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(custom_layout);
          if(FileSystem.exists(layout_filename)){
            layout = File.getContent(layout_filename);
          }else{
            throw "Layout for "+controller.name+":"+controller.action+"  '"+custom_layout+"' doesn't exist at: "+layout_filename;
          }
          
        }else{
          // loop through template types
          var custom_layout_found = false;
          for(ext in Template.types.keys()){
            if(!custom_layout_found){
              layout_filename = Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(custom_layout)+"."+ext;
              if(FileSystem.exists(layout_filename)){
                layout = File.getContent(layout_filename);
                custom_layout_found = true;
                break;
              }
            }
          }
          if(!custom_layout_found){
            throw "Layout "+controller.name+":"+controller.action+" '"+custom_layout+"' doesn't exist at: "+Settings.get("FBN_ROOT")+"app/views/layouts/<br />Must be a supported template type: "+Template.types.toString();
          }
          
        }
        
      }
      if(custom_template == null){
        
        // check for template by default controller and action name
        var default_template_found = false;
        for(ext in Template.types.keys()){
          if(!default_template_found){
            template_filename = Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(controller.name)+"/"+Utils.to_underscore(controller.action)+"."+ext;
            if(FileSystem.exists(template_filename)){
              template = File.getContent(template_filename);
              default_template_found = true;
              break;
            }
          }
        }
        
        if(!default_template_found){
          throw "Default Action template for "+controller.name+":"+controller.action+" not found at "+Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(controller.name)+"/"+Utils.to_underscore(controller.action)+"<br />Must be a supported template type: "+Template.types.toString();
        }
        
      }else{ // custom template defined
        
        var custom_template_found = false;
        
        if(custom_template.indexOf("/")>0){
          // custom path
          
          for(ext in Template.types.keys()){
            if(!custom_template_found){
              template_filename = Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(custom_template)+"."+ext;
              if(FileSystem.exists(template_filename)){
                template = File.getContent(template_filename);
                custom_template_found = true;
                break;
              }
            }
          }
          if(!custom_template_found){
            throw "Template for "+controller.name+":"+controller.action+" not found at "+Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(custom_template)+"<br />Must be a supported template type: "+Template.types.toString();
          }
          
          
        }else{
          // use controller name for path
          
          for(ext in Template.types.keys()){
            if(!custom_template_found){
              template_filename = Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(controller.name)+"/"+Utils.to_underscore(custom_template)+"."+ext;
              if(FileSystem.exists(template_filename)){
                template = File.getContent(template_filename);
                custom_template_found = true;
                break;
              }
            }
          }
          if(!custom_template_found){
            throw "Template for "+controller.name+":"+controller.action+" not found at "+Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(controller.name)+"/"+Utils.to_underscore(custom_template)+"<br />Must be a supported template type: "+Template.types.toString();
          }
          
        }
        
      } // end custom template
      
      
      
      if(custom_content == null){
        content = controller.content;
      }else{
        content = custom_content;
      }
      if(custom_helper == null){
        helper = controller.helper;
      }else{
        helper = custom_helper;
      }
      
      content.set("yield",HamlHX.haml2html(template, template_filename, content, helper)); // page helper
      #if nodejs
        controller.res.write(
      #else
        Lib.print(
      #end
        HamlHX.haml2html(layout, layout_filename, content, helper)
      );
      
      rendered = true;
    }
  }
  
  
  private static inline function determine_template_type( file_name:String ):TemplateType
  {
    var r:TemplateType;
    if(StringTools.endsWith(file_name, ".haml")){
      r = TemplateType.HAML;
    }else if(StringTools.endsWith(file_name, ".mtt")){
      r = TemplateType.TEMPLO;
    }else if(StringTools.endsWith(file_name, ".xml")){
      r = TemplateType.XML;
    }else{
      throw "Template Error! '"+file_name+"' is not one of "+Type.getEnumConstructs(TemplateType).toString();
    }
    
    return r;
  }
  
}