package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class FightResultListEntry implements INetworkType
   {
      
      public static const protocolId:uint = 16;
       
      
      public var outcome:uint = 0;
      
      public var wave:uint = 0;
      
      public var rewards:FightLoot;
      
      public function FightResultListEntry()
      {
         this.rewards = new FightLoot();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 16;
      }
      
      public function initFightResultListEntry(param1:uint = 0, param2:uint = 0, param3:FightLoot = null) : FightResultListEntry
      {
         this.outcome = param1;
         this.wave = param2;
         this.rewards = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.outcome = 0;
         this.wave = 0;
         this.rewards = new FightLoot();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_FightResultListEntry(param1);
      }
      
      public function serializeAs_FightResultListEntry(param1:ICustomDataOutput) : void
      {
         param1.writeVarShort(this.outcome);
         if(this.wave < 0)
         {
            throw new Error("Forbidden value (" + this.wave + ") on element wave.");
         }
         param1.writeByte(this.wave);
         this.rewards.serializeAs_FightLoot(param1);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_FightResultListEntry(param1);
      }
      
      public function deserializeAs_FightResultListEntry(param1:ICustomDataInput) : void
      {
         this.outcome = param1.readVarUhShort();
         if(this.outcome < 0)
         {
            throw new Error("Forbidden value (" + this.outcome + ") on element of FightResultListEntry.outcome.");
         }
         this.wave = param1.readByte();
         if(this.wave < 0)
         {
            throw new Error("Forbidden value (" + this.wave + ") on element of FightResultListEntry.wave.");
         }
         this.rewards = new FightLoot();
         this.rewards.deserialize(param1);
      }
   }
}
