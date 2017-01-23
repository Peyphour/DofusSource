package d2data
{
   import utils.ReadOnlyData;
   
   public class EmblemSymbol extends ReadOnlyData
   {
       
      
      public function EmblemSymbol(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get iconId() : int
      {
         return _target.iconId;
      }
      
      public function get skinId() : int
      {
         return _target.skinId;
      }
      
      public function get order() : int
      {
         return _target.order;
      }
      
      public function get categoryId() : int
      {
         return _target.categoryId;
      }
      
      public function get colorizable() : Boolean
      {
         return _target.colorizable;
      }
   }
}
