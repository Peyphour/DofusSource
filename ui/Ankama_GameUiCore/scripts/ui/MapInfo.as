package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.network.types.game.character.alignment.ActorExtendedAlignmentInformations;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.AggressableStatusEnum;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2hooks.AllianceUpdateInformations;
   import d2hooks.ConfigPropertyChange;
   import d2hooks.DareRewardVisible;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightJoin;
   import d2hooks.GameFightLeave;
   import d2hooks.GiftsWaitingAllocation;
   import d2hooks.HouseEntered;
   import d2hooks.MapComplementaryInformationsData;
   import d2hooks.OpenDareSearch;
   import d2hooks.OpenSocial;
   import d2hooks.PrismsList;
   import d2hooks.PrismsListUpdate;
   import d2hooks.PvpAvaStateChange;
   import d2hooks.RewardableAchievementsVisible;
   
   public class MapInfo
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var fightApi:FightApi;
      
      public var utilApi:UtilApi;
      
      public var socialApi:SocialApi;
      
      public var mapApi:MapApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var chatApi:ChatApi;
      
      public var questApi:QuestApi;
      
      private var _isHardcoreServer:Boolean;
      
      private var _currentSubAreaId:int;
      
      private var _currentMap:WorldPointWrapper;
      
      private var _allianceEmblemBgShape:uint;
      
      private var _allianceEmblemBgColor:uint;
      
      private var _allianceEmblemIconShape:uint;
      
      private var _allianceEmblemIconColor:uint;
      
      private var _showAlliance:Boolean;
      
      private var _allowAggression:Boolean;
      
      private var _currentAllianceId:int;
      
      private var _currentPrism:PrismSubAreaWrapper;
      
      private var _currentPlayerAlignment:ActorExtendedAlignmentInformations;
      
      private var _myVeryOwnAlliance:AllianceWrapper;
      
      private var _inFight:Boolean;
      
      private var _totalDaresInSubArea:uint;
      
      public var skip:Boolean = false;
      
      public var lbl_info:Label;
      
      public var lbl_coordAndLevel:Label;
      
      public var tx_warning:Texture;
      
      public var btn_availableDares:ButtonContainer;
      
      public var infoContainer:GraphicContainer;
      
      public var tx_allianceEmblemBack:Texture;
      
      public var tx_allianceEmblemUp:Texture;
      
      public var lbl_alliance:Label;
      
      public var btn_rewardsAndGifts:ButtonContainer;
      
      public var ctr_rewardsAndGifts:GraphicContainer;
      
      public function MapInfo()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.tx_allianceEmblemBack.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_allianceEmblemBack,"onTextureReady");
         this.tx_allianceEmblemUp.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_allianceEmblemUp,"onTextureReady");
         this.sysApi.addHook(MapComplementaryInformationsData,this.onMapComplementaryInformationsData);
         this.sysApi.addHook(AllianceUpdateInformations,this.onAllianceUpdateInformations);
         this.sysApi.addHook(PrismsList,this.onPrismsList);
         this.sysApi.addHook(PrismsListUpdate,this.onPrismsListUpdate);
         this.sysApi.addHook(HouseEntered,this.houseEntered);
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(GameFightLeave,this.onGameFightLeave);
         this.sysApi.addHook(GameFightJoin,this.onGameFightJoin);
         this.sysApi.addHook(RewardableAchievementsVisible,this.onRewardableAchievementsVisible);
         this.sysApi.addHook(GiftsWaitingAllocation,this.onGiftsWaitingAllocation);
         this.sysApi.addHook(DareRewardVisible,this.onDareRewardVisible);
         this.sysApi.addHook(PvpAvaStateChange,this.onPvpAvaStateChange);
         this.sysApi.addHook(ConfigPropertyChange,this.onConfigChange);
         this.uiApi.addComponentHook(this.btn_rewardsAndGifts,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_rewardsAndGifts,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_warning,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_warning,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_availableDares,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_availableDares,ComponentHookList.ON_ROLL_OUT);
         this.updateRewardsButtonVisibility();
         this._isHardcoreServer = this.sysApi.getPlayerManager().serverGameType != 0;
         this._myVeryOwnAlliance = this.socialApi.getAlliance();
      }
      
      public function set visible(param1:Boolean) : void
      {
         this.infoContainer.visible = param1;
      }
      
      public function onPrismsList(param1:Object) : void
      {
         var _loc2_:PrismSubAreaWrapper = null;
         if(!this._showAlliance)
         {
            _loc2_ = this.socialApi.getPrismSubAreaById(this._currentSubAreaId);
            if(_loc2_ && _loc2_.mapId != -1)
            {
               this.showAllianceInfo(!_loc2_.alliance?this._myVeryOwnAlliance:_loc2_.alliance);
               this._showAlliance = true;
            }
         }
      }
      
      public function onPrismsListUpdate(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PrismSubAreaWrapper = null;
         for each(_loc2_ in param1)
         {
            if(this._currentSubAreaId == _loc2_)
            {
               _loc3_ = this.socialApi.getPrismSubAreaById(_loc2_);
               if(_loc3_.mapId != -1)
               {
                  if(this._currentAllianceId == _loc3_.alliance.allianceId)
                  {
                     this._currentAllianceId = -1;
                  }
                  this.showAllianceInfo(!_loc3_.alliance?this._myVeryOwnAlliance:_loc3_.alliance);
                  this._showAlliance = true;
               }
               else
               {
                  this._currentAllianceId = -1;
                  this._showAlliance = false;
                  this.lbl_alliance.visible = false;
                  this.tx_allianceEmblemBack.visible = false;
                  this.tx_allianceEmblemUp.visible = false;
               }
            }
         }
      }
      
      public function onAllianceUpdateInformations() : void
      {
         this._myVeryOwnAlliance = this.socialApi.getAlliance();
         if(this._currentAllianceId == this._myVeryOwnAlliance.allianceId)
         {
            this._currentAllianceId = -1;
            this.showAllianceInfo(this._myVeryOwnAlliance);
         }
      }
      
      private function showAllianceInfo(param1:AllianceWrapper) : void
      {
         if(!this._inFight && this._currentAllianceId != param1.allianceId)
         {
            this.lbl_alliance.text = this.chatApi.getAllianceLink(param1,"[" + param1.allianceTag + "]");
            this.lbl_alliance.visible = true;
            if(this._allianceEmblemBgShape != param1.backEmblem.idEmblem || this._allianceEmblemBgColor != param1.backEmblem.color || !this._showAlliance)
            {
               this._allianceEmblemBgShape = param1.backEmblem.idEmblem;
               this._allianceEmblemBgColor = param1.backEmblem.color;
               this.tx_allianceEmblemBack.visible = false;
               this.tx_allianceEmblemBack.uri = this.uiApi.createUri(this.sysApi.getConfigEntry("config.gfx.path.emblem_icons.large") + "backalliance/" + param1.backEmblem.idEmblem + ".swf");
            }
            if(this._allianceEmblemIconShape != param1.upEmblem.idEmblem || this._allianceEmblemIconColor != param1.upEmblem.color || !this._showAlliance)
            {
               this._allianceEmblemIconShape = param1.upEmblem.idEmblem;
               this._allianceEmblemIconColor = param1.upEmblem.color;
               this.tx_allianceEmblemUp.visible = false;
               this.tx_allianceEmblemUp.uri = this.uiApi.createUri(this.sysApi.getConfigEntry("config.gfx.path.emblem_icons.large") + "up/" + this._allianceEmblemIconShape + ".swf");
            }
            this._currentAllianceId = param1.allianceId;
            this.renderUpdate();
         }
      }
      
      private function updateAttackWarning() : void
      {
         if(this._inFight)
         {
            return;
         }
         this._allowAggression = this.tx_warning.visible = false;
         var _loc1_:MapPosition = this.mapApi.getMapPositionById(this._currentMap.mapId);
         if(_loc1_ && !_loc1_.allowAggression)
         {
            return;
         }
         var _loc2_:SubArea = this.dataApi.getSubArea(this._currentSubAreaId);
         if(_loc2_ && _loc2_.basicAccountAllowed)
         {
            return;
         }
         if(!this._isHardcoreServer && (!this._currentPlayerAlignment || !this._myVeryOwnAlliance || (this._currentPlayerAlignment.aggressable == AggressableStatusEnum.AvA_DISQUALIFIED || this._currentPlayerAlignment.aggressable == AggressableStatusEnum.AvA_ENABLED_NON_AGGRESSABLE || this._currentPlayerAlignment.aggressable == AggressableStatusEnum.NON_AGGRESSABLE || this._currentPlayerAlignment.aggressable == AggressableStatusEnum.PvP_ENABLED_NON_AGGRESSABLE)))
         {
            return;
         }
         this._allowAggression = this.tx_warning.visible = true;
         this.renderUpdate();
      }
      
      private function updateRewardsButtonVisibility() : void
      {
         var _loc1_:* = this.questApi.getRewardableAchievements();
         var _loc2_:* = this.playerApi.getWaitingGifts();
         var _loc3_:* = this.socialApi.getDareRewards();
         if(_loc1_ && _loc1_.length > 0 || _loc2_ && _loc2_.length > 0 || _loc3_ && _loc3_.length > 0)
         {
            this.ctr_rewardsAndGifts.visible = true;
         }
         else
         {
            this.ctr_rewardsAndGifts.visible = false;
         }
         this.renderUpdate();
      }
      
      public function onMapComplementaryInformationsData(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc4_:WorldPointWrapper = this._currentMap;
         this._currentSubAreaId = param2;
         this._currentMap = param1 as WorldPointWrapper;
         if(this.skip)
         {
            this.skip = false;
         }
         else if(param3)
         {
            this.infoContainer.visible = true;
            _loc5_ = this.dataApi.getMapInfo(this._currentMap.mapId);
            this.lbl_coordAndLevel.text = this._currentMap.outdoorX + "," + this._currentMap.outdoorY;
            if(!_loc5_ || !_loc5_.name)
            {
               try
               {
                  _loc6_ = this.dataApi.getArea(this.dataApi.getSubArea(param2).areaId).name;
                  _loc7_ = this.dataApi.getSubArea(param2);
                  _loc8_ = _loc7_.name;
                  _loc9_ = _loc7_.level.toString();
               }
               catch(e:Error)
               {
               }
               if(!_loc8_)
               {
                  _loc8_ = "???????";
               }
               if(!_loc6_)
               {
                  _loc6_ = "???????";
               }
               if(!_loc9_)
               {
                  _loc9_ = "";
               }
               _loc10_ = "";
               if(_loc6_.length > 1 && _loc6_.substr(0,2) != "//")
               {
                  _loc10_ = _loc10_ + _loc6_;
               }
               if(_loc8_.length > 1 && _loc8_ != _loc6_ && _loc8_.substr(0,2) != "//")
               {
                  _loc10_ = _loc10_ + (" (" + _loc8_ + ")");
               }
               this.lbl_info.text = _loc10_;
               this.lbl_coordAndLevel.text = this.lbl_coordAndLevel.text + (", " + this.uiApi.getText("ui.common.averageLevel") + " " + _loc9_);
            }
            else
            {
               this.lbl_info.text = _loc5_.name;
            }
            this._currentPrism = this.socialApi.getPrismSubAreaById(this._currentSubAreaId);
            if(this._currentPrism && this._currentPrism.mapId != -1)
            {
               this.showAllianceInfo(!this._currentPrism.alliance?this._myVeryOwnAlliance:this._currentPrism.alliance);
               this._showAlliance = true;
            }
            else
            {
               this._currentAllianceId = -1;
               this._showAlliance = false;
               this.lbl_alliance.visible = false;
               this.tx_allianceEmblemBack.visible = false;
               this.tx_allianceEmblemUp.visible = false;
            }
            this._totalDaresInSubArea = this.socialApi.getTotalDaresInSubArea(param2);
            this.btn_availableDares.visible = this._totalDaresInSubArea > 0;
         }
         else
         {
            this.infoContainer.visible = false;
         }
         this.updateAttackWarning();
         this.renderUpdate();
      }
      
      public function onTextureReady(param1:Texture) : void
      {
         var _loc2_:EmblemSymbol = null;
         if(!this._showAlliance)
         {
            return;
         }
         if(param1 == this.tx_allianceEmblemBack)
         {
            this.utilApi.changeColor(this.tx_allianceEmblemBack.getChildByName("back"),this._allianceEmblemBgColor,1);
            this.tx_allianceEmblemBack.mouseEnabled = this.tx_allianceEmblemBack.mouseChildren = false;
            this.tx_allianceEmblemBack.visible = true;
         }
         else if(param1 == this.tx_allianceEmblemUp)
         {
            _loc2_ = this.dataApi.getEmblemSymbol(this._allianceEmblemIconShape);
            if(_loc2_.colorizable)
            {
               this.utilApi.changeColor(this.tx_allianceEmblemUp.getChildByName("up"),this._allianceEmblemIconColor,0);
            }
            else
            {
               this.utilApi.changeColor(this.tx_allianceEmblemUp.getChildByName("up"),this._allianceEmblemIconColor,0,true);
            }
            this.tx_allianceEmblemUp.mouseEnabled = this.tx_allianceEmblemUp.mouseChildren = false;
            this.tx_allianceEmblemUp.visible = true;
         }
      }
      
      public function onGameFightJoin(... rest) : void
      {
         this._inFight = true;
         this.ctr_rewardsAndGifts.visible = false;
         this.lbl_alliance.visible = false;
         this.tx_allianceEmblemBack.visible = false;
         this.tx_allianceEmblemUp.visible = false;
         this.tx_warning.visible = false;
      }
      
      public function onGameFightEnd(... rest) : void
      {
         this._inFight = false;
         this.updateRewardsButtonVisibility();
         this.lbl_alliance.visible = this.tx_allianceEmblemBack.visible = this.tx_allianceEmblemUp.visible = this._showAlliance;
         this.tx_warning.visible = this._allowAggression;
      }
      
      public function onGameFightLeave(param1:Number) : void
      {
         this._inFight = false;
         this.updateRewardsButtonVisibility();
         this.lbl_alliance.visible = this.tx_allianceEmblemBack.visible = this.tx_allianceEmblemUp.visible = this._showAlliance;
         this.tx_warning.visible = this._allowAggression;
      }
      
      private function onPvpAvaStateChange(param1:uint, param2:uint) : void
      {
         if(this._currentMap)
         {
            this._currentPlayerAlignment = this.playerApi.characteristics().alignmentInfos;
            this.updateAttackWarning();
         }
      }
      
      public function onConfigChange(param1:String, param2:String, param3:*, param4:*) : void
      {
         if(param1 == "dofus" && param2 == "smallScreenFont")
         {
            this.renderUpdate();
         }
      }
      
      private function onRewardableAchievementsVisible(param1:Boolean) : void
      {
         this.updateRewardsButtonVisibility();
      }
      
      private function onGiftsWaitingAllocation(param1:Boolean) : void
      {
         this.updateRewardsButtonVisibility();
      }
      
      private function onDareRewardVisible(param1:Boolean) : void
      {
         this.updateRewardsButtonVisibility();
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:SubArea = null;
         var _loc3_:* = null;
         var _loc4_:Object = null;
         if(param1 == this.btn_rewardsAndGifts)
         {
            if(this.uiApi.getUi("rewardsAndGiftsUi"))
            {
               this.uiApi.unloadUi("rewardsAndGiftsUi");
            }
            else
            {
               this.uiApi.loadUi("rewardsAndGiftsUi","rewardsAndGiftsUi");
            }
         }
         else if(param1 == this.btn_availableDares)
         {
            _loc2_ = this.dataApi.getSubArea(this._currentSubAreaId);
            if(_loc2_)
            {
               _loc4_ = _loc2_.area;
               if(_loc4_)
               {
                  _loc3_ = _loc4_.name + " (" + _loc2_.name + ")";
               }
               else
               {
                  _loc3_ = _loc2_.name;
               }
               this.sysApi.dispatchHook(OpenDareSearch,_loc3_,"searchFilterSubArea");
            }
            else
            {
               this.sysApi.dispatchHook(OpenSocial,5,0);
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         if(param1 == this.btn_rewardsAndGifts)
         {
            _loc2_ = this.uiApi.getText("ui.achievement.rewardsWaiting");
         }
         else if(param1 == this.tx_warning)
         {
            _loc2_ = this.uiApi.getText("ui.map.warningAttack");
         }
         else if(param1 == this.btn_availableDares)
         {
            _loc2_ = this.uiApi.processText(this.uiApi.getText("ui.social.dare.totalAvailable",this._totalDaresInSubArea),"",this._totalDaresInSubArea == 1);
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function houseEntered(param1:Boolean, param2:int, param3:String, param4:uint, param5:Boolean, param6:int, param7:int, param8:Object) : void
      {
         this.lbl_coordAndLevel.text = param6 + "," + param7;
      }
      
      public function renderUpdate() : void
      {
         if(this.tx_warning.visible)
         {
            this.lbl_coordAndLevel.fullWidth();
            this.tx_warning.x = this.lbl_coordAndLevel.x + this.lbl_coordAndLevel.width + 10;
         }
         if(this.btn_availableDares.visible)
         {
            this.lbl_info.fullWidth();
            this.btn_availableDares.x = this.lbl_info.x + this.lbl_info.width + 10;
         }
         if(!this._inFight && this._currentAllianceId > 0)
         {
            this.lbl_alliance.fullWidth();
            this.tx_allianceEmblemBack.x = this.lbl_alliance.width + 8;
            this.tx_allianceEmblemUp.x = this.tx_allianceEmblemBack.x + 8;
            this.tx_allianceEmblemUp.y = this.tx_allianceEmblemBack.y + 8;
         }
      }
   }
}
