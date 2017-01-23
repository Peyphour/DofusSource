package com.ankamagames.dofus.network.types.game.interactive.skill
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class SkillActionDescriptionCraft extends SkillActionDescription implements INetworkType
   {
      
      public static const protocolId:uint = 100;
       
      
      public var probability:uint = 0;
      
      public function SkillActionDescriptionCraft()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 100;
      }
      
      public function initSkillActionDescriptionCraft(param1:uint = 0, param2:uint = 0) : SkillActionDescriptionCraft
      {
         super.initSkillActionDescription(param1);
         this.probability = param2;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.probability = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_SkillActionDescriptionCraft(param1);
      }
      
      public function serializeAs_SkillActionDescriptionCraft(param1:ICustomDataOutput) : void
      {
         super.serializeAs_SkillActionDescription(param1);
         if(this.probability < 0)
         {
            throw new Error("Forbidden value (" + this.probability + ") on element probability.");
         }
         param1.writeByte(this.probability);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_SkillActionDescriptionCraft(param1);
      }
      
      public function deserializeAs_SkillActionDescriptionCraft(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.probability = param1.readByte();
         if(this.probability < 0)
         {
            throw new Error("Forbidden value (" + this.probability + ") on element of SkillActionDescriptionCraft.probability.");
         }
      }
   }
}
