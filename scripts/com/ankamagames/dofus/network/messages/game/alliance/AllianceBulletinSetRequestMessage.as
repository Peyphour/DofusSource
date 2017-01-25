package com.ankamagames.dofus.network.messages.game.alliance
{
   import com.ankamagames.dofus.network.messages.game.social.SocialNoticeSetRequestMessage;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class AllianceBulletinSetRequestMessage extends SocialNoticeSetRequestMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6693;
       
      
      private var _isInitialized:Boolean = false;
      
      [Transient]
      public var content:String = "";
      
      public var notifyMembers:Boolean = false;
      
      public function AllianceBulletinSetRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6693;
      }
      
      public function initAllianceBulletinSetRequestMessage(param1:String = "", param2:Boolean = false) : AllianceBulletinSetRequestMessage
      {
         this.content = param1;
         this.notifyMembers = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.content = "";
         this.notifyMembers = false;
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
         this.serializeAs_AllianceBulletinSetRequestMessage(param1);
      }
      
      public function serializeAs_AllianceBulletinSetRequestMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_SocialNoticeSetRequestMessage(param1);
         param1.writeUTF(this.content);
         param1.writeBoolean(this.notifyMembers);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AllianceBulletinSetRequestMessage(param1);
      }
      
      public function deserializeAs_AllianceBulletinSetRequestMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.content = param1.readUTF();
         this.notifyMembers = param1.readBoolean();
      }
   }
}
