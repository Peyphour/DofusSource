package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class Item implements INetworkType
   {
      
      public static const protocolId:uint = 7;
       
      
      public function Item()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 7;
      }
      
      public function initItem() : Item
      {
         return this;
      }
      
      public function reset() : void
      {
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
      }
      
      public function serializeAs_Item(param1:ICustomDataOutput) : void
      {
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
      }
      
      public function deserializeAs_Item(param1:ICustomDataInput) : void
      {
      }
   }
}
