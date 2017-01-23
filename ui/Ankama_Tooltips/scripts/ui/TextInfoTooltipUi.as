package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TextInfoTooltipUi
   {
       
      
      private var _timerHide:Timer;
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      private var _currentCss:String;
      
      private var _currentCssClass:String = "text";
      
      public var lbl_content:Object;
      
      public var backgroundCtr:Object;
      
      public function TextInfoTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:String = this._currentCss;
         var _loc3_:String = param1.data.css;
         if(_loc3_ == null)
         {
            this._currentCss = this.uiApi.me().getConstant("css") + "tooltip_default.css";
         }
         else
         {
            this._currentCss = _loc3_;
         }
         if(param1.data.maxWidth)
         {
            this.lbl_content.multiline = true;
            this.lbl_content.wordWrap = true;
         }
         else
         {
            this.lbl_content.multiline = false;
            this.lbl_content.wordWrap = false;
         }
         if(this._currentCss != _loc2_)
         {
            this.lbl_content.css = this.uiApi.createUri(this._currentCss);
         }
         if(this._currentCssClass != param1.data.cssClass)
         {
            this._currentCssClass = param1.data.cssClass;
            this.lbl_content.cssClass = this._currentCssClass;
         }
         this.lbl_content.text = param1.data.content;
         if(param1.data.bgCornerRadius)
         {
            this.backgroundCtr.bgCornerRadius = param1.data.bgCornerRadius;
         }
         this.lbl_content.fullWidth(param1.data.maxWidth);
         this.backgroundCtr.width = this.lbl_content.textfield.width + 3;
         this.backgroundCtr.height = this.lbl_content.textfield.height + 3;
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset,param1.data.checkSuperposition,param1.data.cellId);
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
