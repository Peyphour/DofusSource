package com.ankamagames.berilia.types.graphic
{
   public class GraphicElement
   {
       
      
      public function GraphicElement()
      {
         super();
      }
      
      public function get sprite() : GraphicContainer
      {
         return new GraphicContainer();
      }
      
      public function get location() : Object
      {
         return new Object();
      }
      
      public function get name() : String
      {
         return new String();
      }
      
      public function get render() : Boolean
      {
         return new Boolean();
      }
      
      public function get size() : GraphicSize
      {
         return new GraphicSize();
      }
      
      public function get locations() : Array
      {
         return new Array();
      }
   }
}
