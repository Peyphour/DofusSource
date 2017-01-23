package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DelayedClosurePopup
   {
       
      
      public var uiApi:UiApi;
      
      public var popCtr:GraphicContainer;
      
      public var lbl_content:Label;
      
      private var _timer:Timer;
      
      public function DelayedClosurePopup()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         if(!param1)
         {
            throw new Error("Can\'t load popup without properties.");
         }
         this.lbl_content.text = param1.content;
         if(param1.marginTop)
         {
            this.popCtr.y = param1.marginTop;
         }
         this._timer = new Timer(param1.delay);
         this._timer.addEventListener(TimerEvent.TIMER,this.closeMe);
         this._timer.start();
         this.uiApi.me().render();
      }
      
      private function closeMe(param1:TimerEvent) : void
      {
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER,this.closeMe);
         this._timer = null;
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function unload() : void
      {
         if(this._timer != null)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.closeMe);
            this._timer = null;
         }
      }
   }
}
