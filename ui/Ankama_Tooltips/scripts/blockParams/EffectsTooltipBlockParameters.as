package blockParams
{
   public class EffectsTooltipBlockParameters extends TooltipBlockParameters
   {
       
      
      public var effects:Object;
      
      public var isCriticalEffects:Boolean = false;
      
      public var setInfo:String;
      
      public var splitDamageAndEffects:Boolean = true;
      
      public var length:int = 409;
      
      public var showDamages:Boolean = true;
      
      public var showSpecialEffects:Boolean = true;
      
      public var showTheoreticalEffects:Boolean = true;
      
      public var addTheoreticalEffects:Boolean = false;
      
      public var showDuration:Boolean = true;
      
      public var showLabel:Boolean = true;
      
      public var itemTheoreticalEffects:Object = null;
      
      public function EffectsTooltipBlockParameters()
      {
         super();
      }
      
      public static function create(param1:Object, param2:String = "chunks") : EffectsTooltipBlockParameters
      {
         var _loc3_:EffectsTooltipBlockParameters = new EffectsTooltipBlockParameters();
         _loc3_.effects = param1;
         _loc3_.chunkType = param2;
         return _loc3_;
      }
   }
}
