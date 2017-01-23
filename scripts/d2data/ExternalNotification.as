package d2data
{
   import utils.ReadOnlyData;
   
   public class ExternalNotification extends ReadOnlyData
   {
       
      
      public function ExternalNotification(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get categoryId() : int
      {
         return _target.categoryId;
      }
      
      public function get iconId() : int
      {
         return _target.iconId;
      }
      
      public function get colorId() : int
      {
         return _target.colorId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get defaultEnable() : Boolean
      {
         return _target.defaultEnable;
      }
      
      public function get defaultSound() : Boolean
      {
         return _target.defaultSound;
      }
      
      public function get defaultNotify() : Boolean
      {
         return _target.defaultNotify;
      }
      
      public function get defaultMultiAccount() : Boolean
      {
         return _target.defaultMultiAccount;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get messageId() : uint
      {
         return _target.messageId;
      }
   }
}
