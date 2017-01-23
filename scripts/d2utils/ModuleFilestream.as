package d2utils
{
   import flash.utils.ByteArray;
   import utils.DirectAccessObject;
   
   public dynamic class ModuleFilestream extends DirectAccessObject
   {
       
      
      public function ModuleFilestream(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      [Untrusted]
      public function get endian() : String
      {
         return _target.endian;
      }
      
      [Untrusted]
      public function get path() : String
      {
         return _target.path;
      }
      
      [Untrusted]
      public function set endian(param1:String) : void
      {
         _target.endian = param1;
      }
      
      [Untrusted]
      public function get bytesAvailable() : uint
      {
         return _target.bytesAvailable;
      }
      
      [Untrusted]
      public function get position() : uint
      {
         return _target.position;
      }
      
      [Untrusted]
      public function set position(param1:uint) : void
      {
         _target.position = param1;
      }
      
      [Untrusted]
      public function close() : void
      {
         _target.close();
      }
      
      [Untrusted]
      public function readBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
      {
         _target.readBytes(param1,param2,param3);
      }
      
      [Untrusted]
      public function readBoolean() : Boolean
      {
         return _target.readBoolean();
      }
      
      [Untrusted]
      public function readByte() : int
      {
         return _target.readByte();
      }
      
      [Untrusted]
      public function readUnsignedByte() : uint
      {
         return _target.readUnsignedByte();
      }
      
      [Untrusted]
      public function readShort() : int
      {
         return _target.readShort();
      }
      
      [Untrusted]
      public function readUnsignedShort() : uint
      {
         return _target.readUnsignedShort();
      }
      
      [Untrusted]
      public function readInt() : int
      {
         return _target.readInt();
      }
      
      [Untrusted]
      public function readUnsignedInt() : uint
      {
         return _target.readUnsignedInt();
      }
      
      [Untrusted]
      public function readFloat() : Number
      {
         return _target.readFloat();
      }
      
      [Untrusted]
      public function readDouble() : Number
      {
         return _target.readDouble();
      }
      
      [Untrusted]
      public function readUTF() : String
      {
         return _target.readUTF();
      }
      
      [Untrusted]
      public function readUTFBytes(param1:uint) : String
      {
         return _target.readUTFBytes(param1);
      }
      
      [Untrusted]
      public function writeBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
      {
         _target.writeBytes(param1,param2,param3);
      }
      
      [Untrusted]
      public function writeBoolean(param1:Boolean) : void
      {
         _target.writeBoolean(param1);
      }
      
      [Untrusted]
      public function writeByte(param1:int) : void
      {
         _target.writeByte(param1);
      }
      
      [Untrusted]
      public function writeShort(param1:int) : void
      {
         _target.writeShort(param1);
      }
      
      [Untrusted]
      public function writeInt(param1:int) : void
      {
         _target.writeInt(param1);
      }
      
      [Untrusted]
      public function writeUnsignedInt(param1:uint) : void
      {
         _target.writeUnsignedInt(param1);
      }
      
      [Untrusted]
      public function writeFloat(param1:Number) : void
      {
         _target.writeFloat(param1);
      }
      
      [Untrusted]
      public function writeDouble(param1:Number) : void
      {
         _target.writeDouble(param1);
      }
      
      [Untrusted]
      public function writeUTF(param1:String) : void
      {
         _target.writeUTF(param1);
      }
      
      [Untrusted]
      public function writeUTFBytes(param1:String) : void
      {
         _target.writeUTFBytes(param1);
      }
   }
}
