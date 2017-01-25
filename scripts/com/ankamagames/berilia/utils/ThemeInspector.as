package com.ankamagames.berilia.utils
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import nochump.util.zip.ZipEntry;
   import nochump.util.zip.ZipFile;
   
   public class ThemeInspector
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ThemeInspector));
      
      public static const whiteList:Array = new Array("dt","swf","xml","xmls","txt","png","jpg","css","dt","json","fla");
      
      public static const MAX_FILE_SIZE:int = int.MAX_VALUE;
      
      public static const MAX_FILE_NUM:int = 1500;
       
      
      public function ThemeInspector()
      {
         super();
      }
      
      public static function checkArchiveValidity(param1:ZipFile) : Boolean
      {
         var _loc3_:ZipEntry = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1.entries)
         {
            _loc2_ = _loc2_ + _loc3_.size;
         }
         return _loc2_ < MAX_FILE_SIZE && param1.size < MAX_FILE_NUM;
      }
      
      public static function getDtFile(param1:File) : XML
      {
         var _loc2_:File = null;
         var _loc4_:XML = null;
         var _loc5_:FileStream = null;
         var _loc3_:ByteArray = new ByteArray();
         if(param1.exists)
         {
            for each(_loc2_ in param1.getDirectoryListing())
            {
               if(!_loc2_.isDirectory)
               {
                  if(_loc2_.type == ".dt")
                  {
                     if(_loc2_.name.lastIndexOf("/") != -1)
                     {
                        return null;
                     }
                     _loc5_ = new FileStream();
                     _loc5_.open(File(_loc2_),FileMode.READ);
                     _loc5_.readBytes(_loc3_,0,_loc5_.bytesAvailable);
                     _loc5_.close();
                     _loc4_ = new XML(_loc3_.readUTFBytes(_loc3_.bytesAvailable));
                     return _loc4_;
                  }
               }
            }
         }
         return null;
      }
      
      public static function getZipDmFile(param1:ZipFile) : XML
      {
         var entry:ZipEntry = null;
         var dtData:XML = null;
         var dotIndex:int = 0;
         var fileType:String = null;
         var targetFile:ZipFile = param1;
         var rawData:ByteArray = new ByteArray();
         for each(entry in targetFile.entries)
         {
            if(!entry.isDirectory())
            {
               dotIndex = entry.name.lastIndexOf(".");
               fileType = entry.name.substring(dotIndex + 1);
               if(fileType.toLowerCase() == "dt")
               {
                  if(entry.name.lastIndexOf("/") != -1)
                  {
                     return null;
                  }
                  rawData = ZipFile(targetFile).getInput(entry);
                  try
                  {
                     dtData = new XML(rawData.readUTFBytes(rawData.bytesAvailable));
                  }
                  catch(error:Error)
                  {
                     _log.error("Error parsing " + entry.name + "\n" + error.message);
                  }
                  return dtData;
               }
            }
         }
         return null;
      }
   }
}
