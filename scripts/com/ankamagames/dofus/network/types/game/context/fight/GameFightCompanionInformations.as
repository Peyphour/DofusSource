package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GameFightCompanionInformations extends GameFightFighterInformations implements INetworkType
   {
      
      public static const protocolId:uint = 450;
       
      
      public var companionGenericId:uint = 0;
      
      public var level:uint = 0;
      
      public var masterId:Number = 0;
      
      public function GameFightCompanionInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 450;
      }
      
      public function initGameFightCompanionInformations(param1:Number = 0, param2:EntityLook = null, param3:EntityDispositionInformations = null, param4:uint = 2, param5:uint = 0, param6:Boolean = false, param7:GameFightMinimalStats = null, param8:Vector.<uint> = null, param9:uint = 0, param10:uint = 0, param11:Number = 0) : GameFightCompanionInformations
      {
         super.initGameFightFighterInformations(param1,param2,param3,param4,param5,param6,param7,param8);
         this.companionGenericId = param9;
         this.level = param10;
         this.masterId = param11;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.companionGenericId = 0;
         this.level = 0;
         this.masterId = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameFightCompanionInformations(param1);
      }
      
      public function serializeAs_GameFightCompanionInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_GameFightFighterInformations(param1);
         if(this.companionGenericId < 0)
         {
            throw new Error("Forbidden value (" + this.companionGenericId + ") on element companionGenericId.");
         }
         param1.writeByte(this.companionGenericId);
         if(this.level < 0 || this.level > 255)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         param1.writeByte(this.level);
         if(this.masterId < -9007199254740990 || this.masterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.masterId + ") on element masterId.");
         }
         param1.writeDouble(this.masterId);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameFightCompanionInformations(param1);
      }
      
      public function deserializeAs_GameFightCompanionInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.companionGenericId = param1.readByte();
         if(this.companionGenericId < 0)
         {
            throw new Error("Forbidden value (" + this.companionGenericId + ") on element of GameFightCompanionInformations.companionGenericId.");
         }
         this.level = param1.readUnsignedByte();
         if(this.level < 0 || this.level > 255)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of GameFightCompanionInformations.level.");
         }
         this.masterId = param1.readDouble();
         if(this.masterId < -9007199254740990 || this.masterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.masterId + ") on element of GameFightCompanionInformations.masterId.");
         }
      }
   }
}
