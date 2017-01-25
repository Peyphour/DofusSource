package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GameRolePlayTreasureHintInformations extends GameRolePlayActorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 471;
       
      
      public var npcId:uint = 0;
      
      public function GameRolePlayTreasureHintInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 471;
      }
      
      public function initGameRolePlayTreasureHintInformations(param1:Number = 0, param2:EntityLook = null, param3:EntityDispositionInformations = null, param4:uint = 0) : GameRolePlayTreasureHintInformations
      {
         super.initGameRolePlayActorInformations(param1,param2,param3);
         this.npcId = param4;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.npcId = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameRolePlayTreasureHintInformations(param1);
      }
      
      public function serializeAs_GameRolePlayTreasureHintInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_GameRolePlayActorInformations(param1);
         if(this.npcId < 0)
         {
            throw new Error("Forbidden value (" + this.npcId + ") on element npcId.");
         }
         param1.writeVarShort(this.npcId);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameRolePlayTreasureHintInformations(param1);
      }
      
      public function deserializeAs_GameRolePlayTreasureHintInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.npcId = param1.readVarUhShort();
         if(this.npcId < 0)
         {
            throw new Error("Forbidden value (" + this.npcId + ") on element of GameRolePlayTreasureHintInformations.npcId.");
         }
      }
   }
}
