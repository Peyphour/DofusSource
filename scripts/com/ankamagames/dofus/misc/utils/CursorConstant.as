package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.jerakine.managers.CursorAssetsManager;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   
   public class CursorConstant
   {
      
      public static var resizeV:Class = CursorConstant_resizeV;
      
      public static var resizeH:Class = CursorConstant_resizeH;
      
      public static var resizeL:Class = CursorConstant_resizeL;
      
      public static var resizeR:Class = CursorConstant_resizeR;
      
      public static var drag:Class = CursorConstant_drag;
       
      
      public function CursorConstant()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc2_:String = null;
         var _loc1_:Array = DescribeTypeCache.getVariables(CursorConstant);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ != "prototype")
            {
               CursorAssetsManager.addCursor(_loc2_,new CursorConstant[_loc2_]());
            }
         }
      }
   }
}
