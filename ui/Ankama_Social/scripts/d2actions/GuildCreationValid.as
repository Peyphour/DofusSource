package d2actions
{
   public class GuildCreationValid implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = false;
      
      public static const NEED_CONFIRMATION:Boolean = false;
      
      public static const MAX_USE_PER_FRAME:int = 1;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function GuildCreationValid(param1:String, param2:uint, param3:uint, param4:uint, param5:uint)
      {
         super();
         this._params = [param1,param2,param3,param4,param5];
      }
      
      public function get parameters() : Array
      {
         return this._params;
      }
   }
}
