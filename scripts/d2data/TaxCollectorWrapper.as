package d2data
{
   import d2network.AdditionalTaxCollectorInformations;
   import d2network.BasicGuildInformations;
   import d2network.EntityLook;
   import utils.ReadOnlyData;
   
   public class TaxCollectorWrapper extends ReadOnlyData
   {
       
      
      public function TaxCollectorWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get uniqueId() : int
      {
         return _target.uniqueId;
      }
      
      public function get guild() : BasicGuildInformations
      {
         return secure(_target.guild);
      }
      
      public function get firstName() : String
      {
         return _target.firstName;
      }
      
      public function get lastName() : String
      {
         return _target.lastName;
      }
      
      public function get entityLook() : EntityLook
      {
         return secure(_target.entityLook);
      }
      
      public function get tiphonEntityLook() : Object
      {
         return secure(_target.tiphonEntityLook);
      }
      
      public function get additionalInformation() : AdditionalTaxCollectorInformations
      {
         return secure(_target.additionalInformation);
      }
      
      public function get mapWorldX() : int
      {
         return _target.mapWorldX;
      }
      
      public function get mapWorldY() : int
      {
         return _target.mapWorldY;
      }
      
      public function get subareaId() : int
      {
         return _target.subareaId;
      }
      
      public function get state() : int
      {
         return _target.state;
      }
      
      public function get fightTime() : Number
      {
         return _target.fightTime;
      }
      
      public function get waitTimeForPlacement() : Number
      {
         return _target.waitTimeForPlacement;
      }
      
      public function get nbPositionPerTeam() : uint
      {
         return _target.nbPositionPerTeam;
      }
      
      public function get kamas() : int
      {
         return _target.kamas;
      }
      
      public function get experience() : int
      {
         return _target.experience;
      }
      
      public function get pods() : int
      {
         return _target.pods;
      }
      
      public function get itemsValue() : int
      {
         return _target.itemsValue;
      }
      
      public function get collectedItems() : Object
      {
         return secure(_target.collectedItems);
      }
      
      public function get callerId() : Number
      {
         return _target.callerId;
      }
      
      public function get callerName() : String
      {
         return _target.callerName;
      }
   }
}
