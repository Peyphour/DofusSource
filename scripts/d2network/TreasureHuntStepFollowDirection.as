package d2network
{
   public class TreasureHuntStepFollowDirection extends TreasureHuntStep
   {
       
      
      public function TreasureHuntStepFollowDirection(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get direction() : uint
      {
         return _target.direction;
      }
      
      public function get mapCount() : uint
      {
         return _target.mapCount;
      }
   }
}
