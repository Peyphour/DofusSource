package com.ankamagames.dofus.network.messages.game.context.roleplay.job
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobBookSubscription;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class JobBookSubscriptionMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6593;
       
      
      private var _isInitialized:Boolean = false;
      
      public var subscriptions:Vector.<JobBookSubscription>;
      
      public function JobBookSubscriptionMessage()
      {
         this.subscriptions = new Vector.<JobBookSubscription>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6593;
      }
      
      public function initJobBookSubscriptionMessage(param1:Vector.<JobBookSubscription> = null) : JobBookSubscriptionMessage
      {
         this.subscriptions = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.subscriptions = new Vector.<JobBookSubscription>();
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
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_JobBookSubscriptionMessage(param1);
      }
      
      public function serializeAs_JobBookSubscriptionMessage(param1:ICustomDataOutput) : void
      {
         param1.writeShort(this.subscriptions.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.subscriptions.length)
         {
            (this.subscriptions[_loc2_] as JobBookSubscription).serializeAs_JobBookSubscription(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_JobBookSubscriptionMessage(param1);
      }
      
      public function deserializeAs_JobBookSubscriptionMessage(param1:ICustomDataInput) : void
      {
         var _loc4_:JobBookSubscription = null;
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new JobBookSubscription();
            _loc4_.deserialize(param1);
            this.subscriptions.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
