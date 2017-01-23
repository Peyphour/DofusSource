package d2data
{
   import utils.ReadOnlyData;
   
   public class AchievementCategory extends ReadOnlyData
   {
       
      
      public function AchievementCategory(param1:*, param2:Object)
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
      
      public function get parentId() : uint
      {
         return _target.parentId;
      }
      
      public function get icon() : String
      {
         return _target.icon;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
      
      public function get color() : String
      {
         return _target.color;
      }
      
      public function get achievementIds() : Object
      {
         return secure(_target.achievementIds);
      }
   }
}
