package com.ankamagames.dofus.modules.utils
{
   import com.ankamagames.jerakine.interfaces.IModuleUtil;
   
   public class SpellTooltipSettings implements IModuleUtil
   {
       
      
      private var _header:Boolean;
      
      private var _effects:Boolean;
      
      private var _description:Boolean;
      
      private var _CC_EC:Boolean;
      
      public function SpellTooltipSettings()
      {
         super();
         this._header = true;
         this._effects = true;
         this._description = true;
         this._CC_EC = true;
      }
      
      [Untrusted]
      public function get header() : Boolean
      {
         return this._header;
      }
      
      public function set header(param1:Boolean) : void
      {
         this._header = param1;
      }
      
      public function get effects() : Boolean
      {
         return this._effects;
      }
      
      [Untrusted]
      public function set effects(param1:Boolean) : void
      {
         this._effects = param1;
      }
      
      public function get description() : Boolean
      {
         return this._description;
      }
      
      [Untrusted]
      public function set description(param1:Boolean) : void
      {
         this._description = param1;
      }
      
      public function get CC_EC() : Boolean
      {
         return this._CC_EC;
      }
      
      [Untrusted]
      public function set CC_EC(param1:Boolean) : void
      {
         this._CC_EC = param1;
      }
   }
}
