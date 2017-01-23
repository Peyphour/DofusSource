package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   
   public class TextureBase extends GraphicContainer
   {
       
      
      public function TextureBase()
      {
         super();
      }
      
      public function get useCache() : Boolean
      {
         return false;
      }
      
      public function set useCache(param1:Boolean) : void
      {
      }
      
      public function get showLoadingError() : Boolean
      {
         return false;
      }
      
      public function set showLoadingError(param1:Boolean) : void
      {
      }
      
      public function get autoCenterBitmap() : Boolean
      {
         return false;
      }
      
      public function set autoCenterBitmap(param1:Boolean) : void
      {
      }
      
      public function get smooth() : Boolean
      {
         return false;
      }
      
      public function set smooth(param1:Boolean) : void
      {
      }
      
      public function get uri() : Object
      {
         return null;
      }
      
      public function set uri(param1:Object) : void
      {
      }
      
      public function loadBitmapData(param1:Object) : void
      {
      }
   }
}
