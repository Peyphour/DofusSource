package org.as3commons.bytecode.tags.serialization
{
   import flash.utils.ByteArray;
   import org.as3commons.bytecode.tags.EndTag;
   import org.as3commons.bytecode.tags.ISWFTag;
   import org.as3commons.bytecode.tags.struct.RecordHeader;
   
   public class EndTagSerializer extends AbstractTagSerializer
   {
       
      
      public function EndTagSerializer(param1:IStructSerializerFactory)
      {
         super(param1);
      }
      
      override public function read(param1:ByteArray, param2:RecordHeader) : ISWFTag
      {
         return new EndTag();
      }
      
      override public function write(param1:ByteArray, param2:ISWFTag) : void
      {
      }
   }
}
