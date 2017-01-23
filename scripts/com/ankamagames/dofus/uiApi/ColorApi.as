package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.jerakine.types.Color;
   
   [InstanciedApi]
   public class ColorApi implements IApi
   {
       
      
      private var _module:UiModule;
      
      public function ColorApi()
      {
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Trusted]
      public function changeLightness(param1:uint, param2:Number) : uint
      {
         return Color.setHSLlightness(param1,param2);
      }
      
      [Trusted]
      public function changeSaturation(param1:uint, param2:Number) : uint
      {
         return Color.setHSVSaturation(param1,param2);
      }
      
      [Trusted]
      public function generateColorList(param1:int) : Array
      {
         return Color.generateColorList(param1);
      }
   }
}
