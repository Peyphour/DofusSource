package d2data
{
   import utils.ReadOnlyData;
   
   public class ChatChannel extends ReadOnlyData
   {
       
      
      public function ChatChannel(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get shortcut() : String
      {
         return _target.shortcut;
      }
      
      public function get shortcutKey() : String
      {
         return _target.shortcutKey;
      }
      
      public function get isPrivate() : Boolean
      {
         return _target.isPrivate;
      }
      
      public function get allowObjects() : Boolean
      {
         return _target.allowObjects;
      }
   }
}
