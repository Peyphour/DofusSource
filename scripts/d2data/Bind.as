package d2data
{
   import utils.ReadOnlyData;
   
   public class Bind extends ReadOnlyData
   {
       
      
      public function Bind(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get key() : String
      {
         return _target.key;
      }
      
      public function get targetedShortcut() : String
      {
         return _target.targetedShortcut;
      }
      
      public function get alt() : Boolean
      {
         return _target.alt;
      }
      
      public function get ctrl() : Boolean
      {
         return _target.ctrl;
      }
      
      public function get shift() : Boolean
      {
         return _target.shift;
      }
      
      public function get disabled() : Boolean
      {
         return _target.disabled;
      }
      
      public function toString() : String
      {
         return _target.toString();
      }
      
      public function equals(param1:Bind) : Boolean
      {
         return _target.equals(unsecure(param1));
      }
      
      public function reset() : void
      {
         _target.reset();
      }
      
      public function copy() : Bind
      {
         return _target.copy();
      }
   }
}
