package d2data
{
   import utils.ReadOnlyData;
   
   public class SpouseWrapper extends ReadOnlyData
   {
       
      
      public function SpouseWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
      
      public function get entityLook() : Object
      {
         return secure(_target.entityLook);
      }
      
      public function get level() : int
      {
         return _target.level;
      }
      
      public function get breed() : uint
      {
         return _target.breed;
      }
      
      public function get sex() : int
      {
         return _target.sex;
      }
      
      public function get online() : Boolean
      {
         return _target.online;
      }
      
      public function get mapId() : uint
      {
         return _target.mapId;
      }
      
      public function get subareaId() : uint
      {
         return _target.subareaId;
      }
      
      public function get inFight() : Boolean
      {
         return _target.inFight;
      }
      
      public function get followSpouse() : Boolean
      {
         return _target.followSpouse;
      }
      
      public function get guildName() : String
      {
         return _target.guildName;
      }
      
      public function get guildId() : uint
      {
         return _target.guildId;
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
   }
}
