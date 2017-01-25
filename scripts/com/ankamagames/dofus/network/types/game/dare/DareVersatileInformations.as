package com.ankamagames.dofus.network.types.game.dare
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class DareVersatileInformations implements INetworkType
   {
      
      public static const protocolId:uint = 504;
       
      
      public var dareId:Number = 0;
      
      public var countEntrants:uint = 0;
      
      public var countWinners:uint = 0;
      
      public function DareVersatileInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 504;
      }
      
      public function initDareVersatileInformations(param1:Number = 0, param2:uint = 0, param3:uint = 0) : DareVersatileInformations
      {
         this.dareId = param1;
         this.countEntrants = param2;
         this.countWinners = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.dareId = 0;
         this.countEntrants = 0;
         this.countWinners = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_DareVersatileInformations(param1);
      }
      
      public function serializeAs_DareVersatileInformations(param1:ICustomDataOutput) : void
      {
         if(this.dareId < 0 || this.dareId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.dareId + ") on element dareId.");
         }
         param1.writeDouble(this.dareId);
         if(this.countEntrants < 0)
         {
            throw new Error("Forbidden value (" + this.countEntrants + ") on element countEntrants.");
         }
         param1.writeInt(this.countEntrants);
         if(this.countWinners < 0)
         {
            throw new Error("Forbidden value (" + this.countWinners + ") on element countWinners.");
         }
         param1.writeInt(this.countWinners);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DareVersatileInformations(param1);
      }
      
      public function deserializeAs_DareVersatileInformations(param1:ICustomDataInput) : void
      {
         this.dareId = param1.readDouble();
         if(this.dareId < 0 || this.dareId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.dareId + ") on element of DareVersatileInformations.dareId.");
         }
         this.countEntrants = param1.readInt();
         if(this.countEntrants < 0)
         {
            throw new Error("Forbidden value (" + this.countEntrants + ") on element of DareVersatileInformations.countEntrants.");
         }
         this.countWinners = param1.readInt();
         if(this.countWinners < 0)
         {
            throw new Error("Forbidden value (" + this.countWinners + ") on element of DareVersatileInformations.countWinners.");
         }
      }
   }
}
