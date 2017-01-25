package com.ankamagames.dofus.network.types.common.basic
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class StatisticDataString extends StatisticData implements INetworkType
   {
      
      public static const protocolId:uint = 487;
       
      
      public var value:String = "";
      
      public function StatisticDataString()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 487;
      }
      
      public function initStatisticDataString(param1:String = "") : StatisticDataString
      {
         this.value = param1;
         return this;
      }
      
      override public function reset() : void
      {
         this.value = "";
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_StatisticDataString(param1);
      }
      
      public function serializeAs_StatisticDataString(param1:ICustomDataOutput) : void
      {
         super.serializeAs_StatisticData(param1);
         param1.writeUTF(this.value);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_StatisticDataString(param1);
      }
      
      public function deserializeAs_StatisticDataString(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.value = param1.readUTF();
      }
   }
}
