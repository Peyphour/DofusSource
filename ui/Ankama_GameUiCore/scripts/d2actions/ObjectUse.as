package d2actions
{
   public class ObjectUse implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = false;
      
      public static const NEED_CONFIRMATION:Boolean = true;
      
      public static const MAX_USE_PER_FRAME:int = 0;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function ObjectUse(param1:uint, param2:int = 1, param3:Boolean = false)
      {
         super();
         this._params = [param1,param2,param3];
      }
      
      public function get parameters() : Array
      {
         return this._params;
      }
   }
}
