package d2api
{
   import d2utils.ModuleFilestream;
   
   public class FileApi
   {
       
      
      public function FileApi()
      {
         super();
      }
      
      [Untrusted]
      public function loadXmlFile(param1:String, param2:Function, param3:Function = null) : void
      {
      }
      
      [Trusted]
      public function trustedLoadXmlFile(param1:String, param2:Function, param3:Function = null) : void
      {
      }
      
      [Untrusted]
      public function openFile(param1:String, param2:String = "update") : ModuleFilestream
      {
         return null;
      }
      
      [Untrusted]
      public function deleteFile(param1:String) : void
      {
      }
      
      [Untrusted]
      public function deleteDir(param1:String, param2:Boolean = true) : void
      {
      }
      
      [Untrusted]
      public function getDirectoryContent(param1:String = null, param2:Boolean = false, param3:Boolean = false) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function isDirectory(param1:String) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function createDirectory(param1:String) : void
      {
      }
      
      [Untrusted]
      public function getAvaibleSpace() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getUsedSpace() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getMaxSpace() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getUsedFileCount() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getMaxFileCount() : uint
      {
         return 0;
      }
   }
}
