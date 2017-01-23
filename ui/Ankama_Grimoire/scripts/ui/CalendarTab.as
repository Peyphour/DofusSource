package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.almanax.AlmanaxCalendar;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxEvent;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxMonth;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxZodiac;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2enums.BuildTypeEnum;
   import d2enums.ComponentHookList;
   import d2hooks.AddMapFlag;
   
   public class CalendarTab
   {
      
      private static const NUMBER_OF_DAYS:int = 365;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var soundApi:SoundApi;
      
      public var timeApi:TimeApi;
      
      public var inventoryApi:InventoryApi;
      
      public var dataApi:DataApi;
      
      public var questApi:QuestApi;
      
      private var _dateId:int;
      
      private var _monthInfo:AlmanaxMonth;
      
      private var _zodiacInfo:AlmanaxZodiac;
      
      private var _eventInfo:AlmanaxEvent;
      
      private var _calendar:AlmanaxCalendar;
      
      private var _meryde:Npc;
      
      private var _sheetsQuantity:int;
      
      public var lbl_day:Label;
      
      public var lbl_month:Label;
      
      public var lbl_year:Label;
      
      public var lbl_nameday:Label;
      
      public var lbl_titlemeryde:Label;
      
      public var lbl_meryde:TextArea;
      
      public var lbl_titleBonus:Label;
      
      public var lbl_bonus:TextArea;
      
      public var lbl_dayObjective:Label;
      
      public var lbl_quest:TextArea;
      
      public var lbl_questProgress:Label;
      
      public var ed_meryde:EntityDisplayer;
      
      public var btn_site:ButtonContainer;
      
      public var btn_locTemple:ButtonContainer;
      
      public var btn_hideDailyNotif:ButtonContainer;
      
      public var tx_astro:Texture;
      
      public var tx_monthGod:Texture;
      
      public var tx_nameDayIllu:Texture;
      
      public var tx_dolmanax:Texture;
      
      public var tx_progressBar:ProgressBar;
      
      public var tx_bgMeryde:Texture;
      
      public var ctr_nameDayIllu:GraphicContainer;
      
      public function CalendarTab()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.uiApi.addComponentHook(this.btn_locTemple,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_site,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_site,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_site,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_astro,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_astro,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_monthGod,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_monthGod,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ed_meryde,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ed_meryde,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_bgMeryde,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_bgMeryde,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_progressBar,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_progressBar,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_hideDailyNotif,ComponentHookList.ON_RELEASE);
         if(this.sysApi.getBuildType() == BuildTypeEnum.BETA)
         {
            this.btn_site.disabled = true;
         }
         this._sheetsQuantity = this.inventoryApi.getItemQty(13345);
         var _loc2_:* = this.sysApi.getData("hideAlmanaxDailyNotif");
         this.btn_hideDailyNotif.selected = _loc2_ != undefined?!this.sysApi.getData("hideAlmanaxDailyNotif"):false;
         this.updateCalendarInfos();
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function updateCalendarInfos() : void
      {
         var _loc1_:Object = Grimoire.getInstance().calendarInfos;
         this._calendar = _loc1_.calendar;
         this._monthInfo = _loc1_.month;
         this._zodiacInfo = _loc1_.zodiac;
         this._eventInfo = _loc1_.event;
         this._meryde = _loc1_.meryde;
         this.displayCalendar();
      }
      
      private function displayCalendar() : void
      {
         var _loc3_:int = 0;
         this.lbl_day.text = "" + this.timeApi.getDofusDay();
         this.lbl_month.text = this.timeApi.getDofusMonth();
         this.lbl_year.text = this.uiApi.getText("ui.common.year",this.timeApi.getDofusYear());
         if(this._zodiacInfo)
         {
            this.tx_astro.uri = this.uiApi.createUri(this._zodiacInfo.webImageUrl);
         }
         if(this._monthInfo)
         {
            this.tx_monthGod.uri = this.uiApi.createUri(this._monthInfo.webImageUrl);
         }
         if(this._eventInfo)
         {
            this.lbl_nameday.text = this._eventInfo.name;
            this.tx_nameDayIllu.uri = this.uiApi.createUri(this._eventInfo.webImageUrl);
            this.lbl_meryde.text = this.getText(this._eventInfo.ephemeris);
         }
         if(this._meryde)
         {
            this.lbl_titlemeryde.text = this.uiApi.getText("ui.almanax.dayMeryde",this._meryde.name);
            this.ed_meryde.look = this._meryde.look;
            this.lbl_dayObjective.text = this.uiApi.getText("ui.almanax.offeringTo",this._meryde.name);
         }
         if(this._calendar)
         {
            this.lbl_titleBonus.text = this.uiApi.getText("ui.almanax.dayBonus") + this.uiApi.getText("ui.common.colon") + this._calendar.bonusName;
            this.lbl_bonus.text = this._calendar.bonusDescription;
         }
         var _loc1_:Object = this.questApi.getCompletedQuests();
         if(_loc1_ && _loc1_.indexOf(954) == -1)
         {
            this.lbl_quest.text = this.uiApi.getText("ui.almanax.dolmanaxQuestDesc");
            this.lbl_questProgress.text = this.uiApi.getText("ui.almanax.questProgress");
            _loc3_ = this._sheetsQuantity > NUMBER_OF_DAYS?int(NUMBER_OF_DAYS):int(this._sheetsQuantity);
            this.tx_progressBar.value = _loc3_ / NUMBER_OF_DAYS;
         }
         else
         {
            this.lbl_quest.text = this.uiApi.getText("ui.almanax.dolmanaxQuestDone");
            this.lbl_questProgress.text = this.uiApi.getText("ui.almanax.questDone");
            this._sheetsQuantity = NUMBER_OF_DAYS;
            this.tx_progressBar.value = 1;
         }
         var _loc2_:Item = this.dataApi.getItem(13344);
         if(_loc2_)
         {
            this.tx_dolmanax.uri = this.uiApi.createUri(this.uiApi.me().getConstant("item_path") + _loc2_.iconId + ".swf");
         }
      }
      
      private function getText(param1:String) : String
      {
         if(param1.indexOf("ui.") == 0)
         {
            return this.uiApi.getText(param1);
         }
         return param1;
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_locTemple:
               this.sysApi.dispatchHook(AddMapFlag,"flag_teleportPoint",this.uiApi.getText("ui.almanax.sanctuary") + " (-4,-24)",1,-4,-24,15636787,true);
               break;
            case this.btn_site:
               this.sysApi.goToUrl(this.uiApi.getText("ui.almanax.link"));
               break;
            case this.btn_hideDailyNotif:
               this.sysApi.setData("hideAlmanaxDailyNotif",!this.btn_hideDailyNotif.selected);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = undefined;
         switch(param1)
         {
            case this.btn_site:
               _loc2_ = this.uiApi.getText("ui.almanax.goToWebsite");
               break;
            case this.tx_monthGod:
               if(this._monthInfo)
               {
                  _loc2_ = this.getText(this._monthInfo.protectorDescription);
               }
               break;
            case this.tx_astro:
               if(this._zodiacInfo)
               {
                  _loc2_ = this.getText(this._zodiacInfo.description);
               }
               break;
            case this.ed_meryde:
            case this.tx_bgMeryde:
               if(this._eventInfo)
               {
                  _loc2_ = this.getText(this._eventInfo.bossText);
               }
               break;
            case this.tx_progressBar:
               _loc2_ = this.uiApi.getText("ui.almanax.calendarSheetsCollected",this._sheetsQuantity,NUMBER_OF_DAYS);
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
   }
}
