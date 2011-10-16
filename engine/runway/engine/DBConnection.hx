/*
  TDD can be applied here for new and custom features of the core Fly By Night engine.
  
*/
package runway.engine;
import db.DBConnection;
class DBConnection extends runway.Unit
{
  public override function afterAll(){
    Settings.set("FBN_ENV", "runway");
    Settings.set("ATMOSPHERE", "runway");
  }
  
  public override function afterEach(){
    db.DBConnection.close();
  }
  
  public function it_connects_to_mysql(){
    Settings.set("FBN_ENV", "runway");
    Settings.set("ATMOSPHERE", "runway");
    assertTrue( db.DBConnection.connection != null );
    assertEquals( "MySQL", db.DBConnection.connection.dbName() );
  }
  
  public function it_connects_to_sqlite3(){
    Settings.set("FBN_ENV", "runway_sqlite");
    Settings.set("ATMOSPHERE", "runway_sqlite");
    assertTrue( db.DBConnection.connection != null );
    assertEquals( "SQLite", db.DBConnection.connection.dbName() );
  }
  
  
  public function it_closes_connection_to_database(){
    db.DBConnection.close();
    assertTrue( neko.db.Manager.cnx == null );
  }
}
