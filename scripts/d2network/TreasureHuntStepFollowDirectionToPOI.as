package d2network
{
   public class TreasureHuntStepFollowDirectionToPOI extends TreasureHuntStep
   {
       
      
      public function TreasureHuntStepFollowDirectionToPOI(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get direction() : uint
      {
         return _target.direction;
      }
      
      public function get poiLabelId() : uint
      {
         return _target.poiLabelId;
      }
   }
}
