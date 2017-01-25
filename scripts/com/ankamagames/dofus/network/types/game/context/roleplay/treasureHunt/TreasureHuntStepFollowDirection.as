package com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class TreasureHuntStepFollowDirection extends TreasureHuntStep implements INetworkType
   {
      
      public static const protocolId:uint = 468;
       
      
      public var direction:uint = 1;
      
      public var mapCount:uint = 0;
      
      public function TreasureHuntStepFollowDirection()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 468;
      }
      
      public function initTreasureHuntStepFollowDirection(param1:uint = 1, param2:uint = 0) : TreasureHuntStepFollowDirection
      {
         this.direction = param1;
         this.mapCount = param2;
         return this;
      }
      
      override public function reset() : void
      {
         this.direction = 1;
         this.mapCount = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_TreasureHuntStepFollowDirection(param1);
      }
      
      public function serializeAs_TreasureHuntStepFollowDirection(param1:ICustomDataOutput) : void
      {
         super.serializeAs_TreasureHuntStep(param1);
         param1.writeByte(this.direction);
         if(this.mapCount < 0)
         {
            throw new Error("Forbidden value (" + this.mapCount + ") on element mapCount.");
         }
         param1.writeVarShort(this.mapCount);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TreasureHuntStepFollowDirection(param1);
      }
      
      public function deserializeAs_TreasureHuntStepFollowDirection(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.direction = param1.readByte();
         if(this.direction < 0)
         {
            throw new Error("Forbidden value (" + this.direction + ") on element of TreasureHuntStepFollowDirection.direction.");
         }
         this.mapCount = param1.readVarUhShort();
         if(this.mapCount < 0)
         {
            throw new Error("Forbidden value (" + this.mapCount + ") on element of TreasureHuntStepFollowDirection.mapCount.");
         }
      }
   }
}
