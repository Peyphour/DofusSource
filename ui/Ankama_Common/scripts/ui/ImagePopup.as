package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   
   public class ImagePopup extends Popup
   {
       
      
      public var imgPopCtr:GraphicContainer;
      
      public var ctr_contents:Object;
      
      public var tx_image:Texture;
      
      public function ImagePopup()
      {
         super();
      }
      
      override public function main(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:ButtonContainer = null;
         var _loc7_:TextureBitmap = null;
         var _loc8_:Label = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         lbl_content.multiline = true;
         lbl_content.wordWrap = true;
         lbl_content.html = true;
         lbl_content.border = false;
         if(param1)
         {
            if(param1.hideModalContainer)
            {
               this.imgPopCtr.getUi().showModalContainer = false;
            }
            else
            {
               this.imgPopCtr.getUi().showModalContainer = true;
            }
            lbl_title_popup.text = param1.title;
            this.tx_image.uri = param1.image;
            _loc12_ = param1.content;
            lbl_content.text = _loc12_;
            if(!param1.buttonText || !param1.buttonText.length)
            {
               throw new Error("Can\'t create popup without any button");
            }
            var _loc2_:uint = 100;
            var _loc3_:uint = 32;
            var _loc4_:uint = 20;
            var _loc9_:uint = 0;
            while(_loc9_ < param1.buttonText.length)
            {
               _loc6_ = uiApi.createContainer("ButtonContainer") as ButtonContainer;
               _loc6_.width = _loc2_;
               _loc6_.height = _loc3_;
               _loc6_.x = _loc9_ * (_loc4_ + _loc2_);
               _loc6_.name = "btn" + (_loc9_ + 1);
               uiApi.me().registerId(_loc6_.name,uiApi.createContainer("GraphicElement",_loc6_,new Array(),_loc6_.name));
               _loc7_ = uiApi.createComponent("TextureBitmap") as TextureBitmap;
               _loc7_.width = _loc2_;
               _loc7_.height = _loc3_;
               _loc7_.themeDataId = uiApi.me().getConstant("txBtnBg_normal") as String;
               _loc7_.name = _loc6_.name + "_tx";
               uiApi.me().registerId(_loc7_.name,uiApi.createContainer("GraphicElement",_loc7_,new Array(),_loc7_.name));
               _loc7_.finalize();
               _loc8_ = uiApi.createComponent("Label") as Label;
               _loc8_.width = _loc2_;
               _loc8_.height = _loc3_;
               _loc8_.verticalAlign = "center";
               _loc8_.css = uiApi.createUri(uiApi.me().getConstant("btn.css"));
               _loc8_.text = uiApi.replaceKey(param1.buttonText[_loc9_]);
               _loc6_.addChild(_loc7_);
               _loc6_.addChild(_loc8_);
               _loc13_ = new Array();
               _loc13_[1] = new Array();
               _loc13_[1][_loc7_.name] = new Array();
               _loc13_[1][_loc7_.name]["themeDataId"] = uiApi.me().getConstant("txBtnBg_over") as String;
               _loc13_[2] = new Array();
               _loc13_[2][_loc7_.name] = new Array();
               _loc13_[2][_loc7_.name]["themeDataId"] = uiApi.me().getConstant("txBtnBg_pressed") as String;
               _loc6_.changingStateData = _loc13_;
               if(param1.buttonCallback && param1.buttonCallback[_loc9_])
               {
                  _aEventIndex[_loc6_.name] = param1.buttonCallback[_loc9_];
               }
               uiApi.addComponentHook(_loc6_,"onRelease");
               ctr_buttons.addChild(_loc6_);
               _loc9_++;
            }
            var _loc10_:uint = this.tx_image.y + this.tx_image.height;
            var _loc11_:uint = lbl_content.y + lbl_content.textHeight + 20 + ctr_buttons.height;
            this.imgPopCtr.height = Math.floor(_loc11_ > this.tx_image.height?Number(_loc11_):Number(_loc10_)) + 70;
            if(param1.onCancel)
            {
               onCancelFunction = param1.onCancel;
            }
            uiApi.me().render();
            return;
         }
         throw new Error("Can\'t load popup without properties.");
      }
   }
}
