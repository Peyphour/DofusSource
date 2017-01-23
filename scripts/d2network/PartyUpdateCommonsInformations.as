package d2network
{
   import utils.ReadOnlyData;
   
   public class PartyUpdateCommonsInformations extends ReadOnlyData
   {
       
      
      public function PartyUpdateCommonsInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get lifePoints() : uint
      {
         return _target.lifePoints;
      }
      
      public function get maxLifePoints() : uint
      {
         return _target.maxLifePoints;
      }
      
      public function get prospecting() : uint
      {
         return _target.prospecting;
      }
      
      public function get regenRate() : uint
      {
         return _target.regenRate;
      }
   }
}
