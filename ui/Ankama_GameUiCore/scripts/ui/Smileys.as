package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.communication.SmileyCategory;
   import com.ankamagames.dofus.internalDatacenter.communication.SmileyWrapper;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ChatSmileyRequest;
   import d2actions.EmotePlayRequest;
   import d2actions.MoodSmileyRequest;
   import d2enums.ComponentHookList;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.EmoteEnabledListUpdated;
   import d2hooks.EmoteListUpdated;
   import d2hooks.MoodResult;
   import d2hooks.OpenSmileys;
   import d2hooks.ShortcutsMovementAllowed;
   import d2hooks.SmileyListUpdated;
   import d2hooks.SmileysStart;
   import d2hooks.TextInformation;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import ui.enums.ContextEnum;
   
   public class Smileys extends ContextAwareUi
   {
       
      
      public var output:Object;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var rpApi:RoleplayApi;
      
      public var chatApi:ChatApi;
      
      public var tooltipApi:TooltipApi;
      
      public var timeApi:TimeApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _currentMood:int = 0;
      
      private var _currentSmileyCategory:int = 0;
      
      private var _selectedTxList:Array;
      
      private var _completeSmileyList:Array;
      
      private var _slotByEmoteId:Dictionary;
      
      private var _usableEmotes:Object;
      
      private var _playSmileAllowed:Boolean = true;
      
      private var _playSmileAllowedTimer:Timer;
      
      private var _shortcutColor:String;
      
      private var _gridComponentsList:Dictionary;
      
      private var _btnHappy:ButtonContainer;
      
      public var mainCtr:GraphicContainer;
      
      public var gd_smileys:Grid;
      
      public var gd_smileyCategories:Grid;
      
      public var gd_emotes:Grid;
      
      public var btn_close:ButtonContainer;
      
      public function Smileys()
      {
         this._selectedTxList = new Array();
         this._completeSmileyList = new Array();
         this._slotByEmoteId = new Dictionary();
         this._usableEmotes = new Object();
         this._gridComponentsList = new Dictionary(true);
         super();
      }
      
      override public function main(param1:Array) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:SmileyCategory = null;
         super.main(param1);
         sysApi.addHook(EmoteListUpdated,this.onEmoteListUpdated);
         sysApi.addHook(MoodResult,this.onMoodResult);
         sysApi.addHook(SmileysStart,this.onSmileysStart);
         sysApi.addHook(SmileyListUpdated,this.onSmileyListUpdated);
         sysApi.addHook(EmoteEnabledListUpdated,this.onEmoteEnabledListUpdated);
         this.uiApi.addComponentHook(this.gd_smileyCategories,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_smileyCategories,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortcut);
         this._playSmileAllowed = true;
         this._playSmileAllowedTimer = new Timer(1000,1);
         this._playSmileAllowedTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onPlaySmileAllowedTimer);
         if(!this.uiApi.getUi(UIEnum.STORAGE_UI))
         {
            sysApi.dispatchHook(ShortcutsMovementAllowed,true);
         }
         this._currentSmileyCategory = sysApi.getData("smileyLastCategoryOpened");
         if(this.gd_smileyCategories.dataProvider.length == 0)
         {
            _loc4_ = this.dataApi.getAllSmileyCategory();
            _loc5_ = new Array();
            for each(_loc6_ in _loc4_)
            {
               _loc5_.push(_loc6_);
            }
            _loc5_.sortOn("order",Array.NUMERIC);
            this.gd_smileyCategories.dataProvider = _loc5_;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.gd_smileyCategories.dataProvider.length)
         {
            if(this._currentSmileyCategory == this.gd_smileyCategories.dataProvider[_loc2_].id)
            {
               this.gd_smileyCategories.selectedIndex = _loc2_;
               break;
            }
            _loc2_++;
         }
         this.createSmileyListWithPacks();
         this.displayCurrentType();
         var _loc3_:String = !!this.playerApi.isInFight()?ContextEnum.FIGHT:ContextEnum.ROLEPLAY;
         changeContext(_loc3_);
      }
      
      public function unload() : void
      {
         if(!this.uiApi.getUi(UIEnum.STORAGE_UI))
         {
            sysApi.dispatchHook(ShortcutsMovementAllowed,false);
         }
         this._playSmileAllowedTimer.stop();
         this._playSmileAllowedTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onPlaySmileAllowedTimer);
         this.uiApi.hideTooltip();
      }
      
      override protected function onContextChanged(param1:String, param2:String = "", param3:Boolean = false) : void
      {
         if(param1 != ContextEnum.ROLEPLAY)
         {
            if(this._currentSmileyCategory == 0)
            {
               if(this._btnHappy)
               {
                  this.onRelease(this._btnHappy);
               }
               this.gd_smileyCategories.selectedIndex = 1;
            }
         }
         this.gd_smileyCategories.updateItem(0);
      }
      
      public function updateSmiley(param1:*, param2:*, param3:Boolean) : void
      {
         param2.slot_smiley.dropValidator = this.dropValidatorFunction;
         if(param1)
         {
            this._selectedTxList[param1.id] = param2.tx_bgSmiley;
            param2.slot_smiley.data = param1;
            if(param1.id == this._currentMood)
            {
               param2.tx_bgSmiley.visible = true;
            }
            else
            {
               param2.tx_bgSmiley.visible = false;
            }
            param2.slot_smiley.allowDrag = true;
         }
         else
         {
            param2.slot_smiley.data = null;
            param2.tx_bgSmiley.visible = false;
         }
      }
      
      public function updateSmileyCategory(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            this._gridComponentsList[param2.btn_cat.name] = param1;
            param2.iconTexturebtn_cat.uri = this.uiApi.createUri(this.uiApi.me().getConstant("icon") + param1.gfxId + ".png");
            param2.btn_cat.selected = param3;
            if(param1.order == 2)
            {
               this._btnHappy = param2.btn_cat;
            }
            else if(param1.order == 1)
            {
               param2.btn_cat.softDisabled = currentContext != ContextEnum.ROLEPLAY;
            }
            param2.btn_cat.visible = true;
         }
         else
         {
            param2.btn_cat.visible = false;
         }
      }
      
      public function updateEmote(param1:*, param2:*, param3:Boolean) : void
      {
         param2.slot_emote.dropValidator = this.dropValidatorFunction;
         if(param1)
         {
            param2.slot_emote.data = param1;
            this._slotByEmoteId[param1.id] = param2.slot_emote;
            param2.slot_emote.allowDrag = true;
            if(this._usableEmotes.indexOf(param1.id) == -1)
            {
               param2.btn_emote.softDisabled = true;
            }
            else
            {
               param2.btn_emote.softDisabled = false;
            }
         }
         else
         {
            param2.slot_emote.data = null;
         }
      }
      
      private function createSmileyListWithPacks() : void
      {
         var _loc3_:SmileyWrapper = null;
         var _loc6_:SmileyWrapper = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this._completeSmileyList = new Array();
         var _loc1_:Object = this.dataApi.getSmileyWrappers();
         var _loc2_:int = Math.floor((this.gd_smileys.width - 20) / this.gd_smileys.slotWidth);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in _loc1_)
         {
            _loc4_++;
            if(_loc3_ && _loc6_.packId != _loc3_.packId)
            {
               _loc7_ = (_loc4_ - 1) % _loc2_;
               if(_loc7_ > 0)
               {
                  _loc5_ = _loc2_ - _loc7_;
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_)
                  {
                     this._completeSmileyList.push(0);
                     _loc4_++;
                     _loc8_++;
                  }
               }
            }
            this._completeSmileyList.push(_loc6_);
            _loc3_ = _loc6_;
         }
      }
      
      private function displayCurrentType() : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         sysApi.dispatchHook(OpenSmileys);
         if(this._currentSmileyCategory == 0)
         {
            this._usableEmotes = this.rpApi.getUsableEmotesList();
            this.gd_emotes.dataProvider = this.rpApi.getEmotesList();
            this.gd_emotes.visible = true;
            this.gd_smileys.visible = false;
         }
         else
         {
            this._selectedTxList = new Array();
            if(this._currentSmileyCategory == -1)
            {
               _loc2_ = sysApi.getOption("favoriteSmileys","chat");
               _loc3_ = new Array();
               for each(_loc4_ in _loc2_)
               {
                  for each(_loc1_ in this._completeSmileyList)
                  {
                     if(_loc1_ && _loc1_.id == _loc4_)
                     {
                        _loc3_.push(_loc1_);
                     }
                  }
               }
               this.gd_smileys.dataProvider = _loc3_;
            }
            else
            {
               _loc5_ = new Array();
               for each(_loc1_ in this._completeSmileyList)
               {
                  if(_loc1_ && _loc1_.categoryId == this._currentSmileyCategory)
                  {
                     _loc5_.push(_loc1_);
                  }
               }
               this.gd_smileys.dataProvider = _loc5_;
            }
            this.gd_smileys.visible = true;
            this.gd_emotes.visible = false;
            this._currentMood = this.chatApi.getSmileyMood();
            if(this._currentMood != 0 && this._selectedTxList[this._currentMood])
            {
               this._selectedTxList[this._currentMood].visible = true;
            }
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:SmileyCategory = null;
         if(param1.name.indexOf("btn_cat") != -1)
         {
            _loc2_ = this._gridComponentsList[param1.name];
            this._currentSmileyCategory = _loc2_.id;
            sysApi.setData("smileyLastCategoryOpened",this._currentSmileyCategory);
            this.displayCurrentType();
         }
         else if(param1 == this.btn_close)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Slot = null;
         switch(param1)
         {
            case this.gd_smileys:
               if(param2 != 7)
               {
                  _loc4_ = param1.selectedItem;
                  if(_loc4_ && this._playSmileAllowed)
                  {
                     sysApi.sendAction(new ChatSmileyRequest(_loc4_.id));
                     this._playSmileAllowed = false;
                     this._playSmileAllowedTimer.start();
                  }
                  if(sysApi.getOption("smileysAutoclosed","chat"))
                  {
                     this.uiApi.unloadUi(this.uiApi.me().name);
                  }
               }
               break;
            case this.gd_emotes:
               if(param2 != 7)
               {
                  _loc5_ = param1.selectedItem;
                  if(_loc5_ && this._playSmileAllowed)
                  {
                     _loc6_ = this._slotByEmoteId[_loc5_.id] as Slot;
                     if(_loc6_ != null)
                     {
                        sysApi.sendAction(new EmotePlayRequest(_loc5_.id));
                        this._playSmileAllowed = false;
                        this._playSmileAllowedTimer.start();
                     }
                  }
                  if(sysApi.getOption("smileysAutoclosed","chat"))
                  {
                     this.uiApi.unloadUi(this.uiApi.me().name);
                  }
               }
         }
      }
      
      public function onPlaySmileAllowedTimer(param1:TimerEvent) : void
      {
         this._playSmileAllowed = true;
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         if(param1 == this.gd_emotes)
         {
            _loc4_ = param2.container;
            if(param2.data)
            {
               if(!this._shortcutColor)
               {
                  this._shortcutColor = sysApi.getConfigEntry("colors.shortcut");
                  this._shortcutColor = this._shortcutColor.replace("0x","#");
               }
               _loc5_ = param2.data.name + " <font color=\'" + this._shortcutColor + "\'>(/" + param2.data.shortcut + ")</font>";
               if(this._usableEmotes.indexOf(param2.data.id) == -1)
               {
                  _loc5_ = _loc5_ + ("\n" + (param2.data.id == 102?this.uiApi.getText("ui.smiley.emoteGhostOnly"):this.uiApi.getText("ui.smiley.emoteDisabled")));
               }
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc5_),_loc4_,false,"standard",7,1,3,null,null,null,"TextInfo");
            }
         }
         else if(param1 == this.gd_smileys)
         {
            _loc4_ = param2.container;
            if(param2.data && param2.data.id == this._currentMood)
            {
               _loc5_ = this.uiApi.getText("ui.smiley.mood");
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc5_),_loc4_,false,"standard",7,1,3,null,null,null,"TextInfo");
            }
         }
         else if(param1 == this.gd_smileyCategories)
         {
            _loc4_ = param2.container;
            if(param2.data && param2.data.gfxId)
            {
               _loc5_ = this.uiApi.getText("ui.smiley.tooltip." + param2.data.gfxId);
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc5_),_loc4_,false,"standard",7,1,3,null,null,null,"TextInfo");
            }
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         if(param2.data == null)
         {
            return;
         }
         var _loc3_:Object = param2.data;
         if(this._currentMood == _loc3_.id)
         {
            sysApi.sendAction(new MoodSmileyRequest(0));
         }
         else
         {
            sysApi.sendAction(new MoodSmileyRequest(_loc3_.id));
         }
      }
      
      public function onEmoteListUpdated() : void
      {
         this._usableEmotes = this.rpApi.getUsableEmotesList();
         this.gd_emotes.dataProvider = this.rpApi.getEmotesList();
      }
      
      public function onEmoteEnabledListUpdated(param1:Object) : void
      {
         this._usableEmotes = this.rpApi.getUsableEmotesList();
         var _loc2_:int = this.gd_emotes.verticalScrollValue;
         this.gd_emotes.dataProvider = this.rpApi.getEmotesList();
         this.gd_emotes.verticalScrollValue = _loc2_;
      }
      
      public function onMoodResult(param1:uint, param2:int) : void
      {
         if(param1 == 0)
         {
            if(this._currentMood != 0 && this._selectedTxList[this._currentMood])
            {
               this._selectedTxList[this._currentMood].visible = false;
            }
            this._currentMood = param2;
            if(this._currentMood != 0 && this._selectedTxList[this._currentMood])
            {
               this._selectedTxList[this._currentMood].visible = true;
            }
         }
         else if(param1 == 1)
         {
            sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.smiley.errorMood"),666,this.timeApi.getTimestamp());
         }
         else if(param1 == 2)
         {
            sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.smiley.errorFloodMood"),666,this.timeApi.getTimestamp());
         }
      }
      
      private function onSmileysStart(param1:uint, param2:String = "") : void
      {
         if(param2 == "true")
         {
            if(param1 == 1)
            {
               this._currentSmileyCategory = 0;
            }
            this.displayCurrentType();
         }
         else
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      private function onSmileyListUpdated() : void
      {
         this.createSmileyListWithPacks();
         this.displayCurrentType();
      }
      
      public function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return false;
      }
      
      public function removeDropSourceFunction(param1:Object) : void
      {
      }
      
      public function processDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         param1.data = param2;
      }
   }
}
