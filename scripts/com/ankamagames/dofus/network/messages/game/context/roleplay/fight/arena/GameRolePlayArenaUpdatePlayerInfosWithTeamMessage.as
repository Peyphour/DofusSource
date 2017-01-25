package com.ankamagames.dofus.network.messages.game.context.roleplay.fight.arena
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.fight.arena.ArenaRankInfos;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameRolePlayArenaUpdatePlayerInfosWithTeamMessage extends GameRolePlayArenaUpdatePlayerInfosMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6640;
       
      
      private var _isInitialized:Boolean = false;
      
      public var team:ArenaRankInfos;
      
      public function GameRolePlayArenaUpdatePlayerInfosWithTeamMessage()
      {
         this.team = new ArenaRankInfos();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6640;
      }
      
      public function initGameRolePlayArenaUpdatePlayerInfosWithTeamMessage(param1:ArenaRankInfos = null, param2:ArenaRankInfos = null) : GameRolePlayArenaUpdatePlayerInfosWithTeamMessage
      {
         super.initGameRolePlayArenaUpdatePlayerInfosMessage(param1);
         this.team = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.team = new ArenaRankInfos();
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
         this.serializeAs_GameRolePlayArenaUpdatePlayerInfosWithTeamMessage(param1);
      }
      
      public function serializeAs_GameRolePlayArenaUpdatePlayerInfosWithTeamMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_GameRolePlayArenaUpdatePlayerInfosMessage(param1);
         this.team.serializeAs_ArenaRankInfos(param1);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameRolePlayArenaUpdatePlayerInfosWithTeamMessage(param1);
      }
      
      public function deserializeAs_GameRolePlayArenaUpdatePlayerInfosWithTeamMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.team = new ArenaRankInfos();
         this.team.deserialize(param1);
      }
   }
}
