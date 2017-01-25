package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class MonsterBoosts implements INetworkType
   {
      
      public static const protocolId:uint = 497;
       
      
      public var id:uint = 0;
      
      public var xpBoost:uint = 0;
      
      public var dropBoost:uint = 0;
      
      public function MonsterBoosts()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 497;
      }
      
      public function initMonsterBoosts(param1:uint = 0, param2:uint = 0, param3:uint = 0) : MonsterBoosts
      {
         this.id = param1;
         this.xpBoost = param2;
         this.dropBoost = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.xpBoost = 0;
         this.dropBoost = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_MonsterBoosts(param1);
      }
      
      public function serializeAs_MonsterBoosts(param1:ICustomDataOutput) : void
      {
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         param1.writeVarInt(this.id);
         if(this.xpBoost < 0)
         {
            throw new Error("Forbidden value (" + this.xpBoost + ") on element xpBoost.");
         }
         param1.writeVarShort(this.xpBoost);
         if(this.dropBoost < 0)
         {
            throw new Error("Forbidden value (" + this.dropBoost + ") on element dropBoost.");
         }
         param1.writeVarShort(this.dropBoost);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_MonsterBoosts(param1);
      }
      
      public function deserializeAs_MonsterBoosts(param1:ICustomDataInput) : void
      {
         this.id = param1.readVarUhInt();
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of MonsterBoosts.id.");
         }
         this.xpBoost = param1.readVarUhShort();
         if(this.xpBoost < 0)
         {
            throw new Error("Forbidden value (" + this.xpBoost + ") on element of MonsterBoosts.xpBoost.");
         }
         this.dropBoost = param1.readVarUhShort();
         if(this.dropBoost < 0)
         {
            throw new Error("Forbidden value (" + this.dropBoost + ") on element of MonsterBoosts.dropBoost.");
         }
      }
   }
}
