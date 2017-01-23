package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TchatTooltipUi
   {
       
      
      private var _timerHide:Timer;
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var mainCtr:Object;
      
      public var chatCtr:Object;
      
      public var lblMsg:Object;
      
      public var txMsg:Object;
      
      public function TchatTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         if(!this.sysApi.worldIsVisible())
         {
            this.uiApi.hideTooltip(this.uiApi.me().name);
            return;
         }
         this.mainCtr.dynamicPosition = true;
         this.txMsg.dynamicPosition = true;
         var _loc2_:String = Api.chat.getStaticHyperlink(param1.data.text);
         _loc2_ = Api.chat.unEscapeChatString(_loc2_);
         this.lblMsg.text = _loc2_;
         this.lblMsg.mouseChildren = false;
         if(this.chatCtr.width > 200)
         {
            this.lblMsg.width = 200;
            this.lblMsg.multiline = true;
            this.lblMsg.wordWrap = true;
            this.lblMsg.fullWidth();
         }
         this.txMsg.width = this.chatCtr.width + 15;
         this.txMsg.height = this.chatCtr.height + 15;
         var _loc3_:Object = this.tooltipApi.placeArrow(param1.position);
         if(_loc3_.bottomFlip)
         {
            this.txMsg.hFlip();
            this.lblMsg.y = this.lblMsg.y + 9;
         }
         if(_loc3_.leftFlip)
         {
            this.txMsg.vFlip();
         }
         if(param1.autoHide)
         {
            this._timerHide = new Timer(4000 + _loc2_.length * 30);
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
