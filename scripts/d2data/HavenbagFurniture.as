package d2data
{
   import utils.ReadOnlyData;
   
   public class HavenbagFurniture extends ReadOnlyData
   {
       
      
      public function HavenbagFurniture(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get typeId() : int
      {
         return _target.typeId;
      }
      
      public function get themeId() : int
      {
         return _target.themeId;
      }
      
      public function get elementId() : int
      {
         return _target.elementId;
      }
      
      public function get color() : int
      {
         return _target.color;
      }
      
      public function get skillId() : int
      {
         return _target.skillId;
      }
      
      public function get layerId() : int
      {
         return _target.layerId;
      }
      
      public function get blocksMovement() : Boolean
      {
         return _target.blocksMovement;
      }
      
      public function get isStackable() : Boolean
      {
         return _target.isStackable;
      }
      
      public function get cellsWidth() : uint
      {
         return _target.cellsWidth;
      }
      
      public function get cellsHeight() : uint
      {
         return _target.cellsHeight;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
   }
}
