package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class FightTeamMemberMonsterInformations extends FightTeamMemberInformations implements INetworkType
   {
      
      public static const protocolId:uint = 6;
       
      
      public var monsterId:int = 0;
      
      public var grade:uint = 0;
      
      public function FightTeamMemberMonsterInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 6;
      }
      
      public function initFightTeamMemberMonsterInformations(param1:Number = 0, param2:int = 0, param3:uint = 0) : FightTeamMemberMonsterInformations
      {
         super.initFightTeamMemberInformations(param1);
         this.monsterId = param2;
         this.grade = param3;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.monsterId = 0;
         this.grade = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_FightTeamMemberMonsterInformations(param1);
      }
      
      public function serializeAs_FightTeamMemberMonsterInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_FightTeamMemberInformations(param1);
         param1.writeInt(this.monsterId);
         if(this.grade < 0)
         {
            throw new Error("Forbidden value (" + this.grade + ") on element grade.");
         }
         param1.writeByte(this.grade);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_FightTeamMemberMonsterInformations(param1);
      }
      
      public function deserializeAs_FightTeamMemberMonsterInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.monsterId = param1.readInt();
         this.grade = param1.readByte();
         if(this.grade < 0)
         {
            throw new Error("Forbidden value (" + this.grade + ") on element of FightTeamMemberMonsterInformations.grade.");
         }
      }
   }
}
