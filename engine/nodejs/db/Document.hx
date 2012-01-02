#if nodejs
  package nodejs.db;
  class Document{ function new(){} 
    function insert(){ throw("AeroModel.insert() doesn't exist yet!"); }
    function update(){ throw("AeroModel.update() doesn't exist yet!"); }
    function delete(){ throw("AeroModel.delete() doesn't exist yet!"); }
    public function toString():String{ throw("AeroModel.toString() doesn't exist yet!"); return "AeroModel.toString() doesn't exist yet!"; }
  }
#end