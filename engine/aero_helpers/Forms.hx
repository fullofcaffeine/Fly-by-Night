package aero_helpers;
typedef OptionForSelect =
{
  var key:String;
  var value:String;
  /*var selected:Bool;*/
}

class Forms extends AeroHelper
{

  private var input_keys: Hash<Int>;
  public function new(c:AeroController)
  {
    super(c);
    input_keys = new Hash<Int>();
  }
  public inline function label( attribute_name:String ):String
  {
    var _id = Utils.to_underscore(Utils.singularize(controller.name)+" "+attribute_name);
    attribute_name = Utils.titleize(attribute_name); 
    return "<label id='label_for_"+_id+"' for='"+_id+"'>"+attribute_name+"</label>";
  }
  public inline function label_val( attribute_name:String, val:String ):String
  {
    var _id = Utils.to_underscore(Utils.singularize(controller.name)+" "+attribute_name);
    attribute_name = (val!=null)? val : Utils.titleize(attribute_name); 
    return "<label id='label_for_"+_id+"' for='"+_id+"'>"+attribute_name+"</label>";
  }
  public inline function label_tag( obj:String, attribute_name:String ):String
  {
    var _id = Utils.to_underscore(obj+" "+attribute_name);
    attribute_name = Utils.titleize(attribute_name); 
    return "<label id='label_for_"+_id+"' for='"+_id+"'>"+attribute_name+"</label>";
  }
  public inline function label_tag_val( obj:String, attribute_name:String, val:String ):String
  {
    var _id = Utils.to_underscore(obj+" "+attribute_name);
    attribute_name = (val!=null)? val : Utils.titleize(attribute_name); 
    return "<label id='label_for_"+_id+"' for='"+_id+"'>"+attribute_name+"</label>";
  }
  public inline function text_field_tag( obj:String, attribute_name:String ):String
  {
    obj = Utils.to_underscore(obj);
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='text' name='"+_name+"' />";
    return tag;
  }
  public inline function text_field_tag_val( obj:String, attribute_name:String, val:String ):String
  {
    obj = Utils.to_underscore(obj);
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='text' name='"+_name+"' value='"+Utils.strip_input_val(val)+"' />";
    return tag;
  }
  public inline function password_field_tag( obj:String, attribute_name:String, val:String ):String
  {
    obj = Utils.to_underscore(obj);
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='password' name='"+_name+"' value='"+Utils.strip_input_val(val)+"' />";
    return tag;
  }
  public inline function textarea_field_tag( obj:String, attribute_name:String ):String
  {
    obj = Utils.to_underscore(obj);
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<textarea id='"+_id+"' name='"+_name+"' cols='40' rows='10'></textarea>";
    
    return tag;
  }
  
  /*
   * options
   * ?autolabel:Bool = true, ?label:String
   *
  */
  public inline function checkbox_field_tag( obj:String, attribute_name:String, ?options:Hash<Dynamic> ):String
  {
    var autolabel = options.get("autolabel");
    var label = options.get("label");
    obj = Utils.to_underscore(obj);
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' name='"+_name+"' type='checkbox' />";
    if(autolabel){
      if(label == null){
        label = Utils.titleize(attribute_name);
      }
      tag += label_tag_val(obj,attribute_name,label);
    }
    return tag;
  }
  
  public inline function hidden_field_tag( obj:String, attribute_name:String ):String
  {
    obj = Utils.to_underscore(obj);
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='hidden' name='"+_name+"' />";
    return tag;
  }
  public inline function hidden_field_tag_val( obj:String, attribute_name:String, val:String ):String
  {
    obj = Utils.to_underscore(obj);
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='hidden' name='"+_name+"' value='"+Utils.strip_input_val(val)+"' />";
    return tag;
  }
  
  
  /*
  %input{ type : "hidden", name : "post_keys[1]", value : "body" }
  %textarea{ id : "post_body", name : "post[1]" } .
  */
  
  /*
  * Uses controller object name as the object
  */
  public inline function text_field( attribute_name:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='text' name='"+_name+"' />";
    return tag;
  }
  
  public inline function text_field_val( attribute_name:String, val:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='text' name='"+_name+"' value='"+Utils.strip_input_val(val)+"' />";
    return tag;
  }
  
  public inline function password_field( attribute_name:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='password' name='"+_name+"' />";
    return tag;
  }
  
  public inline function textarea_field( attribute_name:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<textarea id='"+_id+"' name='"+_name+"' cols='40' rows='10'></textarea>";
    return tag;
  }
  public inline function textarea_field_val( attribute_name:String, val:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<textarea id='"+_id+"' name='"+_name+"' cols='40' rows='10'>"+Utils.strip_input_val(val)+"</textarea>";
    return tag;
  }
  
  public inline function checkbox_field( attribute_name:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' name='"+_name+"' type='checkbox' />";
    return tag;
  }
  
  public inline function file_field( attribute_name:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var _name = _id;
    
    var tag = "<input id='"+_id+"' type='file' name='"+_name+"' />";
    return tag;
  }
  
  public inline function hidden_field( attribute_name:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='hidden' name='"+_name+"' />";
    return tag;
  }
  
  public inline function hidden_field_val( attribute_name:String, val:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='hidden' name='"+_name+"' value='"+Utils.strip_input_val(val)+"' />";
    return tag;
  }
  
  public inline function select_field( attribute_name:String, options_for_select:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<select id='"+_id+"' name='"+_name+"'>\n"+
              options_for_select+
              "</select>";
              
    return tag;
  }
  
  /* type = button, reset, submit */
  public inline function button( attribute_name:String, val:String, ?type:String = 'button', ?options:String = "" ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<button id='"+_id+"' name='"+_name+"' type='"+type+"' "+options+">"+val+"</button>";
              
    return tag;
  }
  
  
  
  
  
  public static inline function options_for_select( options_list:Iterable<Dynamic>, ?value:String = "key", ?display:String = "value", ?selected:String = "" ):String
  {
    var items = new Array<String>();
    var item = "";
    for(o in options_list){
      if(Reflect.hasField(o,value)){
        item = "<option value='"+Reflect.field(o,value)+"'";
        if(selected != ""){
          if(Std.string(Reflect.field(o,value)) == selected){
            item += " selected='selected'";
          }
        }else if(Reflect.hasField(o,"selected") && Reflect.field(o,"selected") == true){
          item += " selected='selected'";
        }
        item += ">";
        if(Reflect.hasField(o,display)){
          item += Reflect.field(o,display);
        }
        item += "</option>";
      }
      items.push(item);
    }
    return items.join("\n");
  }
  
  
  
  
  public inline function getInputIndex( obj:String ):Int
  {
    var i = 0;
    if(input_keys.exists(obj)){
      i = input_keys.get(obj)+1;
    }
    input_keys.set(obj, i);
    return i;
  }
  
  
  
  
  /* requires JQuery UI */
  public inline function date_picker( attribute_name:String, ?format:String = 'yy-mm-dd' ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var input_index = getInputIndex(obj);
    var _name = obj+"["+input_index+"]";
    
    var tag = "<input id='"+obj+"_keys_"+input_index+"' type='hidden' name='"+obj+"_keys["+input_index+"]' value='"+attribute_name+"' />"+
              "<input id='"+_id+"' type='text' name='"+_name+"' />
              <script type='text/javascript'>$(function(){ $('#"+_id+"').datepicker({dateFormat:'"+format+"'})});</script>";
    return tag;
  }
  
  
  
}