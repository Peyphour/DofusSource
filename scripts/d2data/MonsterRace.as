package d2data
{
   import utils.ReadOnlyData;
   
   public class MonsterRace extends ReadOnlyData
   {
       
      
      public function MonsterRace(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get superRaceId() : int
      {
         return _target.superRaceId;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get monsters() : Object
      {
         return secure(_target.monsters);
      }
   }
}
