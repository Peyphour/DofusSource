package com.ankamagames.dofus.network.types.game.context.roleplay.job
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class JobBookSubscription implements INetworkType
   {
      
      public static const protocolId:uint = 500;
       
      
      public var jobId:uint = 0;
      
      public var subscribed:Boolean = false;
      
      public function JobBookSubscription()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 500;
      }
      
      public function initJobBookSubscription(param1:uint = 0, param2:Boolean = false) : JobBookSubscription
      {
         this.jobId = param1;
         this.subscribed = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.jobId = 0;
         this.subscribed = false;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_JobBookSubscription(param1);
      }
      
      public function serializeAs_JobBookSubscription(param1:ICustomDataOutput) : void
      {
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element jobId.");
         }
         param1.writeByte(this.jobId);
         param1.writeBoolean(this.subscribed);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_JobBookSubscription(param1);
      }
      
      public function deserializeAs_JobBookSubscription(param1:ICustomDataInput) : void
      {
         this.jobId = param1.readByte();
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element of JobBookSubscription.jobId.");
         }
         this.subscribed = param1.readBoolean();
      }
   }
}
