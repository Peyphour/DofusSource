package d2network
{
   import utils.ReadOnlyData;
   
   public class MonsterInGroupLightInformations extends ReadOnlyData
   {
       
      
      public function MonsterInGroupLightInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get creatureGenericId() : int
      {
         return _target.creatureGenericId;
      }
      
      public function get grade() : uint
      {
         return _target.grade;
      }
   }
}
