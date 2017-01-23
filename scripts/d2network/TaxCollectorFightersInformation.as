package d2network
{
   import utils.ReadOnlyData;
   
   public class TaxCollectorFightersInformation extends ReadOnlyData
   {
       
      
      public function TaxCollectorFightersInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get collectorId() : int
      {
         return _target.collectorId;
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
