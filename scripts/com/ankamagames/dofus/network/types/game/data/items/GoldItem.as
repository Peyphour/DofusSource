package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GoldItem extends Item implements INetworkType
   {
      
      public static const protocolId:uint = 123;
       
      
      public var sum:uint = 0;
      
      public function GoldItem()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 123;
      }
      
      public function initGoldItem(param1:uint = 0) : GoldItem
      {
         this.sum = param1;
         return this;
      }
      
      override public function reset() : void
      {
         this.sum = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GoldItem(param1);
      }
      
      public function serializeAs_GoldItem(param1:ICustomDataOutput) : void
      {
         super.serializeAs_Item(param1);
         if(this.sum < 0)
         {
            throw new Error("Forbidden value (" + this.sum + ") on element sum.");
         }
         param1.writeVarInt(this.sum);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GoldItem(param1);
      }
      
      public function deserializeAs_GoldItem(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.sum = param1.readVarUhInt();
         if(this.sum < 0)
         {
            throw new Error("Forbidden value (" + this.sum + ") on element of GoldItem.sum.");
         }
      }
   }
}
