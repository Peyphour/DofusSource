package d2data
{
   import d2network.EntityLook;
   import utils.ReadOnlyData;
   
   public class PartyMemberWrapper extends ReadOnlyData
   {
       
      
      public function PartyMemberWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get isMember() : Boolean
      {
         return _target.isMember;
      }
      
      public function get isLeader() : Boolean
      {
         return _target.isLeader;
      }
      
      public function get level() : int
      {
         return _target.level;
      }
      
      public function get breedId() : int
      {
         return _target.breedId;
      }
      
      public function get entityLook() : EntityLook
      {
         return secure(_target.entityLook);
      }
      
      public function get lifePoints() : int
      {
         return _target.lifePoints;
      }
      
      public function get maxLifePoints() : int
      {
         return _target.maxLifePoints;
      }
      
      public function get maxInitiative() : int
      {
         return _target.maxInitiative;
      }
      
      public function get prospecting() : int
      {
         return _target.prospecting;
      }
      
      public function get rank() : int
      {
         return _target.rank;
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
      
      public function get regenRate() : int
      {
         return _target.regenRate;
      }
      
      public function get hostId() : Number
      {
         return _target.hostId;
      }
      
      public function get hostName() : String
      {
         return _target.hostName;
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
      
      public function get status() : uint
      {
         return _target.status;
      }
      
      public function get companions() : Object
      {
         return secure(_target.companions);
      }
   }
}
