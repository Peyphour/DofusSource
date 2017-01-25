package com.somerandomdude.colortoolkit.schemes
{
   public class ColorScheme
   {
       
      
      protected var _colors:ColorList;
      
      public function ColorScheme(... rest)
      {
         super();
      }
      
      public function get colors() : ColorList
      {
         return this._colors;
      }
      
      public function addColor(param1:int) : void
      {
         if(!this._colors)
         {
            this._colors = new ColorList();
         }
      }
      
      public function removeColor(param1:int) : void
      {
      }
   }
}
