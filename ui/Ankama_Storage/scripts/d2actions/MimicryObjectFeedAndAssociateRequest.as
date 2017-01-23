package d2actions
{
   public class MimicryObjectFeedAndAssociateRequest implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = false;
      
      public static const NEED_CONFIRMATION:Boolean = false;
      
      public static const MAX_USE_PER_FRAME:int = 1;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function MimicryObjectFeedAndAssociateRequest(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:Boolean)
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
