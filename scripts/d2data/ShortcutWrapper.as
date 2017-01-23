package d2data
{
   import utils.ReadOnlyData;
   
   public class ShortcutWrapper extends ReadOnlyData
   {
       
      
      public function ShortcutWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get slot() : uint
      {
         return _target.slot;
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get gid() : int
      {
         return _target.gid;
      }
      
      public function get type() : int
      {
         return _target.type;
      }
      
      public function get quantity() : int
      {
         return _target.quantity;
      }
   }
}
