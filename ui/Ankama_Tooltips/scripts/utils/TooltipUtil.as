package utils
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   
   public class TooltipUtil
   {
       
      
      public function TooltipUtil()
      {
         super();
      }
      
      public static function showDamagePreviewIcons(param1:Label, param2:Number, param3:Array, param4:Vector.<Texture>, param5:GraphicContainer) : Number
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Texture = null;
         var _loc12_:Object = null;
         var _loc14_:Texture = null;
         var _loc6_:Number = 0;
         var _loc11_:Number = 17;
         var _loc13_:Number = param2 / 2;
         _loc8_ = 0;
         while(_loc8_ < param1.textfield.numLines)
         {
            _loc7_ = param1.textfield.getLineText(_loc8_);
            if(param3[_loc8_])
            {
               _loc10_ = Api.ui.createComponent("Texture") as Texture;
               _loc10_.uri = Api.ui.createUri(Tooltips.STATS_ICONS_PATH + param3[_loc8_]);
               _loc10_.finalize();
               _loc12_ = Api.ui.getTextSize(_loc7_,param1.css,param1.cssClass);
               _loc10_.y = param1.y + _loc12_.height * _loc8_ + 8;
               _loc10_.x = _loc13_ - _loc12_.width / 2 - _loc11_ - 2 + _loc6_;
               if(_loc10_.x < 0)
               {
                  _loc6_ = Math.abs(_loc10_.x);
                  _loc10_.x = 0;
                  for each(_loc14_ in param4)
                  {
                     _loc14_.x = _loc14_.x + _loc6_;
                  }
               }
               param5.addContent(_loc10_);
               param4.push(_loc10_);
            }
            _loc8_++;
         }
         return _loc6_;
      }
   }
}
