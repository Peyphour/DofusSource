package com.ankamagames.dofus.internalDatacenter.people
{
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.dofus.network.types.game.character.status.PlayerStatusExtended;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations;
   import com.ankamagames.dofus.network.types.game.friend.FriendInformations;
   import com.ankamagames.dofus.network.types.game.friend.FriendOnlineInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class FriendWrapper implements IDataCenter
   {
       
      
      private var _item:FriendInformations;
      
      public var name:String;
      
      public var accountId:int;
      
      public var state:int;
      
      public var lastConnection:uint;
      
      public var online:Boolean = false;
      
      public var type:String = "Friend";
      
      public var playerId:Number;
      
      public var playerName:String = "";
      
      public var level:int = 0;
      
      public var moodSmileyId:int = 0;
      
      public var alignmentSide:int = 0;
      
      public var breed:uint = 0;
      
      public var sex:uint = 2;
      
      public var realGuildName:String = "";
      
      public var guildName:String = "";
      
      public var guildId:int = 0;
      
      public var guildUpEmblem:EmblemWrapper;
      
      public var guildBackEmblem:EmblemWrapper;
      
      public var achievementPoints:int = 0;
      
      public var statusId:uint = 0;
      
      public var awayMessage:String = "";
      
      public function FriendWrapper(param1:FriendInformations)
      {
         super();
         this._item = param1;
         this.name = param1.accountName;
         this.accountId = param1.accountId;
         this.state = param1.playerState;
         this.lastConnection = param1.lastConnection;
         this.achievementPoints = param1.achievementPoints;
         if(param1 is FriendOnlineInformations)
         {
            this.playerName = FriendOnlineInformations(param1).playerName;
            this.playerId = FriendOnlineInformations(param1).playerId;
            this.level = FriendOnlineInformations(param1).level;
            this.alignmentSide = FriendOnlineInformations(param1).alignmentSide;
            this.breed = FriendOnlineInformations(param1).breed;
            this.sex = !!FriendOnlineInformations(param1).sex?uint(1):uint(0);
            if(FriendOnlineInformations(param1).guildInfo.guildName == "#NONAME#")
            {
               this.guildName = I18n.getUiText("ui.guild.noName");
            }
            else
            {
               this.guildName = FriendOnlineInformations(param1).guildInfo.guildName;
            }
            this.realGuildName = FriendOnlineInformations(param1).guildInfo.guildName;
            this.guildId = FriendOnlineInformations(param1).guildInfo.guildId;
            if(FriendOnlineInformations(param1).guildInfo is GuildInformations && GuildInformations(FriendOnlineInformations(param1).guildInfo).guildEmblem)
            {
               this.guildBackEmblem = EmblemWrapper.fromNetwork(GuildInformations(FriendOnlineInformations(param1).guildInfo).guildEmblem,true);
               this.guildUpEmblem = EmblemWrapper.fromNetwork(GuildInformations(FriendOnlineInformations(param1).guildInfo).guildEmblem,false);
            }
            this.moodSmileyId = FriendOnlineInformations(param1).moodSmileyId;
            this.statusId = FriendOnlineInformations(param1).status.statusId;
            if(FriendOnlineInformations(param1).status is PlayerStatusExtended)
            {
               this.awayMessage = PlayerStatusExtended(FriendOnlineInformations(param1).status).message;
            }
            this.online = true;
         }
      }
   }
}
