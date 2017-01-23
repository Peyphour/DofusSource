package com.ankamagames.dofus.network.types.game.character.alignment
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class ActorAlignmentInformations implements INetworkType
   {
      
      public static const protocolId:uint = 201;
       
      
      public var alignmentSide:int = 0;
      
      public var alignmentValue:uint = 0;
      
      public var alignmentGrade:uint = 0;
      
      public var characterPower:Number = 0;
      
      public function ActorAlignmentInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 201;
      }
      
      public function initActorAlignmentInformations(param1:int = 0, param2:uint = 0, param3:uint = 0, param4:Number = 0) : ActorAlignmentInformations
      {
         this.alignmentSide = param1;
         this.alignmentValue = param2;
         this.alignmentGrade = param3;
         this.characterPower = param4;
         return this;
      }
      
      public function reset() : void
      {
         this.alignmentSide = 0;
         this.alignmentValue = 0;
         this.alignmentGrade = 0;
         this.characterPower = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_ActorAlignmentInformations(param1);
      }
      
      public function serializeAs_ActorAlignmentInformations(param1:ICustomDataOutput) : void
      {
         param1.writeByte(this.alignmentSide);
         if(this.alignmentValue < 0)
         {
            throw new Error("Forbidden value (" + this.alignmentValue + ") on element alignmentValue.");
         }
         param1.writeByte(this.alignmentValue);
         if(this.alignmentGrade < 0)
         {
            throw new Error("Forbidden value (" + this.alignmentGrade + ") on element alignmentGrade.");
         }
         param1.writeByte(this.alignmentGrade);
         if(this.characterPower < -9007199254740990 || this.characterPower > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.characterPower + ") on element characterPower.");
         }
         param1.writeDouble(this.characterPower);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ActorAlignmentInformations(param1);
      }
      
      public function deserializeAs_ActorAlignmentInformations(param1:ICustomDataInput) : void
      {
         this.alignmentSide = param1.readByte();
         this.alignmentValue = param1.readByte();
         if(this.alignmentValue < 0)
         {
            throw new Error("Forbidden value (" + this.alignmentValue + ") on element of ActorAlignmentInformations.alignmentValue.");
         }
         this.alignmentGrade = param1.readByte();
         if(this.alignmentGrade < 0)
         {
            throw new Error("Forbidden value (" + this.alignmentGrade + ") on element of ActorAlignmentInformations.alignmentGrade.");
         }
         this.characterPower = param1.readDouble();
         if(this.characterPower < -9007199254740990 || this.characterPower > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.characterPower + ") on element of ActorAlignmentInformations.characterPower.");
         }
      }
   }
}
