package com.ankamagames.dofus.network.types.game.dare
{
   import com.ankamagames.dofus.network.types.game.character.CharacterBasicMinimalInformations;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class DareInformations implements INetworkType
   {
      
      public static const protocolId:uint = 502;
       
      
      public var dareId:Number = 0;
      
      public var creator:CharacterBasicMinimalInformations;
      
      public var subscriptionFee:uint = 0;
      
      public var jackpot:uint = 0;
      
      public var maxCountWinners:uint = 0;
      
      public var endDate:Number = 0;
      
      public var isPrivate:Boolean = false;
      
      public var guildId:uint = 0;
      
      public var allianceId:uint = 0;
      
      public var criterions:Vector.<DareCriteria>;
      
      public var startDate:Number = 0;
      
      public function DareInformations()
      {
         this.creator = new CharacterBasicMinimalInformations();
         this.criterions = new Vector.<DareCriteria>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 502;
      }
      
      public function initDareInformations(param1:Number = 0, param2:CharacterBasicMinimalInformations = null, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:Number = 0, param7:Boolean = false, param8:uint = 0, param9:uint = 0, param10:Vector.<DareCriteria> = null, param11:Number = 0) : DareInformations
      {
         this.dareId = param1;
         this.creator = param2;
         this.subscriptionFee = param3;
         this.jackpot = param4;
         this.maxCountWinners = param5;
         this.endDate = param6;
         this.isPrivate = param7;
         this.guildId = param8;
         this.allianceId = param9;
         this.criterions = param10;
         this.startDate = param11;
         return this;
      }
      
      public function reset() : void
      {
         this.dareId = 0;
         this.creator = new CharacterBasicMinimalInformations();
         this.jackpot = 0;
         this.maxCountWinners = 0;
         this.endDate = 0;
         this.isPrivate = false;
         this.guildId = 0;
         this.allianceId = 0;
         this.criterions = new Vector.<DareCriteria>();
         this.startDate = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_DareInformations(param1);
      }
      
      public function serializeAs_DareInformations(param1:ICustomDataOutput) : void
      {
         if(this.dareId < 0 || this.dareId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.dareId + ") on element dareId.");
         }
         param1.writeDouble(this.dareId);
         this.creator.serializeAs_CharacterBasicMinimalInformations(param1);
         if(this.subscriptionFee < 0)
         {
            throw new Error("Forbidden value (" + this.subscriptionFee + ") on element subscriptionFee.");
         }
         param1.writeInt(this.subscriptionFee);
         if(this.jackpot < 0)
         {
            throw new Error("Forbidden value (" + this.jackpot + ") on element jackpot.");
         }
         param1.writeInt(this.jackpot);
         if(this.maxCountWinners < 0 || this.maxCountWinners > 65535)
         {
            throw new Error("Forbidden value (" + this.maxCountWinners + ") on element maxCountWinners.");
         }
         param1.writeShort(this.maxCountWinners);
         if(this.endDate < 0 || this.endDate > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.endDate + ") on element endDate.");
         }
         param1.writeDouble(this.endDate);
         param1.writeBoolean(this.isPrivate);
         if(this.guildId < 0)
         {
            throw new Error("Forbidden value (" + this.guildId + ") on element guildId.");
         }
         param1.writeVarInt(this.guildId);
         if(this.allianceId < 0)
         {
            throw new Error("Forbidden value (" + this.allianceId + ") on element allianceId.");
         }
         param1.writeVarInt(this.allianceId);
         param1.writeShort(this.criterions.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.criterions.length)
         {
            (this.criterions[_loc2_] as DareCriteria).serializeAs_DareCriteria(param1);
            _loc2_++;
         }
         if(this.startDate < 0 || this.startDate > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.startDate + ") on element startDate.");
         }
         param1.writeDouble(this.startDate);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DareInformations(param1);
      }
      
      public function deserializeAs_DareInformations(param1:ICustomDataInput) : void
      {
         var _loc4_:DareCriteria = null;
         this.dareId = param1.readDouble();
         if(this.dareId < 0 || this.dareId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.dareId + ") on element of DareInformations.dareId.");
         }
         this.creator = new CharacterBasicMinimalInformations();
         this.creator.deserialize(param1);
         this.subscriptionFee = param1.readInt();
         if(this.subscriptionFee < 0)
         {
            throw new Error("Forbidden value (" + this.subscriptionFee + ") on element of DareInformations.subscriptionFee.");
         }
         this.jackpot = param1.readInt();
         if(this.jackpot < 0)
         {
            throw new Error("Forbidden value (" + this.jackpot + ") on element of DareInformations.jackpot.");
         }
         this.maxCountWinners = param1.readUnsignedShort();
         if(this.maxCountWinners < 0 || this.maxCountWinners > 65535)
         {
            throw new Error("Forbidden value (" + this.maxCountWinners + ") on element of DareInformations.maxCountWinners.");
         }
         this.endDate = param1.readDouble();
         if(this.endDate < 0 || this.endDate > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.endDate + ") on element of DareInformations.endDate.");
         }
         this.isPrivate = param1.readBoolean();
         this.guildId = param1.readVarUhInt();
         if(this.guildId < 0)
         {
            throw new Error("Forbidden value (" + this.guildId + ") on element of DareInformations.guildId.");
         }
         this.allianceId = param1.readVarUhInt();
         if(this.allianceId < 0)
         {
            throw new Error("Forbidden value (" + this.allianceId + ") on element of DareInformations.allianceId.");
         }
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new DareCriteria();
            _loc4_.deserialize(param1);
            this.criterions.push(_loc4_);
            _loc3_++;
         }
         this.startDate = param1.readDouble();
         if(this.startDate < 0 || this.startDate > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.startDate + ") on element of DareInformations.startDate.");
         }
      }
   }
}
