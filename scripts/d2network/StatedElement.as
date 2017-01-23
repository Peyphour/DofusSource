package d2network
{
   import utils.ReadOnlyData;
   
   public class StatedElement extends ReadOnlyData
   {
       
      
      public function StatedElement(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get elementId() : uint
      {
         return _target.elementId;
      }
      
      public function get elementCellId() : uint
      {
         return _target.elementCellId;
      }
      
      public function get elementState() : uint
      {
         return _target.elementState;
      }
      
      public function get onCurrentMap() : Boolean
      {
         return _target.onCurrentMap;
      }
   }
}
