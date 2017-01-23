package makers
{
   import com.ankamagames.dofus.datacenter.misc.OptionalFeature;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionAlliance;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionGuild;
   import d2actions.AddEnemy;
   import d2actions.AddFriend;
   import d2actions.AddIgnored;
   import d2actions.AllianceFactsRequest;
   import d2actions.BasicWhoIsRequest;
   import d2actions.ChatTextOutput;
   import d2actions.ExchangePlayerMultiCraftRequest;
   import d2actions.ExchangePlayerRequest;
   import d2actions.ExchangeRequestOnShopStock;
   import d2actions.ExchangeShowVendorTax;
   import d2actions.GameContextKick;
   import d2actions.GameFightPlacementSwapPositionsRequest;
   import d2actions.GameRolePlayFreeSoulRequest;
   import d2actions.GuildFactsRequest;
   import d2actions.GuildInvitation;
   import d2actions.GuildInvitationByName;
   import d2actions.HavenbagInvitePlayer;
   import d2actions.HouseKick;
   import d2actions.JoinFriend;
   import d2actions.JoinSpouse;
   import d2actions.NumericWhoIsRequest;
   import d2actions.PartyAbdicateThrone;
   import d2actions.PartyAllFollowMember;
   import d2actions.PartyAllStopFollowingMember;
   import d2actions.PartyCancelInvitation;
   import d2actions.PartyFollowMember;
   import d2actions.PartyInvitation;
   import d2actions.PartyKickRequest;
   import d2actions.PartyLeaveRequest;
   import d2actions.PartyStopFollowingMember;
   import d2actions.PivotCharacter;
   import d2actions.PlayerFightRequest;
   import d2actions.RemoveIgnored;
   import d2actions.StartZoom;
   import d2enums.AggressableStatusEnum;
   import d2enums.BuildTypeEnum;
   import d2enums.ExchangeTypeEnum;
   import d2enums.PrismStateEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.PvpArenaTypeEnum;
   import d2enums.WebLocationEnum;
   import d2hooks.ChatFocus;
   import d2hooks.OpenReport;
   import d2hooks.OpenWebPortal;
   import d2hooks.ReadyToFight;
   
   public class PlayerMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      protected const SUPERAREA_INCARNAM:uint = 3;
      
      protected var _playerName:String = null;
      
      protected var _cellId:int = -1;
      
      protected var _partyId:int = 0;
      
      protected var _ava:Boolean;
      
      public function PlayerMenuMaker()
      {
         super();
      }
      
      protected function onWisperMessage(param1:String) : void
      {
         Api.system.dispatchHook(ChatFocus,param1);
      }
      
      protected function onAnkaboxMessage(param1:String, param2:Number) : void
      {
         var _loc3_:int = Api.system.getAccountId(param1);
         if(!_loc3_)
         {
            Api.system.sendAction(new NumericWhoIsRequest(param2));
         }
         Api.system.dispatchHook(OpenWebPortal,WebLocationEnum.WEB_LOCATION_ANKABOX_SEND_MESSAGE,false,[_loc3_,param1]);
      }
      
      protected function onFightChallenge(param1:Number) : void
      {
         Api.system.sendAction(new PlayerFightRequest(param1,false,true,true,this._cellId));
      }
      
      protected function onAttack(param1:Number) : void
      {
         Api.system.sendAction(new PlayerFightRequest(param1,this._ava,false,false,this._cellId));
      }
      
      protected function onInviteMenuClicked(param1:String) : void
      {
         Api.system.sendAction(new PartyInvitation(param1,0,false));
      }
      
      protected function onArenaInvite(param1:String) : void
      {
         Api.system.sendAction(new PartyInvitation(param1,0,true));
      }
      
      protected function onExchangeMenuClicked(param1:Number) : void
      {
         Api.system.sendAction(new ExchangePlayerRequest(1,param1));
      }
      
      protected function onGuildInvite(param1:*) : void
      {
         if(param1 is String)
         {
            Api.system.sendAction(new GuildInvitationByName(param1 as String));
         }
         else
         {
            Api.system.sendAction(new GuildInvitation(param1 as Number));
         }
      }
      
      protected function onHavenbagInvite(param1:Number) : void
      {
         Api.system.sendAction(new HavenbagInvitePlayer(param1,true));
      }
      
      protected function onHavenbagKick(param1:Number) : void
      {
         Api.system.sendAction(new HavenbagInvitePlayer(param1,false));
      }
      
      protected function onAddEnemy(param1:String) : void
      {
         this._playerName = param1;
         Api.modCommon.openPopup(Api.ui.getText("ui.popup.warning"),Api.ui.getText("ui.social.confirmAddEnemy",param1),[Api.ui.getText("ui.common.yes"),Api.ui.getText("ui.common.no")],[this.onAcceptAddEnemy],this.onAcceptAddEnemy);
      }
      
      protected function onAcceptAddEnemy() : void
      {
         Api.system.sendAction(new AddEnemy(this._playerName));
      }
      
      protected function onAddFriend(param1:String) : void
      {
         this._playerName = param1;
         Api.modCommon.openPopup(Api.ui.getText("ui.popup.warning"),Api.ui.getText("ui.social.confirmAddFriend",param1),[Api.ui.getText("ui.common.yes"),Api.ui.getText("ui.common.no")],[this.onAcceptAddFriend],this.onAcceptAddFriend);
      }
      
      protected function onAcceptAddFriend() : void
      {
         Api.system.sendAction(new AddFriend(this._playerName));
      }
      
      protected function onIgnorePlayer(param1:String) : void
      {
         Api.system.sendAction(new AddIgnored(param1));
      }
      
      protected function onUnignorePlayer(param1:int) : void
      {
         Api.system.sendAction(new RemoveIgnored(param1));
      }
      
      protected function onHouseKickOff(param1:Number) : void
      {
         Api.system.sendAction(new HouseKick(param1));
      }
      
      protected function onMultiCraftCustomerAskClicked(param1:Number, param2:uint) : void
      {
         Api.system.sendAction(new ExchangePlayerMultiCraftRequest(ExchangeTypeEnum.MULTICRAFT_CUSTOMER,param1,param2));
      }
      
      protected function onMultiCraftCrafterAskClicked(param1:Number, param2:uint) : void
      {
         Api.system.sendAction(new ExchangePlayerMultiCraftRequest(ExchangeTypeEnum.MULTICRAFT_CRAFTER,param1,param2));
      }
      
      protected function onInformations(param1:String, param2:Boolean = false, param3:Number = 0) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         if(!param2)
         {
            Api.system.sendAction(new BasicWhoIsRequest(param1,true));
         }
         else
         {
            _loc4_ = Math.floor(param3 / 65536) * 100000 + Math.floor(param3 % 65536);
            _loc5_ = Api.ui.getText("ui.link.characterPage",_loc4_,param1.toLowerCase());
            Api.system.goToUrl(_loc5_);
         }
      }
      
      protected function onGuildInformations(param1:uint) : void
      {
         Api.system.sendAction(new GuildFactsRequest(param1));
      }
      
      protected function onAllianceInformations(param1:uint) : void
      {
         Api.system.sendAction(new AllianceFactsRequest(param1));
      }
      
      protected function onManageShoppingModMenuClicked() : void
      {
         Api.system.sendAction(new ExchangeRequestOnShopStock());
      }
      
      protected function onWantFreeSoul() : void
      {
         Api.system.sendAction(new GameRolePlayFreeSoulRequest());
      }
      
      protected function onShoppingModMenuClicked() : void
      {
         Api.system.sendAction(new ExchangeShowVendorTax());
      }
      
      protected function onPivotCharacter() : void
      {
         Api.system.sendAction(new PivotCharacter());
      }
      
      protected function onZoom(param1:Number) : void
      {
         Api.system.sendAction(new StartZoom(param1,2));
      }
      
      protected function onReportClicked(param1:Number, param2:String, param3:Object = null) : void
      {
         Api.system.dispatchHook(OpenReport,param1,param2,param3);
      }
      
      protected function onSlapMenuClicked() : void
      {
         Api.system.sendAction(new ChatTextOutput(Api.ui.getText("ui.dialog.slapSentence"),0,null,null));
      }
      
      protected function onReady() : void
      {
         Api.system.dispatchHook(ReadyToFight);
      }
      
      protected function onKick(param1:Number) : void
      {
         Api.system.sendAction(new GameContextKick(param1));
      }
      
      protected function onJoinFriend(param1:String) : void
      {
         Api.system.sendAction(new JoinFriend(param1));
      }
      
      protected function onJoinSpouse() : void
      {
         Api.system.sendAction(new JoinSpouse());
      }
      
      protected function promoteLeader(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new PartyAbdicateThrone(param1,param2));
      }
      
      protected function kickPlayer(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new PartyKickRequest(param1,param2));
      }
      
      protected function leaveParty(param1:int) : void
      {
         Api.system.sendAction(new PartyLeaveRequest(param1));
      }
      
      protected function followThisMember(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new PartyFollowMember(param1,param2));
      }
      
      protected function followAllThisMember(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new PartyAllFollowMember(param1,param2));
      }
      
      protected function stopFollowingThisMember(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new PartyStopFollowingMember(param1,param2));
      }
      
      protected function stopAllFollowingThisMember(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new PartyAllStopFollowingMember(param1,param2));
      }
      
      protected function cancelPartyInvitation(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new PartyCancelInvitation(param1,param2));
      }
      
      protected function addPartyMenu(param1:Number, param2:Boolean, param3:Number = 0, param4:Boolean = false) : Array
      {
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc10_:* = false;
         var _loc5_:Array = new Array();
         if(!param4)
         {
            _loc5_.push(ContextMenu.static_createContextMenuTitleObject(Api.ui.getText("ui.common.party")));
         }
         else
         {
            _loc5_.push(ContextMenu.static_createContextMenuTitleObject(Api.ui.getText("ui.common.koliseum")));
         }
         var _loc6_:Number = Api.player.id();
         if(param4)
         {
            _loc8_ = Api.party.getArenaPartyId();
            _loc7_ = Api.party.getPartyLeaderId(_loc8_);
         }
         else
         {
            _loc8_ = Api.party.getPartyId();
            _loc7_ = Api.party.getPartyLeaderId(_loc8_);
         }
         var _loc9_:Number = Api.party.getAllMemberFollowPlayerId(this._partyId);
         if(param1 == _loc6_)
         {
            if(!param4)
            {
               _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.leaveParty"),this.leaveParty,[_loc8_]));
            }
            else
            {
               _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.arenaQuit"),this.leaveParty,[_loc8_]));
            }
            if(!param4)
            {
               if(_loc9_ == _loc6_)
               {
                  _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.stopAllFollowingMe"),this.stopAllFollowingThisMember,[_loc8_,param1]));
               }
               else
               {
                  _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.followMeAll"),this.followAllThisMember,[_loc8_,param1]));
               }
            }
         }
         else if(param2)
         {
            if(_loc6_ == _loc7_ || _loc6_ == param3)
            {
               _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.cancelInvitation"),this.cancelPartyInvitation,[_loc8_,param1]));
            }
         }
         else
         {
            if(!param4)
            {
               _loc10_ = Api.player.getFollowingPlayerIds().indexOf(param1) != -1;
               if(_loc10_)
               {
                  _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.stopFollowing"),this.stopFollowingThisMember,[_loc8_,param1]));
               }
               else
               {
                  _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.follow"),this.followThisMember,[_loc8_,param1]));
               }
            }
            if(_loc7_ == _loc6_)
            {
               _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.kickPlayer"),this.kickPlayer,[_loc8_,param1]));
               _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.promotePartyLeader"),this.promoteLeader,[_loc8_,param1]));
               if(!param4)
               {
                  if(_loc9_ == param1)
                  {
                     _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.stopAllFollowingHim"),this.stopAllFollowingThisMember,[_loc8_,param1]));
                  }
                  else
                  {
                     _loc5_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.followHimAll"),this.followAllThisMember,[_loc8_,param1]));
                  }
               }
            }
         }
         if(_loc5_.length > 1)
         {
            return _loc5_;
         }
         return new Array();
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:GameRolePlayHumanoidInformations = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:* = undefined;
         var _loc11_:GameFightCharacterInformations = null;
         if(param1 is GameRolePlayHumanoidInformations)
         {
            _loc3_ = param1 as GameRolePlayHumanoidInformations;
            _loc4_ = param2[0];
            if(_loc4_.hasOwnProperty("position") && _loc4_.position && _loc4_.position.hasOwnProperty("cellId"))
            {
               this._cellId = _loc4_.position.cellId;
            }
            _loc5_ = null;
            _loc6_ = null;
            _loc7_ = null;
            _loc8_ = false;
            _loc9_ = false;
            if(_loc3_.humanoidInfo is HumanInformations)
            {
               for each(_loc10_ in (_loc3_.humanoidInfo as HumanInformations).options)
               {
                  if(_loc10_ is HumanOptionGuild)
                  {
                     _loc5_ = _loc10_.guildInformations;
                  }
                  if(_loc10_ is HumanOptionAlliance)
                  {
                     _loc6_ = _loc10_;
                  }
               }
               _loc8_ = _loc3_.humanoidInfo.restrictions.cantChallenge;
               _loc9_ = _loc3_.humanoidInfo.restrictions.cantExchange;
            }
            if(_loc3_ is GameRolePlayCharacterInformations)
            {
               _loc7_ = (_loc3_ as GameRolePlayCharacterInformations).alignmentInfos;
            }
            return this.createMenu2(_loc3_.name,_loc4_.id,this.getIsMutant(_loc3_),_loc7_,_loc5_,_loc6_,param2[0],_loc3_.accountId,_loc8_,_loc9_);
         }
         if(param1 is GameFightCharacterInformations)
         {
            _loc11_ = param1 as GameFightCharacterInformations;
            return this.createMenu2(_loc11_.name,_loc11_.contextualId,false);
         }
         return this.createMenu2(param1,0,false);
      }
      
      public function getIsMutant(param1:GameRolePlayHumanoidInformations) : Boolean
      {
         return param1 is GameRolePlayMutantInformations;
      }
      
      public function createMenu2(param1:String, param2:Number, param3:Boolean, param4:Object = null, param5:Object = null, param6:Object = null, param7:Object = null, param8:uint = 0, param9:Boolean = false, param10:Boolean = false) : Array
      {
         var _loc15_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc22_:PartyMemberWrapper = null;
         var _loc23_:* = false;
         var _loc24_:Array = null;
         var _loc25_:OptionalFeature = null;
         var _loc26_:Object = null;
         var _loc27_:Object = null;
         var _loc28_:Boolean = false;
         var _loc29_:SubArea = null;
         var _loc30_:Object = null;
         var _loc31_:Boolean = false;
         var _loc32_:Object = null;
         var _loc33_:String = null;
         var _loc34_:Object = null;
         var _loc35_:Object = null;
         var _loc36_:String = null;
         var _loc11_:Array = new Array();
         var _loc12_:* = !Api.player.isAlive();
         var _loc13_:Boolean = false;
         var _loc14_:* = false;
         var _loc16_:Boolean = false;
         var _loc17_:* = false;
         var _loc19_:Object = Api.player.getPlayedCharacterInfo();
         if(_loc19_.name == param1)
         {
            param2 = _loc19_.id;
         }
         var _loc20_:Object = Api.fight.getFighterInformations(Api.player.id());
         var _loc21_:Object = Api.fight.getFighterInformations(param2);
         for each(_loc22_ in Api.party.getPartyMembers(0))
         {
            if(_loc22_.id == param2)
            {
               _loc13_ = true;
               _loc14_ = !_loc22_.isMember;
               if(_loc14_)
               {
                  _loc15_ = _loc22_.hostId;
               }
            }
         }
         for each(_loc22_ in Api.party.getPartyMembers(1))
         {
            if(_loc22_.id == param2)
            {
               _loc16_ = true;
               _loc17_ = !_loc22_.isMember;
               if(_loc17_)
               {
                  _loc18_ = _loc22_.hostId;
               }
            }
         }
         if(param2 != _loc19_.id && param1 != _loc19_.name)
         {
            _loc23_ = false;
            if(param1 != null)
            {
               if(!Api.player.isInFight() && !Api.player.isInPreFight())
               {
                  _loc26_ = Api.roleplay.getEntityByName(param1);
                  _loc23_ = _loc26_ != null;
                  if(_loc26_)
                  {
                     _loc27_ = Api.roleplay.getEntityInfos(_loc26_);
                     if(_loc27_)
                     {
                        param2 = _loc27_.contextualId;
                     }
                  }
               }
            }
            else if(param2)
            {
               _loc23_ = Boolean(Api.roleplay.getPlayerIsInCurrentMap(param2));
            }
            _loc11_.push(ContextMenu.static_createContextMenuTitleObject(param1));
            if(Api.player.isInPreFight() && _loc21_.team == _loc20_.team)
            {
               if(Api.fight.isFightLeader())
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.fight.kick"),this.onKick,[param2]),disabled || _loc12_);
                  _loc11_.push(ContextMenu.static_createContextMenuSeparatorObject());
               }
               _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.companion.switchPlaces"),this.onSwitchPlaces,[_loc21_.currentCell,param2]));
               _loc11_.push(ContextMenu.static_createContextMenuSeparatorObject());
            }
            _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.wisperMessage"),this.onWisperMessage,[param1],disabled));
            if(Api.system.getIsAnkaBoxEnabled())
            {
               _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.ankaboxMessage"),this.onAnkaboxMessage,[param1,param2],disabled));
            }
            if(!Api.player.isInFight())
            {
               if(_loc23_)
               {
                  if(!Api.player.restrictions().cantChallenge && !param9 && !_loc12_)
                  {
                     _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.challenge"),this.onFightChallenge,[param2],disabled || _loc12_));
                  }
                  if(param4 && !_loc12_)
                  {
                     switch(this.allowAgression(param4,param6,param3,param2))
                     {
                        case -1:
                           break;
                        case 0:
                           _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.pvp.assault"),null,null,true));
                           break;
                        case 1:
                           _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.pvp.assault"),this.onAttack,[param2],disabled || _loc12_));
                     }
                  }
               }
               if(_loc23_ && Api.player.isInHisHouse())
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.kickOff"),this.onHouseKickOff,[param2],disabled || _loc12_));
               }
               _loc28_ = false;
               _loc29_ = Api.map.getCurrentSubArea();
               if(_loc29_ && _loc29_.area && _loc29_.area.superArea)
               {
                  _loc30_ = _loc29_.area.superArea;
                  if(_loc29_.area.superArea.id == this.SUPERAREA_INCARNAM)
                  {
                     _loc28_ = true;
                     _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.join"),this.onJoinFriend,[param1],disabled || _loc12_));
                  }
               }
               if(!_loc28_ && Api.social.hasSpouse() && Api.social.getSpouse() && Api.social.getSpouse().id == param2)
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.join"),this.onJoinSpouse,null,disabled || _loc12_));
               }
               if(_loc23_)
               {
                  _loc31_ = false;
                  if(param2)
                  {
                     _loc31_ = true;
                  }
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.zoom"),this.onZoom,[param2],disabled || !_loc31_));
               }
            }
            _loc24_ = new Array();
            _loc24_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.details"),this.onInformations,[param1,false],disabled));
            _loc24_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.characterPage"),this.onInformations,[param1,true,param2],disabled));
            if(param5)
            {
               _loc24_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.guild.guildInformations"),this.onGuildInformations,[param5.guildId],disabled));
               if(param6)
               {
                  _loc24_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.alliance.allianceInformations"),this.onAllianceInformations,[param6.allianceInformations.allianceId],disabled));
               }
            }
            _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.informations"),null,null,false,_loc24_));
            _loc11_.push(ContextMenu.static_createContextMenuSeparatorObject());
            if(!Api.player.isInFight())
            {
               if(_loc23_ && !Api.player.restrictions().cantExchange && !param10)
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.exchangeProp"),this.onExchangeMenuClicked,[param2],disabled || _loc12_));
               }
            }
            if(!_loc13_ && Api.party.getPartyMembers(0).length < 8)
            {
               _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.addToParty"),this.onInviteMenuClicked,[param1],disabled));
            }
            _loc25_ = Api.data.getOptionalFeatureByKeyword("pvp.arena");
            if(_loc25_)
            {
               if((!_loc16_ || Api.party.getPartyMembers(1).length < PvpArenaTypeEnum.ARENA_TYPE_3VS3) && Api.config.isOptionalFeatureActive(_loc25_.id))
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.addToArena"),this.onArenaInvite,[param1],disabled));
               }
            }
            if(Api.social.hasGuild() && Api.social.hasGuildRight(_loc19_.id,"inviteNewMembers"))
            {
               if(!param5)
               {
                  if(param2 == 0)
                  {
                     _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.social.inviteInGuild"),this.onGuildInvite,[param1],disabled));
                  }
                  else
                  {
                     _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.social.inviteInGuild"),this.onGuildInvite,[param2],disabled));
                  }
               }
            }
            if(Api.player.getPlayedCharacterInfo().level >= ProtocolConstantsEnum.MIN_LEVEL_HAVENBAG)
            {
               if(Api.player.isInHisHavenbag() && _loc23_)
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.havenbag.kick.player"),this.onHavenbagKick,[param2],disabled));
               }
               else
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.havenbag.invite.player"),this.onHavenbagInvite,[param2],disabled));
               }
            }
            if(!Api.player.isInFight() && _loc23_)
            {
               _loc32_ = Api.jobs.getUsableSkillsInMap(_loc19_.id);
               _loc33_ = Api.ui.getText("ui.common.inviteTo");
               for each(_loc34_ in _loc32_)
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(_loc33_ + " " + _loc34_.name,this.onMultiCraftCrafterAskClicked,[param2,_loc34_.id],disabled || _loc12_));
               }
               _loc35_ = Api.jobs.getUsableSkillsInMap(param2);
               _loc36_ = Api.ui.getText("ui.common.askTo");
               for each(_loc34_ in _loc35_)
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(_loc36_ + " " + _loc34_.name,this.onMultiCraftCustomerAskClicked,[param2,_loc34_.id],disabled || _loc12_));
               }
            }
            _loc11_.push(ContextMenu.static_createContextMenuSeparatorObject());
            if(!Api.social.isFriend(param1) && !Api.social.isEnemy(param1))
            {
               _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.social.addToFriends"),this.onAddFriend,[param1],disabled));
               _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.social.addToEnemy"),this.onAddEnemy,[param1],disabled));
            }
            if(Api.social.isIgnored(param1,param8))
            {
               _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.social.blackListRemove"),this.onUnignorePlayer,[param8],disabled));
            }
            else
            {
               _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.social.blackListTemporarly"),this.onIgnorePlayer,[param1],disabled));
            }
            if(Api.system.getBuildType() == BuildTypeEnum.DEBUG || Api.system.getBuildType() == BuildTypeEnum.INTERNAL)
            {
               if(param7 && (!param7.hasOwnProperty("chan") || param7.chan == 0 || param7.chan == 3 || param7.chan == 5 || param7.chan == 6 || param7.chan == 9))
               {
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.social.report"),this.onReportClicked,[param2,param1,param7],disabled));
               }
            }
         }
         else
         {
            _loc11_.push(ContextMenu.static_createContextMenuTitleObject(param1));
            switch(Api.player.state())
            {
               case 1:
                  _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.freeSoul"),this.onWantFreeSoul,null,disabled));
                  break;
               case 0:
               case 2:
                  if(Api.player.isInPreFight())
                  {
                     _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.banner.ready"),this.onReady,null,disabled || Api.fight.isWaitingBeforeFight()));
                  }
                  else
                  {
                     _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.dialog.slapHimself"),this.onSlapMenuClicked,null,disabled));
                  }
                  if(!Api.player.isInFight())
                  {
                     _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.humanVendor.organizeShop"),this.onManageShoppingModMenuClicked,null,disabled || Api.player.state() == 2));
                     if(!Api.player.restrictions().cantBeMerchant)
                     {
                        _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.humanVendor.switchToMerchantMode"),this.onShoppingModMenuClicked,null,disabled || Api.player.state() == 2));
                     }
                     _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.orientCharacter"),this.onPivotCharacter,null,disabled || Api.roleplay.isUsingInteractive()));
                     _loc11_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.zoom"),this.onZoom,[param2],disabled));
                  }
            }
         }
         if(Api.player.isInParty())
         {
            if(_loc13_)
            {
               _loc11_ = _loc11_.concat(this.addPartyMenu(param2,_loc14_,_loc15_,false));
            }
            if(_loc16_)
            {
               _loc11_ = _loc11_.concat(this.addPartyMenu(param2,_loc17_,_loc18_,true));
            }
         }
         return _loc11_;
      }
      
      private function allowAgression(param1:Object, param2:Object, param3:Boolean, param4:Number) : int
      {
         var _loc5_:Object = Api.player.currentMap();
         var _loc6_:SubArea = Api.player.currentSubArea();
         var _loc7_:PrismSubAreaWrapper = Api.social.getPrismSubAreaById(_loc6_.id);
         var _loc8_:Object = Api.player.characteristics().alignmentInfos;
         var _loc9_:MapPosition = Api.map.getMapPositionById(_loc5_.mapId);
         if(_loc9_ && !_loc9_.allowAggression)
         {
            return -1;
         }
         if(Api.player.isMutant())
         {
            if(!Api.player.restrictions().cantAttack)
            {
               if(param3)
               {
                  return 0;
               }
               return 1;
            }
            return 0;
         }
         if(param3)
         {
            return 1;
         }
         var _loc10_:int = Api.system.getPlayerManager().serverGameType;
         var _loc11_:* = _loc10_ == 1;
         var _loc12_:AllianceWrapper = Api.social.getAlliance();
         var _loc13_:Boolean = _loc7_ && _loc7_.mapId != -1;
         var _loc14_:Boolean = false;
         if(_loc13_)
         {
            if(!_loc11_)
            {
               if(_loc7_.state == PrismStateEnum.PRISM_STATE_VULNERABLE)
               {
                  if(_loc12_)
                  {
                     if(!this.isAggressableAvA(_loc8_.aggressable))
                     {
                        return -1;
                     }
                     if(param2 == null)
                     {
                        return -1;
                     }
                  }
               }
               else
               {
                  _loc14_ = true;
               }
            }
            else if(_loc12_)
            {
               if(_loc7_.alliance.allianceId != _loc12_.allianceId)
               {
                  if(!this.isAggressableAvA(_loc8_.aggressable))
                  {
                     return -1;
                  }
               }
               else if(!this.isAggressableAvA(_loc8_.aggressable) && _loc8_.aggressable != AggressableStatusEnum.AvA_ENABLED_NON_AGGRESSABLE)
               {
                  return -1;
               }
            }
            if(!_loc14_ && !_loc12_)
            {
               return -1;
            }
            if(!_loc14_ && param2 && (_loc11_ || _loc7_.state == PrismStateEnum.PRISM_STATE_VULNERABLE))
            {
               if(param2.aggressable == AggressableStatusEnum.AvA_DISQUALIFIED)
               {
                  return 0;
               }
               if(!this.isAggressableAvA(param2.aggressable))
               {
                  return -1;
               }
               if(_loc12_.allianceId == param2.allianceInformations.allianceId)
               {
                  return -1;
               }
            }
            this._ava = true;
         }
         if(!_loc11_)
         {
            if(!_loc13_ || _loc14_)
            {
               if(_loc8_ == null || param1 == null)
               {
                  return -1;
               }
               if(_loc8_.aggressable != AggressableStatusEnum.PvP_ENABLED_AGGRESSABLE)
               {
                  return -1;
               }
               if(param1.alignmentSide <= 0 || param1.alignmentGrade == 0)
               {
                  return -1;
               }
               if(_loc8_.alignmentSide != 3 && _loc8_.alignmentSide == param1.alignmentSide)
               {
                  return -1;
               }
               if(_loc8_.alignmentSide == 0)
               {
                  return -1;
               }
               this._ava = false;
            }
         }
         else if(!_loc13_)
         {
            if(_loc12_ && param2)
            {
               if(_loc12_.allianceId == param2.allianceInformations.allianceId || !this.isAggressableAvA(_loc8_.aggressable) || !this.isAggressableAvA(param2.aggressable))
               {
                  return -1;
               }
            }
            else if(!_loc12_ || !this.isAggressableAvA(_loc8_.aggressable))
            {
               return -1;
            }
            this._ava = true;
         }
         if(_loc11_ && Api.player.getPlayedCharacterInfo().level < 50)
         {
            return 0;
         }
         var _loc15_:int = !!this._ava?100:50;
         var _loc16_:int = Api.player.getPlayedCharacterInfo().level;
         if(_loc16_ > ProtocolConstantsEnum.MAX_LEVEL)
         {
            _loc16_ = ProtocolConstantsEnum.MAX_LEVEL;
         }
         var _loc17_:int = int(param1.characterPower - param4);
         if(_loc17_ > ProtocolConstantsEnum.MAX_LEVEL)
         {
            _loc17_ = ProtocolConstantsEnum.MAX_LEVEL;
         }
         if(_loc16_ + _loc15_ < _loc17_)
         {
            return -1;
         }
         return 1;
      }
      
      private function isAggressableAvA(param1:uint) : Boolean
      {
         return !(param1 != AggressableStatusEnum.AvA_ENABLED_AGGRESSABLE && param1 != AggressableStatusEnum.AvA_PREQUALIFIED_AGGRESSABLE);
      }
      
      private function onSwitchPlaces(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new GameFightPlacementSwapPositionsRequest(param1,param2));
      }
   }
}
