package d2actions
{
   public class FightOutput implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = false;
      
      public static const NEED_CONFIRMATION:Boolean = false;
      
      public static const MAX_USE_PER_FRAME:int = 0;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function FightOutput(param1:String, param2:uint = 0)
      {
         super();
         this._params = [param1,param2];
      }
      
      public function get parameters() : Array
      {
         return this._params;
      }
   }
}
