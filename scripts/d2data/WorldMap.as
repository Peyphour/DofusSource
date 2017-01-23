package d2data
{
   import utils.ReadOnlyData;
   
   public class WorldMap extends ReadOnlyData
   {
       
      
      public function WorldMap(param1:*, param2:Object)
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
      
      public function get origineX() : int
      {
         return _target.origineX;
      }
      
      public function get origineY() : int
      {
         return _target.origineY;
      }
      
      public function get mapWidth() : Number
      {
         return _target.mapWidth;
      }
      
      public function get mapHeight() : Number
      {
         return _target.mapHeight;
      }
      
      public function get horizontalChunck() : uint
      {
         return _target.horizontalChunck;
      }
      
      public function get verticalChunck() : uint
      {
         return _target.verticalChunck;
      }
      
      public function get viewableEverywhere() : Boolean
      {
         return _target.viewableEverywhere;
      }
      
      public function get minScale() : Number
      {
         return _target.minScale;
      }
      
      public function get maxScale() : Number
      {
         return _target.maxScale;
      }
      
      public function get startScale() : Number
      {
         return _target.startScale;
      }
      
      public function get centerX() : int
      {
         return _target.centerX;
      }
      
      public function get centerY() : int
      {
         return _target.centerY;
      }
      
      public function get totalWidth() : int
      {
         return _target.totalWidth;
      }
      
      public function get totalHeight() : int
      {
         return _target.totalHeight;
      }
      
      public function get zoom() : Object
      {
         return secure(_target.zoom);
      }
   }
}
