package d2network
{
   import utils.ReadOnlyData;
   
   public class PartyCompanionBaseInformations extends ReadOnlyData
   {
       
      
      public function PartyCompanionBaseInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get indexId() : uint
      {
         return _target.indexId;
      }
      
      public function get companionGenericId() : uint
      {
         return _target.companionGenericId;
      }
      
      public function get entityLook() : EntityLook
      {
         return secure(_target.entityLook);
      }
   }
}
