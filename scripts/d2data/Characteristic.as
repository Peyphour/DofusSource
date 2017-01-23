package d2data
{
   import utils.ReadOnlyData;
   
   public class Characteristic extends ReadOnlyData
   {
       
      
      public function Characteristic(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get keyword() : String
      {
         return _target.keyword;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get asset() : String
      {
         return _target.asset;
      }
      
      public function get categoryId() : int
      {
         return _target.categoryId;
      }
      
      public function get visible() : Boolean
      {
         return _target.visible;
      }
      
      public function get order() : int
      {
         return _target.order;
      }
      
      public function get upgradable() : Boolean
      {
         return _target.upgradable;
      }
   }
}
