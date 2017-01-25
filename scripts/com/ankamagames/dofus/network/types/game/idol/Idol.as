package com.ankamagames.dofus.network.types.game.idol
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class Idol implements INetworkType
   {
      
      public static const protocolId:uint = 489;
       
      
      public var id:uint = 0;
      
      public var xpBonusPercent:uint = 0;
      
      public var dropBonusPercent:uint = 0;
      
      public function Idol()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 489;
      }
      
      public function initIdol(param1:uint = 0, param2:uint = 0, param3:uint = 0) : Idol
      {
         this.id = param1;
         this.xpBonusPercent = param2;
         this.dropBonusPercent = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.xpBonusPercent = 0;
         this.dropBonusPercent = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_Idol(param1);
      }
      
      public function serializeAs_Idol(param1:ICustomDataOutput) : void
      {
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         param1.writeVarShort(this.id);
         if(this.xpBonusPercent < 0)
         {
            throw new Error("Forbidden value (" + this.xpBonusPercent + ") on element xpBonusPercent.");
         }
         param1.writeVarShort(this.xpBonusPercent);
         if(this.dropBonusPercent < 0)
         {
            throw new Error("Forbidden value (" + this.dropBonusPercent + ") on element dropBonusPercent.");
         }
         param1.writeVarShort(this.dropBonusPercent);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_Idol(param1);
      }
      
      public function deserializeAs_Idol(param1:ICustomDataInput) : void
      {
         this.id = param1.readVarUhShort();
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of Idol.id.");
         }
         this.xpBonusPercent = param1.readVarUhShort();
         if(this.xpBonusPercent < 0)
         {
            throw new Error("Forbidden value (" + this.xpBonusPercent + ") on element of Idol.xpBonusPercent.");
         }
         this.dropBonusPercent = param1.readVarUhShort();
         if(this.dropBonusPercent < 0)
         {
            throw new Error("Forbidden value (" + this.dropBonusPercent + ") on element of Idol.dropBonusPercent.");
         }
      }
   }
}
