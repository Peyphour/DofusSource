package d2data
{
   import utils.ReadOnlyData;
   
   public class MonsterDrop extends ReadOnlyData
   {
       
      
      public function MonsterDrop(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get dropId() : uint
      {
         return _target.dropId;
      }
      
      public function get monsterId() : int
      {
         return _target.monsterId;
      }
      
      public function get objectId() : int
      {
         return _target.objectId;
      }
      
      public function get percentDropForGrade1() : Number
      {
         return _target.percentDropForGrade1;
      }
      
      public function get percentDropForGrade2() : Number
      {
         return _target.percentDropForGrade2;
      }
      
      public function get percentDropForGrade3() : Number
      {
         return _target.percentDropForGrade3;
      }
      
      public function get percentDropForGrade4() : Number
      {
         return _target.percentDropForGrade4;
      }
      
      public function get percentDropForGrade5() : Number
      {
         return _target.percentDropForGrade5;
      }
      
      public function get count() : int
      {
         return _target.count;
      }
      
      public function get hasCriteria() : Boolean
      {
         return _target.hasCriteria;
      }
   }
}
