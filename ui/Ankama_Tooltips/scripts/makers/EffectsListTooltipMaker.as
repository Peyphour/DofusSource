package makers
{
   import blockParams.EffectsTooltipBlockParameters;
   import blocks.EffectsTooltipBlock;
   import blocks.TextTooltipBlock;
   
   public class EffectsListTooltipMaker
   {
       
      
      public function EffectsListTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc4_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc12_:EffectsTooltipBlockParameters = null;
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
         for each(_loc7_ in _loc6_.categories)
         {
            switch(int(_loc7_))
            {
               case 0:
                  _loc8_ = Api.ui.getText("ui.fight.activeBonus");
                  break;
               case 1:
                  _loc8_ = Api.ui.getText("ui.fight.activeMalus");
                  break;
               case 2:
                  _loc8_ = Api.ui.getText("ui.fight.passiveBonus");
                  break;
               case 3:
                  _loc8_ = Api.ui.getText("ui.fight.passiveMalus");
                  break;
               case 4:
                  _loc8_ = Api.ui.getText("ui.fight.triggeredEffects");
                  break;
               case 5:
                  _loc8_ = Api.ui.getText("ui.fight.states");
                  break;
               case 6:
                  _loc8_ = Api.ui.getText("ui.fight.others");
            }
            _loc5_.addBlock(new TextTooltipBlock(_loc8_ + Api.ui.getText("ui.common.colon"),{"css":"[local.css]tooltip_title.css"}).block);
            _loc9_ = _loc6_.buffArray;
            _loc10_ = new Array();
            for each(_loc11_ in _loc9_[_loc7_])
            {
               _loc10_.push(_loc11_.effect);
            }
            _loc12_ = EffectsTooltipBlockParameters.create(_loc10_);
            _loc12_.showLabel = false;
            _loc12_.showDuration = false;
            _loc5_.addBlock(new EffectsTooltipBlock(_loc12_).block);
         }
         return _loc5_;
      }
   }
}
