package ui
{
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   
   public class AbstractWorldCharacterTooltipUi
   {
       
      
      public function AbstractWorldCharacterTooltipUi()
      {
         super();
      }
      
      protected function showAlignmentWings(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc6_:int = 0;
         var _loc2_:Object = param1.data;
         var _loc4_:Object = this["uiApi"].me();
         var _loc5_:String = _loc4_.getConstant("alignment");
         var _loc7_:GraphicContainer = _loc4_.getElement("tx_back") as GraphicContainer;
         var _loc8_:GraphicContainer = _loc4_.getElement("ctr_alignment_bottom") as GraphicContainer;
         var _loc9_:GraphicContainer = _loc4_.getElement("ctr_alignment_top") as GraphicContainer;
         var _loc10_:Texture = _loc4_.getElement("tx_alignment") as Texture;
         var _loc11_:Texture = _loc4_.getElement("tx_alignmentBottom") as Texture;
         if(_loc2_.hasOwnProperty("infos") && _loc2_.infos.hasOwnProperty("alignmentInfos"))
         {
            _loc3_ = param1.data.infos.alignmentInfos;
         }
         else if(_loc2_.hasOwnProperty("alignmentInfos"))
         {
            _loc3_ = _loc2_.alignmentInfos;
         }
         if(_loc3_ && _loc3_.alignmentSide > 0 && _loc3_.alignmentGrade > 0)
         {
            _loc6_ = _loc7_.width / 2;
            _loc8_.x = _loc6_;
            _loc9_.x = _loc6_;
            _loc8_.y = _loc7_.height - 4;
            _loc9_.addContent(_loc10_);
            _loc8_.addContent(_loc11_);
            _loc10_.uri = Api.ui.createUri(_loc5_ + "wings.swf|demonAngel");
            _loc11_.uri = Api.ui.createUri(_loc5_ + "wings.swf|demonAngel2");
            _loc10_.cacheAsBitmap = true;
            _loc11_.cacheAsBitmap = true;
            _loc10_.gotoAndStop = (_loc3_.alignmentSide - 1) * 10 + 1 + _loc3_.alignmentGrade;
            _loc11_.gotoAndStop = (_loc3_.alignmentSide - 1) * 10 + 1 + _loc3_.alignmentGrade;
            _loc10_.filters = new Array();
            _loc11_.filters = new Array();
            _loc10_.transform.colorTransform = new ColorTransform(1,1,1);
            _loc11_.transform.colorTransform = new ColorTransform(1,1,1);
            if(_loc2_.hasOwnProperty("wingsEffect"))
            {
               if(_loc2_.wingsEffect == -1)
               {
                  if(_loc3_.alignmentSide == 2)
                  {
                     _loc10_.transform.colorTransform = new ColorTransform(0.6,0.6,0.6);
                     _loc11_.transform.colorTransform = new ColorTransform(0.6,0.6,0.6);
                  }
                  else
                  {
                     _loc10_.transform.colorTransform = new ColorTransform(0.7,0.7,0.7);
                     _loc11_.transform.colorTransform = new ColorTransform(0.7,0.7,0.7);
                  }
               }
               else if(_loc2_.wingsEffect == 1)
               {
                  if(_loc3_.alignmentSide == 1)
                  {
                     _loc10_.filters = new Array(new GlowFilter(16777215,1,5,5,1,3));
                     _loc11_.filters = new Array(new GlowFilter(16777215,1,5,5,1,3));
                     _loc10_.transform.colorTransform = new ColorTransform(1.1,1.1,1.2);
                     _loc11_.transform.colorTransform = new ColorTransform(1.1,1.1,1.2);
                  }
                  else if(_loc3_.alignmentSide == 2)
                  {
                     _loc10_.filters = new Array(new GlowFilter(16711704,1,10,10,2,3));
                     _loc11_.filters = new Array(new GlowFilter(16711704,1,10,10,2,3));
                     _loc10_.transform.colorTransform = new ColorTransform(1.2,1.1,1.1);
                     _loc11_.transform.colorTransform = new ColorTransform(1.2,1.1,1.1);
                  }
                  else if(_loc3_.alignmentSide == 3)
                  {
                     _loc10_.filters = new Array(new GlowFilter(16771761,1,5,5,1,3));
                     _loc11_.filters = new Array(new GlowFilter(16771761,1,5,5,1,3));
                     _loc10_.transform.colorTransform = new ColorTransform(1.2,1.2,1.1);
                     _loc11_.transform.colorTransform = new ColorTransform(1.2,1.2,1.1);
                  }
               }
            }
         }
      }
   }
}
