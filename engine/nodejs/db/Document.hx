package nodejs.db;
#if mongodb
  import js.node.mongo.Mongo;
#end
#if nodejs
  class Document{ 
    
    public var _id: ObjectID; // id: String;
    
    function new(){
      
      
      
    } 
    function insert(){ throw("AeroModel.insert() doesn't exist yet!"); }
    function update(){ throw("AeroModel.update() doesn't exist yet!"); }
    function delete(){ throw("AeroModel.delete() doesn't exist yet!"); }
    public dynamic function toString():String{ throw("AeroModel.toString() doesn't exist yet!"); return "AeroModel.toString() doesn't exist yet!"; }
  }
#end