package contextMenu
{
   public class ContextMenuItem
   {
       
      
      public var label:String;
      
      public var callback:Function;
      
      public var callbackArgs:Array;
      
      public var disabled:Boolean;
      
      public var child:Array;
      
      public var selected:Boolean;
      
      public var radioStyle:Boolean;
      
      public var help:String;
      
      public var forceCloseOnSelect:Boolean;
      
      public var helpDelay:uint;
      
      public var disabledCallback:Function;
      
      public var disabledCallbackArgs:Array;
      
      public function ContextMenuItem(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false, param5:Array = null, param6:Boolean = false, param7:Boolean = true, param8:String = null, param9:Boolean = false, param10:uint = 1000)
      {
         super();
         this.label = param1;
         this.callback = param2;
         this.callbackArgs = param3;
         this.disabled = param4;
         this.child = param5;
         this.selected = param6;
         this.radioStyle = param7;
         this.help = param8;
         this.forceCloseOnSelect = param9;
         this.helpDelay = param10;
      }
      
      public function addDisabledCallback(param1:Function, param2:Array = null) : void
      {
         if(this.disabled)
         {
            this.disabledCallback = param1;
            this.disabledCallbackArgs = param2;
         }
      }
   }
}
