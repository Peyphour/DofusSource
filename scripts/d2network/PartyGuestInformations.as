package d2network
{
   import utils.ReadOnlyData;
   
   public class PartyGuestInformations extends ReadOnlyData
   {
       
      
      public function PartyGuestInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guestId() : Number
      {
         return _target.guestId;
      }
      
      public function get hostId() : Number
      {
         return _target.hostId;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get guestLook() : EntityLook
      {
         return secure(_target.guestLook);
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get status() : PlayerStatus
      {
         return secure(_target.status);
      }
      
      public function get companions() : Object
      {
         return secure(_target.companions);
      }
   }
}
