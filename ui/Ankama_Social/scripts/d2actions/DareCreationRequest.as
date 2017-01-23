package d2actions
{
   public class DareCreationRequest implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = true;
      
      public static const NEED_CONFIRMATION:Boolean = false;
      
      public static const MAX_USE_PER_FRAME:int = 1;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function DareCreationRequest(param1:uint, param2:uint, param3:uint, param4:Number, param5:Number, param6:Boolean, param7:Boolean, param8:Boolean, param9:Boolean, param10:Object)
      {
         super();
         this._params = [param1,param2,param3,param4,param5,param6,param7,param8,param9,param10];
      }
      
      public function get parameters() : Array
      {
         return this._params;
      }
   }
}
