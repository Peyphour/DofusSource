package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.types.tooltip.TooltipRectangle;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.modules.utils.SpellTooltipSettings;
   
   public class TooltipApi
   {
       
      
      public function TooltipApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function setDefaultTooltipUiScript(param1:String, param2:String) : void
      {
      }
      
      [Untrusted]
      public function createTooltip(param1:String, param2:String, param3:String = null) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function createTooltipBlock(param1:Function, param2:Function, param3:String = "chunks") : Object
      {
         return null;
      }
      
      [Untrusted]
      public function registerTooltipAssoc(param1:*, param2:String) : void
      {
      }
      
      [Untrusted]
      public function registerTooltipMaker(param1:String, param2:Class, param3:Class = null) : void
      {
      }
      
      [Untrusted]
      public function createChunkData(param1:String, param2:String) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function place(param1:*, param2:uint = 6, param3:uint = 0, param4:int = 3, param5:Boolean = false, param6:int = -1, param7:Object = null, param8:Boolean = true) : void
      {
      }
      
      [Untrusted]
      public function placeArrow(param1:*) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getSpellTooltipInfo(param1:SpellWrapper, param2:String = null) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getItemTooltipInfo(param1:ItemWrapper, param2:String = null) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getSpellTooltipCache() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function resetSpellTooltipCache() : void
      {
      }
      
      [Untrusted]
      public function createTooltipRectangle(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : TooltipRectangle
      {
         return null;
      }
      
      [Trusted]
      public function createSpellSettings() : SpellTooltipSettings
      {
         return null;
      }
      
      [Trusted]
      public function createItemSettings() : ItemTooltipSettings
      {
         return null;
      }
      
      [Untrusted]
      public function update(param1:String, ... rest) : void
      {
      }
      
      [Untrusted]
      public function adjustTooltipPositions(param1:Array, param2:String, param3:int = 0) : void
      {
      }
   }
}
