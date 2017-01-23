package d2data
{
   import utils.ReadOnlyData;
   
   public class SpellType extends ReadOnlyData
   {
       
      
      public function SpellType(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get longNameId() : uint
      {
         return _target.longNameId;
      }
      
      public function get shortNameId() : uint
      {
         return _target.shortNameId;
      }
   }
}
