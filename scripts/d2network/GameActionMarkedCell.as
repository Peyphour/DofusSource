package d2network
{
   import utils.ReadOnlyData;
   
   public class GameActionMarkedCell extends ReadOnlyData
   {
       
      
      public function GameActionMarkedCell(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get cellId() : uint
      {
         return _target.cellId;
      }
      
      public function get zoneSize() : int
      {
         return _target.zoneSize;
      }
      
      public function get cellColor() : int
      {
         return _target.cellColor;
      }
      
      public function get cellsType() : int
      {
         return _target.cellsType;
      }
   }
}
