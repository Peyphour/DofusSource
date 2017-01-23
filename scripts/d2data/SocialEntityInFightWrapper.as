package d2data
{
   import utils.ReadOnlyData;
   
   public class SocialEntityInFightWrapper extends ReadOnlyData
   {
       
      
      public function SocialEntityInFightWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get uniqueId() : int
      {
         return _target.uniqueId;
      }
      
      public function get typeId() : int
      {
         return _target.typeId;
      }
      
      public function get fightTime() : int
      {
         return _target.fightTime;
      }
      
      public function get allyCharactersInformations() : Object
      {
         return secure(_target.allyCharactersInformations);
      }
      
      public function get enemyCharactersInformations() : Object
      {
         return secure(_target.enemyCharactersInformations);
      }
      
      public function get waitTimeForPlacement() : Number
      {
         return _target.waitTimeForPlacement;
      }
      
      public function get nbPositionPerTeam() : uint
      {
         return _target.nbPositionPerTeam;
      }
   }
}
