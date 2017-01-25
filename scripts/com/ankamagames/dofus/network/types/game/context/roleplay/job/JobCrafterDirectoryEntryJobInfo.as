package com.ankamagames.dofus.network.types.game.context.roleplay.job
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class JobCrafterDirectoryEntryJobInfo implements INetworkType
   {
      
      public static const protocolId:uint = 195;
       
      
      public var jobId:uint = 0;
      
      public var jobLevel:uint = 0;
      
      public var free:Boolean = false;
      
      public var minLevel:uint = 0;
      
      public function JobCrafterDirectoryEntryJobInfo()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 195;
      }
      
      public function initJobCrafterDirectoryEntryJobInfo(param1:uint = 0, param2:uint = 0, param3:Boolean = false, param4:uint = 0) : JobCrafterDirectoryEntryJobInfo
      {
         this.jobId = param1;
         this.jobLevel = param2;
         this.free = param3;
         this.minLevel = param4;
         return this;
      }
      
      public function reset() : void
      {
         this.jobId = 0;
         this.jobLevel = 0;
         this.free = false;
         this.minLevel = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_JobCrafterDirectoryEntryJobInfo(param1);
      }
      
      public function serializeAs_JobCrafterDirectoryEntryJobInfo(param1:ICustomDataOutput) : void
      {
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element jobId.");
         }
         param1.writeByte(this.jobId);
         if(this.jobLevel < 1 || this.jobLevel > 200)
         {
            throw new Error("Forbidden value (" + this.jobLevel + ") on element jobLevel.");
         }
         param1.writeByte(this.jobLevel);
         param1.writeBoolean(this.free);
         if(this.minLevel < 0 || this.minLevel > 255)
         {
            throw new Error("Forbidden value (" + this.minLevel + ") on element minLevel.");
         }
         param1.writeByte(this.minLevel);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_JobCrafterDirectoryEntryJobInfo(param1);
      }
      
      public function deserializeAs_JobCrafterDirectoryEntryJobInfo(param1:ICustomDataInput) : void
      {
         this.jobId = param1.readByte();
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element of JobCrafterDirectoryEntryJobInfo.jobId.");
         }
         this.jobLevel = param1.readUnsignedByte();
         if(this.jobLevel < 1 || this.jobLevel > 200)
         {
            throw new Error("Forbidden value (" + this.jobLevel + ") on element of JobCrafterDirectoryEntryJobInfo.jobLevel.");
         }
         this.free = param1.readBoolean();
         this.minLevel = param1.readUnsignedByte();
         if(this.minLevel < 0 || this.minLevel > 255)
         {
            throw new Error("Forbidden value (" + this.minLevel + ") on element of JobCrafterDirectoryEntryJobInfo.minLevel.");
         }
      }
   }
}
