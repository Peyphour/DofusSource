package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.arena.ArenaRankInfosWrapper;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.ArenaRegister;
   import d2actions.ArenaUnregister;
   import d2actions.PartyLeaveRequest;
   import d2enums.PvpArenaStepEnum;
   import d2enums.PvpArenaTypeEnum;
   import d2enums.SoundTypeEnum;
   import d2enums.UISoundEnum;
   import d2hooks.ArenaFightProposition;
   import d2hooks.ArenaFighterStatusUpdate;
   import d2hooks.ArenaRegistrationStatusUpdate;
   import d2hooks.ArenaUpdateRank;
   import d2hooks.PartyJoin;
   import d2hooks.PartyLeaderUpdate;
   import d2hooks.PartyLeave;
   import d2hooks.PartyMemberRemove;
   import d2hooks.PartyMemberUpdate;
   import d2hooks.PartyUpdate;
   import flash.utils.Dictionary;
   
   public class PvpArena
   {
      
      public static const TEAM_MEMBERS_MAX:int = PvpArenaTypeEnum.ARENA_TYPE_3VS3;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var partyApi:PartyApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var soundApi:SoundApi;
      
      private var _isRegistered:Boolean;
      
      private var _currentStatus:int;
      
      private var _nbFightersReady:int = 0;
      
      private var _myTeam:Array;
      
      private var _statusList:Dictionary;
      
      private var _componentsList:Dictionary;
      
      public var lbl_step:Label;
      
      public var lbl_whatToDo:Label;
      
      public var ctr_groupTitle:GraphicContainer;
      
      public var gd_myTeam:Grid;
      
      public var gd_rankInfos:Grid;
      
      public var btn_lbl_btn_validate:Label;
      
      public var btn_validate:ButtonContainer;
      
      public var btn_quitArena:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public function PvpArena()
      {
         this._statusList = new Dictionary(true);
         this._componentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Array) : void
      {
         var _loc5_:Number = NaN;
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.btn_validate.soundId = UISoundEnum.OK_BUTTON;
         this.btn_quitArena.soundId = UISoundEnum.OK_BUTTON;
         this.btn_close.soundId = UISoundEnum.CANCEL_BUTTON;
         this.sysApi.addHook(ArenaRegistrationStatusUpdate,this.onArenaRegistrationStatusUpdate);
         this.sysApi.addHook(ArenaFighterStatusUpdate,this.onArenaFighterStatusUpdate);
         this.sysApi.addHook(ArenaFightProposition,this.onArenaFightProposition);
         this.sysApi.addHook(ArenaUpdateRank,this.onArenaUpdateRank);
         this.sysApi.addHook(PartyJoin,this.onPartyJoin);
         this.sysApi.addHook(PartyUpdate,this.onPartyUpdate);
         this.sysApi.addHook(PartyLeave,this.onPartyLeave);
         this.sysApi.addHook(PartyLeaderUpdate,this.onPartyLeaderUpdate);
         this.sysApi.addHook(PartyMemberUpdate,this.onPartyMemberUpdate);
         this.sysApi.addHook(PartyMemberRemove,this.onPartyMemberRemove);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addComponentHook(this.btn_validate,"onRollOver");
         this.uiApi.addComponentHook(this.btn_validate,"onRollOut");
         this.uiApi.addComponentHook(this.btn_quitArena,"onRollOver");
         this.uiApi.addComponentHook(this.btn_quitArena,"onRollOut");
         this._isRegistered = this.partyApi.isArenaRegistered();
         this._currentStatus = this.partyApi.getArenaCurrentStatus();
         this.onArenaRegistrationStatusUpdate(this._isRegistered,this._currentStatus);
         this.updateFighters();
         if(this.partyApi.getArenaLeader() && this.playerApi.id() != this.partyApi.getArenaLeader().id)
         {
            this.btn_validate.softDisabled = true;
         }
         if(this.partyApi.getArenaPartyId() == 0)
         {
            this.btn_quitArena.softDisabled = true;
         }
         var _loc2_:Array = new Array();
         var _loc3_:Object = this.partyApi.getArenaRankSoloInfos();
         _loc2_.push({
            "title":this.uiApi.getText("ui.party.arenaRank"),
            "solo":_loc3_.rank,
            "group":"",
            "rolloverText":this.uiApi.getText("ui.party.arenaRankInfos")
         });
         _loc2_.push({
            "title":this.uiApi.getText("ui.party.arenaRankMax"),
            "solo":_loc3_.maxRank,
            "group":"",
            "rolloverText":this.uiApi.getText("ui.party.arenaRankMaxInfos")
         });
         _loc2_.push({
            "title":this.uiApi.getText("ui.party.arenaFightsOfTheDay"),
            "solo":_loc3_.todayVictoryCount + "/" + _loc3_.todayFightCount,
            "group":"",
            "rolloverText":this.uiApi.getText("ui.party.arenaFightsOfTheDayInfos")
         });
         var _loc4_:Object = this.partyApi.getArenaRankGroupInfos();
         if(_loc4_)
         {
            this.ctr_groupTitle.visible = true;
            _loc2_[0].group = _loc4_.rank;
            _loc2_[1].group = _loc4_.maxRank;
            _loc2_[2].group = _loc4_.todayVictoryCount + "/" + _loc4_.todayFightCount;
         }
         else
         {
            this.ctr_groupTitle.visible = false;
         }
         this.gd_rankInfos.dataProvider = _loc2_;
         for each(_loc5_ in this.partyApi.getArenaReadyPartyMemberIds())
         {
            this.onArenaFighterStatusUpdate(_loc5_,true);
         }
      }
      
      public function unload() : void
      {
         this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
      }
      
      public function updateFighterLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:* = null;
         if(!this._statusList[param2.tx_fighterState.name])
         {
            this.uiApi.addComponentHook(param2.tx_fighterState,"onRollOut");
            this.uiApi.addComponentHook(param2.tx_fighterState,"onRollOver");
         }
         this._statusList[param2.tx_fighterState.name] = param1;
         if(param1)
         {
            if(param1.name != "")
            {
               _loc4_ = "{player," + param1.name + "," + param1.realId + "::" + param1.name + "}";
               param2.lbl_fighterName.text = _loc4_;
               if(param1.chief)
               {
                  param2.tx_leader.visible = true;
               }
               else
               {
                  param2.tx_leader.visible = false;
               }
            }
            else
            {
               param2.lbl_fighterName.text = this.uiApi.getText("ui.common.randomCharacter");
               param2.tx_leader.visible = false;
            }
            param2.tx_fighterState.uri = this.uiApi.createUri(this.uiApi.me().getConstant("stateAssets") + this.getColorButtonByStatus(param1.status) + ".png");
         }
         else
         {
            param2.lbl_fighterName.text = "";
            param2.tx_fighterState.uri = null;
            param2.tx_leader.visible = false;
         }
      }
      
      protected function getColorButtonByStatus(param1:int) : String
      {
         switch(param1)
         {
            case 3:
               return "green";
            case 0:
            default:
               return "grey";
         }
      }
      
      public function updateRankLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._componentsList[param2.ctr_rankInfo.name])
         {
            this.uiApi.addComponentHook(param2.ctr_rankInfo,"onRollOut");
            this.uiApi.addComponentHook(param2.ctr_rankInfo,"onRollOver");
         }
         this._componentsList[param2.ctr_rankInfo.name] = param1;
         if(param1)
         {
            param2.lbl_title.text = param1.title;
            if(param1.solo == 0 || param1.solo == "0")
            {
               param2.lbl_solo.text = "-";
            }
            else
            {
               param2.lbl_solo.text = param1.solo;
            }
            if(param1.group == 0 || param1.group == "0")
            {
               param2.lbl_group.text = "-";
            }
            else
            {
               param2.lbl_group.text = param1.group;
            }
         }
         else
         {
            param2.lbl_title.text = "";
            param2.lbl_solo.text = "";
            param2.lbl_group.text = "";
         }
      }
      
      private function updateFighters() : void
      {
         this._myTeam = new Array();
         var _loc1_:Object = this.partyApi.getPartyMembers(1);
         var _loc2_:Object = this.partyApi.getArenaAlliesIds();
         if(_loc1_ && _loc1_.length > 0)
         {
            this.btn_quitArena.softDisabled = false;
            if(this.playerApi.id() != this.partyApi.getArenaLeader().id)
            {
               this.btn_validate.softDisabled = true;
            }
            else
            {
               this.btn_validate.softDisabled = false;
            }
         }
         else
         {
            this.btn_quitArena.softDisabled = true;
            this.btn_validate.softDisabled = false;
         }
         var _loc3_:String = "";
         var _loc4_:Number = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < TEAM_MEMBERS_MAX)
         {
            _loc3_ = "";
            _loc4_ = 0;
            _loc5_ = false;
            if(_loc1_ && _loc1_.length > 0 && _loc6_ < _loc1_.length && _loc1_[_loc6_] && _loc1_[_loc6_].isMember)
            {
               _loc3_ = _loc1_[_loc6_].name;
               _loc4_ = _loc1_[_loc6_].id;
               _loc5_ = _loc1_[_loc6_].isLeader;
            }
            else if((!_loc1_ || _loc1_.length == 0) && _loc6_ == 0)
            {
               _loc3_ = this.playerApi.getPlayedCharacterInfo().name;
               _loc4_ = this.playerApi.id();
            }
            else if(_loc2_ && _loc2_[_loc6_] && _loc2_[_loc6_] != this.playerApi.id())
            {
               _loc3_ = "";
               _loc4_ = _loc2_[_loc6_];
            }
            this._myTeam.push({
               "id":_loc6_,
               "realId":_loc4_,
               "name":_loc3_,
               "status":0,
               "chief":_loc5_
            });
            _loc6_++;
         }
         this.gd_myTeam.dataProvider = this._myTeam;
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_validate:
               if(!this._isRegistered)
               {
                  this.sysApi.sendAction(new ArenaRegister(PvpArenaTypeEnum.ARENA_TYPE_3VS3));
               }
               else
               {
                  this.sysApi.sendAction(new ArenaUnregister());
               }
               break;
            case this.btn_quitArena:
               this.sysApi.sendAction(new PartyLeaveRequest(this.partyApi.getArenaPartyId()));
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_validate:
               if(this.btn_validate.softDisabled)
               {
                  if(this._isRegistered)
                  {
                     _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaUnregistrationRestricted",this.partyApi.getArenaLeader().name));
                  }
                  else
                  {
                     _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaRegistrationRestricted",this.partyApi.getArenaLeader().name));
                  }
               }
               else if(this.partyApi.getArenaPartyId() == 0)
               {
                  if(this._isRegistered)
                  {
                     _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaSoloUnregister"));
                  }
                  else
                  {
                     _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaSoloRegister"));
                  }
               }
               else if(this._isRegistered)
               {
                  _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaTeamUnregister"));
               }
               else
               {
                  _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaTeamRegister"));
               }
               break;
            case this.btn_quitArena:
               if(!this.btn_quitArena.softDisabled)
               {
                  _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaInfoQuit"));
               }
         }
         if(param1.name.indexOf("tx_fighterState") != -1)
         {
            if(this._statusList[param1.name] && this._statusList[param1.name].status == 3)
            {
               _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaFightAccepted"));
            }
            else if(this._currentStatus == PvpArenaStepEnum.ARENA_STEP_WAITING_FIGHT)
            {
               _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.arenaFightNotYetAccepted"));
            }
         }
         else if(param1.name.indexOf("ctr_rankInfo") != -1 && this._componentsList[param1.name])
         {
            _loc2_ = this.uiApi.textTooltipInfo(this._componentsList[param1.name].rolloverText);
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(_loc2_,param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               if(!this._isRegistered)
               {
                  this.sysApi.sendAction(new ArenaRegister(PvpArenaTypeEnum.ARENA_TYPE_3VS3));
               }
               return true;
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onArenaRegistrationStatusUpdate(param1:Boolean, param2:int) : void
      {
         var _loc3_:String = null;
         this._isRegistered = param1;
         this._currentStatus = param2;
         this.lbl_step.text = this.uiApi.getText("ui.common.step",(this._currentStatus + 1) % 4 + 1,4);
         switch(this._currentStatus)
         {
            case PvpArenaStepEnum.ARENA_STEP_UNREGISTER:
               this._nbFightersReady = 0;
               _loc3_ = this.uiApi.getText("ui.party.arenaInfoInvite");
               if(!this.btn_validate.softDisabled)
               {
                  this.btn_validate.disabled = false;
               }
               if(!this.btn_quitArena.softDisabled)
               {
                  this.btn_quitArena.disabled = false;
               }
               break;
            case PvpArenaStepEnum.ARENA_STEP_REGISTRED:
               _loc3_ = this.uiApi.getText("ui.party.arenaInfoSearch");
               if(!this.btn_validate.softDisabled)
               {
                  this.btn_validate.disabled = false;
               }
               if(!this.btn_quitArena.softDisabled)
               {
                  this.btn_quitArena.disabled = false;
               }
               break;
            case PvpArenaStepEnum.ARENA_STEP_WAITING_FIGHT:
               _loc3_ = this.uiApi.getText("ui.party.arenaInfoWaiting",0);
               if(!this.btn_validate.softDisabled)
               {
                  this.btn_validate.disabled = true;
               }
               if(!this.btn_quitArena.softDisabled)
               {
                  this.btn_quitArena.disabled = true;
               }
               break;
            case PvpArenaStepEnum.ARENA_STEP_STARTING_FIGHT:
               this._nbFightersReady = 0;
               _loc3_ = this.uiApi.getText("ui.party.arenaInfoFighting");
               if(!this.btn_validate.softDisabled)
               {
                  this.btn_validate.disabled = true;
               }
               if(!this.btn_quitArena.softDisabled)
               {
                  this.btn_quitArena.disabled = true;
               }
               break;
            default:
               this.sysApi.log(1,"Probleme de status d\'arene");
         }
         if(!this._isRegistered)
         {
            this.btn_lbl_btn_validate.text = this.uiApi.getText("ui.teamSearch.registration");
         }
         else
         {
            this.btn_lbl_btn_validate.text = this.uiApi.getText("ui.teamSearch.unregistration");
         }
         this.lbl_whatToDo.text = _loc3_;
      }
      
      public function onArenaFighterStatusUpdate(param1:Number, param2:Boolean) : void
      {
         var _loc3_:Object = null;
         if(param2)
         {
            for each(_loc3_ in this._myTeam)
            {
               if(_loc3_.realId == param1)
               {
                  _loc3_.status = 3;
               }
            }
            this._nbFightersReady++;
            if(this._currentStatus == PvpArenaStepEnum.ARENA_STEP_WAITING_FIGHT)
            {
               this.lbl_whatToDo.text = this.uiApi.getText("ui.party.arenaInfoWaiting",this._nbFightersReady);
            }
         }
         else
         {
            for each(_loc3_ in this._myTeam)
            {
               _loc3_.status = 0;
            }
            this._nbFightersReady = 0;
         }
         this.gd_myTeam.dataProvider = this._myTeam;
      }
      
      public function onArenaFightProposition(param1:Object) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         this._myTeam = new Array();
         var _loc2_:Object = this.partyApi.getPartyMembers(1);
         var _loc3_:Boolean = false;
         this._nbFightersReady = 0;
         if(this._currentStatus == PvpArenaStepEnum.ARENA_STEP_WAITING_FIGHT)
         {
            this.lbl_whatToDo.text = this.uiApi.getText("ui.party.arenaInfoWaiting",this._nbFightersReady);
         }
         for each(_loc4_ in param1)
         {
            _loc3_ = false;
            if(!_loc2_ || _loc2_.length == 0)
            {
               if(_loc4_ == this.playerApi.id())
               {
                  _loc5_ = this.playerApi.getPlayedCharacterInfo().name;
                  this._myTeam.push({
                     "id":0,
                     "realId":_loc4_,
                     "name":_loc5_,
                     "status":0,
                     "chief":false
                  });
               }
               else
               {
                  this._myTeam.push({
                     "id":0,
                     "realId":_loc4_,
                     "name":"",
                     "status":0,
                     "chief":false
                  });
               }
            }
            else
            {
               for each(_loc6_ in _loc2_)
               {
                  if(_loc4_ == _loc6_.id)
                  {
                     this._myTeam.push({
                        "id":0,
                        "realId":_loc4_,
                        "name":_loc6_.name,
                        "status":0,
                        "chief":_loc6_.isLeader
                     });
                     _loc3_ = true;
                  }
               }
               if(!_loc3_)
               {
                  this._myTeam.push({
                     "id":0,
                     "realId":_loc4_,
                     "name":"",
                     "status":0,
                     "chief":false
                  });
               }
            }
         }
         this.gd_myTeam.dataProvider = this._myTeam;
      }
      
      public function onPartyJoin(param1:int, param2:Object, param3:Boolean, param4:Boolean, param5:String = "") : void
      {
         if(param1 == this.partyApi.getArenaPartyId())
         {
            this.updateFighters();
         }
      }
      
      public function onPartyUpdate(param1:int, param2:Object) : void
      {
         if(param1 == this.partyApi.getArenaPartyId())
         {
            this.updateFighters();
         }
      }
      
      public function onPartyLeave(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            this.updateFighters();
         }
      }
      
      public function onPartyMemberUpdate(param1:int, param2:Number) : void
      {
         if(param1 == this.partyApi.getArenaPartyId())
         {
            this.updateFighters();
         }
      }
      
      public function onPartyLeaderUpdate(param1:int, param2:Number) : void
      {
         if(param1 == this.partyApi.getArenaPartyId())
         {
            if(this.partyApi.getArenaLeader() && this.playerApi.id() != this.partyApi.getArenaLeader().id)
            {
               this.btn_validate.softDisabled = true;
            }
            else
            {
               this.btn_validate.softDisabled = false;
            }
         }
      }
      
      public function onPartyMemberRemove(param1:int, param2:Number) : void
      {
         if(param1 == this.partyApi.getArenaPartyId())
         {
            this.updateFighters();
         }
      }
      
      public function onArenaUpdateRank(param1:ArenaRankInfosWrapper, param2:ArenaRankInfosWrapper = null) : void
      {
         var _loc3_:Array = new Array();
         _loc3_.push({
            "title":this.uiApi.getText("ui.party.arenaRank"),
            "solo":param1.rank,
            "group":"",
            "rolloverText":this.uiApi.getText("ui.party.arenaRankInfos")
         });
         _loc3_.push({
            "title":this.uiApi.getText("ui.party.arenaRankMax"),
            "solo":param1.maxRank,
            "group":"",
            "rolloverText":this.uiApi.getText("ui.party.arenaRankMaxInfos")
         });
         _loc3_.push({
            "title":this.uiApi.getText("ui.party.arenaFightsOfTheDay"),
            "solo":param1.todayVictoryCount + "/" + param1.todayFightCount,
            "group":"",
            "rolloverText":this.uiApi.getText("ui.party.arenaFightsOfTheDayInfos")
         });
         if(param2)
         {
            this.ctr_groupTitle.visible = true;
            _loc3_[0].group = param2.rank;
            _loc3_[1].group = param2.maxRank;
            _loc3_[2].group = param2.todayVictoryCount + "/" + param2.todayFightCount;
         }
         else
         {
            this.ctr_groupTitle.visible = false;
         }
         this.gd_rankInfos.dataProvider = _loc3_;
      }
   }
}
