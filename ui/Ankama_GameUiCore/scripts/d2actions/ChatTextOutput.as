package d2actions
{
   public class ChatTextOutput implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = true;
      
      public static const NEED_CONFIRMATION:Boolean = false;
      
      public static const MAX_USE_PER_FRAME:int = 1;
      
      public static const DELAY:int = 100;
       
      
      private var _params:Array;
      
      public function ChatTextOutput(param1:String, param2:uint = 0, param3:String = "", param4:Object = null)
      {
         super();
         this._params = [param1,param2,param3,param4];
      }
      
      public function get parameters() : Array
      {
         return this._params;
      }
   }
}
