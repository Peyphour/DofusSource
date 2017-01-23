package d2data
{
   import utils.ReadOnlyData;
   
   public class OrnamentWrapper extends ReadOnlyData
   {
       
      
      public function OrnamentWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get iconId() : uint
      {
         return _target.iconId;
      }
      
      public function get isOkForMultiUse() : Boolean
      {
         return _target.isOkForMultiUse;
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
   }
}
