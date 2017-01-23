package d2utils
{
   import utils.DirectAccessObject;
   
   public dynamic class ItemTooltipSettings extends DirectAccessObject
   {
       
      
      public function ItemTooltipSettings(param1:*, param2:Object)
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
      public function get conditions() : Boolean
      {
         return _target.conditions;
      }
      
      [Untrusted]
      public function set conditions(param1:Boolean) : void
      {
         _target.conditions = param1;
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
      public function get averagePrice() : Boolean
      {
         return _target.averagePrice;
      }
      
      [Untrusted]
      public function set averagePrice(param1:Boolean) : void
      {
         _target.averagePrice = param1;
      }
      
      [Untrusted]
      public function get showEffects() : Boolean
      {
         return _target.showEffects;
      }
      
      [Untrusted]
      public function set showEffects(param1:Boolean) : void
      {
         _target.showEffects = param1;
      }
      
      [Untrusted]
      public function get contextual() : Boolean
      {
         return _target.contextual;
      }
      
      [Untrusted]
      public function set contextual(param1:Boolean) : void
      {
         _target.contextual = param1;
      }
      
      [Untrusted]
      public function get addTheoreticalEffects() : Boolean
      {
         return _target.addTheoreticalEffects;
      }
      
      [Untrusted]
      public function set addTheoreticalEffects(param1:Boolean) : void
      {
         _target.addTheoreticalEffects = param1;
      }
   }
}
