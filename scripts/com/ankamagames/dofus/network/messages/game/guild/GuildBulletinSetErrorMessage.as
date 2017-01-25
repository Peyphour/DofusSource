package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.dofus.network.messages.game.social.SocialNoticeSetErrorMessage;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GuildBulletinSetErrorMessage extends SocialNoticeSetErrorMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6691;
       
      
      private var _isInitialized:Boolean = false;
      
      public function GuildBulletinSetErrorMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6691;
      }
      
      public function initGuildBulletinSetErrorMessage(param1:uint = 0) : GuildBulletinSetErrorMessage
      {
         super.initSocialNoticeSetErrorMessage(param1);
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GuildBulletinSetErrorMessage(param1);
      }
      
      public function serializeAs_GuildBulletinSetErrorMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_SocialNoticeSetErrorMessage(param1);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GuildBulletinSetErrorMessage(param1);
      }
      
      public function deserializeAs_GuildBulletinSetErrorMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
      }
   }
}
