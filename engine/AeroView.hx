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
  
  public function render_text( text:String, ?custom_layout:String ):Void
  {
    if(custom_layout != null){
      var layout_filename = Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(custom_layout)+type_ext;
      if(FileSystem.exists(layout_filename)){
        layout = File.getContent(layout_filename);
      }else{
        throw "Layout "+custom_layout+" doesn't exist at: "+layout_filename;
      }
      
      content.set("yield",text);
      Lib.print( HamlHX.haml2html(layout, layout_filename, content, helper) );
      
    }else{
      Lib.print( text );
    }
    rendered = true;
  }
  
  public function render( ?custom_layout:String, ?custom_template:String, ?custom_content:Hash<Dynamic>, ?custom_helper:AeroHelper ):Void
  {
    var layout_filename, template_filename = "";
    if(!rendered){
      if(custom_layout == null){
        if( Reflect.hasField(Type.getClass(controller), "layout" ) ){
          layout_filename = Settings.get("FBN_ROOT")+"app/views/layouts/"+Reflect.field(Type.getClass(controller), "layout" )+type_ext;
        } else{
          layout_filename = Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(controller.name)+type_ext;
        }
        
        if(FileSystem.exists(layout_filename)){
          layout = File.getContent(layout_filename);
        }else{
          layout_filename = Settings.get("FBN_ROOT")+"app/views/layouts/application"+type_ext;
          if(FileSystem.exists(layout_filename)){
            layout = File.getContent(layout_filename);
          }else{
            throw "Default Layout is missing at: "+layout_filename;
          }
        }
      }else if(custom_layout == "false"){
        layout_filename = "[none]";
        layout = "= yield";
      }else{
        layout_filename = Settings.get("FBN_ROOT")+"app/views/layouts/"+Utils.to_underscore(custom_layout)+type_ext;
        if(FileSystem.exists(layout_filename)){
          layout = File.getContent(layout_filename);
        }else{
          throw "Layout "+custom_layout+" doesn't exist at: "+layout_filename;
        }
      }
      if(custom_template == null){
        template_filename = Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(controller.name)+"/"+controller.action+type_ext;
        if(FileSystem.exists(template_filename)){
          template = File.getContent(template_filename);
        }else{
          throw "Default Action template for "+controller.action+" not found at "+template_filename;
        }
      }else{
       template_filename = Settings.get("FBN_ROOT")+"app/views/"+Utils.to_underscore(custom_template)+type_ext;
        if(FileSystem.exists(template_filename)){
          template = File.getContent(template_filename);
        }else{
          throw "Template "+custom_template+" doesn't exist at: "+template_filename;
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
      
      content.set("yield",HamlHX.haml2html(template, template_filename, content, helper)); // page helper
      Lib.print( HamlHX.haml2html(layout, layout_filename, content, helper) );
      
      rendered = true;
    }
  }
  
}