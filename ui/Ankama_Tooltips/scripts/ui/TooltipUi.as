package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TooltipUi
   {
       
      
      private var _timerHide:Timer;
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var lbl_content:Label;
      
      public function TooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1.tooltip && param1.tooltip.chunkType == "htmlChunks")
         {
            _loc2_ = "tooltip_item";
            _loc3_ = this.sysApi.getActiveFontType();
            if(_loc3_ && _loc3_ != "default")
            {
               _loc2_ = _loc2_ + ("-" + _loc3_);
            }
            this.uiApi.setLabelStyleSheet(this.lbl_content,this.sysApi.getConfigEntry("config.ui.skin") + "css/" + _loc2_ + ".css");
            this.lbl_content.multiline = true;
            this.lbl_content.text = param1.tooltip.htmlText;
         }
         if(param1.zoom > 1)
         {
            this.uiApi.me().scale = param1.zoom;
         }
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset,false,-1,null,param1.alwaysDisplayed);
         if(param1.autoHide)
         {
            this._timerHide = new Timer(2500);
            this._timerHide.addEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerHide.start();
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.uiApi.hideTooltip(this.uiApi.me().name);
      }
      
      public function unload() : void
      {
         if(this._timerHide)
         {
            this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerHide.stop();
            this._timerHide = null;
         }
      }
   }
}
