package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.LeaveDialogRequest;
   import d2enums.AggressableStatusEnum;
   import d2enums.PrismStateEnum;
   import d2hooks.AllianceMembershipUpdated;
   import d2hooks.CharacterLevelUp;
   import d2hooks.CurrentMap;
   import d2hooks.FightResultClosed;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightJoin;
   import d2hooks.GameFightStarting;
   import d2hooks.KohState;
   import d2hooks.MapComplementaryInformationsData;
   import d2hooks.MapRunningFightList;
   import d2hooks.NpcDialogCreation;
   import d2hooks.NpcDialogCreationFailure;
   import d2hooks.NpcDialogQuestion;
   import d2hooks.PonyDialogCreation;
   import d2hooks.PortalDialogCreation;
   import d2hooks.PrismDialogCreation;
   import d2hooks.PvpAvaStateChange;
   import d2hooks.SpectatorWantLeave;
   import d2hooks.TreasureHuntLegendaryUiUpdate;
   import d2hooks.TreasureHuntUpdate;
   import flash.display.Sprite;
   import ui.KingOfTheHill;
   import ui.LegendaryHunts;
   import ui.LevelUpUi;
   import ui.NpcDialog;
   import ui.PrismDefense;
   import ui.SpectatorUi;
   import ui.TreasureHunt;
   
   public class Roleplay extends Sprite
   {
      
      public static var questions:Array;
      
      public static const LEVEL_UP_UI:String = "levelUp";
      
      private static var _compt:uint = 0;
       
      
      protected var npcDialog:NpcDialog;
      
      protected var prismDefense:PrismDefense;
      
      protected var spectatorUi:SpectatorUi;
      
      protected var levelUpUi:LevelUpUi;
      
      protected var kingOfTheHill:KingOfTheHill;
      
      protected var treasureHunt:TreasureHunt;
      
      protected var legendaryHunts:LegendaryHunts;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var mapApi:MapApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var dataApi:DataApi;
      
      private var _newLevel:uint;
      
      private var _spellPointEarned:uint;
      
      private var _caracPointEarned:uint;
      
      private var _healPointEarned:uint;
      
      private var _newSpell:Object;
      
      private var _spellObtained:Boolean;
      
      private var _levelSpellObtention:int;
      
      private var _avaEnable:Boolean;
      
      private var _probationTime:uint;
      
      private var _openUI:Boolean = false;
      
      private var _fightContext:Boolean = false;
      
      public function Roleplay()
      {
         super();
      }
      
      public function main() : void
      {
         this.sysApi.addHook(NpcDialogCreationFailure,this.onNpcDialogCreationFailure);
         this.sysApi.addHook(NpcDialogCreation,this.onNpcDialogCreation);
         this.sysApi.addHook(PonyDialogCreation,this.onPonyDialogCreation);
         this.sysApi.addHook(PrismDialogCreation,this.onPrismDialogCreation);
         this.sysApi.addHook(PortalDialogCreation,this.onPortalDialogCreation);
         this.sysApi.addHook(NpcDialogQuestion,this.onNpcDialogQuestion);
         this.sysApi.addHook(MapRunningFightList,this.onMapRunningFightList);
         this.sysApi.addHook(GameFightStarting,this.onGameFightStarting);
         this.sysApi.addHook(CurrentMap,this.onMapChange);
         this.sysApi.addHook(MapComplementaryInformationsData,this.onMapLoaded);
         this.sysApi.addHook(CharacterLevelUp,this.onLevelUp);
         this.sysApi.addHook(FightResultClosed,this.onFightResultClosed);
         this.sysApi.addHook(GameFightJoin,this.onGameFightJoin);
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(SpectatorWantLeave,this.onSpectatorWantLeave);
         this.sysApi.addHook(KohState,this.onKohStateChange);
         this.sysApi.addHook(PvpAvaStateChange,this.onPvpAvaStateChange);
         this.sysApi.addHook(AllianceMembershipUpdated,this.onAllianceMembershipUpdated);
         this.sysApi.addHook(TreasureHuntUpdate,this.onTreasureHunt);
         this.sysApi.addHook(TreasureHuntLegendaryUiUpdate,this.onTreasureHuntLegendaryUiUpdate);
      }
      
      private function onNpcDialogCreationFailure() : void
      {
         this.sysApi.log(16,"Impossible de parler à ce pnj :o");
      }
      
      private function onNpcDialogCreation(param1:int, param2:int, param3:Object) : void
      {
         questions = new Array();
         var _loc4_:uint = this.playerApi.currentMap().mapId;
         if(param1 == _loc4_)
         {
            if(this.uiApi.getUi("npcDialog"))
            {
               this.uiApi.unloadUi("npcDialog");
            }
            this.uiApi.loadUi("npcDialog","npcDialog",[param2,param3]);
         }
         else
         {
            this.sysApi.log(16,"Required npc (" + param2 + ") cannot be found on map " + _loc4_ + ".");
            this.sysApi.sendAction(new LeaveDialogRequest());
         }
      }
      
      private function onPonyDialogCreation(param1:int, param2:int, param3:int, param4:Object) : void
      {
         questions = new Array();
         var _loc5_:uint = this.playerApi.currentMap().mapId;
         if(param1 == _loc5_)
         {
            this.uiApi.loadUi("npcDialog","npcDialog",[1,param4,param2,param3]);
         }
         else
         {
            this.sysApi.log(16,"Required tax collector cannot be found on map " + _loc5_ + ".");
            this.sysApi.sendAction(new LeaveDialogRequest());
         }
      }
      
      private function onPrismDialogCreation(param1:int, param2:String, param3:Object) : void
      {
         questions = new Array();
         var _loc4_:uint = this.playerApi.currentMap().mapId;
         if(param1 == _loc4_)
         {
            this.uiApi.loadUi("npcDialog","npcDialog",[2141,param3,param2]);
         }
         else
         {
            this.sysApi.log(16,"Required prism cannot be found on map " + _loc4_ + ".");
            this.sysApi.sendAction(new LeaveDialogRequest());
         }
      }
      
      private function onPortalDialogCreation(param1:int, param2:String, param3:Object) : void
      {
         var _loc5_:int = 0;
         questions = new Array();
         var _loc4_:uint = this.playerApi.currentMap().mapId;
         if(param3.getBone() == 2720)
         {
            _loc5_ = 2374;
         }
         else if(param3.getBone() == 2893)
         {
            _loc5_ = 2594;
         }
         else if(param3.getBone() == 3031)
         {
            _loc5_ = 2667;
         }
         else if(param3.getBone() == 3489)
         {
            _loc5_ = 3136;
         }
         if(param1 == _loc4_)
         {
            this.uiApi.loadUi("npcDialog","npcDialog",[_loc5_,param3,param2]);
         }
         else
         {
            this.sysApi.log(16,"Required portal cannot be found on map " + _loc4_ + ".");
            this.sysApi.sendAction(new LeaveDialogRequest());
         }
      }
      
      public function onNpcDialogQuestion(param1:uint = 0, param2:Object = null, param3:Object = null) : void
      {
      }
      
      private function onKohStateChange(param1:PrismSubAreaWrapper) : void
      {
         if(!param1)
         {
            this.uiApi.unloadUi("kingOfTheHill");
            return;
         }
         if(!this._avaEnable || !param1.alliance || KingOfTheHill.instance && KingOfTheHill.instance.currentSubArea != param1.subAreaId)
         {
            this.uiApi.unloadUi("kingOfTheHill");
         }
         if(this._avaEnable && param1.state == PrismStateEnum.PRISM_STATE_VULNERABLE && !this.uiApi.getUi("kingOfTheHill"))
         {
            this.uiApi.loadUi("kingOfTheHill","kingOfTheHill",{
               "prism":param1,
               "probationTime":this._probationTime
            });
         }
      }
      
      private function onPvpAvaStateChange(param1:uint, param2:uint) : void
      {
         this._avaEnable = param1 == AggressableStatusEnum.AvA_DISQUALIFIED || param1 == AggressableStatusEnum.AvA_ENABLED_AGGRESSABLE || param1 == AggressableStatusEnum.AvA_ENABLED_NON_AGGRESSABLE || param1 == AggressableStatusEnum.AvA_PREQUALIFIED_AGGRESSABLE;
         this._probationTime = param2;
         if(!this._avaEnable)
         {
            this.uiApi.unloadUi("kingOfTheHill");
         }
      }
      
      private function onAllianceMembershipUpdated(param1:Boolean) : void
      {
         if(!param1 && this._avaEnable)
         {
            this.uiApi.unloadUi("kingOfTheHill");
            this._avaEnable = false;
         }
      }
      
      private function onTreasureHunt(param1:uint) : void
      {
         if(!this.uiApi.getUi("treasureHunt"))
         {
            this.uiApi.loadUi("treasureHunt","treasureHunt",param1);
         }
      }
      
      private function onTreasureHuntLegendaryUiUpdate(param1:Object) : void
      {
         if(!this.uiApi.getUi("legendaryHunts"))
         {
            this.uiApi.loadUi("legendaryHunts","legendaryHunts",param1);
         }
      }
      
      private function onMapRunningFightList(param1:Object) : void
      {
         if(!this.uiApi.getUi(UIEnum.SPECTATOR_UI))
         {
            this.uiApi.loadUi(UIEnum.SPECTATOR_UI,UIEnum.SPECTATOR_UI,param1);
         }
      }
      
      private function onGameFightStarting(param1:uint) : void
      {
         if(this.uiApi.getUi(UIEnum.SPECTATOR_UI))
         {
            this.uiApi.unloadUi(UIEnum.SPECTATOR_UI);
         }
      }
      
      private function onMapChange(param1:Object) : void
      {
         if(this.uiApi.getUi(UIEnum.SPECTATOR_UI))
         {
            this.uiApi.unloadUi(UIEnum.SPECTATOR_UI);
         }
      }
      
      private function onMapLoaded(param1:WorldPointWrapper, param2:uint, param3:Boolean) : void
      {
         if(KingOfTheHill.instance && this.dataApi.getSubAreaFromMap(this.playerApi.currentMap().mapId).id != KingOfTheHill.instance.currentSubArea)
         {
            this.uiApi.unloadUi("kingOfTheHill");
         }
      }
      
      private function onLevelUp(param1:uint, param2:uint, param3:uint, param4:uint, param5:Object, param6:Boolean, param7:int) : void
      {
         this._openUI = true;
         this._newLevel = param1;
         this._spellPointEarned = param2;
         this._caracPointEarned = param3;
         this._healPointEarned = param4;
         this._newSpell = param5;
         this._spellObtained = param6;
         this._levelSpellObtention = param7;
         if(!this._fightContext)
         {
            this.uiApi.loadUi(LEVEL_UP_UI,LEVEL_UP_UI,{
               "newLevel":param1,
               "spellPointEarned":param2,
               "caracPointEarned":param3,
               "healPointEarned":param4,
               "newSpell":param5,
               "spellObtained":param6,
               "levelSpellObtention":param7
            },1,null,true);
            this._openUI = false;
         }
      }
      
      private function onFightResultClosed() : void
      {
         if(this._openUI)
         {
            this.uiApi.loadUi(LEVEL_UP_UI,LEVEL_UP_UI + ++_compt,{
               "newLevel":this._newLevel,
               "spellPointEarned":this._spellPointEarned,
               "caracPointEarned":this._caracPointEarned,
               "healPointEarned":this._healPointEarned,
               "newSpell":this._newSpell,
               "spellObtained":this._spellObtained,
               "levelSpellObtention":this._levelSpellObtention
            });
            this._openUI = false;
         }
      }
      
      public function onGameFightJoin(param1:Boolean, param2:Boolean, param3:Boolean, param4:uint, param5:int, param6:Boolean) : void
      {
         this._fightContext = true;
         if(this.uiApi.getUi(UIEnum.TREASURE_HUNT))
         {
            this.uiApi.getUi(UIEnum.TREASURE_HUNT).visible = false;
         }
      }
      
      public function onGameFightEnd(param1:Object) : void
      {
         this._fightContext = false;
         if(this.uiApi.getUi(UIEnum.TREASURE_HUNT))
         {
            this.uiApi.getUi(UIEnum.TREASURE_HUNT).visible = true;
         }
      }
      
      public function onSpectatorWantLeave() : void
      {
         this._fightContext = false;
         if(this.uiApi.getUi(UIEnum.TREASURE_HUNT))
         {
            this.uiApi.getUi(UIEnum.TREASURE_HUNT).visible = true;
         }
      }
   }
}
