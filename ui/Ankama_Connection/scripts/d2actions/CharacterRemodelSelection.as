package d2actions
{
   public class CharacterRemodelSelection implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = false;
      
      public static const NEED_CONFIRMATION:Boolean = false;
      
      public static const MAX_USE_PER_FRAME:int = 1;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function CharacterRemodelSelection(param1:Number, param2:Boolean, param3:uint, param4:uint, param5:String, param6:Object)
      {
         super();
         this._params = [param1,param2,param3,param4,param5,param6];
      }
      
      public function get parameters() : Array
      {
         return this._params;
      }
   }
}
