package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   
   public class GameRolePlayGroupMonsterInformations extends GameRolePlayActorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 160;
       
      
      public var staticInfos:GroupMonsterStaticInformations;
      
      public var creationTime:Number = 0;
      
      public var ageBonusRate:uint = 0;
      
      public var lootShare:int = 0;
      
      public var alignmentSide:int = 0;
      
      public var keyRingBonus:Boolean = false;
      
      public var hasHardcoreDrop:Boolean = false;
      
      public var hasAVARewardToken:Boolean = false;
      
      public function GameRolePlayGroupMonsterInformations()
      {
         this.staticInfos = new GroupMonsterStaticInformations();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 160;
      }
      
      public function initGameRolePlayGroupMonsterInformations(param1:Number = 0, param2:EntityLook = null, param3:EntityDispositionInformations = null, param4:GroupMonsterStaticInformations = null, param5:Number = 0, param6:uint = 0, param7:int = 0, param8:int = 0, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false) : GameRolePlayGroupMonsterInformations
      {
         super.initGameRolePlayActorInformations(param1,param2,param3);
         this.staticInfos = param4;
         this.creationTime = param5;
         this.ageBonusRate = param6;
         this.lootShare = param7;
         this.alignmentSide = param8;
         this.keyRingBonus = param9;
         this.hasHardcoreDrop = param10;
         this.hasAVARewardToken = param11;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.staticInfos = new GroupMonsterStaticInformations();
         this.ageBonusRate = 0;
         this.lootShare = 0;
         this.alignmentSide = 0;
         this.keyRingBonus = false;
         this.hasHardcoreDrop = false;
         this.hasAVARewardToken = false;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameRolePlayGroupMonsterInformations(param1);
      }
      
      public function serializeAs_GameRolePlayGroupMonsterInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_GameRolePlayActorInformations(param1);
         var _loc2_:uint = 0;
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,0,this.keyRingBonus);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,1,this.hasHardcoreDrop);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,2,this.hasAVARewardToken);
         param1.writeByte(_loc2_);
         param1.writeShort(this.staticInfos.getTypeId());
         this.staticInfos.serialize(param1);
         if(this.creationTime < 0 || this.creationTime > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.creationTime + ") on element creationTime.");
         }
         param1.writeDouble(this.creationTime);
         if(this.ageBonusRate < 0)
         {
            throw new Error("Forbidden value (" + this.ageBonusRate + ") on element ageBonusRate.");
         }
         param1.writeInt(this.ageBonusRate);
         if(this.lootShare < -1 || this.lootShare > 8)
         {
            throw new Error("Forbidden value (" + this.lootShare + ") on element lootShare.");
         }
         param1.writeByte(this.lootShare);
         param1.writeByte(this.alignmentSide);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameRolePlayGroupMonsterInformations(param1);
      }
      
      public function deserializeAs_GameRolePlayGroupMonsterInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         var _loc2_:uint = param1.readByte();
         this.keyRingBonus = BooleanByteWrapper.getFlag(_loc2_,0);
         this.hasHardcoreDrop = BooleanByteWrapper.getFlag(_loc2_,1);
         this.hasAVARewardToken = BooleanByteWrapper.getFlag(_loc2_,2);
         var _loc3_:uint = param1.readUnsignedShort();
         this.staticInfos = ProtocolTypeManager.getInstance(GroupMonsterStaticInformations,_loc3_);
         this.staticInfos.deserialize(param1);
         this.creationTime = param1.readDouble();
         if(this.creationTime < 0 || this.creationTime > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.creationTime + ") on element of GameRolePlayGroupMonsterInformations.creationTime.");
         }
         this.ageBonusRate = param1.readInt();
         if(this.ageBonusRate < 0)
         {
            throw new Error("Forbidden value (" + this.ageBonusRate + ") on element of GameRolePlayGroupMonsterInformations.ageBonusRate.");
         }
         this.lootShare = param1.readByte();
         if(this.lootShare < -1 || this.lootShare > 8)
         {
            throw new Error("Forbidden value (" + this.lootShare + ") on element of GameRolePlayGroupMonsterInformations.lootShare.");
         }
         this.alignmentSide = param1.readByte();
      }
   }
}
