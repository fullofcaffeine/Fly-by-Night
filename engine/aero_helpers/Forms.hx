package aero_helpers;
class Forms extends AeroHelper
{

  private var input_keys: Hash<Int>;
  public function new(c:AeroController)
  {
    super(c);
    input_keys = new Hash<Int>();
  }
  public inline function label( attribute_name:String, ?val:String ):String
  {
    var _id = Utils.to_underscore(Utils.singularize(controller.name)+" "+attribute_name);
    attribute_name = (val!=null)? val : Utils.titleize(attribute_name); 
    return "<label id='label_for_"+_id+"' for='"+_id+"'>"+attribute_name+"</label>";
  }
  public inline function label_tag( obj:String, attribute_name:String, ?val:String ):String
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
  
  public inline function file_field( attribute_name:String ):String
  {
    var obj = Utils.to_underscore(Utils.singularize(controller.name));
    var _id = obj+"_"+Utils.to_underscore(attribute_name);
    var _name = _id;
    
    var tag = "<input id='"+_id+"' type='file' name='"+_name+"' />";
    return tag;
  }
  
  private inline function getInputIndex( obj:String ):Int
  {
    var i = 0;
    if(input_keys.exists(obj)){
      i = input_keys.get(obj)+1;
    }
    input_keys.set(obj, i);
    return i;
  }
  
}