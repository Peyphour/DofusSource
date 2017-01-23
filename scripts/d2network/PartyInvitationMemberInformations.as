package d2network
{
   public class PartyInvitationMemberInformations extends CharacterBaseInformations
   {
       
      
      public function PartyInvitationMemberInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get worldX() : int
      {
         return _target.worldX;
      }
      
      public function get worldY() : int
      {
         return _target.worldY;
      }
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
      
      public function get companions() : Object
      {
         return secure(_target.companions);
      }
   }
}
