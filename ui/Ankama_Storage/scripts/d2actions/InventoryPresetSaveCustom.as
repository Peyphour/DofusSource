package d2actions
{
   public class InventoryPresetSaveCustom implements IAction
   {
      
      public static const NEED_INTERACTION:Boolean = false;
      
      public static const NEED_CONFIRMATION:Boolean = false;
      
      public static const MAX_USE_PER_FRAME:int = 0;
      
      public static const DELAY:int = 0;
       
      
      private var _params:Array;
      
      public function InventoryPresetSaveCustom(param1:uint, param2:uint, param3:Object, param4:Object)
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
