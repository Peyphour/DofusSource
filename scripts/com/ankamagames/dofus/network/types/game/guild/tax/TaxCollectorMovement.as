package com.ankamagames.dofus.network.types.game.guild.tax
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class TaxCollectorMovement implements INetworkType
   {
      
      public static const protocolId:uint = 493;
       
      
      public var movementType:uint = 0;
      
      public var basicInfos:TaxCollectorBasicInformations;
      
      public var playerId:Number = 0;
      
      public var playerName:String = "";
      
      public function TaxCollectorMovement()
      {
         this.basicInfos = new TaxCollectorBasicInformations();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 493;
      }
      
      public function initTaxCollectorMovement(param1:uint = 0, param2:TaxCollectorBasicInformations = null, param3:Number = 0, param4:String = "") : TaxCollectorMovement
      {
         this.movementType = param1;
         this.basicInfos = param2;
         this.playerId = param3;
         this.playerName = param4;
         return this;
      }
      
      public function reset() : void
      {
         this.movementType = 0;
         this.basicInfos = new TaxCollectorBasicInformations();
         this.playerName = "";
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_TaxCollectorMovement(param1);
      }
      
      public function serializeAs_TaxCollectorMovement(param1:ICustomDataOutput) : void
      {
         param1.writeByte(this.movementType);
         this.basicInfos.serializeAs_TaxCollectorBasicInformations(param1);
         if(this.playerId < 0 || this.playerId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.playerId + ") on element playerId.");
         }
         param1.writeVarLong(this.playerId);
         param1.writeUTF(this.playerName);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TaxCollectorMovement(param1);
      }
      
      public function deserializeAs_TaxCollectorMovement(param1:ICustomDataInput) : void
      {
         this.movementType = param1.readByte();
         if(this.movementType < 0)
         {
            throw new Error("Forbidden value (" + this.movementType + ") on element of TaxCollectorMovement.movementType.");
         }
         this.basicInfos = new TaxCollectorBasicInformations();
         this.basicInfos.deserialize(param1);
         this.playerId = param1.readVarUhLong();
         if(this.playerId < 0 || this.playerId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.playerId + ") on element of TaxCollectorMovement.playerId.");
         }
         this.playerName = param1.readUTF();
      }
   }
}
