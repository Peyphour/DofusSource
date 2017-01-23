package d2data
{
   import utils.ReadOnlyData;
   
   public class ContextMenuData extends ReadOnlyData
   {
       
      
      public function ContextMenuData(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get data() : *
      {
         return secure(_target.data);
      }
      
      public function get makerName() : String
      {
         return _target.makerName;
      }
      
      public function get content() : Object
      {
         return secure(_target.content);
      }
   }
}
