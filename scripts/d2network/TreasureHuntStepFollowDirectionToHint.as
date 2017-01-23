package d2network
{
   public class TreasureHuntStepFollowDirectionToHint extends TreasureHuntStep
   {
       
      
      public function TreasureHuntStepFollowDirectionToHint(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get direction() : uint
      {
         return _target.direction;
      }
      
      public function get npcId() : uint
      {
         return _target.npcId;
      }
   }
}
