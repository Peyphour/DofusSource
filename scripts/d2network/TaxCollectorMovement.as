package d2network
{
   import utils.ReadOnlyData;
   
   public class TaxCollectorMovement extends ReadOnlyData
   {
       
      
      public function TaxCollectorMovement(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get movementType() : uint
      {
         return _target.movementType;
      }
      
      public function get basicInfos() : TaxCollectorBasicInformations
      {
         return secure(_target.basicInfos);
      }
      
      public function get playerId() : Number
      {
         return _target.playerId;
      }
      
      public function get playerName() : String
      {
         return _target.playerName;
      }
   }
}
