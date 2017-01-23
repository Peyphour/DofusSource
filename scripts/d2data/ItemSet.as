package d2data
{
   import utils.ReadOnlyData;
   
   public class ItemSet extends ReadOnlyData
   {
       
      
      public function ItemSet(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get items() : Object
      {
         return secure(_target.items);
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get effects() : Object
      {
         return secure(_target.effects);
      }
      
      public function get bonusIsSecret() : Boolean
      {
         return _target.bonusIsSecret;
      }
   }
}
