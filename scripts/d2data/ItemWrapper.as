package d2data
{
   public class ItemWrapper extends Item
   {
       
      
      public function ItemWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get position() : uint
      {
         return _target.position;
      }
      
      public function get sortOrder() : uint
      {
         return _target.sortOrder;
      }
      
      public function get objectUID() : uint
      {
         return _target.objectUID;
      }
      
      public function get objectGID() : uint
      {
         return _target.objectGID;
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
      
      public function get effects() : Object
      {
         return secure(_target.effects);
      }
      
      public function get effectsList() : Object
      {
         return secure(_target.effectsList);
      }
      
      public function get livingObjectId() : uint
      {
         return _target.livingObjectId;
      }
      
      public function get livingObjectMood() : uint
      {
         return _target.livingObjectMood;
      }
      
      public function get livingObjectSkin() : uint
      {
         return _target.livingObjectSkin;
      }
      
      public function get livingObjectCategory() : uint
      {
         return _target.livingObjectCategory;
      }
      
      public function get livingObjectXp() : uint
      {
         return _target.livingObjectXp;
      }
      
      public function get livingObjectMaxXp() : uint
      {
         return _target.livingObjectMaxXp;
      }
      
      public function get livingObjectLevel() : uint
      {
         return _target.livingObjectLevel;
      }
      
      public function get livingObjectFoodDate() : String
      {
         return _target.livingObjectFoodDate;
      }
      
      public function get wrapperObjectCategory() : uint
      {
         return _target.wrapperObjectCategory;
      }
      
      public function get presetIcon() : int
      {
         return _target.presetIcon;
      }
      
      public function get exchangeAllowed() : Boolean
      {
         return _target.exchangeAllowed;
      }
      
      public function get isPresetObject() : Boolean
      {
         return _target.isPresetObject;
      }
      
      public function get isOkForMultiUse() : Boolean
      {
         return _target.isOkForMultiUse;
      }
   }
}
