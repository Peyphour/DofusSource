package d2network
{
   import utils.ReadOnlyData;
   
   public class PrismFightersInformation extends ReadOnlyData
   {
       
      
      public function PrismFightersInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
      
      public function get waitingForHelpInfo() : ProtectedEntityWaitingForHelpInfo
      {
         return secure(_target.waitingForHelpInfo);
      }
      
      public function get allyCharactersInformations() : Object
      {
         return secure(_target.allyCharactersInformations);
      }
      
      public function get enemyCharactersInformations() : Object
      {
         return secure(_target.enemyCharactersInformations);
      }
   }
}
