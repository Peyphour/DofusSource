package com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class TreasureHuntStepFight extends TreasureHuntStep implements INetworkType
   {
      
      public static const protocolId:uint = 462;
       
      
      public function TreasureHuntStepFight()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 462;
      }
      
      public function initTreasureHuntStepFight() : TreasureHuntStepFight
      {
         return this;
      }
      
      override public function reset() : void
      {
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
      }
      
      public function serializeAs_TreasureHuntStepFight(param1:ICustomDataOutput) : void
      {
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
      }
      
      public function deserializeAs_TreasureHuntStepFight(param1:ICustomDataInput) : void
      {
      }
   }
}
