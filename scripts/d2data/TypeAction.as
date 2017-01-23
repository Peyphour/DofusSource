package d2data
{
   import utils.ReadOnlyData;
   
   public class TypeAction extends ReadOnlyData
   {
       
      
      public function TypeAction(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get elementName() : String
      {
         return _target.elementName;
      }
      
      public function get elementId() : int
      {
         return _target.elementId;
      }
   }
}
