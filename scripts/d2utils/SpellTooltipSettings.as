package d2utils
{
   import utils.DirectAccessObject;
   
   public dynamic class SpellTooltipSettings extends DirectAccessObject
   {
       
      
      public function SpellTooltipSettings(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      [Untrusted]
      public function get header() : Boolean
      {
         return _target.header;
      }
      
      [Untrusted]
      public function set header(param1:Boolean) : void
      {
         _target.header = param1;
      }
      
      [Untrusted]
      public function get effects() : Boolean
      {
         return _target.effects;
      }
      
      [Untrusted]
      public function set effects(param1:Boolean) : void
      {
         _target.effects = param1;
      }
      
      [Untrusted]
      public function get description() : Boolean
      {
         return _target.description;
      }
      
      [Untrusted]
      public function set description(param1:Boolean) : void
      {
         _target.description = param1;
      }
      
      [Untrusted]
      public function get CC_EC() : Boolean
      {
         return _target.CC_EC;
      }
      
      [Untrusted]
      public function set CC_EC(param1:Boolean) : void
      {
         _target.CC_EC = param1;
      }
   }
}
