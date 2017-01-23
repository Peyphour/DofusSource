package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import enum.EnumTab;
   
   public class QuestBase
   {
      
      private static var _shortcutColor:String;
       
      
      public var bindsApi:BindsApi;
      
      public var soundApi:SoundApi;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      private var _currentTabUi:String = "";
      
      public var uiCtr:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_tabSuccess:ButtonContainer;
      
      public var btn_tabQuests:ButtonContainer;
      
      public var btn_tabAlmanax:ButtonContainer;
      
      public var lbl_btn_tabSuccess:Label;
      
      public var lbl_btn_tabQuests:Label;
      
      public var lbl_btn_tabAlmanax:Label;
      
      public function QuestBase()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:String = null;
         this.btn_close.soundId = SoundEnum.CANCEL_BUTTON;
         this.soundApi.playSound(SoundTypeEnum.GRIMOIRE_OPEN);
         this.btn_tabSuccess.soundId = SoundEnum.TAB;
         this.btn_tabQuests.soundId = SoundEnum.TAB;
         this.btn_tabAlmanax.soundId = SoundEnum.TAB;
         this.uiApi.addComponentHook(this.btn_tabSuccess,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabSuccess,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabSuccess,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabQuests,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabQuests,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabQuests,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabAlmanax,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabAlmanax,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabAlmanax,"onRollOut");
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("openAchievement",this.onShortcut);
         this.uiApi.addShortcutHook("openBookQuest",this.onShortcut);
         this.uiApi.addShortcutHook("openAlmanax",this.onShortcut);
         if(!_shortcutColor)
         {
            _shortcutColor = this.sysApi.getConfigEntry("colors.shortcut");
            _shortcutColor = _shortcutColor.replace("0x","#");
         }
         this.lbl_btn_tabSuccess.text = this.uiApi.getText("ui.achievement.achievement");
         _loc2_ = this.bindsApi.getShortcutBindStr("openAchievement");
         if(_loc2_ != "")
         {
            this.lbl_btn_tabSuccess.text = this.lbl_btn_tabSuccess.text + (" <font color=\'" + _shortcutColor + "\'>(" + _loc2_ + ")</font>");
         }
         this.lbl_btn_tabQuests.text = this.uiApi.getText("ui.common.quests");
         _loc2_ = this.bindsApi.getShortcutBindStr("openBookQuest");
         if(_loc2_ != "")
         {
            this.lbl_btn_tabQuests.text = this.lbl_btn_tabQuests.text + (" <font color=\'" + _shortcutColor + "\'>(" + _loc2_ + ")</font>");
         }
         this.lbl_btn_tabAlmanax.text = this.uiApi.getText("ui.almanax.almanax");
         _loc2_ = this.bindsApi.getShortcutBindStr("openAlmanax");
         if(_loc2_ != "")
         {
            this.lbl_btn_tabAlmanax.text = this.lbl_btn_tabAlmanax.text + (" <font color=\'" + _shortcutColor + "\'>(" + _loc2_ + ")</font>");
         }
         if(param1 != null)
         {
            this.openTab(param1[0],param1[1],param1[1],this.uiApi.me().restoreSnapshotAfterLoading);
         }
         else
         {
            this.openTab();
         }
      }
      
      public function unload() : void
      {
         if(this.soundApi)
         {
            this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
         }
         this.closeTab(this._currentTabUi);
      }
      
      public function getTab() : String
      {
         return this._currentTabUi;
      }
      
      public function openTab(param1:String = "", param2:int = 0, param3:Object = null, param4:Boolean = true) : void
      {
         var _loc5_:String = null;
         if(param1 != "" && (this._currentTabUi == param1 || this.getButtonByTab(param1).disabled))
         {
            this.closeQuestBase();
            return;
         }
         if(this._currentTabUi != "")
         {
            this.uiApi.unloadUi("subQuestUi");
         }
         if(param1 == "")
         {
            _loc5_ = this.sysApi.getData("lastQuestsTab");
            if(_loc5_ && !this.getButtonByTab(_loc5_).disabled)
            {
               this._currentTabUi = _loc5_;
            }
            else
            {
               this._currentTabUi = EnumTab.ACHIEVEMENT_TAB;
            }
         }
         else
         {
            this._currentTabUi = param1;
         }
         this.sysApi.setData("lastQuestsTab",this._currentTabUi);
         this.uiCtr.getUi().restoreSnapshotAfterLoading = param4;
         this.uiApi.loadUiInside(this._currentTabUi,this.uiCtr,"subQuestUi",param3);
         this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.getButtonByTab(this._currentTabUi),this.uiApi.me());
         this.getButtonByTab(this._currentTabUi).selected = true;
      }
      
      private function getButtonByTab(param1:String) : Object
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case EnumTab.ACHIEVEMENT_TAB:
               _loc2_ = this.btn_tabSuccess;
               break;
            case EnumTab.QUEST_TAB:
               _loc2_ = this.btn_tabQuests;
               break;
            case EnumTab.CALENDAR_TAB:
               _loc2_ = this.btn_tabAlmanax;
         }
         return _loc2_;
      }
      
      private function closeTab(param1:String) : void
      {
         this.uiApi.unloadUi("subQuestUi");
      }
      
      private function closeQuestBase() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.closeQuestBase();
               break;
            case this.btn_tabSuccess:
               this.openTab(EnumTab.ACHIEVEMENT_TAB);
               break;
            case this.btn_tabQuests:
               this.openTab(EnumTab.QUEST_TAB);
               break;
            case this.btn_tabAlmanax:
               this.openTab(EnumTab.CALENDAR_TAB);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "openAchievement":
               if(this._currentTabUi == EnumTab.ACHIEVEMENT_TAB)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this.openTab(EnumTab.ACHIEVEMENT_TAB);
               }
               return true;
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
            case "openAlmanax":
               if(this._currentTabUi == EnumTab.CALENDAR_TAB)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this.openTab(EnumTab.CALENDAR_TAB);
               }
               return true;
            case "closeUi":
               this.closeQuestBase();
               return true;
            default:
               return false;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
