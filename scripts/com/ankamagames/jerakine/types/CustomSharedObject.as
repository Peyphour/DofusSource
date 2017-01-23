package com.ankamagames.jerakine.types
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.errors.CustomSharedObjectFileFormatError;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.ObjectEncoding;
   import flash.utils.getQualifiedClassName;
   
   public class CustomSharedObject
   {
      
      public static const DATAFILE_EXTENSION:String = "dat";
      
      public static var clearedCacheAndRebooting:Boolean = false;
      
      private static var COMMON_FOLDER:String;
      
      private static var _cache:Array = [];
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CustomSharedObject));
      
      public static var throwException:Boolean;
       
      
      private var _name:String;
      
      private var _fileStream:FileStream;
      
      private var _file:File;
      
      public var data:Object;
      
      public var objectEncoding:uint;
      
      public function CustomSharedObject()
      {
         this.data = new Object();
         super();
      }
      
      public static function getLocal(param1:String) : CustomSharedObject
      {
         if(_cache[param1])
         {
            return _cache[param1];
         }
         if(!COMMON_FOLDER)
         {
            COMMON_FOLDER = getCustomSharedObjectDirectory();
         }
         var _loc2_:CustomSharedObject = new CustomSharedObject();
         _loc2_._name = param1;
         _loc2_.getDataFromFile();
         _cache[param1] = _loc2_;
         return _loc2_;
      }
      
      public static function getCustomSharedObjectDirectory() : String
      {
         var _loc1_:Array = null;
         var _loc2_:File = null;
         var _loc3_:Array = null;
         if(!COMMON_FOLDER)
         {
            _loc1_ = File.applicationDirectory.nativePath.split(File.separator);
            if(AirScanner.hasAir())
            {
               if(CommandLineArguments.getInstance().hasArgument("prefs"))
               {
                  COMMON_FOLDER = CommandLineArguments.getInstance().getArgument("prefs");
               }
               else
               {
                  _loc3_ = File.applicationStorageDirectory.nativePath.split(File.separator);
                  _loc3_.pop();
                  _loc3_.pop();
                  COMMON_FOLDER = _loc3_.join(File.separator) + File.separator + _loc1_[_loc1_.length - 2];
               }
            }
            else
            {
               COMMON_FOLDER = File.applicationStorageDirectory.nativePath;
            }
            COMMON_FOLDER = COMMON_FOLDER + File.separator;
            _loc2_ = new File(COMMON_FOLDER);
            if(!_loc2_.exists)
            {
               _loc2_.createDirectory();
            }
         }
         return COMMON_FOLDER;
      }
      
      public static function closeAll() : void
      {
         var _loc1_:CustomSharedObject = null;
         for each(_loc1_ in _cache)
         {
            if(_loc1_)
            {
               _loc1_.close();
            }
         }
      }
      
      public static function resetCache() : void
      {
         _cache = [];
      }
      
      public static function clearCache(param1:String) : void
      {
         delete _cache[param1];
      }
      
      public function flush() : void
      {
         if(clearedCacheAndRebooting)
         {
            return;
         }
         this.writeData(this.data);
      }
      
      public function clear() : void
      {
         this.data = new Object();
         this.writeData(this.data);
      }
      
      public function close() : void
      {
         if(this._fileStream)
         {
            this._fileStream.close();
         }
      }
      
      private function writeData(param1:*) : Boolean
      {
         var data:* = param1;
         try
         {
            this._fileStream.open(this._file,FileMode.WRITE);
            this._fileStream.writeObject(data);
            this._fileStream.close();
         }
         catch(e:Error)
         {
            if(_fileStream)
            {
               _fileStream.close();
            }
            _log.error("Impossible d\'écrire le fichier " + _file.url);
            return false;
         }
         return true;
      }
      
      private function getDataFromFile() : void
      {
         if(!this._file)
         {
            this._file = new File(COMMON_FOLDER + this._name + "." + DATAFILE_EXTENSION);
            this._fileStream = new FileStream();
         }
         if(this._file.exists)
         {
            try
            {
               this._fileStream.objectEncoding = ObjectEncoding.AMF3;
               this._fileStream.open(this._file,FileMode.READ);
               this.data = this._fileStream.readObject();
               this._fileStream.close();
            }
            catch(e:Error)
            {
               if(_fileStream)
               {
                  _fileStream.close();
               }
               _log.error("Impossible d\'ouvrir le fichier " + _file.url);
               if(throwException)
               {
                  throw new CustomSharedObjectFileFormatError("Malformated file : " + _file.url);
               }
            }
         }
         if(!this.data)
         {
            this.data = new Object();
         }
      }
   }
}
