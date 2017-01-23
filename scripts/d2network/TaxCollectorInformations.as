package d2network
{
   import utils.ReadOnlyData;
   
   public class TaxCollectorInformations extends ReadOnlyData
   {
       
      
      public function TaxCollectorInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get uniqueId() : int
      {
         return _target.uniqueId;
      }
      
      public function get firtNameId() : uint
      {
         return _target.firtNameId;
      }
      
      public function get lastNameId() : uint
      {
         return _target.lastNameId;
      }
      
      public function get additionalInfos() : AdditionalTaxCollectorInformations
      {
         return secure(_target.additionalInfos);
      }
      
      public function get worldX() : int
      {
         return _target.worldX;
      }
      
      public function get worldY() : int
      {
         return _target.worldY;
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
      
      public function get state() : uint
      {
         return _target.state;
      }
      
      public function get look() : EntityLook
      {
         return secure(_target.look);
      }
      
      public function get complements() : Object
      {
         return secure(_target.complements);
      }
   }
}
