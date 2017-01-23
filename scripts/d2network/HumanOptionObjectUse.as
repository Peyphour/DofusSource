package d2network
{
   public class HumanOptionObjectUse extends HumanOption
   {
       
      
      public function HumanOptionObjectUse(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get delayTypeId() : uint
      {
         return _target.delayTypeId;
      }
      
      public function get delayEndTime() : Number
      {
         return _target.delayEndTime;
      }
      
      public function get objectGID() : uint
      {
         return _target.objectGID;
      }
   }
}
