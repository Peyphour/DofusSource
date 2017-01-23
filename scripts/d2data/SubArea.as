package d2data
{
   import utils.ReadOnlyData;
   
   public class SubArea extends ReadOnlyData
   {
       
      
      public function SubArea(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get areaId() : int
      {
         return _target.areaId;
      }
      
      public function get ambientSounds() : Object
      {
         return secure(_target.ambientSounds);
      }
      
      public function get playlists() : Object
      {
         return secure(_target.playlists);
      }
      
      public function get mapIds() : Object
      {
         return secure(_target.mapIds);
      }
      
      public function get bounds() : Object
      {
         return secure(_target.bounds);
      }
      
      public function get shape() : Object
      {
         return secure(_target.shape);
      }
      
      public function get customWorldMap() : Object
      {
         return secure(_target.customWorldMap);
      }
      
      public function get packId() : int
      {
         return _target.packId;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get isConquestVillage() : Boolean
      {
         return _target.isConquestVillage;
      }
      
      public function get basicAccountAllowed() : Boolean
      {
         return _target.basicAccountAllowed;
      }
      
      public function get displayOnWorldMap() : Boolean
      {
         return _target.displayOnWorldMap;
      }
      
      public function get monsters() : Object
      {
         return secure(_target.monsters);
      }
      
      public function get entranceMapIds() : Object
      {
         return secure(_target.entranceMapIds);
      }
      
      public function get exitMapIds() : Object
      {
         return secure(_target.exitMapIds);
      }
      
      public function get capturable() : Boolean
      {
         return _target.capturable;
      }
      
      public function get achievements() : Object
      {
         return secure(_target.achievements);
      }
      
      public function get quests() : Object
      {
         return secure(_target.quests);
      }
      
      public function get npcs() : Object
      {
         return secure(_target.npcs);
      }
      
      public function get exploreAchievementId() : int
      {
         return _target.exploreAchievementId;
      }
      
      public function get isDiscovered() : Boolean
      {
         return _target.isDiscovered;
      }
      
      public function get harvestables() : Object
      {
         return secure(_target.harvestables);
      }
   }
}
