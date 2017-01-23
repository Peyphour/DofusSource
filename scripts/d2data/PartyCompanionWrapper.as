package d2data
{
   public class PartyCompanionWrapper extends PartyMemberWrapper
   {
       
      
      public function PartyCompanionWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get companionGenericId() : uint
      {
         return _target.companionGenericId;
      }
      
      public function get index() : uint
      {
         return _target.index;
      }
      
      public function get masterName() : String
      {
         return _target.masterName;
      }
   }
}
