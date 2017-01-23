package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.conquest.AllianceOnTheHillWrapper;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicAllianceInformations;
   import com.ankamagames.dofus.uiApi.AlignmentApi;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.AggressableStatusEnum;
   import d2enums.ComponentHookList;
   import d2enums.PrismStateEnum;
   import d2hooks.KohUpdate;
   import d2hooks.PrismsListUpdate;
   import d2hooks.PvpAvaStateChange;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class KingOfTheHill
   {
      
      private static const MAX_ALLIANCE:uint = 5;
      
      private static const TIME_UNLOAD_AFTER_END:uint = 1000 * 60;
      
      private static const SERVER_CONST_KOH_DURATION:int = 2;
      
      private static const SERVER_CONST_KOH_WINNING_SCORE:int = 3;
      
      private static const SERVER_CONST_MINIMAL_TIME_BEFORE_KOH:int = 4;
      
      private static const SERVER_CONST_TIME_BEFORE_WEIGH_IN_KOH:int = 5;
      
      private static const TEAM_PLAYER_COLOR:uint = 10802701;
      
      private static const TEAM_PLAYER_BG_COLOR:uint = 6453255;
      
      private static const TEAM_DEFENDER_COLOR:uint = 52479;
      
      private static const TEAM_DEFENDER_BG_COLOR:uint = 3431610;
      
      private static const TEAM_ATTACKER_COLOR:uint = 16711680;
      
      private static const TEAM_ATTACKER_BG_COLOR:uint = 10751759;
      
      private static var _self:KingOfTheHill;
      
      public static var SERVER_KOH_DURATION:int;
      
      public static var SERVER_KOH_WINNING_SCORE:int;
      
      public static var SERVER_TIME_BEFORE_WEIGH_IN_KOH:int;
      
      private static var _lastViewType:int;
       
      
      private const VIEW_NONE:int = 0;
      
      private const VIEW_SMALL:int = 1;
      
      private const VIEW_FULL:int = 2;
      
      public var currentSubArea:uint;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var alignApi:AlignmentApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var utilApi:UtilApi;
      
      public var socialApi:SocialApi;
      
      public var timeApi:TimeApi;
      
      public var configApi:ConfigApi;
      
      public var chatApi:ChatApi;
      
      private var _kohRealDuration:uint;
      
      private var _kohStartTime:uint;
      
      private var _endOfPrequalifiedTime:uint;
      
      private var _mapScoreUpdateTime:uint;
      
      private var _compHookData:Dictionary;
      
      private var _alliances:Array;
      
      private var _currentWinnerAlliance:AllianceOnTheHillWrapper;
      
      private var _unexpectedWinnerAllianceName:String;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _currentView:int;
      
      private var _iconPath:String;
      
      private var _emblemsPath:String;
      
      private var _barWidth:uint;
      
      private var _barHeight:uint;
      
      private var _bar:Dictionary;
      
      private var _barCtr:Dictionary;
      
      private var _closeTimer:Timer;
      
      private var _end:Boolean;
      
      private var _playerWeighInKoh:Boolean;
      
      private var _myAllianceId:uint;
      
      private var _prismAllianceId:uint;
      
      private var _kohPlayerStatus:uint = 4.294967295E9;
      
      private var _maxBgHeigt:uint;
      
      private var _foldBgHeight:uint;
      
      public var btn_smallView:ButtonContainer;
      
      public var btn_fullView:ButtonContainer;
      
      public var btn_whoswhoTab:ButtonContainer;
      
      public var btn_allianceTab:ButtonContainer;
      
      public var btn_playersTab:ButtonContainer;
      
      public var btn_mapsTab:ButtonContainer;
      
      public var btn_scoreTab:ButtonContainer;
      
      public var ctr_progressBar:GraphicContainer;
      
      public var ctr_details:GraphicContainer;
      
      public var ctr_bar:GraphicContainer;
      
      public var ctr_prequalified:GraphicContainer;
      
      public var tx_bg:TextureBitmap;
      
      public var tx_swords:Texture;
      
      public var tx_svArrow:Texture;
      
      public var tx_fvPlusMinux:Texture;
      
      public var lbl_remainingTime:Label;
      
      public var lbl_empty:Label;
      
      public var lbl_prequalifiedTime:Label;
      
      public var lbl_mapConquest:Label;
      
      public var lbl_mapConquestMyPov:Label;
      
      public var gd_alliances:Grid;
      
      public function KingOfTheHill()
      {
         this._compHookData = new Dictionary(true);
         this._alliances = new Array();
         this._bar = new Dictionary();
         this._barCtr = new Dictionary();
         this._closeTimer = new Timer(TIME_UNLOAD_AFTER_END);
         super();
      }
      
      public static function get instance() : KingOfTheHill
      {
         return _self;
      }
      
      public function main(param1:Object) : void
      {
         _self = this;
         var _loc2_:PrismSubAreaWrapper = param1.prism;
         this.currentSubArea = _loc2_.subAreaId;
         this.sysApi.addHook(KohUpdate,this.onKohUpdate);
         this.sysApi.addHook(PvpAvaStateChange,this.onPvpAvaStateChange);
         this.sysApi.addHook(PrismsListUpdate,this.onPrismsListUpdate);
         this.uiApi.addComponentHook(this.tx_swords,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_swords,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_empty,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_empty,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_mapConquest,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_mapConquest,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_mapConquestMyPov,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_mapConquestMyPov,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_playersTab,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_playersTab,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_mapsTab,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_mapsTab,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_scoreTab,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_scoreTab,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_smallView,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_fullView,ComponentHookList.ON_RELEASE);
         this._maxBgHeigt = this.uiApi.me().getConstant("mainBgHeight");
         this._foldBgHeight = this.uiApi.me().getConstant("foldBgHeight");
         this.ctr_progressBar.visible = false;
         this.ctr_details.visible = false;
         this._closeTimer.addEventListener(TimerEvent.TIMER,this.unloadUi);
         this._emblemsPath = this.uiApi.me().getConstant("emblems_uri");
         this._iconPath = this.uiApi.me().getConstant("icons_uri");
         this._barWidth = this.uiApi.me().getConstant("bar_width");
         this._barHeight = this.uiApi.me().getConstant("bar_height");
         SERVER_KOH_DURATION = int(this.configApi.getServerConstant(SERVER_CONST_KOH_DURATION));
         SERVER_KOH_WINNING_SCORE = int(this.configApi.getServerConstant(SERVER_CONST_KOH_WINNING_SCORE));
         SERVER_TIME_BEFORE_WEIGH_IN_KOH = int(this.configApi.getServerConstant(SERVER_CONST_TIME_BEFORE_WEIGH_IN_KOH));
         this._kohStartTime = getTimer();
         var _loc3_:Date = new Date();
         this._kohRealDuration = _loc2_.nextVulnerabilityDate * 1000 + SERVER_KOH_DURATION - _loc3_.time;
         this._currentView = -1;
         this.updateKohStatus(param1.probationTime);
         this.switchView(_lastViewType);
         this.sysApi.addEventListener(this.onEnterFrame,"kohTimers");
      }
      
      public function unload() : void
      {
         _self = null;
         this.sysApi.removeEventListener(this.onEnterFrame);
         if(this._closeTimer)
         {
            this._closeTimer.removeEventListener(TimerEvent.TIMER,this.unloadUi);
            this._closeTimer.stop();
         }
      }
      
      public function get barHeight() : int
      {
         return this._barHeight;
      }
      
      public function updateAllianceLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:EmblemSymbol = null;
         if(!this._compHookData[param2.tx_emblemBack.name])
         {
            this.uiApi.addComponentHook(param2.tx_emblemBack,ComponentHookList.ON_TEXTURE_READY);
            this.uiApi.addComponentHook(param2.tx_emblemBack,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_emblemBack,ComponentHookList.ON_ROLL_OUT);
         }
         this._compHookData[param2.tx_emblemBack.name] = param1;
         if(!this._compHookData[param2.tx_type.name])
         {
            this.uiApi.addComponentHook(param2.tx_type,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_type,ComponentHookList.ON_ROLL_OUT);
         }
         this._compHookData[param2.tx_type.name] = param1;
         if(param1 != null)
         {
            param2.lbl_tag.text = this.chatApi.getAllianceLink(param1,param1.allianceTag);
            param2.lbl_players.text = param1.nbMembers;
            param2.lbl_points.text = param1.roundWeigth;
            param2.lbl_score.text = param1.matchScore + "/" + SERVER_KOH_WINNING_SCORE;
            param2.tx_type.uri = this.uiApi.createUri(this._iconPath + (this._myAllianceId == param1.allianceId?"ownTeam":this._prismAllianceId == param1.allianceId?"defender":"forward"));
            param2.tx_emblemBack.uri = param1.backEmblem.iconUri;
            param2.tx_emblemUp.uri = param1.upEmblem.iconUri;
            this.utilApi.changeColor(param2.tx_emblemBack,param1.backEmblem.color,1);
            _loc4_ = this.dataApi.getEmblemSymbol(param1.upEmblem.idEmblem);
            if(_loc4_.colorizable)
            {
               this.utilApi.changeColor(param2.tx_emblemUp,param1.upEmblem.color,0);
            }
            else
            {
               this.utilApi.changeColor(param2.tx_emblemUp,param1.upEmblem.color,0,true);
            }
         }
         else
         {
            param2.lbl_tag.text = "";
            param2.lbl_players.text = "";
            param2.lbl_points.text = "";
            param2.lbl_score.text = "";
            param2.tx_type.uri = null;
            param2.tx_emblemBack.uri = null;
            param2.tx_emblemUp.uri = null;
         }
      }
      
      public function onEnterFrame() : void
      {
         this.updateTime();
         if(this._endOfPrequalifiedTime != 0)
         {
            this.updatePrequalifiedTime();
         }
         if(this._mapScoreUpdateTime != 0)
         {
            this.updateMapScoreUpdateTime();
         }
      }
      
      private function updateTheHill() : void
      {
         var _loc1_:AllianceOnTheHillWrapper = null;
         var _loc4_:uint = 0;
         var _loc5_:Bar = null;
         var _loc7_:int = 0;
         var _loc12_:* = undefined;
         var _loc13_:Bar = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:uint = 1;
         var _loc8_:uint = 0;
         for each(_loc1_ in this._alliances)
         {
            if(_loc8_++ == MAX_ALLIANCE)
            {
               break;
            }
            _loc2_ = _loc2_ + _loc1_.roundWeigth;
            _loc3_ = _loc3_ + _loc1_.nbMembers;
         }
         if(!this.socialApi.hasAlliance())
         {
            this._myAllianceId = 0;
         }
         else
         {
            this._myAllianceId = this.socialApi.getAlliance().allianceId;
         }
         var _loc9_:PrismSubAreaWrapper = this.socialApi.getPrismSubAreaById(this.playerApi.currentSubArea().id);
         if(!_loc9_)
         {
            return;
         }
         if(_loc9_.alliance)
         {
            this._prismAllianceId = this.socialApi.getPrismSubAreaById(this.playerApi.currentSubArea().id).alliance.allianceId;
         }
         else
         {
            this._prismAllianceId = this._myAllianceId;
         }
         this._currentWinnerAlliance = this._alliances[0];
         var _loc10_:Dictionary = new Dictionary();
         var _loc11_:* = _loc3_ == 0;
         this.lbl_empty.visible = _loc11_;
         _loc8_ = 0;
         for each(_loc1_ in this._alliances)
         {
            if(_loc8_++ == MAX_ALLIANCE)
            {
               break;
            }
            _loc10_[_loc1_.allianceId] = true;
            if(!_loc11_)
            {
               _loc7_ = Math.max(1,Math.floor((this._barWidth - this._alliances.length + 1) / _loc2_ * _loc1_.roundWeigth));
            }
            else
            {
               _loc7_ = Math.max(1,Math.floor((this._barWidth - this._alliances.length + 1) / this._alliances.length));
            }
            _loc5_ = this._bar[_loc1_.allianceId];
            if(!_loc5_)
            {
               _loc5_ = new Bar(this.uiApi);
               _loc5_.container.y = 1;
               this._bar[_loc1_.allianceId] = _loc5_;
               if(_loc1_.allianceId == this._myAllianceId)
               {
                  _loc5_.colorBackground = TEAM_PLAYER_BG_COLOR;
                  _loc5_.colorScore = TEAM_PLAYER_COLOR;
               }
               else if(_loc1_.allianceId == this._prismAllianceId)
               {
                  _loc5_.colorBackground = TEAM_DEFENDER_BG_COLOR;
                  _loc5_.colorScore = TEAM_DEFENDER_COLOR;
               }
               else
               {
                  _loc5_.colorBackground = TEAM_ATTACKER_BG_COLOR;
                  _loc5_.colorScore = TEAM_ATTACKER_COLOR;
               }
               this.uiApi.addComponentHook(_loc5_.container,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(_loc5_.container,ComponentHookList.ON_ROLL_OUT);
               this.ctr_bar.addChild(_loc5_.container);
            }
            _loc5_.score = _loc1_.matchScore;
            _loc5_.update();
            _loc5_.container.visible = true;
            this._barCtr[_loc5_.container] = _loc1_;
            _loc5_.width = _loc7_;
            _loc5_.container.x = _loc6_;
            _loc6_ = _loc6_ + (_loc7_ + 1);
         }
         for(_loc12_ in this._bar)
         {
            if(!_loc10_[_loc12_])
            {
               _loc13_ = this._bar[_loc12_];
               _loc13_.container.visible = false;
            }
         }
         if(this._currentWinnerAlliance && this._currentWinnerAlliance.matchScore >= SERVER_KOH_WINNING_SCORE)
         {
            this.kohOver();
         }
         if(this._currentView == this.VIEW_FULL)
         {
            this.gd_alliances.dataProvider = this._alliances;
         }
      }
      
      private function kohOver() : void
      {
         if(this._unexpectedWinnerAllianceName)
         {
            this.lbl_remainingTime.text = this.uiApi.getText("ui.koh.win",this._unexpectedWinnerAllianceName);
            this._unexpectedWinnerAllianceName = null;
         }
         else
         {
            this.lbl_remainingTime.text = this.uiApi.getText("ui.koh.win",this._currentWinnerAlliance.allianceName);
         }
         this._end = true;
         this.sysApi.removeEventListener(this.onEnterFrame);
         this._closeTimer.start();
      }
      
      private function unloadUi(param1:Event = null) : void
      {
         if(this.uiApi && this.uiApi.me())
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      private function switchView(param1:int) : void
      {
         if(this._currentView == param1)
         {
            return;
         }
         switch(param1)
         {
            case this.VIEW_NONE:
               this.ctr_progressBar.visible = false;
               this.ctr_details.visible = false;
               this.btn_smallView.selected = this.btn_fullView.selected = false;
               this.tx_bg.visible = false;
               this.btn_smallView.visible = false;
               this.tx_svArrow.visible = false;
               this.tx_fvPlusMinux.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_plus_floating_menu.png");
               break;
            case this.VIEW_SMALL:
               this.tx_bg.visible = true;
               this.ctr_progressBar.visible = true;
               this.ctr_details.visible = false;
               if(this.tx_bg.height == this._maxBgHeigt)
               {
                  this.tx_bg.height = this._foldBgHeight;
               }
               this.btn_smallView.selected = true;
               this.btn_fullView.selected = false;
               this.btn_smallView.visible = true;
               this.tx_svArrow.visible = true;
               this.tx_svArrow.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_arrowDown_floating_menu.png");
               this.tx_fvPlusMinux.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_minus_floating_menu.png");
               break;
            case this.VIEW_FULL:
               this.tx_bg.visible = true;
               this.ctr_progressBar.visible = true;
               this.ctr_details.visible = true;
               this.tx_bg.height = this._maxBgHeigt;
               this.gd_alliances.dataProvider = this._alliances;
               this.btn_smallView.selected = false;
               this.btn_fullView.selected = true;
               this.btn_smallView.visible = true;
               this.tx_svArrow.visible = true;
               this.tx_svArrow.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_arrowUp_floating_menu.png");
               this.tx_fvPlusMinux.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_minus_floating_menu.png");
               this.updateTheHill();
         }
         this._currentView = param1;
         _lastViewType = this._currentView;
      }
      
      private function updateKohStatus(param1:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:uint = this.playerApi.characteristics().alignmentInfos.aggressable;
         if(this._kohPlayerStatus == _loc2_ || _loc2_ == AggressableStatusEnum.AvA_PREQUALIFIED_AGGRESSABLE && param1 == 0)
         {
            return;
         }
         this._kohPlayerStatus = _loc2_;
         this._playerWeighInKoh = _loc2_ == AggressableStatusEnum.AvA_ENABLED_AGGRESSABLE;
         if(_loc2_ == AggressableStatusEnum.AvA_PREQUALIFIED_AGGRESSABLE)
         {
            this._mapScoreUpdateTime = 0;
            this.ctr_prequalified.visible = true;
            _loc3_ = (param1 + 1) * 1000 - new Date().time;
            this._endOfPrequalifiedTime = _loc3_ + getTimer();
            this.updatePrequalifiedTime();
         }
         else
         {
            this.ctr_prequalified.visible = false;
         }
      }
      
      private function onKohUpdate(param1:Object, param2:BasicAllianceInformations, param3:uint, param4:uint, param5:Number) : void
      {
         var _loc6_:AllianceOnTheHillWrapper = null;
         var _loc7_:WorldPointWrapper = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         if(param4 == 0 && this.playerApi.characteristics().alignmentInfos.aggressable == AggressableStatusEnum.AvA_ENABLED_AGGRESSABLE)
         {
            _loc11_ = new Date().time;
            if(param5 > _loc11_)
            {
               this._mapScoreUpdateTime = param5 - _loc11_ + getTimer();
               this.ctr_prequalified.visible = true;
            }
         }
         this._alliances = new Array();
         for each(_loc6_ in param1)
         {
            this._alliances.push(_loc6_);
         }
         this._alliances.sortOn("roundWeigth",Array.NUMERIC | Array.DESCENDING);
         this.updateTheHill();
         _loc7_ = this.playerApi.currentMap();
         _loc9_ = "";
         _loc10_ = "";
         if(param3 == 0)
         {
            _loc8_ = this.uiApi.getText("ui.common.neutral");
         }
         else if(param2.allianceTag == "")
         {
            _loc8_ = "";
            _loc9_ = this.uiApi.getText("ui.koh.draw",param3.toString());
         }
         else
         {
            _loc8_ = this.chatApi.getAllianceLink(param2,param2.allianceTag);
            _loc9_ = param3.toString() + " " + this.uiApi.getText("ui.short.points");
         }
         if(param2.allianceId != this._myAllianceId && param3 > 0)
         {
            _loc10_ = this.chatApi.getAllianceLink(this.socialApi.getAlliance(),this.socialApi.getAlliance().allianceTag);
            Number(param4) + " " + this.uiApi.getText("ui.short.points") + ")";
            this.lbl_mapConquestMyPov.text = _loc10_;
         }
         else
         {
            this.lbl_mapConquestMyPov.text = "";
         }
         this.lbl_mapConquest.text = this.uiApi.getText("ui.option.worldOption") + " [" + _loc7_.outdoorX + "," + _loc7_.outdoorY + "]" + this.uiApi.getText("ui.common.colon") + _loc8_;
         if(param3 > 0)
         {
            this.lbl_mapConquest.appendText(" " + _loc9_);
         }
      }
      
      private function onPvpAvaStateChange(param1:uint, param2:uint) : void
      {
         this.updateKohStatus(param2);
      }
      
      public function onPrismsListUpdate(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PrismSubAreaWrapper = null;
         var _loc4_:int = this.playerApi.currentSubArea().id;
         for each(_loc2_ in param1)
         {
            if(_loc4_ == _loc2_)
            {
               _loc3_ = this.socialApi.getPrismSubAreaById(_loc2_);
               if(_loc3_.state != PrismStateEnum.PRISM_STATE_VULNERABLE)
               {
                  this._unexpectedWinnerAllianceName = _loc3_.alliance.allianceName;
                  this.kohOver();
               }
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_smallView:
               if(this._currentView == this.VIEW_SMALL)
               {
                  this.switchView(this.VIEW_FULL);
               }
               else
               {
                  this.switchView(this.VIEW_SMALL);
               }
               break;
            case this.btn_fullView:
               if(this._currentView == this.VIEW_FULL)
               {
                  this.switchView(this.VIEW_NONE);
               }
               else
               {
                  this.switchView(this.VIEW_FULL);
               }
               break;
            case this.btn_whoswhoTab:
               if(this._bDescendingSort)
               {
                  this.gd_alliances.sortOn("side",Array.NUMERIC);
               }
               else
               {
                  this.gd_alliances.sortOn("side",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_allianceTab:
               if(this._bDescendingSort)
               {
                  this.gd_alliances.sortOn("allianceTag",Array.CASEINSENSITIVE);
               }
               else
               {
                  this.gd_alliances.sortOn("allianceTag",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_playersTab:
               if(this._bDescendingSort)
               {
                  this.gd_alliances.sortOn("nbMembers",Array.NUMERIC);
               }
               else
               {
                  this.gd_alliances.sortOn("nbMembers",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_mapsTab:
               if(this._bDescendingSort)
               {
                  this.gd_alliances.sortOn("roundWeigth",Array.NUMERIC);
               }
               else
               {
                  this.gd_alliances.sortOn("roundWeigth",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_scoreTab:
               if(this._bDescendingSort)
               {
                  this.gd_alliances.sortOn("matchScore",Array.NUMERIC);
               }
               else
               {
                  this.gd_alliances.sortOn("matchScore",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc5_:AllianceOnTheHillWrapper = null;
         var _loc3_:uint = 6;
         var _loc4_:uint = 0;
         switch(true)
         {
            case param1.name.indexOf("tx_type") != -1:
               _loc5_ = this._compHookData[param1.name];
               if(!_loc5_)
               {
                  return;
               }
               _loc2_ = _loc2_ = this.uiApi.getText(this._myAllianceId == _loc5_.allianceId?"ui.alliance.myAlliance":this._prismAllianceId == _loc5_.allianceId?"ui.alliance.allianceInDefense":"ui.alliance.allianceInAttack");
               break;
            case param1.name.indexOf("tx_emblemBack") != -1:
               _loc5_ = this._compHookData[param1.name];
               if(!_loc5_)
               {
                  return;
               }
               _loc2_ = _loc5_.allianceName + " [" + _loc5_.allianceTag + "]";
               break;
            case param1 == this.lbl_empty:
               _loc2_ = this.uiApi.getText("ui.koh.tooltip.emptyConquest");
               break;
            case this._barCtr[param1] != null:
               _loc5_ = this._barCtr[param1];
               if(!_loc5_)
               {
                  return;
               }
               _loc2_ = _loc5_.allianceName + " [" + _loc5_.allianceTag + "] " + "(" + _loc5_.roundWeigth + ") : " + _loc5_.matchScore + " / " + SERVER_KOH_WINNING_SCORE + "\n" + this.uiApi.getText(this._myAllianceId == _loc5_.allianceId?"ui.alliance.myAlliance":this._prismAllianceId == _loc5_.allianceId?"ui.alliance.allianceInDefense":"ui.alliance.allianceInAttack");
               break;
            case param1 == this.tx_swords:
               _loc2_ = this.uiApi.getText("ui.koh.tooltip.rules",SERVER_KOH_WINNING_SCORE,this.timeApi.getShortDuration(SERVER_KOH_DURATION));
               break;
            case param1 == this.btn_playersTab:
               _loc2_ = this.uiApi.getText("ui.koh.tooltip.members");
               break;
            case param1 == this.btn_mapsTab:
               _loc2_ = this.uiApi.getText("ui.koh.tooltip.maps");
               break;
            case param1 == this.btn_scoreTab:
               _loc2_ = this.uiApi.getText("ui.koh.tooltip.time");
               break;
            case param1 == this.lbl_mapConquest:
               _loc2_ = this.uiApi.getText("ui.koh.tooltip.mapConquest");
               break;
            case param1 == this.lbl_mapConquestMyPov:
               if(this.lbl_mapConquestMyPov.text != "")
               {
                  _loc2_ = this.uiApi.getText("ui.koh.tooltip.mapConquestForMyAlliance");
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function updateTime() : void
      {
         var _loc1_:int = this._kohStartTime + this._kohRealDuration - getTimer();
         if(_loc1_ <= 0)
         {
            if(!this._end)
            {
               this.lbl_remainingTime.text = "-";
            }
            return;
         }
         this.lbl_remainingTime.text = this.timeApi.getShortDuration(_loc1_,true);
      }
      
      private function updatePrequalifiedTime() : void
      {
         var _loc1_:int = this._endOfPrequalifiedTime - getTimer();
         if(_loc1_ <= 0)
         {
            this.ctr_prequalified.visible = false;
            this._endOfPrequalifiedTime = 0;
            return;
         }
         this.lbl_prequalifiedTime.text = this.timeApi.getShortDuration(_loc1_,true);
      }
      
      private function updateMapScoreUpdateTime() : void
      {
         var _loc1_:int = this._mapScoreUpdateTime - getTimer();
         if(_loc1_ <= 0)
         {
            this.ctr_prequalified.visible = false;
            this._mapScoreUpdateTime = 0;
            return;
         }
         this.lbl_prequalifiedTime.text = this.timeApi.getShortDuration(_loc1_,true);
      }
   }
}

import com.ankamagames.berilia.api.UiApi;
import com.ankamagames.berilia.types.graphic.GraphicContainer;
import ui.KingOfTheHill;

class Bar
{
    
   
   public var colorBackground:uint;
   
   public var colorScore:uint;
   
   public var score:uint;
   
   public var container:GraphicContainer;
   
   private var bg:GraphicContainer;
   
   private var ctr_score:GraphicContainer;
   
   function Bar(param1:UiApi)
   {
      super();
      this.container = param1.createContainer("GraphicContainer");
      this.ctr_score = param1.createContainer("GraphicContainer");
      this.bg = param1.createContainer("GraphicContainer");
      this.ctr_score.x = this.ctr_score.y = this.ctr_score.width = this.ctr_score.height = 0;
      this.container.addChild(this.bg);
      this.container.addChild(this.ctr_score);
      this.bg.mouseEnabled = true;
      this.ctr_score.mouseEnabled = true;
   }
   
   public function set width(param1:int) : void
   {
      this.ctr_score.width = param1;
      this.bg.width = param1;
   }
   
   public function update() : void
   {
      var _loc1_:Number = (KingOfTheHill.SERVER_KOH_WINNING_SCORE - this.score) / KingOfTheHill.SERVER_KOH_WINNING_SCORE;
      var _loc2_:uint = 20;
      this.bg.bgColor = this.colorBackground;
      this.bg.width = 5;
      this.bg.height = Math.round(_loc2_ * _loc1_);
      this.ctr_score.bgColor = this.colorScore;
      this.ctr_score.y = this.bg.height;
      this.ctr_score.height = Math.round(_loc2_ - _loc2_ * _loc1_);
   }
}
