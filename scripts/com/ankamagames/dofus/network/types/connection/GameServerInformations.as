package com.ankamagames.dofus.network.types.connection
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class GameServerInformations implements INetworkType
   {
      
      public static const protocolId:uint = 25;
       
      
      public var id:uint = 0;
      
      public var type:int = -1;
      
      public var status:uint = 1;
      
      public var completion:uint = 0;
      
      public var isSelectable:Boolean = false;
      
      public var charactersCount:uint = 0;
      
      public var charactersSlots:uint = 0;
      
      public var date:Number = 0;
      
      public function GameServerInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 25;
      }
      
      public function initGameServerInformations(param1:uint = 0, param2:int = -1, param3:uint = 1, param4:uint = 0, param5:Boolean = false, param6:uint = 0, param7:uint = 0, param8:Number = 0) : GameServerInformations
      {
         this.id = param1;
         this.type = param2;
         this.status = param3;
         this.completion = param4;
         this.isSelectable = param5;
         this.charactersCount = param6;
         this.charactersSlots = param7;
         this.date = param8;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.type = -1;
         this.status = 1;
         this.completion = 0;
         this.isSelectable = false;
         this.charactersCount = 0;
         this.charactersSlots = 0;
         this.date = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameServerInformations(param1);
      }
      
      public function serializeAs_GameServerInformations(param1:ICustomDataOutput) : void
      {
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         param1.writeVarShort(this.id);
         param1.writeByte(this.type);
         param1.writeByte(this.status);
         param1.writeByte(this.completion);
         param1.writeBoolean(this.isSelectable);
         if(this.charactersCount < 0)
         {
            throw new Error("Forbidden value (" + this.charactersCount + ") on element charactersCount.");
         }
         param1.writeByte(this.charactersCount);
         if(this.charactersSlots < 0)
         {
            throw new Error("Forbidden value (" + this.charactersSlots + ") on element charactersSlots.");
         }
         param1.writeByte(this.charactersSlots);
         if(this.date < -9007199254740990 || this.date > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.date + ") on element date.");
         }
         param1.writeDouble(this.date);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameServerInformations(param1);
      }
      
      public function deserializeAs_GameServerInformations(param1:ICustomDataInput) : void
      {
         this.id = param1.readVarUhShort();
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of GameServerInformations.id.");
         }
         this.type = param1.readByte();
         this.status = param1.readByte();
         if(this.status < 0)
         {
            throw new Error("Forbidden value (" + this.status + ") on element of GameServerInformations.status.");
         }
         this.completion = param1.readByte();
         if(this.completion < 0)
         {
            throw new Error("Forbidden value (" + this.completion + ") on element of GameServerInformations.completion.");
         }
         this.isSelectable = param1.readBoolean();
         this.charactersCount = param1.readByte();
         if(this.charactersCount < 0)
         {
            throw new Error("Forbidden value (" + this.charactersCount + ") on element of GameServerInformations.charactersCount.");
         }
         this.charactersSlots = param1.readByte();
         if(this.charactersSlots < 0)
         {
            throw new Error("Forbidden value (" + this.charactersSlots + ") on element of GameServerInformations.charactersSlots.");
         }
         this.date = param1.readDouble();
         if(this.date < -9007199254740990 || this.date > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.date + ") on element of GameServerInformations.date.");
         }
      }
   }
}
