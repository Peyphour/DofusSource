package com.ankamagames.dofus.network.types.game.guild.tax
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class TaxCollectorLootInformations extends TaxCollectorComplementaryInformations implements INetworkType
   {
      
      public static const protocolId:uint = 372;
       
      
      public var kamas:uint = 0;
      
      public var experience:Number = 0;
      
      public var pods:uint = 0;
      
      public var itemsValue:uint = 0;
      
      public function TaxCollectorLootInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 372;
      }
      
      public function initTaxCollectorLootInformations(param1:uint = 0, param2:Number = 0, param3:uint = 0, param4:uint = 0) : TaxCollectorLootInformations
      {
         this.kamas = param1;
         this.experience = param2;
         this.pods = param3;
         this.itemsValue = param4;
         return this;
      }
      
      override public function reset() : void
      {
         this.kamas = 0;
         this.experience = 0;
         this.pods = 0;
         this.itemsValue = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_TaxCollectorLootInformations(param1);
      }
      
      public function serializeAs_TaxCollectorLootInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_TaxCollectorComplementaryInformations(param1);
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element kamas.");
         }
         param1.writeVarInt(this.kamas);
         if(this.experience < 0 || this.experience > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element experience.");
         }
         param1.writeVarLong(this.experience);
         if(this.pods < 0)
         {
            throw new Error("Forbidden value (" + this.pods + ") on element pods.");
         }
         param1.writeVarInt(this.pods);
         if(this.itemsValue < 0)
         {
            throw new Error("Forbidden value (" + this.itemsValue + ") on element itemsValue.");
         }
         param1.writeVarInt(this.itemsValue);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TaxCollectorLootInformations(param1);
      }
      
      public function deserializeAs_TaxCollectorLootInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.kamas = param1.readVarUhInt();
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element of TaxCollectorLootInformations.kamas.");
         }
         this.experience = param1.readVarUhLong();
         if(this.experience < 0 || this.experience > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element of TaxCollectorLootInformations.experience.");
         }
         this.pods = param1.readVarUhInt();
         if(this.pods < 0)
         {
            throw new Error("Forbidden value (" + this.pods + ") on element of TaxCollectorLootInformations.pods.");
         }
         this.itemsValue = param1.readVarUhInt();
         if(this.itemsValue < 0)
         {
            throw new Error("Forbidden value (" + this.itemsValue + ") on element of TaxCollectorLootInformations.itemsValue.");
         }
      }
   }
}
