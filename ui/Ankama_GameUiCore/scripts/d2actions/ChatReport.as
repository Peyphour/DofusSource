package d2actions
{
   public class ChatReport implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = false;
      
      public static const NEED_CONFIRMATION:Boolean = false;
      
      public static const MAX_USE_PER_FRAME:int = 1;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function ChatReport(param1:Number, param2:uint, param3:String, param4:uint, param5:String, param6:String, param7:Number)
      {
         super();
         this._params = [param1,param2,param3,param4,param5,param6,param7];
      }
      
      public function get parameters() : Array
      {
         return this._params;
      }
   }
}
