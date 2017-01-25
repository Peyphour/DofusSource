package com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class HavenBagFurnituresRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6637;
       
      
      private var _isInitialized:Boolean = false;
      
      public var cellIds:Vector.<uint>;
      
      public var funitureIds:Vector.<int>;
      
      public var orientations:Vector.<uint>;
      
      public function HavenBagFurnituresRequestMessage()
      {
         this.cellIds = new Vector.<uint>();
         this.funitureIds = new Vector.<int>();
         this.orientations = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6637;
      }
      
      public function initHavenBagFurnituresRequestMessage(param1:Vector.<uint> = null, param2:Vector.<int> = null, param3:Vector.<uint> = null) : HavenBagFurnituresRequestMessage
      {
         this.cellIds = param1;
         this.funitureIds = param2;
         this.orientations = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.cellIds = new Vector.<uint>();
         this.funitureIds = new Vector.<int>();
         this.orientations = new Vector.<uint>();
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
         this.serializeAs_HavenBagFurnituresRequestMessage(param1);
      }
      
      public function serializeAs_HavenBagFurnituresRequestMessage(param1:ICustomDataOutput) : void
      {
         param1.writeShort(this.cellIds.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.cellIds.length)
         {
            if(this.cellIds[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.cellIds[_loc2_] + ") on element 1 (starting at 1) of cellIds.");
            }
            param1.writeVarShort(this.cellIds[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.funitureIds.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.funitureIds.length)
         {
            param1.writeInt(this.funitureIds[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.orientations.length);
         var _loc4_:uint = 0;
         while(_loc4_ < this.orientations.length)
         {
            if(this.orientations[_loc4_] < 0)
            {
               throw new Error("Forbidden value (" + this.orientations[_loc4_] + ") on element 3 (starting at 1) of orientations.");
            }
            param1.writeByte(this.orientations[_loc4_]);
            _loc4_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HavenBagFurnituresRequestMessage(param1);
      }
      
      public function deserializeAs_HavenBagFurnituresRequestMessage(param1:ICustomDataInput) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc8_ = param1.readVarUhShort();
            if(_loc8_ < 0)
            {
               throw new Error("Forbidden value (" + _loc8_ + ") on elements of cellIds.");
            }
            this.cellIds.push(_loc8_);
            _loc3_++;
         }
         var _loc4_:uint = param1.readUnsignedShort();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc9_ = param1.readInt();
            this.funitureIds.push(_loc9_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = param1.readByte();
            if(_loc10_ < 0)
            {
               throw new Error("Forbidden value (" + _loc10_ + ") on elements of orientations.");
            }
            this.orientations.push(_loc10_);
            _loc7_++;
         }
      }
   }
}
