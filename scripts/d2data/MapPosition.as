package d2data
{
   import utils.ReadOnlyData;
   
   public class MapPosition extends ReadOnlyData
   {
       
      
      public function MapPosition(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get posX() : int
      {
         return _target.posX;
      }
      
      public function get posY() : int
      {
         return _target.posY;
      }
      
      public function get outdoor() : Boolean
      {
         return _target.outdoor;
      }
      
      public function get capabilities() : int
      {
         return _target.capabilities;
      }
      
      public function get nameId() : int
      {
         return _target.nameId;
      }
      
      public function get showNameOnFingerpost() : Boolean
      {
         return _target.showNameOnFingerpost;
      }
      
      public function get sounds() : Object
      {
         return secure(_target.sounds);
      }
      
      public function get playlists() : Object
      {
         return secure(_target.playlists);
      }
      
      public function get subAreaId() : int
      {
         return _target.subAreaId;
      }
      
      public function get worldMap() : int
      {
         return _target.worldMap;
      }
      
      public function get hasPriorityOnWorldmap() : Boolean
      {
         return _target.hasPriorityOnWorldmap;
      }
      
      public function get isUnderWater() : Boolean
      {
         return _target.isUnderWater;
      }
   }
}
