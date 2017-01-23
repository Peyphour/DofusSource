package d2data
{
   import utils.ReadOnlyData;
   
   public class Interactive extends ReadOnlyData
   {
       
      
      public function Interactive(param1:*, param2:Object)
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
      
      public function get actionId() : int
      {
         return _target.actionId;
      }
      
      public function get displayTooltip() : Boolean
      {
         return _target.displayTooltip;
      }
   }
}
