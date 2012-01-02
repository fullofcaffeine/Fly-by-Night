#if mongodb
  import js.node.mongo.Mongo;
#end
#if nodejs
  package nodejs.db;
  class Document{ 
    
    public var id: ObjectID;
    
    function new(){
      
      pool.connection(function (db :Database) {
   			trace('db=' + db);

   			MongoTools.create(pool, DBStore, function (err :MongoErr, obj :DBStore) {
   				if (err != null) trace(Std.string(err));
   				if(obj==null) trace( "obj is null" );

   				trace('obj=' + Std.string(obj));

   				MongoTools.load(pool, DBStore, obj._id, function (err :MongoErr, loaded :DBStore) {
   					if (err != null) trace(Std.string(err));
   					trace('loaded=' + Std.string(loaded));
   					if(loaded==null) trace( "loaded is null" );

   					MongoTools.find(pool, DBStore, "a", 1, function (err :MongoErr, loaded :DBStore) {
   						if (err != null) trace(Std.string(err));
   						trace('found with a==1:' + Std.string(loaded));
               if(loaded==null) trace( "find loaded is null" );

   						loaded.b = "changed";

   						MongoTools.update(pool, loaded, function (err :MongoErr, done :Bool) {
   							if (err != null) trace(Std.string(err));
   							trace('updated, now load again');

   							MongoTools.load(pool, DBStore, loaded._id, function (err :MongoErr, updated :DBStore) {
   								if (err != null) trace(Std.string(err));
   								trace('updated loaded=' + Std.string(updated));

   								MongoTools.keys(pool, DBStore, function (err :MongoErr, keys :Array<Dynamic>) {
   									if (err != null) trace(Std.string(err));
   									trace('keys=' + keys);
   								});
   							});
   						});
   					});
   				});
   			});




   			// db.collection("test", function (err :MongoErr, collection :Collection) {
   			// 	var obj :MongoObj = {};
   			// 	Reflect.setField(obj, "foo", "blah");
   			// 	collection.insert(obj, function (err :MongoErr, inserted :MongoObj) {
   			// 		trace('inserted=' + Std.string(inserted));

   			// 		pool.returnConnection(db);


   			// 	});
   			// });
   		});
      
      
    } 
    function insert(){ throw("AeroModel.insert() doesn't exist yet!"); }
    function update(){ throw("AeroModel.update() doesn't exist yet!"); }
    function delete(){ throw("AeroModel.delete() doesn't exist yet!"); }
    public function toString():String{ throw("AeroModel.toString() doesn't exist yet!"); return "AeroModel.toString() doesn't exist yet!"; }
  }
#end