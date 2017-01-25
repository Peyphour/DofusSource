package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class FightResultFighterListEntry extends FightResultListEntry implements INetworkType
   {
      
      public static const protocolId:uint = 189;
       
      
      public var id:Number = 0;
      
      public var alive:Boolean = false;
      
      public function FightResultFighterListEntry()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 189;
      }
      
      public function initFightResultFighterListEntry(param1:uint = 0, param2:uint = 0, param3:FightLoot = null, param4:Number = 0, param5:Boolean = false) : FightResultFighterListEntry
      {
         super.initFightResultListEntry(param1,param2,param3);
         this.id = param4;
         this.alive = param5;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.id = 0;
         this.alive = false;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_FightResultFighterListEntry(param1);
      }
      
      public function serializeAs_FightResultFighterListEntry(param1:ICustomDataOutput) : void
      {
         super.serializeAs_FightResultListEntry(param1);
         if(this.id < -9007199254740990 || this.id > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         param1.writeDouble(this.id);
         param1.writeBoolean(this.alive);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_FightResultFighterListEntry(param1);
      }
      
      public function deserializeAs_FightResultFighterListEntry(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.id = param1.readDouble();
         if(this.id < -9007199254740990 || this.id > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of FightResultFighterListEntry.id.");
         }
         this.alive = param1.readBoolean();
      }
   }
}
