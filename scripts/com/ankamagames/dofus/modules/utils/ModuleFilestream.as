package com.ankamagames.dofus.modules.utils
{
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.utils.ModuleFileManager;
   import com.ankamagames.jerakine.interfaces.IModuleUtil;
   import com.ankamagames.jerakine.utils.errors.FileTypeError;
   import flash.errors.IOError;
   import flash.errors.IllegalOperationError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ModuleFilestream implements IDataInput, IDataOutput, IModuleUtil
   {
      
      private static const ERROR_SPACE:IOError = new IOError("Not enough space free",1);
      
      private static const ERROR_FILE_NUM:IOError = new IOError("Maximum number of files reaches",2);
      
      private static const ERROR_FILE_NOT_EXISTS:IOError = new IOError("File does not exist",3);
      
      private static const AUTHORIZED_URL_CHAR_REGEXPR:RegExp = new RegExp(/[^a-zA-Z0-9-_\/]/mg);
      
      public static const MAX_SIZE:uint = 10 * Math.pow(2,20);
      
      public static const MODULE_FILE_HEADER:String = "Ankama DOFUS 2 module File";
       
      
      private var _fs:FileStream;
      
      private var _file:File;
      
      private var _fileSize:uint;
      
      private var _nextAddSize:int;
      
      private var _startOffset:uint;
      
      private var _moduleId:String;
      
      private var _fileMode:String;
      
      private var _url:String;
      
      public function ModuleFilestream(param1:String, param2:String, param3:UiModule)
      {
         super();
         ModuleFileManager.getInstance().initModuleFiles(param3.id);
         param1 = cleanUrl(param1);
         this._url = param1;
         this._file = checkCreation(param1,param3);
         if(param2 == FileMode.READ && !this._file.exists)
         {
            throw ERROR_FILE_NOT_EXISTS;
         }
         this._file.parent.createDirectory();
         this._fs = new FileStream();
         this._fs.open(this._file,param2);
         this._fileSize = this._file.size;
         this._moduleId = param3.id;
         this._fileMode = param2;
         var _loc4_:Boolean = !this._file.exists || this._file.size == 0;
         if(param2 == FileMode.WRITE || param2 == FileMode.UPDATE && _loc4_)
         {
            this.writeHeader();
         }
         else
         {
            this.readHeader();
         }
      }
      
      public static function checkCreation(param1:String, param2:UiModule) : File
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         ModuleFileManager.getInstance().initModuleFiles(param2.id);
         param1 = cleanUrl(param1);
         var _loc3_:File = new File(param2.storagePath + param1 + ".dmf");
         if(!_loc3_.exists)
         {
            _loc4_ = param1.replace(/\./g,"").replace(/\\/g,"/").split("/");
            _loc5_ = 0;
            _loc6_ = param2.storagePath;
            for each(_loc7_ in _loc4_)
            {
               _loc6_ = _loc6_ + ("/" + _loc7_);
               if(!new File(_loc6_).exists)
               {
                  _loc5_++;
               }
            }
            if(!ModuleFileManager.getInstance().canCreateFiles(param2.id,_loc5_))
            {
               throw ERROR_FILE_NUM;
            }
            ModuleFileManager.getInstance().updateModuleFileNum(param2.id,_loc5_);
         }
         return _loc3_;
      }
      
      public static function cleanUrl(param1:String) : String
      {
         return param1.replace(AUTHORIZED_URL_CHAR_REGEXPR,"");
      }
      
      [Untrusted]
      public function get objectEncoding() : uint
      {
         return this._fs.objectEncoding;
      }
      
      [Untrusted]
      public function set objectEncoding(param1:uint) : void
      {
         this._fs.objectEncoding = param1;
      }
      
      [Untrusted]
      public function get endian() : String
      {
         return this._fs.endian;
      }
      
      [Untrusted]
      public function get path() : String
      {
         return this._url;
      }
      
      [Untrusted]
      public function set endian(param1:String) : void
      {
         this._fs.endian = param1;
      }
      
      [Untrusted]
      public function get bytesAvailable() : uint
      {
         return this._fs.bytesAvailable;
      }
      
      [Untrusted]
      public function get position() : uint
      {
         return this._fs.position - MODULE_FILE_HEADER.length;
      }
      
      public function set position(param1:uint) : void
      {
         this._fs.position = this.position + MODULE_FILE_HEADER.length;
      }
      
      [Untrusted]
      public function close() : void
      {
         this._fs.close();
      }
      
      [Untrusted]
      public function readBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
      {
         this._fs.readBytes(param1,param2,param3);
      }
      
      [Untrusted]
      public function readBoolean() : Boolean
      {
         return this._fs.readBoolean();
      }
      
      [Untrusted]
      public function readByte() : int
      {
         return this._fs.readByte();
      }
      
      [Untrusted]
      public function readUnsignedByte() : uint
      {
         return this._fs.readUnsignedByte();
      }
      
      [Untrusted]
      public function readShort() : int
      {
         return this._fs.readShort();
      }
      
      [Untrusted]
      public function readUnsignedShort() : uint
      {
         return this._fs.readUnsignedShort();
      }
      
      [Untrusted]
      public function readInt() : int
      {
         return this._fs.readInt();
      }
      
      [Untrusted]
      public function readUnsignedInt() : uint
      {
         return this._fs.readUnsignedInt();
      }
      
      [Untrusted]
      public function readFloat() : Number
      {
         return this._fs.readFloat();
      }
      
      [Untrusted]
      public function readDouble() : Number
      {
         return this._fs.readDouble();
      }
      
      [Untrusted]
      public function readMultiByte(param1:uint, param2:String) : String
      {
         throw new IllegalOperationError();
      }
      
      [Untrusted]
      public function readUTF() : String
      {
         return this._fs.readUTF();
      }
      
      [Untrusted]
      public function readUTFBytes(param1:uint) : String
      {
         return this._fs.readUTFBytes(param1);
      }
      
      [Untrusted]
      public function readObject() : *
      {
         throw new IllegalOperationError();
      }
      
      [Untrusted]
      public function writeBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
      {
         if(param3 == 0)
         {
            if(!this.check(param1.bytesAvailable - param2))
            {
               throw ERROR_SPACE;
            }
            if(!this.check(Math.min(param1.bytesAvailable,param3) - param2))
            {
               throw ERROR_SPACE;
            }
         }
         this._fs.writeBytes(param1,param2,param3);
         this.update();
      }
      
      [Untrusted]
      public function writeBoolean(param1:Boolean) : void
      {
         if(!this.check(1))
         {
            throw ERROR_SPACE;
         }
         this._fs.writeBoolean(param1);
         this.update();
      }
      
      [Untrusted]
      public function writeByte(param1:int) : void
      {
         if(!this.check(1))
         {
            throw ERROR_SPACE;
         }
         this._fs.writeByte(param1);
         this.update();
      }
      
      [Untrusted]
      public function writeShort(param1:int) : void
      {
         if(!this.check(2))
         {
            throw ERROR_SPACE;
         }
         this._fs.writeShort(param1);
         this.update();
      }
      
      [Untrusted]
      public function writeInt(param1:int) : void
      {
         if(!this.check(4))
         {
            throw ERROR_SPACE;
         }
         this._fs.writeInt(param1);
         this.update();
      }
      
      [Untrusted]
      public function writeUnsignedInt(param1:uint) : void
      {
         if(!this.check(4))
         {
            throw ERROR_SPACE;
         }
         this._fs.writeUnsignedInt(param1);
         this.update();
      }
      
      [Untrusted]
      public function writeFloat(param1:Number) : void
      {
         if(!this.check(4))
         {
            throw ERROR_SPACE;
         }
         this._fs.writeFloat(param1);
         this.update();
      }
      
      [Untrusted]
      public function writeDouble(param1:Number) : void
      {
         if(!this.check(8))
         {
            throw ERROR_SPACE;
         }
         this._fs.writeDouble(param1);
         this.update();
      }
      
      [Untrusted]
      public function writeMultiByte(param1:String, param2:String) : void
      {
         throw new IllegalOperationError();
      }
      
      [Untrusted]
      public function writeUTF(param1:String) : void
      {
         if(!this.check(param1.length + 2))
         {
            throw ERROR_SPACE;
         }
         this._fs.writeUTF(param1);
         this.update();
      }
      
      [Untrusted]
      public function writeUTFBytes(param1:String) : void
      {
         if(!this.check(param1.length))
         {
            throw ERROR_SPACE;
         }
         this._fs.writeUTFBytes(param1);
         this.update();
      }
      
      [Untrusted]
      public function writeObject(param1:*) : void
      {
         throw new IllegalOperationError();
      }
      
      private function check(param1:uint) : Boolean
      {
         this._nextAddSize = param1 - (this._fileSize - this._fs.position);
         if(this._nextAddSize < 0)
         {
            this._nextAddSize = 0;
         }
         return this._fileSize + this._nextAddSize <= MAX_SIZE;
      }
      
      private function update() : void
      {
         this._fileSize = this._fileSize + this._nextAddSize;
         ModuleFileManager.getInstance().updateModuleSize(this._moduleId,this._nextAddSize);
         this._nextAddSize = 0;
      }
      
      private function readHeader() : void
      {
         this._fs.position = 0;
         var _loc1_:String = this._fs.readUTF();
         if(_loc1_ != MODULE_FILE_HEADER)
         {
            throw new FileTypeError("Wrong header");
         }
         this._startOffset = this._fs.position;
         if(this._fileMode == FileMode.APPEND)
         {
            this._fs.position = this._fs.position + this._fs.bytesAvailable;
         }
      }
      
      private function writeHeader() : void
      {
         this._fs.position = 0;
         this._fs.writeUTF(MODULE_FILE_HEADER);
      }
   }
}
