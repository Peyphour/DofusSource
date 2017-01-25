package org.as3commons.bytecode.tags.serialization
{
   import flash.utils.ByteArray;
   import org.as3commons.bytecode.tags.ISWFTag;
   import org.as3commons.bytecode.tags.struct.RecordHeader;
   
   public class AbstractTagSerializer implements ITagSerializer
   {
       
      
      private var _structSerializerFactory:IStructSerializerFactory;
      
      public function AbstractTagSerializer(param1:IStructSerializerFactory = null)
      {
         super();
         this._structSerializerFactory = param1;
      }
      
      public function get structSerializerFactory() : IStructSerializerFactory
      {
         return this._structSerializerFactory;
      }
      
      public function read(param1:ByteArray, param2:RecordHeader) : ISWFTag
      {
         throw new Error("Method not implemented in abstract base class");
      }
      
      public function write(param1:ByteArray, param2:ISWFTag) : void
      {
         throw new Error("Method not implemented in abstract base class");
      }
   }
}
