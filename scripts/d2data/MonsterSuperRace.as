package d2data
{
   import utils.ReadOnlyData;
   
   public class MonsterSuperRace extends ReadOnlyData
   {
       
      
      public function MonsterSuperRace(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
   }
}
