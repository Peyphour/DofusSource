package com.ankamagames.atouin.renderers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   
   public class MovementZoneRenderer extends ZoneDARenderer
   {
       
      
      private var _showText:Boolean;
      
      private var _startAt:int;
      
      public function MovementZoneRenderer(param1:Boolean, param2:int = 1)
      {
         super();
         this._showText = param1;
         this._startAt = param2;
         _strata = PlacementStrataEnums.STRATA_AREA;
         currentStrata = !!Atouin.getInstance().options.transparentOverlayMode?uint(PlacementStrataEnums.STRATA_NO_Z_ORDER):uint(_strata);
      }
      
      public function get startAt() : int
      {
         return this._startAt;
      }
      
      public function set startAt(param1:int) : void
      {
         this._startAt = param1;
      }
      
      override protected function getText(param1:int) : String
      {
         if(this._showText)
         {
            return String(param1 + this._startAt);
         }
         return null;
      }
   }
}
