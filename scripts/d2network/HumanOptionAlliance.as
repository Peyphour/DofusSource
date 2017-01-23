package d2network
{
   public class HumanOptionAlliance extends HumanOption
   {
       
      
      public function HumanOptionAlliance(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceInformations() : AllianceInformations
      {
         return secure(_target.allianceInformations);
      }
      
      public function get aggressable() : uint
      {
         return _target.aggressable;
      }
   }
}
