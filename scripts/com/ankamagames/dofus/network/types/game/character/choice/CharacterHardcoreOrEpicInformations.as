package com.ankamagames.dofus.network.types.game.character.choice
{
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class CharacterHardcoreOrEpicInformations extends CharacterBaseInformations implements INetworkType
   {
      
      public static const protocolId:uint = 474;
       
      
      public var deathState:uint = 0;
      
      public var deathCount:uint = 0;
      
      public var deathMaxLevel:uint = 0;
      
      public function CharacterHardcoreOrEpicInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 474;
      }
      
      public function initCharacterHardcoreOrEpicInformations(param1:Number = 0, param2:String = "", param3:uint = 0, param4:EntityLook = null, param5:int = 0, param6:Boolean = false, param7:uint = 0, param8:uint = 0, param9:uint = 0) : CharacterHardcoreOrEpicInformations
      {
         super.initCharacterBaseInformations(param1,param2,param3,param4,param5,param6);
         this.deathState = param7;
         this.deathCount = param8;
         this.deathMaxLevel = param9;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.deathState = 0;
         this.deathCount = 0;
         this.deathMaxLevel = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_CharacterHardcoreOrEpicInformations(param1);
      }
      
      public function serializeAs_CharacterHardcoreOrEpicInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_CharacterBaseInformations(param1);
         param1.writeByte(this.deathState);
         if(this.deathCount < 0)
         {
            throw new Error("Forbidden value (" + this.deathCount + ") on element deathCount.");
         }
         param1.writeVarShort(this.deathCount);
         if(this.deathMaxLevel < 1 || this.deathMaxLevel > 206)
         {
            throw new Error("Forbidden value (" + this.deathMaxLevel + ") on element deathMaxLevel.");
         }
         param1.writeByte(this.deathMaxLevel);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_CharacterHardcoreOrEpicInformations(param1);
      }
      
      public function deserializeAs_CharacterHardcoreOrEpicInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.deathState = param1.readByte();
         if(this.deathState < 0)
         {
            throw new Error("Forbidden value (" + this.deathState + ") on element of CharacterHardcoreOrEpicInformations.deathState.");
         }
         this.deathCount = param1.readVarUhShort();
         if(this.deathCount < 0)
         {
            throw new Error("Forbidden value (" + this.deathCount + ") on element of CharacterHardcoreOrEpicInformations.deathCount.");
         }
         this.deathMaxLevel = param1.readUnsignedByte();
         if(this.deathMaxLevel < 1 || this.deathMaxLevel > 206)
         {
            throw new Error("Forbidden value (" + this.deathMaxLevel + ") on element of CharacterHardcoreOrEpicInformations.deathMaxLevel.");
         }
      }
   }
}
