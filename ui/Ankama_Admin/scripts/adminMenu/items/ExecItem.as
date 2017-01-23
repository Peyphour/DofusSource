package adminMenu.items
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ExecItem extends BasicItem
   {
       
      
      private var _delayTimer:Timer;
      
      protected var _cmdArg:Array;
      
      public function ExecItem(param1:int = 0, param2:int = 0)
      {
         super();
         if(param1 > 0)
         {
            if(param2 > 10)
            {
               param2 = 10;
            }
            this._delayTimer = new Timer(param1,param2);
            this._delayTimer.addEventListener(TimerEvent.TIMER,this.timerCallback);
         }
      }
      
      override public function get label() : String
      {
         if(this._delayTimer && this._delayTimer.running)
         {
            return super.label + " (stop)";
         }
         return super.label;
      }
      
      override public function getContextMenuItem(param1:Object) : Object
      {
         return Api.contextMod.createContextMenuItemObject(replace(this.label,param1),this.beginTimerCallback,this.getcallbackArgs(param1),false,null,false,true,help);
      }
      
      public function beginTimerCallback(... rest) : void
      {
         if(this._delayTimer)
         {
            if(this._delayTimer.running)
            {
               this._delayTimer.stop();
            }
            else
            {
               this._cmdArg = rest;
               this._delayTimer.reset();
               this._delayTimer.start();
            }
         }
         else
         {
            this.callbackFunction.apply(this,rest);
         }
      }
      
      public function timerCallback(param1:TimerEvent) : void
      {
         this.callbackFunction.apply(this,this._cmdArg);
      }
      
      public function get callbackFunction() : Function
      {
         throw new Error("callbackFunction is abstract function, should be overrided");
      }
      
      public function getcallbackArgs(param1:Object) : Array
      {
         throw new Error("getcallbackArgs is abstract function, should be overrided");
      }
   }
}
