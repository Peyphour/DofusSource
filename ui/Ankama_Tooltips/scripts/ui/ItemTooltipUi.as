package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import d2enums.LocationEnum;
   import d2hooks.KeyDown;
   import d2hooks.KeyUp;
   import d2hooks.UiLoaded;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import makers.ItemTooltipMaker;
   
   public class ItemTooltipUi extends TooltipPinableBaseUi
   {
      
      private static const TIME_BEFORE_COMPARAISON:Number = 500;
      
      protected static var MARGIN:int;
      
      private static var _compareTooltips:Array;
       
      
      public var tooltipApi:TooltipApi;
      
      public var inventoryApi:InventoryApi;
      
      public var lbl_content:Label;
      
      public var tx_icon:Texture;
      
      private var _timerHide:Timer;
      
      private var _timerCompare:Timer;
      
      private var _timerDisplay:Timer;
      
      private var _skip:Boolean = true;
      
      private var _item:Object;
      
      private var _equippedItems:Object;
      
      private var _rectangle:Object;
      
      private var _ctrlKeyIsDown:Boolean = false;
      
      private var _ttOffset:Number;
      
      private var _mainParams:Object;
      
      private var _isEquipped:Boolean = false;
      
      private var _htmlTextWithoutTheoreticalEffects:String;
      
      private var _htmlTextWitTheoreticalEffects:String;
      
      private var _hasShortDescription:Boolean = false;
      
      public function ItemTooltipUi()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         MARGIN = this.lbl_content.x;
         var _loc2_:String = uiApi.me().name;
         this._item = param1.data;
         this._mainParams = param1;
         if(param1.data != null && param1.data is Item)
         {
            this._item = param1.data;
         }
         else
         {
            this._item = param1.data.itemWrapper;
         }
         var _loc3_:String = "tooltip_item";
         var _loc4_:String = sysApi.getActiveFontType();
         if(_loc4_ && _loc4_ != "default")
         {
            _loc3_ = _loc3_ + ("-" + _loc4_);
         }
         uiApi.setLabelStyleSheet(this.lbl_content,sysApi.getConfigEntry("config.ui.skin") + "css/" + _loc3_ + ".css");
         this.lbl_content.multiline = true;
         this.lbl_content.text = param1.tooltip.htmlText;
         if(this.tx_icon)
         {
            this.tx_icon.uri = this._item.iconUri;
         }
         if(_loc2_ == "tooltip_Hyperlink")
         {
            uiApi.addComponentHook(backgroundCtr,"onRelease");
            uiApi.addComponentHook(backgroundCtr,"onRollOver");
            uiApi.addComponentHook(backgroundCtr,"onRollOut");
            uiApi.addComponentHook(backgroundCtr,"onRightClick");
            backgroundCtr.buttonMode = true;
            backgroundCtr.useHandCursor = true;
         }
         var _loc5_:Boolean = false;
         if(_loc2_.indexOf("tooltip_compare") == 0)
         {
            _loc6_ = Api.system.getConfigEntry("colors.grid.title");
            backgroundCtr.borderColor = parseInt(_loc6_);
            if(this.tx_icon)
            {
               this.tx_icon.y = 36 + MARGIN;
            }
         }
         else
         {
            _loc5_ = true;
            if(this.tx_icon && this.tx_icon.y != MARGIN)
            {
               this.tx_icon.y = MARGIN;
            }
         }
         sysApi.addHook(KeyUp,this.onKeyUp);
         sysApi.addHook(KeyDown,this.onKeyDown);
         this._ctrlKeyIsDown = sysApi.isKeyDown(Keyboard.CONTROL);
         if(param1.autoHide)
         {
            this._timerHide = new Timer(2500);
            this._timerHide.addEventListener(TimerEvent.TIMER,this.onTimerHide);
            this._timerHide.start();
         }
         if(uiApi.me().height > uiApi.getStageHeight() && param1.makerParam && param1.makerParam.description)
         {
            this.lbl_content.text = this.shortenDescriptionFromHtmlText(this._mainParams.tooltip.htmlText);
            _loc5_ = true;
         }
         if(this._mainParams.makerParam && this._mainParams.makerParam.hasOwnProperty("addTheoreticalEffects") && !this.hasTheoreticalEffectsOnly)
         {
            if(this._mainParams.makerParam.addTheoreticalEffects)
            {
               this._htmlTextWitTheoreticalEffects = this.lbl_content.htmlText;
            }
            else
            {
               this._htmlTextWithoutTheoreticalEffects = this.lbl_content.htmlText;
            }
         }
         this.updateTooltipSize();
         if(_loc5_)
         {
            this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
         }
         super.main(param1);
         if((!param1 || !param1.makerParam || !param1.makerParam.hasOwnProperty("pinnable") || !param1.makerParam.pinnable) && !isPin)
         {
            _loc7_ = sysApi.getOption("itemTooltipDelay","dofus");
            if(_loc7_ > 0)
            {
               mainCtr.visible = false;
               this._timerDisplay = new Timer(_loc7_);
               this._timerDisplay.addEventListener(TimerEvent.TIMER,this.onTimerDisplay);
               this._timerDisplay.start();
            }
            else if(_loc7_ == -1)
            {
               mainCtr.visible = false;
            }
         }
      }
      
      private function updateTooltipSize() : void
      {
         backgroundCtr.height = this.lbl_content.contentHeight + MARGIN * 2;
      }
      
      protected function onTimerDisplay(param1:TimerEvent) : void
      {
         this._timerDisplay.removeEventListener(TimerEvent.TIMER,this.onTimerDisplay);
         mainCtr.visible = true;
      }
      
      protected function onTimerCompare(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         this._timerCompare.removeEventListener(TimerEvent.TIMER,this.onTimerCompare);
         if(!this._isEquipped)
         {
            _compareTooltips = [];
            this._ttOffset = 6;
            _loc2_ = 0;
            for each(_loc3_ in this._equippedItems)
            {
               if(_loc3_)
               {
                  if(_loc3_.type && this._item.type && _loc3_.type.superTypeId == this._item.type.superTypeId)
                  {
                     _compareTooltips.push("tooltip_compare" + _loc2_);
                     uiApi.showTooltip(_loc3_,new Rectangle(),false,"compare" + _loc2_,LocationEnum.POINT_TOPRIGHT,LocationEnum.POINT_TOPLEFT,this._ttOffset,"item",null,{
                        "header":true,
                        "description":false,
                        "equipped":true
                     },null,false,4,1,"Ankama_Tooltips");
                     _loc2_++;
                  }
               }
            }
            if(_compareTooltips.length > 0)
            {
               if(uiApi.getUi(_compareTooltips[_compareTooltips.length - 1]))
               {
                  this.tooltipApi.adjustTooltipPositions(_compareTooltips,"tooltip_standard",this._ttOffset);
               }
               else
               {
                  sysApi.addHook(UiLoaded,this.onUiLoaded);
               }
            }
         }
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(param2 == Keyboard.CONTROL && !this.hasTheoreticalEffectsOnly && !sysApi.getOption("alwaysDisplayTheoreticalEffectsInTooltip","dofus"))
         {
            this._ctrlKeyIsDown = false;
            this.hideTheoreticalEffects();
         }
      }
      
      public function onKeyDown(param1:Object, param2:uint) : void
      {
         if(!this._ctrlKeyIsDown && param2 == Keyboard.CONTROL && !this.hasTheoreticalEffectsOnly && this.lbl_content.text != this._htmlTextWitTheoreticalEffects && !sysApi.getOption("alwaysDisplayTheoreticalEffectsInTooltip","dofus"))
         {
            this._ctrlKeyIsDown = true;
            this.showTheoreticalEffects();
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(this._item)
         {
            _loc2_ = menuApi.create(this._item);
            if(_loc2_.content.length > 0)
            {
               modContextMenu.createContextMenu(_loc2_);
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         backgroundCtr.filters = new Array(new GlowFilter(sysApi.getConfigEntry("colors.text.glow.red"),1,5,5,2,3));
         uiApi.showTooltip(uiApi.textTooltipInfo(uiApi.getText("ui.common.close")),param1,false,"close_tooltip",7,1,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         backgroundCtr.filters = new Array();
         uiApi.hideTooltip("close_tooltip");
      }
      
      public function onUiLoaded(param1:String) : void
      {
         if(param1 == _compareTooltips[_compareTooltips.length - 1])
         {
            this.tooltipApi.adjustTooltipPositions(_compareTooltips,"tooltip_standard",this._ttOffset);
            sysApi.removeHook(UiLoaded);
         }
      }
      
      private function shortenDescriptionFromHtmlText(param1:String) : String
      {
         this._hasShortDescription = true;
         var _loc2_:String = param1;
         var _loc3_:int = _loc2_.indexOf("<p class=\'quote\'>" + 17);
         var _loc4_:int = _loc2_.indexOf("</p>",_loc3_);
         _loc2_ = _loc2_.replace(this._item.description,"[" + String.fromCharCode(8230) + "]");
         return _loc2_;
      }
      
      private function showTheoreticalEffects() : void
      {
         var _loc1_:ItemTooltipMaker = null;
         var _loc2_:* = undefined;
         if(!this._htmlTextWitTheoreticalEffects)
         {
            _loc1_ = new ItemTooltipMaker();
            if(this._mainParams.makerParam)
            {
               this._mainParams.makerParam.addTheoreticalEffects = true;
            }
            _loc2_ = _loc1_.createTooltip(this._item,this._mainParams.makerParam);
            this._htmlTextWitTheoreticalEffects = _loc2_.updateAndReturnHtmlText();
            if(this._hasShortDescription)
            {
               this._htmlTextWitTheoreticalEffects = this.shortenDescriptionFromHtmlText(this._htmlTextWitTheoreticalEffects);
            }
         }
         this.lbl_content.text = this._htmlTextWitTheoreticalEffects;
         this.updateTooltipSize();
      }
      
      private function hideTheoreticalEffects() : void
      {
         var _loc1_:ItemTooltipMaker = null;
         var _loc2_:* = undefined;
         if(!this._htmlTextWithoutTheoreticalEffects)
         {
            _loc1_ = new ItemTooltipMaker();
            if(this._mainParams.makerParam)
            {
               this._mainParams.makerParam.addTheoreticalEffects = false;
            }
            _loc2_ = _loc1_.createTooltip(this._item,this._mainParams.makerParam);
            this._htmlTextWithoutTheoreticalEffects = _loc2_.updateAndReturnHtmlText();
            if(this._hasShortDescription)
            {
               this._htmlTextWithoutTheoreticalEffects = this.shortenDescriptionFromHtmlText(this._htmlTextWithoutTheoreticalEffects);
            }
         }
         this.lbl_content.text = this._htmlTextWithoutTheoreticalEffects;
         this.updateTooltipSize();
      }
      
      private function get hasTheoreticalEffectsOnly() : Boolean
      {
         if(this._mainParams.makerParam && this._mainParams.makerParam.hasOwnProperty("showEffects"))
         {
            return this._mainParams.makerParam.showEffects;
         }
         return false;
      }
      
      private function onTimerHide(param1:TimerEvent) : void
      {
         this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimerHide);
         uiApi.hideTooltip(uiApi.me().name);
      }
      
      private function hideCompareTooltips() : void
      {
         var _loc1_:String = null;
         if(_compareTooltips)
         {
            for each(_loc1_ in _compareTooltips)
            {
               uiApi.hideTooltip(_loc1_.replace("tooltip_",""));
            }
            _compareTooltips = null;
         }
      }
      
      public function unload() : void
      {
         if(this._timerDisplay)
         {
            this._timerDisplay.removeEventListener(TimerEvent.TIMER,this.onTimerDisplay);
            this._timerDisplay.stop();
            this._timerDisplay = null;
         }
         if(this._timerCompare)
         {
            this._timerCompare.removeEventListener(TimerEvent.TIMER,this.onTimerCompare);
            this._timerCompare.stop();
            this._timerCompare = null;
         }
         if(this._timerHide)
         {
            this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimerHide);
            this._timerHide.stop();
            this._timerHide = null;
         }
         if(uiApi && uiApi.me().name.indexOf("compare") == -1)
         {
            this.hideCompareTooltips();
         }
         if(sysApi)
         {
            sysApi.removeHook(KeyUp);
            sysApi.removeHook(KeyDown);
            sysApi.removeHook(UiLoaded);
         }
         this._equippedItems = null;
         this._item = null;
         this._mainParams = null;
      }
   }
}
