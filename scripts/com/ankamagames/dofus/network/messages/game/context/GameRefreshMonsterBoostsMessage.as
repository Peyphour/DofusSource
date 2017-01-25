package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterBoosts;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameRefreshMonsterBoostsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6618;
       
      
      private var _isInitialized:Boolean = false;
      
      public var monsterBoosts:Vector.<MonsterBoosts>;
      
      public var familyBoosts:Vector.<MonsterBoosts>;
      
      public function GameRefreshMonsterBoostsMessage()
      {
         this.monsterBoosts = new Vector.<MonsterBoosts>();
         this.familyBoosts = new Vector.<MonsterBoosts>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6618;
      }
      
      public function initGameRefreshMonsterBoostsMessage(param1:Vector.<MonsterBoosts> = null, param2:Vector.<MonsterBoosts> = null) : GameRefreshMonsterBoostsMessage
      {
         this.monsterBoosts = param1;
         this.familyBoosts = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.monsterBoosts = new Vector.<MonsterBoosts>();
         this.familyBoosts = new Vector.<MonsterBoosts>();
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
         this.serializeAs_GameRefreshMonsterBoostsMessage(param1);
      }
      
      public function serializeAs_GameRefreshMonsterBoostsMessage(param1:ICustomDataOutput) : void
      {
         param1.writeShort(this.monsterBoosts.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.monsterBoosts.length)
         {
            (this.monsterBoosts[_loc2_] as MonsterBoosts).serializeAs_MonsterBoosts(param1);
            _loc2_++;
         }
         param1.writeShort(this.familyBoosts.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.familyBoosts.length)
         {
            (this.familyBoosts[_loc3_] as MonsterBoosts).serializeAs_MonsterBoosts(param1);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameRefreshMonsterBoostsMessage(param1);
      }
      
      public function deserializeAs_GameRefreshMonsterBoostsMessage(param1:ICustomDataInput) : void
      {
         var _loc6_:MonsterBoosts = null;
         var _loc7_:MonsterBoosts = null;
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = new MonsterBoosts();
            _loc6_.deserialize(param1);
            this.monsterBoosts.push(_loc6_);
            _loc3_++;
         }
         var _loc4_:uint = param1.readUnsignedShort();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = new MonsterBoosts();
            _loc7_.deserialize(param1);
            this.familyBoosts.push(_loc7_);
            _loc5_++;
         }
      }
   }
}
