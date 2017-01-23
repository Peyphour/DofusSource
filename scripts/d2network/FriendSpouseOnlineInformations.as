package d2network
{
   public class FriendSpouseOnlineInformations extends FriendSpouseInformations
   {
       
      
      public function FriendSpouseOnlineInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get mapId() : uint
      {
         return _target.mapId;
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
      
      public function get inFight() : Boolean
      {
         return _target.inFight;
      }
      
      public function get followSpouse() : Boolean
      {
         return _target.followSpouse;
      }
   }
}
