package makers
{
   import blockParams.EffectsTooltipBlockParameters;
   import blocks.EffectsTooltipBlock;
   import blocks.SeparatorTooltipBlock;
   
   public class EffectsListDurationTooltipMaker
   {
       
      
      public function EffectsListDurationTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc4_:String = null;
         var _loc6_:Array = null;
         var _loc8_:EffectsTooltipBlockParameters = null;
         var _loc9_:Object = null;
         var _loc3_:Object = Api.data;
         if(param2 && param2.noBg)
         {
            _loc4_ = "chunks/base/base.txt";
         }
         else
         {
            _loc4_ = "chunks/base/baseWithBackground.txt";
         }
         var _loc5_:Object = Api.tooltip.createTooltip(_loc4_,"chunks/base/container.txt","chunks/base/separator.txt");
         var _loc7_:int = -1;
         for each(_loc9_ in param1)
         {
            if(_loc9_.duration != _loc7_)
            {
               if(_loc6_)
               {
                  _loc8_ = EffectsTooltipBlockParameters.create(_loc6_);
                  _loc8_.length = 422;
                  _loc8_.showLabel = false;
                  _loc5_.addBlock(new EffectsTooltipBlock(_loc8_).block);
                  _loc5_.addBlock(new SeparatorTooltipBlock().block);
               }
               _loc7_ = _loc9_.duration;
               _loc6_ = new Array();
            }
            _loc6_.push(_loc9_);
         }
         _loc8_ = EffectsTooltipBlockParameters.create(_loc6_);
         _loc8_.length = 422;
         _loc8_.showLabel = false;
         _loc5_.addBlock(new EffectsTooltipBlock(_loc8_).block);
         _loc5_.addBlock(new SeparatorTooltipBlock().block);
         return _loc5_;
      }
   }
}
