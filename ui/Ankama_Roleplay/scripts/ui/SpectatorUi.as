package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterCompanionLightInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterMonsterLightInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedLightInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterTaxCollectorLightInformations;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofusModuleLibrary.enum.AlignementSideEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.JoinAsSpectatorRequest;
   import d2actions.JoinFightRequest;
   import d2actions.MapRunningFightDetailsRequest;
   import d2actions.OpenCurrentFight;
   import d2actions.StopToListenRunningFight;
   import d2enums.ComponentHookList;
   import d2enums.FightTypeEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.TeamTypeEnum;
   import d2hooks.GameFightOptionStateUpdate;
   import d2hooks.GameRolePlayRemoveFight;
   import d2hooks.MapFightCount;
   import d2hooks.MapRunningFightDetails;
   import d2hooks.MapRunningFightList;
   import d2hooks.OpenSocial;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class SpectatorUi
   {
      
      public static const ORDER_NUMBER:int = 1;
      
      public static const ORDER_LEVEL:int = 2;
      
      public static const ORDER_DURATION:int = 3;
      
      public static const ORDER_VIP:int = 4;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var roleplayApi:RoleplayApi;
      
      public var timeApi:TimeApi;
      
      public var dataApi:DataApi;
      
      public var socialApi:SocialApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var contextMod:Object;
      
      public var tooltipApi:TooltipApi;
      
      private var _selectedFight:Object;
      
      private var _fights:Array;
      
      private var _fightersNameById:Dictionary;
      
      private var _timerTest:Timer;
      
      private var _iconsRight:Array;
      
      private var _iconsLeft:Array;
      
      private var _bgLevelUri:Object;
      
      private var _bgPrestigeUri:Object;
      
      private var _initialDurations:Dictionary;
      
      private var _fightsRef:Dictionary;
      
      private var _fightsRefInverse:Dictionary;
      
      private var _compsTxVip:Dictionary;
      
      private var _compsTxFightType:Dictionary;
      
      private var _timerFights:Timer;
      
      private var _timerStart:Number;
      
      private var _timerTick:Number;
      
      private var _constHeads:String;
      
      private var _constAlignUri:String;
      
      private var _constDoubleArrowUri:String;
      
      private var _currentSort:int = 4;
      
      public var mainCtr:GraphicContainer;
      
      public var btn_spectate:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var gd_fights:Grid;
      
      public var btn_orderNumberPlayers:ButtonContainer;
      
      public var btn_orderLevel:ButtonContainer;
      
      public var btn_orderDuration:ButtonContainer;
      
      public var btn_orderVip:ButtonContainer;
      
      public var lbl_levelRight:Label;
      
      public var lbl_levelLeft:Label;
      
      public var lbl_wavesRight:Label;
      
      public var lbl_wavesLeft:Label;
      
      public var lbl_attackersName:Label;
      
      public var lbl_defendersName:Label;
      
      public var gd_rightTeam:Grid;
      
      public var gd_leftTeam:Grid;
      
      public var ctr_iconsRight:GraphicContainer;
      
      public var ctr_iconsLeft:GraphicContainer;
      
      public var btn_fightRight:ButtonContainer;
      
      public var btn_fightLeft:ButtonContainer;
      
      public function SpectatorUi()
      {
         this._fights = new Array();
         this._fightersNameById = new Dictionary(true);
         this._iconsRight = new Array();
         this._iconsLeft = new Array();
         this._initialDurations = new Dictionary(true);
         this._fightsRef = new Dictionary();
         this._fightsRefInverse = new Dictionary();
         this._compsTxVip = new Dictionary(true);
         this._compsTxFightType = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.btn_fightRight.soundId = SoundEnum.OK_BUTTON;
         this.btn_fightLeft.soundId = SoundEnum.OK_BUTTON;
         this.btn_spectate.soundId = SoundEnum.OK_BUTTON;
         this.sysApi.addHook(MapRunningFightDetails,this.onMapRunningFightDetails);
         this.sysApi.addHook(MapFightCount,this.onMapFightCount);
         this.sysApi.addHook(MapRunningFightList,this.onMapRunningFightList);
         this.sysApi.addHook(GameRolePlayRemoveFight,this.onMapRemoveFight);
         this.sysApi.addHook(GameFightOptionStateUpdate,this.onGameFightOptionStateUpdate);
         this.uiApi.addComponentHook(this.gd_fights,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this._constHeads = this.uiApi.me().getConstant("heads");
         this._constAlignUri = this.uiApi.me().getConstant("fighterType_uri");
         this._constDoubleArrowUri = this.uiApi.me().getConstant("doubleArrow_uri");
         this._bgLevelUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgLevel_uri"));
         this._bgPrestigeUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgPrestige_uri"));
         this.gd_fights.autoSelectMode = 1;
         this.btn_spectate.disabled = true;
         this.btn_fightRight.disabled = true;
         this.btn_fightLeft.disabled = true;
         this._timerFights = new Timer(1000);
         this._timerTick = 0;
         this._timerStart = Math.floor(new Date().time / 1000);
         this._timerFights.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this._timerFights.start();
         this.handleFights(param1);
         this.updateFightsList();
      }
      
      public function unload() : void
      {
         this._timerFights.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
         this._timerFights.stop();
         this._fightsRef = null;
         this._fightsRefInverse = null;
         this.sysApi.sendAction(new StopToListenRunningFight());
      }
      
      public function updateFighterLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:* = null;
         var _loc5_:GameFightFighterCompanionLightInformations = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:GameFightFighterMonsterLightInformations = null;
         var _loc9_:GameFightFighterTaxCollectorLightInformations = null;
         var _loc10_:GameFightFighterNamedLightInformations = null;
         if(param1)
         {
            if(param1 is GameFightFighterCompanionLightInformations)
            {
               _loc5_ = param1 as GameFightFighterCompanionLightInformations;
               _loc6_ = this.dataApi.getCompanion(_loc5_.companionId).name;
               _loc7_ = this._fightersNameById[_loc5_.masterId];
               _loc4_ = this.uiApi.getText("ui.common.belonging",_loc6_,_loc7_);
            }
            else if(param1 is GameFightFighterMonsterLightInformations)
            {
               _loc8_ = param1 as GameFightFighterMonsterLightInformations;
               _loc4_ = this.dataApi.getMonsterFromId(_loc8_.creatureGenericId).name;
            }
            else if(param1 is GameFightFighterTaxCollectorLightInformations)
            {
               _loc9_ = param1 as GameFightFighterTaxCollectorLightInformations;
               _loc4_ = this.dataApi.getTaxCollectorFirstname(_loc9_.firstNameId).firstname + " " + this.dataApi.getTaxCollectorName(_loc9_.lastNameId).name;
            }
            else if(param1 is GameFightFighterNamedLightInformations)
            {
               _loc10_ = param1 as GameFightFighterNamedLightInformations;
               _loc4_ = "{player," + _loc10_.name + "," + _loc10_.id + "::" + _loc10_.name + "}";
            }
            param2.lbl_playerName.text = _loc4_;
            if(param1.id > 0 && param1.level > ProtocolConstantsEnum.MAX_LEVEL)
            {
               param2.lbl_playerLevel.text = "" + (param1.level - ProtocolConstantsEnum.MAX_LEVEL);
               param2.tx_playerLevel.uri = this._bgPrestigeUri;
            }
            else
            {
               param2.lbl_playerLevel.text = param1.level;
               param2.tx_playerLevel.uri = this._bgLevelUri;
            }
            if(param1.breed > 0)
            {
               param2.tx_head.uri = this.uiApi.createUri(this._constHeads + "" + param1.breed + "" + int(param1.sex) + ".png");
               param2.tx_head.visible = true;
            }
            else
            {
               param2.tx_head.visible = false;
            }
         }
         else
         {
            param2.lbl_playerName.text = "";
            param2.lbl_playerLevel.text = "";
            param2.tx_head.visible = false;
            param2.tx_playerLevel.uri = null;
         }
      }
      
      public function updateFightLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         var _loc7_:Array = null;
         var _loc8_:* = null;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         delete this._fightsRef[this._fightsRefInverse[param2]];
         this._fightsRefInverse[param2] = param1;
         this._fightsRef[param1] = param2;
         if(!this._compsTxFightType[param2.tx_twoArrows.name])
         {
            this.uiApi.addComponentHook(param2.tx_twoArrows,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_twoArrows,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsTxFightType[param2.tx_twoArrows.name] = param1;
         if(!this._compsTxVip[param2.tx_iknowyou.name])
         {
            this.uiApi.addComponentHook(param2.tx_iknowyou,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_iknowyou,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsTxVip[param2.tx_iknowyou.name] = param1;
         if(!this._compsTxVip[param2.tx_spectatorLocked.name])
         {
            this.uiApi.addComponentHook(param2.tx_spectatorLocked,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_spectatorLocked,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsTxVip[param2.tx_spectatorLocked.name] = param1;
         if(param1)
         {
            param2.ctr_itemFight.visible = true;
            param2.btn_itemFight.selected = param3;
            _loc4_ = param1.fightTeams[0];
            _loc5_ = param1.fightTeams[1];
            param2.lbl_nbPLayerTeamOne.text = _loc4_.teamMembersCount;
            param2.lbl_nbPLayerTeamTwo.text = _loc5_.teamMembersCount;
            _loc6_ = this._constDoubleArrowUri;
            if(param1.type == FightTypeEnum.FIGHT_TYPE_PVP_ARENA)
            {
               _loc6_ = _loc6_ + "2.png";
            }
            else if(param1.type == FightTypeEnum.FIGHT_TYPE_CHALLENGE)
            {
               _loc6_ = _loc6_ + "3.png";
            }
            else if(param1.type == FightTypeEnum.FIGHT_TYPE_AGRESSION || param1.type == FightTypeEnum.FIGHT_TYPE_PvT || param1.type == FightTypeEnum.FIGHT_TYPE_PvPr || param1.type == FightTypeEnum.FIGHT_TYPE_Koh)
            {
               _loc6_ = _loc6_ + "4.png";
            }
            else
            {
               _loc6_ = _loc6_ + "1.png";
            }
            param2.tx_twoArrows.uri = this.uiApi.createUri(_loc6_);
            _loc7_ = new Array();
            for each(_loc9_ in param1.fightTeams)
            {
               _loc8_ = this._constAlignUri;
               if(_loc9_.teamSide >= 0)
               {
                  switch(_loc9_.teamSide)
                  {
                     case AlignementSideEnum.ALIGNMENT_NEUTRAL:
                        _loc8_ = _loc8_ + "Neutre";
                        break;
                     case AlignementSideEnum.ALIGNMENT_ANGEL:
                        _loc8_ = _loc8_ + "Bonta";
                        break;
                     case AlignementSideEnum.ALIGNMENT_EVIL:
                        _loc8_ = _loc8_ + "Brakmar";
                        break;
                     case AlignementSideEnum.ALIGNMENT_MERCENARY:
                        _loc8_ = _loc8_ + "Seriane";
                  }
               }
               else
               {
                  switch(_loc9_.teamTypeId)
                  {
                     case TeamTypeEnum.TEAM_TYPE_MONSTER:
                        _loc8_ = _loc8_ + "Monstre";
                        break;
                     case TeamTypeEnum.TEAM_TYPE_TAXCOLLECTOR:
                        _loc8_ = _loc8_ + "Perco";
                        break;
                     case TeamTypeEnum.TEAM_TYPE_PRISM:
                        _loc8_ = _loc8_ + "Alliance";
                        break;
                     default:
                        _loc8_ = _loc8_ + "Neutre";
                  }
               }
               _loc7_.push(_loc8_);
            }
            param2.tx_alignTeamOne.uri = this.uiApi.createUri(_loc7_[0] + "G.png");
            param2.tx_alignTeamTwo.uri = this.uiApi.createUri(_loc7_[1] + "D.png");
            param2.tx_spectatorLocked.visible = param1.spectatorLocked;
            param2.lbl_averageLevel.text = param1.averageLevel;
            if(_loc4_.nbWaves > 0)
            {
               param2.lbl_nbWaveTeamOne.text = _loc4_.nbWaves;
               param2.tx_waveTeamOne.visible = true;
            }
            else
            {
               param2.lbl_nbWaveTeamOne.text = "";
               param2.tx_waveTeamOne.visible = false;
            }
            if(_loc5_.nbWaves > 0)
            {
               param2.lbl_nbWaveTeamTwo.text = _loc5_.nbWaves;
               param2.tx_waveTeamTwo.visible = true;
            }
            else
            {
               param2.lbl_nbWaveTeamTwo.text = "";
               param2.tx_waveTeamTwo.visible = false;
            }
            param2.tx_iknowyou.visible = true;
            if(param1.iKnowYou == 1)
            {
               param2.tx_iknowyou.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "spectator/spectator_tx_PictoFriendsMember.png");
               param2.tx_iknowyou.visible = true;
            }
            else if(param1.iKnowYou == 2)
            {
               param2.tx_iknowyou.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "spectator/spectator_tx_PictoFriendsMember.png");
               param2.tx_iknowyou.visible = true;
            }
            else if(param1.iKnowYou == 3)
            {
               param2.tx_iknowyou.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "spectator/spectator_tx_PictoGuildeMember.png");
               param2.tx_iknowyou.visible = true;
            }
            else if(param1.iKnowYou == 4)
            {
               param2.tx_iknowyou.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "spectator/spectator_tx_PictoAllianceMember.png");
               param2.tx_iknowyou.visible = true;
            }
            else
            {
               param2.tx_iknowyou.visible = false;
            }
            if(param1.start == 0)
            {
               param2.lbl_timeStartFight.text = "-";
            }
            else
            {
               _loc10_ = this._timerStart - param1.start;
               this._initialDurations[param1.id] = _loc10_ >= -this._timerTick?_loc10_:-this._timerTick;
               param2.lbl_timeStartFight.text = this.timeApi.getShortDuration((this._initialDurations[param1.id] + this._timerTick) * 1000);
            }
         }
         else
         {
            param2.ctr_itemFight.visible = false;
            param2.tx_alignTeamOne.uri = null;
            param2.tx_alignTeamTwo.uri = null;
            param2.lbl_nbPLayerTeamOne.text = "";
            param2.lbl_nbPLayerTeamTwo.text = "";
            param2.lbl_timeStartFight.text = "";
            param2.lbl_averageLevel.text = "";
            param2.btn_itemFight.selected = false;
         }
      }
      
      private function updateFightsList() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc1_:Array = new Array();
         if(this._currentSort < 0)
         {
            if(this._currentSort == -ORDER_NUMBER)
            {
               this._fights.sortOn("fightersNumber",Array.NUMERIC | Array.DESCENDING);
            }
            else if(this._currentSort == -ORDER_LEVEL)
            {
               this._fights.sortOn("averageLevel",Array.NUMERIC | Array.DESCENDING);
            }
            else if(this._currentSort == -ORDER_DURATION)
            {
               this._fights.sortOn("start",Array.NUMERIC | Array.DESCENDING);
            }
            else
            {
               this._fights.sortOn("iKnowYou",Array.NUMERIC | Array.DESCENDING);
            }
         }
         else if(this._currentSort == ORDER_NUMBER)
         {
            this._fights.sortOn("fightersNumber",Array.NUMERIC);
         }
         else if(this._currentSort == ORDER_LEVEL)
         {
            this._fights.sortOn("averageLevel",Array.NUMERIC);
         }
         else if(this._currentSort == ORDER_DURATION)
         {
            this._fights.sortOn("start",Array.NUMERIC);
         }
         else
         {
            this._fights.sortOn("iKnowYou",Array.NUMERIC);
         }
         if(this.gd_fights.selectedItem)
         {
            _loc2_ = this.gd_fights.selectedItem.id;
         }
         this.gd_fights.dataProvider = this._fights;
         if(_loc2_ > 0)
         {
            for each(_loc3_ in this._fights)
            {
               if(_loc3_.id == _loc2_)
               {
                  this.gd_fights.selectedItem = _loc3_;
                  return;
               }
            }
         }
      }
      
      private function refreshButtons(param1:uint) : void
      {
         this.refreshSpectateButton(this._selectedFight.spectatorLocked);
         this.refreshJoinButton(0,this._selectedFight.fightTeamsOptions[0].isClosed);
         this.refreshJoinButton(1,this._selectedFight.fightTeamsOptions[1].isClosed);
      }
      
      private function refreshJoinButton(param1:uint, param2:Boolean) : void
      {
         var _loc3_:ButtonContainer = param1 == 0?this.btn_fightLeft:this.btn_fightRight;
         var _loc4_:Object = this.roleplayApi.getFight(this._selectedFight.id);
         var _loc5_:int = (param1 + 1) % 2;
         _loc3_.disabled = this._selectedFight.start != 0 || this._selectedFight.fightTeams[param1].teamTypeId == TeamTypeEnum.TEAM_TYPE_MONSTER || this._selectedFight.fightTeams[param1].teamTypeId == TeamTypeEnum.TEAM_TYPE_TAXCOLLECTOR && !this._selectedFight.fightTeams[param1].hasMyTaxCollector || this._selectedFight.fightTeams[_loc5_].teamTypeId == TeamTypeEnum.TEAM_TYPE_TAXCOLLECTOR && this._selectedFight.fightTeams[_loc5_].hasMyTaxCollector || param2 || _loc4_ == null || !_loc4_;
      }
      
      private function refreshSpectateButton(param1:Boolean) : void
      {
         this.btn_spectate.disabled = !this.sysApi.hasRight() && param1;
      }
      
      private function joinFight(param1:*) : void
      {
         this.sysApi.sendAction(new JoinAsSpectatorRequest(param1));
      }
      
      private function iconIndex(param1:int, param2:int) : int
      {
         if(param1 == 0)
         {
            if(this._iconsLeft[param2] != null)
            {
               return param2;
            }
         }
         else if(param1 == 1)
         {
            if(this._iconsRight[param2] != null)
            {
               return param2;
            }
         }
         return -1;
      }
      
      private function handleFights(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = {
               "id":_loc2_.fightId,
               "type":_loc2_.fightType,
               "start":_loc2_.fightStart,
               "spectatorLocked":_loc2_.fightSpectatorLocked,
               "fightTeams":_loc2_.fightTeams,
               "fightTeamsOptions":_loc2_.fightTeamsOptions
            };
            _loc3_.averageLevel = Math.round((_loc2_.fightTeams[0].meanLevel * _loc2_.fightTeams[0].teamMembersCount + _loc2_.fightTeams[1].meanLevel * _loc2_.fightTeams[1].teamMembersCount) / (_loc2_.fightTeams[0].teamMembersCount + _loc2_.fightTeams[1].teamMembersCount));
            _loc3_.fightersNumber = _loc2_.fightTeams[0].teamMembersCount + _loc2_.fightTeams[1].teamMembersCount;
            if(_loc2_.fightTeams[0].hasGroupMember || _loc2_.fightTeams[1].hasGroupMember)
            {
               _loc3_.iKnowYou = 1;
            }
            else if(_loc2_.fightTeams[0].hasFriend || _loc2_.fightTeams[1].hasFriend)
            {
               _loc3_.iKnowYou = 2;
            }
            else if(_loc2_.fightTeams[0].hasGuildMember || _loc2_.fightTeams[1].hasGuildMember)
            {
               _loc3_.iKnowYou = 3;
            }
            else if(_loc2_.fightTeams[0].hasAllianceMember || _loc2_.fightTeams[1].hasAllianceMember)
            {
               _loc3_.iKnowYou = 4;
            }
            else
            {
               _loc3_.iKnowYou = 5;
            }
            this._fights.push(_loc3_);
         }
         this._fights.sortOn(["iKnowYou","id"],[Array.NUMERIC,Array.NUMERIC]);
      }
      
      private function updateOptions(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc5_:Texture = null;
         if(param2 == 0)
         {
            return;
         }
         var _loc4_:int = this.iconIndex(param1,param2);
         if(param3)
         {
            if(_loc4_ == -1)
            {
               _loc5_ = this.uiApi.createComponent("Texture") as Texture;
               _loc5_.x = 25 * (param2 - 1);
               _loc5_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("assets") + "fightOption" + param2);
               _loc5_.finalize();
               this.uiApi.addComponentHook(_loc5_,"onRollOver");
               this.uiApi.addComponentHook(_loc5_,"onRollOut");
               if(param1)
               {
                  this.ctr_iconsRight.addChild(_loc5_);
                  this._iconsRight[param2] = _loc5_;
               }
               else
               {
                  this.ctr_iconsLeft.addChild(_loc5_);
                  this._iconsLeft[param2] = _loc5_;
               }
            }
            else if(param1)
            {
               this._iconsRight[param2].visible = true;
            }
            else
            {
               this._iconsLeft[param2].visible = true;
            }
         }
         else if(_loc4_ != -1)
         {
            if(param1)
            {
               this._iconsRight[_loc4_].visible = false;
            }
            else
            {
               this._iconsLeft[_loc4_].visible = false;
            }
         }
      }
      
      private function onMapRunningFightList(param1:Object) : void
      {
         this._fights = new Array();
         if(param1.length == 0)
         {
            this.gd_leftTeam.dataProvider = new Array();
            this.gd_rightTeam.dataProvider = new Array();
            this.lbl_levelLeft.text = "";
            this.lbl_levelRight.text = "";
            this.lbl_wavesLeft.text = "";
            this.lbl_wavesRight.text = "";
            this.lbl_attackersName.text = this.uiApi.getText("ui.common.attackers") + " - ";
            this.lbl_defendersName.text = this.uiApi.getText("ui.common.defenders") + " - ";
         }
         else
         {
            this.handleFights(param1);
         }
         this.btn_spectate.softDisabled = this._fights.length <= 0;
         this.updateFightsList();
      }
      
      private function onMapFightCount(param1:uint) : void
      {
         if(param1 != this.gd_fights.dataProvider.length)
         {
            this.sysApi.sendAction(new OpenCurrentFight());
         }
      }
      
      private function onMapRunningFightDetails(param1:uint, param2:Object, param3:Object, param4:String, param5:String) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         if(this._selectedFight)
         {
            this.refreshButtons(this._selectedFight.id);
         }
         this._fightersNameById = new Dictionary();
         if(param4 && param4 != "")
         {
            this.lbl_attackersName.text = param4;
         }
         else
         {
            this.lbl_attackersName.text = this.uiApi.getText("ui.common.attackers");
         }
         if(param5 && param5 != "")
         {
            this.lbl_defendersName.text = param5;
         }
         else
         {
            this.lbl_defendersName.text = this.uiApi.getText("ui.common.defenders");
         }
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         for each(_loc13_ in param2)
         {
            _loc12_ = _loc13_.level;
            if(_loc13_.id > 0 && _loc12_ > ProtocolConstantsEnum.MAX_LEVEL)
            {
               _loc12_ = ProtocolConstantsEnum.MAX_LEVEL;
            }
            _loc6_ = _loc6_ + _loc12_;
            if(_loc13_ is GameFightFighterNamedLightInformations)
            {
               this._fightersNameById[(_loc13_ as GameFightFighterNamedLightInformations).id] = (_loc13_ as GameFightFighterNamedLightInformations).name;
            }
            if(_loc13_.wave > 0 && _loc13_.wave > _loc9_)
            {
               _loc9_ = _loc13_.wave;
            }
         }
         _loc7_ = Math.round(_loc6_ / param2.length);
         this.lbl_levelLeft.x = this.lbl_attackersName.x + this.lbl_attackersName.textWidth;
         this.lbl_levelLeft.text = " - " + this.uiApi.getText("ui.common.short.level") + " " + _loc7_.toString();
         _loc6_ = 0;
         for each(_loc14_ in param3)
         {
            _loc12_ = _loc14_.level;
            if(_loc14_.id > 0 && _loc12_ > ProtocolConstantsEnum.MAX_LEVEL)
            {
               _loc12_ = ProtocolConstantsEnum.MAX_LEVEL;
            }
            _loc6_ = _loc6_ + _loc12_;
            if(_loc14_ is GameFightFighterNamedLightInformations)
            {
               this._fightersNameById[(_loc14_ as GameFightFighterNamedLightInformations).id] = (_loc14_ as GameFightFighterNamedLightInformations).name;
            }
            if(_loc14_.wave > 0 && _loc14_.wave > _loc8_)
            {
               _loc8_ = _loc14_.wave;
            }
         }
         _loc7_ = Math.round(_loc6_ / param3.length);
         this.lbl_levelRight.x = this.lbl_defendersName.x + this.lbl_defendersName.textWidth;
         this.lbl_levelRight.text = " - " + this.uiApi.getText("ui.common.short.level") + " " + _loc7_.toString();
         if(_loc9_ > 0 || _loc8_ > 0)
         {
            for each(_loc16_ in this._fights)
            {
               if(_loc16_ && _loc16_.id == this._selectedFight.id)
               {
                  if(_loc16_.fightTeams[0])
                  {
                     _loc10_ = _loc16_.fightTeams[0].nbWaves;
                  }
                  if(_loc16_.fightTeams[1])
                  {
                     _loc11_ = _loc16_.fightTeams[1].nbWaves;
                  }
               }
            }
            if(_loc10_ > 0)
            {
               this.lbl_wavesLeft.text = this.uiApi.processText(this.uiApi.getText("ui.spectator.wavesDisplayed"),"",_loc9_ == 1) + " " + _loc9_ + "/" + _loc10_;
            }
            else
            {
               this.lbl_wavesLeft.text = "";
            }
            if(_loc11_ > 0)
            {
               this.lbl_wavesRight.text = this.uiApi.processText(this.uiApi.getText("ui.spectator.wavesDisplayed"),"",_loc8_ == 1) + " " + _loc8_ + "/" + _loc11_;
            }
            else
            {
               this.lbl_wavesRight.text = "";
            }
         }
         this.gd_leftTeam.dataProvider = param2;
         this.gd_rightTeam.dataProvider = param3;
         var _loc15_:Object = this.roleplayApi.getFight(this._selectedFight.id);
         if(!_loc15_ || !_loc15_.teams[0] || !_loc15_.teams[1])
         {
            this.updateOptions(0,1,false);
            this.updateOptions(0,2,false);
            this.updateOptions(0,3,false);
            this.updateOptions(1,1,false);
            this.updateOptions(1,2,false);
            this.updateOptions(1,3,false);
         }
         else
         {
            for(_loc17_ in _loc15_.teams[0].teamOptions)
            {
               this.updateOptions(0,_loc17_,_loc15_.teams[0].teamOptions[_loc17_]);
            }
            for(_loc18_ in _loc15_.teams[1].teamOptions)
            {
               this.updateOptions(1,_loc18_,_loc15_.teams[1].teamOptions[_loc18_]);
            }
         }
      }
      
      private function onMapRemoveFight(param1:uint) : void
      {
         this._timerTest = new Timer(100);
         this._timerTest.addEventListener(TimerEvent.TIMER,this.onTimerEnd);
         this._timerTest.start();
      }
      
      private function onTimerEnd(param1:TimerEvent) : void
      {
         this._timerTest.removeEventListener(TimerEvent.TIMER,this.onTimerEnd);
         this._timerTest = null;
         this.sysApi.sendAction(new OpenCurrentFight());
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         for each(_loc2_ in this.gd_fights.dataProvider)
         {
            if(this._initialDurations[_loc2_.id])
            {
               _loc3_ = this._initialDurations[_loc2_.id] + this._timerTick;
               _loc4_ = this.timeApi.getShortDuration(_loc3_ * 1000);
               if(this._fightsRef[_loc2_] && this._fightsRef[_loc2_].lbl_timeStartFight && _loc4_ != this._fightsRef[_loc2_].lbl_timeStartFight.text)
               {
                  this._fightsRef[_loc2_].lbl_timeStartFight.text = _loc4_;
               }
            }
         }
         this._timerTick++;
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.gd_fights:
               switch(param2)
               {
                  case GridItemSelectMethodEnum.DOUBLE_CLICK:
                     if(this._selectedFight == null)
                     {
                        break;
                     }
                     this.joinFight(this._selectedFight.id);
                     break;
                  default:
                     if(!param3 && param2 != GridItemSelectMethodEnum.AUTO)
                     {
                        return;
                     }
                     this._selectedFight = this.gd_fights.dataProvider[param1.selectedIndex];
                     if(this._selectedFight == null)
                     {
                        break;
                     }
                     this.sysApi.sendAction(new MapRunningFightDetailsRequest(this._selectedFight.id));
                     break;
               }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_fightLeft:
               _loc2_ = this.roleplayApi.getFight(this._selectedFight.id);
               if(!_loc2_)
               {
                  return;
               }
               this.sysApi.sendAction(new JoinFightRequest(this._selectedFight.id,_loc2_.teams[0].teamInfos.leaderId));
               break;
            case this.btn_fightRight:
               _loc2_ = this.roleplayApi.getFight(this._selectedFight.id);
               if(!_loc2_)
               {
                  return;
               }
               if(_loc2_.teams[1].teamType == TeamTypeEnum.TEAM_TYPE_TAXCOLLECTOR)
               {
                  this.sysApi.dispatchHook(OpenSocial,1,2);
               }
               else
               {
                  this.sysApi.sendAction(new JoinFightRequest(this._selectedFight.id,_loc2_.teams[1].teamInfos.leaderId));
               }
               break;
            case this.btn_spectate:
               this.sysApi.sendAction(new JoinAsSpectatorRequest(this._selectedFight.id));
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_orderNumberPlayers:
               if(this._currentSort == ORDER_NUMBER)
               {
                  this._currentSort = -ORDER_NUMBER;
                  this.updateFightsList();
               }
               else
               {
                  this._currentSort = ORDER_NUMBER;
                  this.updateFightsList();
               }
               break;
            case this.btn_orderLevel:
               if(this._currentSort == ORDER_LEVEL)
               {
                  this._currentSort = -ORDER_LEVEL;
                  this.updateFightsList();
               }
               else
               {
                  this._currentSort = ORDER_LEVEL;
                  this.updateFightsList();
               }
               break;
            case this.btn_orderDuration:
               if(this._currentSort == ORDER_DURATION)
               {
                  this._currentSort = -ORDER_DURATION;
                  this.updateFightsList();
               }
               else
               {
                  this._currentSort = ORDER_DURATION;
                  this.updateFightsList();
               }
               break;
            case this.btn_orderVip:
               if(this._currentSort == ORDER_VIP)
               {
                  this._currentSort = -ORDER_VIP;
                  this.updateFightsList();
               }
               else
               {
                  this._currentSort = ORDER_VIP;
                  this.updateFightsList();
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         switch(param1)
         {
            case this._iconsRight[1]:
            case this._iconsLeft[1]:
               _loc2_ = this.uiApi.getText("ui.fight.option.blockJoinerExceptParty");
               break;
            case this._iconsRight[2]:
            case this._iconsLeft[2]:
               _loc2_ = this.uiApi.getText("ui.fight.option.blockJoiner");
               break;
            case this._iconsRight[3]:
            case this._iconsLeft[3]:
               _loc2_ = this.uiApi.getText("ui.fight.option.help");
               break;
            default:
               if(param1.name.indexOf("tx_iknowyou") != -1)
               {
                  _loc3_ = this._compsTxVip[param1.name].iKnowYou;
                  if(_loc3_ == 1)
                  {
                     _loc2_ = this.uiApi.getText("ui.spectator.isGroup");
                  }
                  else if(_loc3_ == 2)
                  {
                     _loc2_ = this.uiApi.getText("ui.spectator.isFriend");
                  }
                  else if(_loc3_ == 3)
                  {
                     _loc2_ = this.uiApi.getText("ui.spectator.isGuild");
                  }
                  else if(_loc3_ == 4)
                  {
                     _loc2_ = this.uiApi.getText("ui.spectator.isAlliance");
                  }
               }
               else if(param1.name.indexOf("tx_twoArrows") != -1)
               {
                  _loc4_ = this._compsTxFightType[param1.name].type;
                  if(_loc4_ == FightTypeEnum.FIGHT_TYPE_PVP_ARENA)
                  {
                     _loc2_ = this.uiApi.getText("ui.common.koliseum");
                  }
                  else if(_loc4_ == FightTypeEnum.FIGHT_TYPE_CHALLENGE)
                  {
                     _loc2_ = this.uiApi.getText("ui.fight.challenge");
                  }
                  else if(_loc4_ == FightTypeEnum.FIGHT_TYPE_AGRESSION)
                  {
                     _loc2_ = this.uiApi.getText("ui.alert.event.11");
                  }
                  else if(_loc4_ == FightTypeEnum.FIGHT_TYPE_PvT)
                  {
                     _loc2_ = this.uiApi.getText("ui.spectator.taxcollectorAttack");
                  }
                  else if(_loc4_ == FightTypeEnum.FIGHT_TYPE_PvPr)
                  {
                     _loc2_ = this.uiApi.getText("ui.prism.attackedNotificationTitle");
                  }
               }
               else if(param1.name.indexOf("tx_spectatorLocked") != -1)
               {
                  _loc2_ = this.uiApi.getText("ui.spectator.noSpectatorForThisFight");
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
      
      public function onGameFightOptionStateUpdate(param1:int, param2:uint, param3:int, param4:Boolean) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         if(this._selectedFight && param1 == this._selectedFight.id)
         {
            this.updateOptions(param2,param3,param4);
            switch(param3)
            {
               case 0:
                  this.refreshSpectateButton(param4);
                  break;
               case 2:
                  this.refreshJoinButton(param2,param4);
            }
         }
         if(param3 == 0)
         {
            for each(_loc5_ in this._fights)
            {
               if(_loc5_ && _loc5_.id == param1)
               {
                  _loc5_.spectatorLocked = param4;
               }
            }
            for each(_loc6_ in this.gd_fights.dataProvider)
            {
               if(_loc6_.id == param1 && this._fightsRef[_loc6_] && this._fightsRef[_loc6_].tx_spectatorLocked)
               {
                  this._fightsRef[_loc6_].tx_spectatorLocked.visible = param4;
               }
            }
         }
      }
   }
}
