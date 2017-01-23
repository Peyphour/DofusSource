package ui
{
   import com.ankamagames.berilia.components.ColorPicker;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.NotificationReset;
   import d2hooks.RefreshTips;
   import d2hooks.UpdateChatOptions;
   import flash.geom.ColorTransform;
   import types.ConfigProperty;
   
   public class ConfigChat extends ConfigUi
   {
       
      
      public var dataApi:DataApi;
      
      public var chatApi:ChatApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _colorTexture:Object;
      
      private var _oldColors:Array;
      
      private var _channels:Array;
      
      private var _spellTooltipDelays:Array;
      
      private var _itemTooltipDelays:Array;
      
      private const _tooltipMsDelay:Array = [0,500,2000,-1];
      
      public var cp_colorPk:ColorPicker;
      
      public var btn_resetColors:ButtonContainer;
      
      public var btn_smallScreenFont:ButtonContainer;
      
      public var btn_showNotifications:ButtonContainer;
      
      public var btn_resetNotifications:ButtonContainer;
      
      public var btn_resetUIPositions:ButtonContainer;
      
      public var btn_bigMenuButton:ButtonContainer;
      
      public var lbl_sample:Label;
      
      public var cb_channel:ComboBox;
      
      public var cb_spellTooltipDelay:ComboBox;
      
      public var cb_itemTooltipDelay:ComboBox;
      
      public var btn_pinnedOnClick:ButtonContainer;
      
      public var btn_alwaysDisplayTheoreticalEffects:ButtonContainer;
      
      public function ConfigChat()
      {
         super();
      }
      
      public function main(param1:*) : void
      {
         this.btn_resetColors.soundId = SoundEnum.CHECKBOX_CHECKED;
         var _loc2_:Array = new Array();
         _loc2_.push(new ConfigProperty("btn_smallScreenFont","smallScreenFont","dofus"));
         _loc2_.push(new ConfigProperty("btn_confirmItemDrop","confirmItemDrop","dofus"));
         _loc2_.push(new ConfigProperty("btn_showNotifications","showNotifications","dofus"));
         _loc2_.push(new ConfigProperty("btn_bigMenuButton","bigMenuButton","dofus"));
         _loc2_.push(new ConfigProperty("btn_letLivingObjectTalk","letLivingObjectTalk","chat"));
         _loc2_.push(new ConfigProperty("btn_filterInsult","filterInsult","chat"));
         _loc2_.push(new ConfigProperty("btn_showTime","showTime","chat"));
         _loc2_.push(new ConfigProperty("btn_channelLocked","channelLocked","chat"));
         _loc2_.push(new ConfigProperty("btn_showShortcut","showShortcut","chat"));
         _loc2_.push(new ConfigProperty("btn_showInfoPrefix","showInfoPrefix","chat"));
         _loc2_.push(new ConfigProperty("btn_smileysAutoclosed","smileysAutoclosed","chat"));
         _loc2_.push(new ConfigProperty("cb_spellTooltipDelay","spellTooltipDelay","dofus"));
         _loc2_.push(new ConfigProperty("cb_itemTooltipDelay","itemTooltipDelay","dofus"));
         _loc2_.push(new ConfigProperty("btn_alwaysDisplayTheoreticalEffects","alwaysDisplayTheoreticalEffectsInTooltip","dofus"));
         init(_loc2_);
         this.initChatOptions();
         this.initTooltipOptions();
      }
      
      override public function reset() : void
      {
         super.reset();
         init(_properties);
         this.initChatOptions();
      }
      
      public function unload() : void
      {
         sysApi.dispatchHook(UpdateChatOptions);
      }
      
      private function initChatOptions() : void
      {
         var _loc1_:* = undefined;
         this._channels = new Array();
         for each(_loc1_ in this.dataApi.getAllChatChannels())
         {
            if(_loc1_.id != sysApi.getEnum("com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum").PSEUDO_CHANNEL_FIGHT_LOG)
            {
               this._channels.push(_loc1_);
            }
         }
         this.cb_channel.dataProvider = this._channels;
         this.cb_channel.value = this._channels[0];
         this.cb_channel.dataNameField = "name";
      }
      
      private function initTooltipOptions() : void
      {
         this._spellTooltipDelays = [uiApi.getText("ui.option.tooltip.displayDelayInstant"),uiApi.getText("ui.option.tooltip.displayDelayShort"),uiApi.getText("ui.option.tooltip.displayDelayLong"),uiApi.getText("ui.option.tooltip.displayDelayDisabled")];
         this.cb_spellTooltipDelay.dataProvider = this._spellTooltipDelays;
         var _loc1_:int = this._tooltipMsDelay.indexOf(sysApi.getOption("spellTooltipDelay","dofus"));
         if(_loc1_ == -1)
         {
            _loc1_ = 1;
         }
         this.cb_spellTooltipDelay.value = this._spellTooltipDelays[_loc1_];
         this.cb_spellTooltipDelay.dataNameField = "";
         this._itemTooltipDelays = [uiApi.getText("ui.option.tooltip.displayDelayInstant"),uiApi.getText("ui.option.tooltip.displayDelayShort"),uiApi.getText("ui.option.tooltip.displayDelayLong"),uiApi.getText("ui.option.tooltip.displayDelayDisabled")];
         this.cb_itemTooltipDelay.dataProvider = this._itemTooltipDelays;
         _loc1_ = this._tooltipMsDelay.indexOf(sysApi.getOption("itemTooltipDelay","dofus"));
         if(_loc1_ == -1)
         {
            _loc1_ = 1;
         }
         this.cb_itemTooltipDelay.value = this._itemTooltipDelays[_loc1_];
         this.cb_itemTooltipDelay.dataNameField = "";
      }
      
      private function saveOptions() : void
      {
      }
      
      private function undoOptions() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.chatApi.getChatColors())
         {
            _loc1_.push(_loc2_);
         }
         for each(_loc3_ in this._channels)
         {
            configApi.setConfigProperty("chat","channelColor" + _loc3_.id,_loc1_[_loc3_.id]);
         }
         this.cb_channel.dataProvider = this._channels;
         this.cb_channel.selectedIndex = 0;
         _loc4_ = configApi.getConfigProperty("chat","channelColor" + this.cb_channel.value.id);
         this.cp_colorPk.color = _loc4_;
         this.lbl_sample.colorText = _loc4_;
      }
      
      private function selectColor() : void
      {
      }
      
      override public function onRelease(param1:Object) : void
      {
         super.onRelease(param1);
         switch(param1)
         {
            case this.btn_resetColors:
               this.undoOptions();
               break;
            case this.btn_showNotifications:
               sysApi.dispatchHook(RefreshTips);
               break;
            case this.btn_resetNotifications:
               sysApi.sendAction(new NotificationReset());
               break;
            case this.btn_smallScreenFont:
               sysApi.changeActiveFontType(!!this.btn_smallScreenFont.selected?"smallScreen":"");
               break;
            case this.btn_resetUIPositions:
               uiApi.resetUiSavedUserModification();
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:uint = 0;
         switch(param1)
         {
            case this.cb_channel:
               _loc4_ = configApi.getConfigProperty("chat","channelColor" + this.cb_channel.value.id);
               this.lbl_sample.colorText = _loc4_;
               this.cp_colorPk.color = _loc4_;
               break;
            case this.cb_spellTooltipDelay:
               setProperty("dofus","spellTooltipDelay",this._tooltipMsDelay[this.cb_spellTooltipDelay.selectedIndex]);
               break;
            case this.cb_itemTooltipDelay:
               setProperty("dofus","itemTooltipDelay",this._tooltipMsDelay[this.cb_itemTooltipDelay.selectedIndex]);
         }
      }
      
      public function onColorChange(param1:Object) : void
      {
         var _loc3_:ColorTransform = null;
         var _loc2_:uint = this.cp_colorPk.color;
         if(_loc2_ != configApi.getConfigProperty("chat","channelColor" + this.cb_channel.value.id))
         {
            if(!this._colorTexture)
            {
               this._colorTexture = this.cb_channel.container.uiClass.tx_color;
            }
            _loc3_ = new ColorTransform();
            _loc3_.color = _loc2_;
            this._colorTexture.transform.colorTransform = _loc3_;
            configApi.setConfigProperty("chat","channelColor" + this.cb_channel.value.id,_loc2_);
            this.lbl_sample.colorText = _loc2_;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_resetNotifications:
               _loc2_ = uiApi.getText("ui.option.resetHints");
         }
         uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
   }
}
