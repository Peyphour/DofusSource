package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ItemNameTooltipUi
   {
      
      private static var _shortcutColor:String;
       
      
      private var _timerHide:Timer;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var sysApi:SystemApi;
      
      public var tooltipApi:TooltipApi;
      
      public var menuApi:ContextMenuApi;
      
      public var uiApi:UiApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var utilApi:UtilApi;
      
      public var backgroundCtr:Object;
      
      public var lbl_content:Object;
      
      private var _itemWrapper:Object;
      
      private var _shortcutKey:String;
      
      private var _timerShowItemTooltip:Timer;
      
      private var _param:Object;
      
      private var _alwaysShowTooltipModuleException:Array;
      
      public function ItemNameTooltipUi()
      {
         this._alwaysShowTooltipModuleException = ["giftMenu"];
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc4_:int = 0;
         if(!_shortcutColor)
         {
            _shortcutColor = this.sysApi.getConfigEntry("colors.shortcut");
            _shortcutColor = _shortcutColor.replace("0x","#");
         }
         this._param = param1;
         var _loc2_:Boolean = this._param.makerParam.hasOwnProperty("nameOnly") && !this._param.makerParam.nameOnly || (!this._param.makerParam.hasOwnProperty("nameOnly") && Api.system.getOption("displayTooltips","dofus") || this._alwaysShowTooltipModuleException.indexOf(this._param.tooltip.uiModuleName) != -1);
         var _loc3_:String = "";
         if(this._param.data != null && this._param.data is Item)
         {
            this._itemWrapper = this._param.data;
            _loc3_ = this._itemWrapper.name;
         }
         else
         {
            this._itemWrapper = this._param.data.itemWrapper;
            this._shortcutKey = this._param.data.shortcutKey;
            _loc3_ = this._itemWrapper.name;
            if(this._shortcutKey && this._shortcutKey != "")
            {
               _loc3_ = _loc3_ + (" <font color=\'" + _shortcutColor + "\'>(" + this._shortcutKey + ")</font>");
            }
         }
         this.lbl_content.text = _loc3_;
         if(this.sysApi.isInGame() && !_loc2_ && this._itemWrapper.exchangeable)
         {
            this.lbl_content.appendText(this.averagePricesApi.getItemAveragePriceString(this._itemWrapper));
         }
         this.lbl_content.multiline = true;
         this.lbl_content.wordWrap = false;
         this.lbl_content.fullWidth();
         this.backgroundCtr.width = this.lbl_content.textfield.width + 12;
         this.backgroundCtr.height = this.lbl_content.textfield.height;
         this.tooltipApi.place(this._param.position,this._param.point,this._param.relativePoint,this._param.offset);
         if(_loc2_)
         {
            _loc4_ = this.sysApi.getOption("largeTooltipDelay","dofus");
            this._timerShowItemTooltip = new Timer(_loc4_,1);
            this._timerShowItemTooltip.addEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerShowItemTooltip.start();
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(!this._timerShowItemTooltip)
         {
            return;
         }
         this._timerShowItemTooltip.stop();
         this._timerShowItemTooltip.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._timerShowItemTooltip = null;
         this.uiApi.showTooltip(this._itemWrapper,this._param.makerParam.hasOwnProperty("ref") && this._param.makerParam.ref != null?this._param.makerParam.ref:this._param.position,false,"standard",this._param.point,this._param.relativePoint,this._param.offset,null,null,this._param.makerParam);
      }
      
      public function unload() : void
      {
         if(this._timerShowItemTooltip)
         {
            this._timerShowItemTooltip.stop();
            this._timerShowItemTooltip.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerShowItemTooltip = null;
         }
      }
   }
}
