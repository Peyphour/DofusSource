package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.misc.OptionalFeature;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.OpenIdols;
   import d2enums.LocationEnum;
   import d2hooks.GameFightJoin;
   import d2hooks.GameFightStart;
   import d2hooks.OpenGrimoireCalendarTab;
   import d2hooks.OpenGrimoireJobTab;
   import d2hooks.OpenGrimoireQuestTab;
   import enum.EnumTab;
   
   public class Book
   {
      
      private static var _shortcutColor:String;
      
      private static var _disabledColor:String;
      
      private static var _self:Book;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var soundApi:SoundApi;
      
      public var bindsApi:BindsApi;
      
      public var configApi:ConfigApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var dataApi:DataApi;
      
      public var uiCtr:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_ongletQuetes:ButtonContainer;
      
      public var btn_ongletMetiers:ButtonContainer;
      
      public var btn_ongletCalendar:ButtonContainer;
      
      public var btn_ongletAchievement:ButtonContainer;
      
      public var btn_ongletTitle:ButtonContainer;
      
      public var btn_ongletBestiary:ButtonContainer;
      
      public var btn_ongletKrosmaster:ButtonContainer;
      
      public var btn_ongletCompanion:ButtonContainer;
      
      public var btn_ongletIdols:ButtonContainer;
      
      private var _currentTabUi:String;
      
      private var _spellList:Object;
      
      public function Book()
      {
         super();
      }
      
      public static function getInstance() : Book
      {
         return _self;
      }
      
      public function main(param1:Object = null) : void
      {
         this.sysApi.addHook(GameFightJoin,this.onGameFightJoin);
         this.sysApi.addHook(GameFightStart,this.onGameFightStart);
         this.uiApi.addComponentHook(this.btn_ongletQuetes,"onRelease");
         this.uiApi.addComponentHook(this.btn_ongletQuetes,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ongletQuetes,"onRollOut");
         this.uiApi.addComponentHook(this.btn_ongletMetiers,"onRelease");
         this.uiApi.addComponentHook(this.btn_ongletMetiers,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ongletMetiers,"onRollOut");
         this.uiApi.addComponentHook(this.btn_ongletCalendar,"onRelease");
         this.uiApi.addComponentHook(this.btn_ongletCalendar,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ongletCalendar,"onRollOut");
         this.uiApi.addComponentHook(this.btn_ongletAchievement,"onRelease");
         this.uiApi.addComponentHook(this.btn_ongletAchievement,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ongletAchievement,"onRollOut");
         this.uiApi.addComponentHook(this.btn_ongletTitle,"onRelease");
         this.uiApi.addComponentHook(this.btn_ongletTitle,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ongletTitle,"onRollOut");
         this.uiApi.addComponentHook(this.btn_ongletBestiary,"onRelease");
         this.uiApi.addComponentHook(this.btn_ongletBestiary,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ongletBestiary,"onRollOut");
         this.uiApi.addComponentHook(this.btn_ongletKrosmaster,"onRelease");
         this.uiApi.addComponentHook(this.btn_ongletKrosmaster,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ongletKrosmaster,"onRollOut");
         this.uiApi.addComponentHook(this.btn_ongletCompanion,"onRelease");
         this.uiApi.addComponentHook(this.btn_ongletCompanion,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ongletCompanion,"onRollOut");
         this.uiApi.addComponentHook(this.btn_ongletIdols,"onRelease");
         this.uiApi.addComponentHook(this.btn_ongletIdols,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ongletIdols,"onRollOut");
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.btn_close.soundId = SoundEnum.CANCEL_BUTTON;
         this._currentTabUi = null;
         this.soundApi.playSound(SoundTypeEnum.GRIMOIRE_OPEN);
         this.btn_ongletQuetes.soundId = SoundEnum.TAB;
         this.btn_ongletMetiers.soundId = SoundEnum.TAB;
         this.btn_ongletCalendar.soundId = SoundEnum.TAB;
         this.btn_ongletAchievement.soundId = SoundEnum.TAB;
         this.btn_ongletTitle.soundId = SoundEnum.TAB;
         this.btn_ongletBestiary.soundId = SoundEnum.TAB;
         this.btn_ongletKrosmaster.soundId = SoundEnum.TAB;
         this.btn_ongletCompanion.soundId = SoundEnum.TAB;
         this.btn_ongletIdols.soundId = SoundEnum.TAB;
         _self = this;
         this.uiApi.addShortcutHook("closeUi",this.onShortCut);
         this.uiApi.addShortcutHook("openBookQuest",this.onShortCut);
         this.uiApi.addShortcutHook("openBookJob",this.onShortCut);
         if(param1 != null)
         {
            this.openTab(param1[0],param1[1]);
         }
         else
         {
            this.openTab();
         }
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "openBookQuest":
               if(this._currentTabUi == EnumTab.QUEST_TAB)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this.openTab(EnumTab.QUEST_TAB);
               }
               return true;
            case "openBookJob":
               if(this._currentTabUi == EnumTab.JOB_TAB)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this.openTab(EnumTab.JOB_TAB);
               }
               return true;
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function unload() : void
      {
         this.soundApi.playSound(SoundTypeEnum.GRIMOIRE_CLOSE);
         this.sysApi.enableWorldInteraction();
         Grimoire.getInstance().tabOpened = "";
         this.closeTab();
      }
      
      public function get spellList() : Object
      {
         return this._spellList;
      }
      
      public function openTab(param1:String = null, param2:Object = null) : void
      {
         var _loc6_:* = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc3_:OptionalFeature = this.dataApi.getOptionalFeatureByKeyword("game.krosmaster");
         var _loc4_:Array = new Array();
         _loc4_[EnumTab.CALENDAR_TAB] = Grimoire.getInstance().isCalendarDisabled();
         _loc4_[EnumTab.KROSMASTER_TAB] = !this.configApi.isOptionalFeatureActive(_loc3_.id);
         _loc4_[EnumTab.TITLE_TAB] = this.playerApi.isInFight();
         var _loc5_:Object = this.uiApi.getUi(UIEnum.TUTORIAL_UI);
         if(_loc5_ && !_loc5_.uiClass.tutorialDisabled)
         {
            _loc4_[EnumTab.JOB_TAB] = true;
            _loc4_[EnumTab.CALENDAR_TAB] = true;
            _loc4_[EnumTab.KROSMASTER_TAB] = true;
            _loc4_[EnumTab.ACHIEVEMENT_TAB] = true;
            _loc4_[EnumTab.TITLE_TAB] = true;
            _loc4_[EnumTab.BESTIARY_TAB] = true;
            _loc4_[EnumTab.COMPANION_TAB] = true;
            _loc4_[EnumTab.IDOLS_TAB] = true;
         }
         this.getButtonByTabName(EnumTab.KROSMASTER_TAB).visible = !_loc4_[EnumTab.KROSMASTER_TAB];
         for(_loc6_ in _loc4_)
         {
            this.getButtonByTabName(_loc6_).softDisabled = _loc4_[_loc6_];
         }
         if(param1 == null || _loc4_[param1])
         {
            _loc8_ = this.sysApi.getData("lastGrimoireTab");
            if(_loc8_ && !_loc4_[_loc8_])
            {
               _loc7_ = _loc8_;
            }
            else
            {
               _loc7_ = EnumTab.SPELL_TAB;
            }
         }
         else
         {
            _loc7_ = param1;
         }
         if(_loc7_ == this._currentTabUi)
         {
            return;
         }
         if(this._currentTabUi)
         {
            this.uiApi.unloadUi(this._currentTabUi);
         }
         this._currentTabUi = _loc7_;
         this.sysApi.setData("lastGrimoireTab",this._currentTabUi);
         Grimoire.getInstance().tabOpened = this._currentTabUi;
         this.uiApi.loadUiInside(_loc7_,this.uiCtr,_loc7_,param2);
         this.uiApi.setRadioGroupSelectedItem("tabGroup",this.getButtonByTabName(this._currentTabUi),this.uiApi.me());
         this.getButtonByTabName(this._currentTabUi).selected = true;
      }
      
      private function closeTab(param1:String = null) : void
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            if(this._currentTabUi)
            {
               _loc2_ = this._currentTabUi;
            }
            else
            {
               _loc2_ = param1;
            }
         }
         if(_loc2_)
         {
            this.uiApi.unloadUi(_loc2_);
         }
      }
      
      private function getButtonByTabName(param1:String) : Object
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case EnumTab.QUEST_TAB:
               _loc2_ = this.btn_ongletQuetes;
               break;
            case EnumTab.JOB_TAB:
               _loc2_ = this.btn_ongletMetiers;
               break;
            case EnumTab.CALENDAR_TAB:
               _loc2_ = this.btn_ongletCalendar;
               break;
            case EnumTab.ACHIEVEMENT_TAB:
               _loc2_ = this.btn_ongletAchievement;
               break;
            case EnumTab.TITLE_TAB:
               _loc2_ = this.btn_ongletTitle;
               break;
            case EnumTab.BESTIARY_TAB:
               _loc2_ = this.btn_ongletBestiary;
               break;
            case EnumTab.COMPANION_TAB:
               _loc2_ = this.btn_ongletCompanion;
               break;
            case EnumTab.IDOLS_TAB:
               _loc2_ = this.btn_ongletIdols;
               break;
            case EnumTab.KROSMASTER_TAB:
               _loc2_ = this.btn_ongletKrosmaster;
         }
         return _loc2_;
      }
      
      private function onSpellsList(param1:Object) : void
      {
         this._spellList = param1;
      }
      
      public function onGameFightJoin(param1:Boolean, param2:Boolean, param3:Boolean, param4:int, param5:int, param6:Boolean) : void
      {
         if(this._currentTabUi == EnumTab.TITLE_TAB)
         {
            this.openTab(EnumTab.SPELL_TAB);
         }
      }
      
      public function onGameFightStart() : void
      {
         if(this._currentTabUi == EnumTab.TITLE_TAB)
         {
            this.openTab(EnumTab.SPELL_TAB);
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.sysApi.enableWorldInteraction();
               this.uiApi.unloadUi(UIEnum.GRIMOIRE);
               return;
            case this.btn_ongletQuetes:
               this.openTab(EnumTab.QUEST_TAB);
               this.sysApi.dispatchHook(OpenGrimoireQuestTab);
               break;
            case this.btn_ongletMetiers:
               this.openTab(EnumTab.JOB_TAB);
               this.sysApi.dispatchHook(OpenGrimoireJobTab);
               break;
            case this.btn_ongletCalendar:
               this.openTab(EnumTab.CALENDAR_TAB);
               this.sysApi.dispatchHook(OpenGrimoireCalendarTab);
               break;
            case this.btn_ongletAchievement:
               this.openTab(EnumTab.ACHIEVEMENT_TAB);
               break;
            case this.btn_ongletTitle:
               this.openTab(EnumTab.TITLE_TAB);
               break;
            case this.btn_ongletBestiary:
               this.openTab(EnumTab.BESTIARY_TAB);
               break;
            case this.btn_ongletCompanion:
               this.openTab(EnumTab.COMPANION_TAB);
               break;
            case this.btn_ongletIdols:
               this.sysApi.sendAction(new OpenIdols());
               break;
            case this.btn_ongletKrosmaster:
               this.openTab(EnumTab.KROSMASTER_TAB);
         }
         if(Grimoire.getInstance().tabOpened != "")
         {
            this.sysApi.disableWorldInteraction();
         }
         else
         {
            this.sysApi.enableWorldInteraction();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc8_:Object = null;
         var _loc3_:uint = LocationEnum.POINT_LEFT;
         var _loc4_:uint = LocationEnum.POINT_RIGHT;
         var _loc5_:String = null;
         var _loc6_:String = "";
         var _loc7_:* = "";
         switch(param1)
         {
            case this.btn_ongletQuetes:
               _loc2_ = this.uiApi.getText("ui.common.quests");
               _loc5_ = this.bindsApi.getShortcutBindStr("openBookQuest");
               break;
            case this.btn_ongletMetiers:
               _loc2_ = this.uiApi.getText("ui.common.myJobs");
               _loc5_ = this.bindsApi.getShortcutBindStr("openBookJob");
               break;
            case this.btn_ongletCalendar:
               _loc2_ = this.uiApi.getText("ui.almanax.almanax");
               _loc5_ = this.bindsApi.getShortcutBindStr("openAlmanax");
               break;
            case this.btn_ongletAchievement:
               _loc2_ = this.uiApi.getText("ui.achievement.achievement");
               _loc5_ = this.bindsApi.getShortcutBindStr("openAchievement");
               break;
            case this.btn_ongletTitle:
               _loc2_ = this.uiApi.getText("ui.common.titles");
               _loc5_ = this.bindsApi.getShortcutBindStr("openTitle");
               _loc6_ = this.uiApi.getText("ui.banner.lockBtn.inRP");
               break;
            case this.btn_ongletBestiary:
               _loc2_ = this.uiApi.getText("ui.common.bestiary");
               _loc5_ = this.bindsApi.getShortcutBindStr("openBestiary");
               break;
            case this.btn_ongletCompanion:
               _loc2_ = this.uiApi.getText("ui.companion.companions");
               break;
            case this.btn_ongletIdols:
               _loc2_ = this.uiApi.getText("ui.idol.idols");
               break;
            case this.btn_ongletKrosmaster:
               _loc2_ = this.uiApi.getText("ui.krosmaster.krosmaster");
         }
         if(_loc5_)
         {
            if(!_shortcutColor)
            {
               _shortcutColor = this.sysApi.getConfigEntry("colors.shortcut");
               _shortcutColor = _shortcutColor.replace("0x","#");
            }
            _loc7_ = _loc2_ + " <font color=\'" + _shortcutColor + "\'>(" + _loc5_ + ")</font>";
         }
         else
         {
            _loc7_ = _loc2_;
         }
         if(param1.softDisabled)
         {
            if(!_disabledColor)
            {
               _disabledColor = (this.sysApi.getConfigEntry("colors.tooltip.text.disabled") as String).replace("0x","#");
            }
            _loc7_ = _loc7_.replace(_loc2_,"<font color=\'" + _disabledColor + "\'>" + _loc2_ + "</font>");
            if(_loc6_)
            {
               _loc7_ = _loc7_ + ("\n" + _loc6_);
            }
         }
         this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc7_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
