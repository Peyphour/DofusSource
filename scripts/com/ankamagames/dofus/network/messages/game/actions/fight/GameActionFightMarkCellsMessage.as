package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMark;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameActionFightMarkCellsMessage extends AbstractGameActionMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5540;
       
      
      private var _isInitialized:Boolean = false;
      
      public var mark:GameActionMark;
      
      public function GameActionFightMarkCellsMessage()
      {
         this.mark = new GameActionMark();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5540;
      }
      
      public function initGameActionFightMarkCellsMessage(param1:uint = 0, param2:Number = 0, param3:GameActionMark = null) : GameActionFightMarkCellsMessage
      {
         super.initAbstractGameActionMessage(param1,param2);
         this.mark = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.mark = new GameActionMark();
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
         this.serializeAs_GameActionFightMarkCellsMessage(param1);
      }
      
      public function serializeAs_GameActionFightMarkCellsMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_AbstractGameActionMessage(param1);
         this.mark.serializeAs_GameActionMark(param1);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameActionFightMarkCellsMessage(param1);
      }
      
      public function deserializeAs_GameActionFightMarkCellsMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.mark = new GameActionMark();
         this.mark.deserialize(param1);
      }
   }
}