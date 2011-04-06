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
      filename = fileName;
      if(!FileSystem.exists(uploads_dir)){
        FileSystem.createDirectory(uploads_dir);
      }
    },function(d:Bytes, pos:Int, len:Int){
      if(currentFileName != filename){
        currentFileName = filename;
        output = File.write(uploads_dir+filename, true);
      }
      output.write(Bytes.ofString(Std.string(d)));
      totalBytes += len;
    });
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