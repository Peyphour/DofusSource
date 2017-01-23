package d2data
{
   import utils.ReadOnlyData;
   
   public class AlmanaxEvent extends ReadOnlyData
   {
       
      
      public function AlmanaxEvent(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get bossText() : String
      {
         return _target.bossText;
      }
      
      public function get ephemeris() : String
      {
         return _target.ephemeris;
      }
      
      public function get rubrikabrax() : String
      {
         return _target.rubrikabrax;
      }
      
      public function get isFest() : Boolean
      {
         return _target.isFest;
      }
      
      public function get festText() : String
      {
         return _target.festText;
      }
      
      public function get webImageUrl() : String
      {
         return _target.webImageUrl;
      }
   }
}
