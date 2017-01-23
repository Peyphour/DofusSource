package d2network
{
   import utils.ReadOnlyData;
   
   public class GameFightFighterLightInformations extends ReadOnlyData
   {
       
      
      public function GameFightFighterLightInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
      
      public function get wave() : uint
      {
         return _target.wave;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get alive() : Boolean
      {
         return _target.alive;
      }
   }
}
