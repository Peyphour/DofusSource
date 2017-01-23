package d2actions
{
   public class GuidedModeReturnRequest implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = false;
      
      public static const NEED_CONFIRMATION:Boolean = false;
      
      public static const MAX_USE_PER_FRAME:int = 1;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function GuidedModeReturnRequest()
      {
         super();
         this._params = [];
      }
      
      public function get parameters() : Array
      {
         return this._params;
      }
   }
}