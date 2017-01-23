package d2network
{
   public class PartyMemberInformations extends CharacterBaseInformations
   {
       
      
      public function PartyMemberInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get lifePoints() : uint
      {
         return _target.lifePoints;
      }
      
      public function get maxLifePoints() : uint
      {
         return _target.maxLifePoints;
      }
      
      public function get prospecting() : uint
      {
         return _target.prospecting;
      }
      
      public function get regenRate() : uint
      {
         return _target.regenRate;
      }
      
      public function get initiative() : uint
      {
         return _target.initiative;
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
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
