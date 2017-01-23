package d2data
{
   import utils.ReadOnlyData;
   
   public class GridItem extends ReadOnlyData
   {
       
      
      public function GridItem(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get index() : uint
      {
         return _target.index;
      }
      
      public function get container() : Object
      {
         return secure(_target.container);
      }
      
      public function get data() : *
      {
         return secure(_target.data);
      }
   }
}
