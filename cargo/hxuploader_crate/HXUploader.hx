package hxuploader_crate;
import haxe.io.Bytes;
import php.Web;
import php.NativeArray;
import php.io.File;
import php.io.FileOutput;
import php.FileSystem;
class HXUploader
{

  public static function upload(uploads_dir:String = "upload/"):Void
  {
    var currentFileName = "";
    var output:FileOutput = null;
    var filename = "";
    var totalBytes:Int = 0;
    
    Web.parseMultipart(function(partName:String, fileName:String){
      if(!FileSystem.exists(uploads_dir)){
        FileSystem.createDirectory(uploads_dir);
      }
      filename = fileName;
    },function(d:Bytes, pos:Int, len:Int){
      if(currentFileName != filename){
        currentFileName = filename;
        output = File.write(uploads_dir+filename, true);
      }
      output.write(Bytes.ofString(Std.string(d)));
      totalBytes += len;
    });
  }
  
  // will only append _1 and doesn't count up past it yet. 
  // TODO: fix this 
  public static inline function checkIdenticalFileName( fileName:String, uploads_dir:String ): String
  {
    var newFileName = fileName;
    var saveFileName = fileName;
    var newFileExt = "";
    
    var dot_pos = fileName.lastIndexOf(".");
    if(dot_pos > 0){
      var newFileName = fileName.substr(0,fileName.lastIndexOf("."));
      var saveFileName = newFileName;
      var newFileExt = fileName.substr(fileName.lastIndexOf(".")+1);
    }
    
    var i = 1;
    if(FileSystem.exists(uploads_dir+fileName)){
      if(newFileName.lastIndexOf("_")>0){
        if(Std.parseInt(newFileName.substr(newFileName.lastIndexOf("_")+1)) > 0){
          var lastNum = Std.parseInt(newFileName.substr(newFileName.lastIndexOf("_")+1));
          while(FileSystem.exists(uploads_dir+newFileName+"."+newFileExt)){
            newFileName = saveFileName+"_"+Std.string(lastNum++);
          }
          //newFileName = newFileName.substr(0,newFileName.lastIndexOf("_"))+"_"+Std.string(lastNum+1);
        }else{
          while(FileSystem.exists(uploads_dir+newFileName+"."+newFileExt)){
            newFileName = saveFileName+"_"+Std.string(i++);
          }
        }
      }else{
        while(FileSystem.exists(uploads_dir+newFileName+"."+newFileExt)){
          newFileName = saveFileName+"_"+Std.string(i++);
        }
      }
    }
    
    return newFileName+"."+newFileExt;
  }

	/* from project poko poko.utils.PhpTools */
	public static function getFilesInfo():Hash <Hash<Dynamic>>
		{
			var files:Hash<NativeArray> = php.Lib.hashOfAssociativeArray(untyped __php__("$_FILES"));
			var output:Hash < Hash < String >> = new Hash();

			for (file in files.keys())
				output.set(file, php.Lib.hashOfAssociativeArray(files.get(file)));	

			return output;
		}
}