package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   
   public class DialogParamsDecoder
   {
      
      public static const MAIN_TYPE_CHARACTER:String = "P";
       
      
      public function DialogParamsDecoder()
      {
         super();
      }
      
      public static function applyParams(param1:String, param2:Object) : String
      {
         var _loc3_:Array = getParamsValues(param2);
         return !!_loc3_?ParamsDecoder.applyParams(param1,_loc3_,"#"):param1;
      }
      
      private static function getParamsValues(param1:Object) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc6_:int = 0;
         var _loc5_:int = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            if(!_loc2_)
            {
               _loc2_ = new Array();
            }
            _loc3_ = param1[_loc6_].charAt(0);
            _loc4_ = param1[_loc6_].charAt(1);
            switch(_loc3_)
            {
               case MAIN_TYPE_CHARACTER:
                  switch(_loc4_)
                  {
                     case "N":
                        _loc2_.push(PlayedCharacterManager.getInstance().infos.name);
                        break;
                     default:
                        _loc2_.push("[UNKNOWN_PARAM_" + param1[_loc6_] + "]");
                  }
                  break;
               default:
                  _loc2_.push("[UNKNOWN_PARAM_" + param1[_loc6_] + "]");
            }
            _loc6_++;
         }
         return _loc2_;
      }
   }
}
