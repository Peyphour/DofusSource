package com.ankamagames.dofus.network.types.game.context
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class MapCoordinates implements INetworkType
   {
      
      public static const protocolId:uint = 174;
       
      
      public var worldX:int = 0;
      
      public var worldY:int = 0;
      
      public function MapCoordinates()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 174;
      }
      
      public function initMapCoordinates(param1:int = 0, param2:int = 0) : MapCoordinates
      {
         this.worldX = param1;
         this.worldY = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.worldX = 0;
         this.worldY = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_MapCoordinates(param1);
      }
      
      public function serializeAs_MapCoordinates(param1:ICustomDataOutput) : void
      {
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element worldX.");
         }
         param1.writeShort(this.worldX);
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element worldY.");
         }
         param1.writeShort(this.worldY);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_MapCoordinates(param1);
      }
      
      public function deserializeAs_MapCoordinates(param1:ICustomDataInput) : void
      {
         this.worldX = param1.readShort();
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element of MapCoordinates.worldX.");
         }
         this.worldY = param1.readShort();
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element of MapCoordinates.worldY.");
         }
      }
   }
}
