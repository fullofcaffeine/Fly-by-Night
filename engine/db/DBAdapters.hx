package db;
enum DBAdapters
{

#if php || neko

  sqlite3;
  mysql;

#elseif nodejs

  mongodb;

#end

}