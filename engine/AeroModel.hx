/*
  To see a full list of auto imported classes for all subclasses of AeroModel
  See LandingGearMacro.APPEND_TO_MODEL
  
  
  TODO: add exists() get()
  TODO: add dynamic getters (through macros?) for strings, then use Utils.strip_slashes
  
  - nodejs uses nodejs.db.Document
  - php and - neko use SPOD Object
*/
#if php
  import php.FileSystem;
  import php.db.Object;
  import php.db.Manager;
#elseif neko
  import neko.FileSystem;
  import neko.db.Object;
  import neko.db.Manager;
#elseif nodejs
  import nodejs.db.Document;
  import js.Node;
#end
#if mongodb
  import js.node.mongo.Mongo;
  import js.node.mongo.MongoPool;
  import js.node.mongo.MongoTools;
#end

import db.DBConnection;

#if mongodb
  class AeroModel extends Document
#else
  class AeroModel extends Object
#end
{
  
  // Document uses ObjectID
  #if ( php || neko )
    public var id: Int;
    public var manager: Dynamic;
  #elseif mongodb
    public var id:String; // last 4 of _id, reroll if exists
  #end
  
    
  public function new( )
  {
    DBConnection.connection;
/*    name = Type.getClassName(Type.getClass(this)).substr(8); // models.*/
    #if ( php || neko )
      manager = new Manager(cast Type.resolveClass(Type.getClassName(Type.getClass(this))));
    #end
    
    super();
      
  }

  public function save( ):Bool
  {
    DBConnection.connection;
    
    if(find(Type.getClass(this),this.id) == null){ // new record
      
      // magic columns
      if(Lambda.has(Type.getInstanceFields(Type.getClass(this)),"created_at")){
        Reflect.setField(this, "created_at", Date.now());
      }
      if(Lambda.has(Type.getInstanceFields(Type.getClass(this)),"updated_at")){
        Reflect.setField(this, "updated_at", Date.now());
      }
      
      this.insert();
    }else{
      // magic columns
      if(Reflect.hasField(Type.getClass(this), "updated_at")){
        Reflect.setField(this, "updated_at", Date.now());
      }
      
      this.update();
    }
    
    // TODO FIXME do checks, validations, etc.
    return true;
  }
  public function destroy():Void
  {
    // TODO add before_destroy
    this.delete();
    // TODO add after_destroy
  }
  
  public static inline function all( model:Dynamic, ?conditions:String, ?order:String, ?limit:Int = -1, ?offset:Int = -1):List<Dynamic>
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    var result:List<Dynamic> = new List<Dynamic>();
    var _limit = "";
    if(limit >= 0){
      _limit = "LIMIT "+Std.string(limit);
    }
    var _offset = "";
    if(offset >= 0){
      _offset = "OFFSET "+Std.string(offset);
    }
    var _order = "";
    if(order != null){
      _order = "ORDER BY "+order;
    }
    if(Type.getSuperClass(model) == AeroModel){
      #if ( php || neko )
        var manager = new Manager(cast Type.resolveClass(class_name));
  /*      result = manager.all(false);*/
        result = manager.objects("SELECT * FROM "+Reflect.field(Type.resolveClass(class_name), "TABLE_NAME")+" "+conditions+" "+_order+" "+_limit+" "+_offset, false);
      #end
    }
    return result;
  }
  public static inline function find( 
    model:Dynamic, 
    #if (php || neko)
      id:Int
    #elseif nodejs
      id:String
    #end
    ):Dynamic
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    
    #if ( php || neko )
      var result:Object = null;
    #elseif mongodb
      var result:Document = null;
    #end
    if(Type.getSuperClass(model) == AeroModel){
      #if ( php || neko )
        var manager = new Manager(cast Type.resolveClass(class_name));
        result = manager.get(id);
  /*      result = manager.objects("SELECT * FROM posts", false);*/
      #elseif mongodb
        var pool = DBConnection.connection;
        pool.connection(function (db :Database) {
    			trace('db=' + db);

    			MongoTools.create(pool, model, function (err :MongoErr, obj :Dynamic) {
    				if (err != null) trace(Std.string(err));
    				// Assert.isNotNull(obj);
    				trace('obj=' + Std.string(obj));

    				MongoTools.load(pool, model, obj._id, function (err :MongoErr, loaded :Dynamic) {
    					if (err != null) trace(Std.string(err));
    					trace('loaded=' + Std.string(loaded));
    					// Assert.isNotNull(loaded, "loaded is null");

    					MongoTools.find(pool, model, "id", id, function (err :MongoErr, loaded :Dynamic) {
    						if (err != null) trace(Std.string(err));
    						trace('found with a==1:' + Std.string(loaded));

    						//Assert.isNotNull(loaded, "find loaded is null");	


    						/*MongoTools.update(DBConnection.pool, loaded, function (err :MongoErr, done :Bool) {
    						                  if (err != null) trace(Std.string(err));
    						                  trace('updated, now load again');

    						                  MongoTools.load(DBConnection.pool, DBStore, loaded._id, function (err :MongoErr, updated :DBStore) {
    						                    if (err != null) trace(Std.string(err));
    						                    trace('updated loaded=' + Std.string(updated));

    						                    MongoTools.keys(DBConnection.pool, DBStore, function (err :MongoErr, keys :Array<Dynamic>) {
    						                      if (err != null) trace(Std.string(err));
    						                      trace('keys=' + keys);
    						                    });
    						                  });*/
                });                
    					});
    				});
    			});
    
        
        
        
        
        
        
        
        
        
      #end
    }
    return result;
  }
  
  public static inline function count( model:Dynamic, ?conditions:String ):Int
  {
    DBConnection.connection;
    
    var class_name = Type.getClassName(model);
    var result:Dynamic;
    var count = 0;
    if(Type.getSuperClass(model) == AeroModel){
      #if ( php || neko )
        var manager = new Manager(cast Type.resolveClass(class_name));
  /*      result = manager.all(false);*/
        result = manager.result("SELECT COUNT(*) as `count` FROM "+Reflect.field(Type.resolveClass(class_name), "TABLE_NAME")+" "+conditions);
        count = result.count;
      #end
    }
    return count;
  }
  
  public override function toString(  ):String
  {
    var out = Type.getClass(this) + " => {\n";
    var hash = this.toHash();
    for(key in hash.keys()){
      out += "\t"+key+" => "+hash.get(key)+"\n";
    }
    out += "}";
    //return this.toHash().toString();
    return out;
  }
  public inline function toHash(  ):Hash<Dynamic>
  {
    var fields = Lambda.filter(Reflect.fields(this),function(f){ return !StringTools.startsWith(f,"__"); });
    var fields_hash = new Hash<Dynamic>();
    for(field in fields){
      fields_hash.set(field,Reflect.field(this,field));
    }
    return fields_hash;
  }
  
}