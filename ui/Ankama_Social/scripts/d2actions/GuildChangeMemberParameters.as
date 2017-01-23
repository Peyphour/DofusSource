package d2actions
{
   public class GuildChangeMemberParameters implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = false;
      
      public static const NEED_CONFIRMATION:Boolean = true;
      
      public static const MAX_USE_PER_FRAME:int = 1;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function GuildChangeMemberParameters(param1:Number, param2:uint, param3:uint, param4:Object)
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
