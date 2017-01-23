package d2data
{
   import utils.ReadOnlyData;
   
   public class Quest extends ReadOnlyData
   {
       
      
      public function Quest(param1:*, param2:Object)
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
      
      public function get stepIds() : Object
      {
         return secure(_target.stepIds);
      }
      
      public function get categoryId() : uint
      {
         return _target.categoryId;
      }
      
      public function get repeatType() : uint
      {
         return _target.repeatType;
      }
      
      public function get repeatLimit() : uint
      {
         return _target.repeatLimit;
      }
      
      public function get isDungeonQuest() : Boolean
      {
         return _target.isDungeonQuest;
      }
      
      public function get levelMin() : uint
      {
         return _target.levelMin;
      }
      
      public function get levelMax() : uint
      {
         return _target.levelMax;
      }
      
      public function get isPartyQuest() : Boolean
      {
         return _target.isPartyQuest;
      }
      
      public function get startCriterion() : String
      {
         return _target.startCriterion;
      }
   }
}
