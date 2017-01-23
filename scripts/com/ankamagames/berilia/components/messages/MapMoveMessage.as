package com.ankamagames.berilia.components.messages
{
   import com.ankamagames.berilia.components.MapViewer;
   
   public class MapMoveMessage extends ComponentMessage
   {
       
      
      private var _map:MapViewer;
      
      public function MapMoveMessage(param1:MapViewer)
      {
         super(param1);
      }
   }
}
