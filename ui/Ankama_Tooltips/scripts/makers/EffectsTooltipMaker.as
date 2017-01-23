package makers
{
   import blockParams.EffectsTooltipBlockParameters;
   import blocks.EffectsTooltipBlock;
   import blocks.TextTooltipBlock;
   
   public class EffectsTooltipMaker
   {
       
      
      public function EffectsTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc4_:String = null;
         var _loc7_:EffectsTooltipBlockParameters = null;
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
         var _loc6_:Object = param1;
         _loc5_.addBlock(new TextTooltipBlock(_loc6_.spellName,{"css":"[local.css]tooltip_title.css"}).block);
         _loc5_.addBlock(new TextTooltipBlock(Api.ui.getText("ui.fight.caster") + Api.ui.getText("ui.common.colon") + param1.casterName,{"css":"[local.css]tooltip_default.css"}).block);
         _loc7_ = EffectsTooltipBlockParameters.create(_loc6_.effects);
         _loc7_.showTheoreticalEffects = false;
         _loc5_.addBlock(new EffectsTooltipBlock(_loc7_).block);
         return _loc5_;
      }
   }
}
