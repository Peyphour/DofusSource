package d2data
{
   import utils.ReadOnlyData;
   
   public class Notification extends ReadOnlyData
   {
       
      
      public function Notification(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get titleId() : uint
      {
         return _target.titleId;
      }
      
      public function get messageId() : uint
      {
         return _target.messageId;
      }
      
      public function get iconId() : int
      {
         return _target.iconId;
      }
      
      public function get typeId() : int
      {
         return _target.typeId;
      }
      
      public function get trigger() : String
      {
         return _target.trigger;
      }
   }
}
