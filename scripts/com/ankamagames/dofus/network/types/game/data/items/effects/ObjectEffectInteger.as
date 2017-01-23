package com.ankamagames.dofus.network.types.game.data.items.effects
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class ObjectEffectInteger extends ObjectEffect implements INetworkType
   {
      
      public static const protocolId:uint = 70;
       
      
      public var value:uint = 0;
      
      public function ObjectEffectInteger()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 70;
      }
      
      public function initObjectEffectInteger(param1:uint = 0, param2:uint = 0) : ObjectEffectInteger
      {
         super.initObjectEffect(param1);
         this.value = param2;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.value = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_ObjectEffectInteger(param1);
      }
      
      public function serializeAs_ObjectEffectInteger(param1:ICustomDataOutput) : void
      {
         super.serializeAs_ObjectEffect(param1);
         if(this.value < 0)
         {
            throw new Error("Forbidden value (" + this.value + ") on element value.");
         }
         param1.writeVarShort(this.value);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ObjectEffectInteger(param1);
      }
      
      public function deserializeAs_ObjectEffectInteger(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.value = param1.readVarUhShort();
         if(this.value < 0)
         {
            throw new Error("Forbidden value (" + this.value + ") on element of ObjectEffectInteger.value.");
         }
      }
   }
}
