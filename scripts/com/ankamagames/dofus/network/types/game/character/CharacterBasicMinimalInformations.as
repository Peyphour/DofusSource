package com.ankamagames.dofus.network.types.game.character
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class CharacterBasicMinimalInformations extends AbstractCharacterInformation implements INetworkType
   {
      
      public static const protocolId:uint = 503;
       
      
      public var name:String = "";
      
      public function CharacterBasicMinimalInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 503;
      }
      
      public function initCharacterBasicMinimalInformations(param1:Number = 0, param2:String = "") : CharacterBasicMinimalInformations
      {
         super.initAbstractCharacterInformation(param1);
         this.name = param2;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.name = "";
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_CharacterBasicMinimalInformations(param1);
      }
      
      public function serializeAs_CharacterBasicMinimalInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_AbstractCharacterInformation(param1);
         param1.writeUTF(this.name);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_CharacterBasicMinimalInformations(param1);
      }
      
      public function deserializeAs_CharacterBasicMinimalInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.name = param1.readUTF();
      }
   }
}
