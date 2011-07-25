import php.FileSystem;
import php.io.File;
import php.Lib;
import haml_crate.HamlHX;
class AeroView
{
  private var controller: AeroController;
  private var layout: String;
  private var template: String;
  private var content: Hash<Dynamic>;
  private var helper: AeroHelper;
  
  private var _template_type:TemplateType;
  public var template_type(get_template_type,set_template_type):TemplateType;
  private inline function get_template_type():TemplateType{ return _template_type; }
  private inline function set_template_type( val:TemplateType ):TemplateType{ _template_type = val; return _template_type; }
  
  public var type_ext(get_type_ext,null):String;
  private inline function get_type_ext():String{ 
    var r = ".haml";
/*    switch(_type_ext){
      case Std.string(TemplateType.HAML):
        r = ".haml";
      default:
        return ".haml";
    }*/
    return r;  
  }
  
  private var rendered: Bool;
  
  public function new( controller:AeroController )
  {
    this.controller = controller;
  }
  
  public function render( ?custom_layout:String, ?custom_template:String, ?custom_content:Hash<Dynamic>, ?custom_helper:AeroHelper ):Void
  {
    if(!rendered){
      if(custom_layout == null){
        if(FileSystem.exists(Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(controller.name)+type_ext)){
          layout = File.getContent(Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(controller.name)+type_ext);
        }else if(FileSystem.exists(Settings.get("FBN_ROOT")+"app/views/layouts/application"+type_ext)){
          layout = File.getContent(Settings.get("FBN_ROOT")+"app/views/layouts/application"+type_ext);
        }else{
          throw "Default Layout is missing at: "+Settings.get("FBN_ROOT")+"app/views/layouts/application"+type_ext;
        }
      }else{
        if(FileSystem.exists(Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(custom_layout)+type_ext)){
          layout = File.getContent(Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(custom_layout)+type_ext);
        }else{
          throw "Layout "+custom_layout+" doesn't exist at: "+Settings.get("FBN_ROOT")+"/app/views/layouts/"+Utils.to_underscore(custom_layout)+type_ext;
        }
      }
      if(custom_template == null){
        if(FileSystem.exists(Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(controller.name)+"/"+controller.action+type_ext)){
          template = File.getContent(Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(controller.name)+"/"+controller.action+type_ext);
        }else{
          throw "Default Action template for "+controller.action+" not found at "+Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(controller.name)+"/"+controller.action+type_ext;
        }
      }else{
        if(FileSystem.exists(Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(custom_template)+type_ext)){
          template = File.getContent(Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(custom_template)+type_ext);
        }else{
          throw "Template "+custom_template+" doesn't exist at: "+Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(custom_template)+type_ext;
        }
      }
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
      
      content.set("yield",HamlHX.haml2html(template, content, helper)); // page helper
      Lib.print( HamlHX.haml2html(layout, content, helper) );
      
      rendered = true;
    }
  }
  
}