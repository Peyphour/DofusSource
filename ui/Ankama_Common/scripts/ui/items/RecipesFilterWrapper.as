package ui.items
{
   public class RecipesFilterWrapper
   {
       
      
      public var jobId:int;
      
      public var minLevel:int;
      
      public var maxLevel:int;
      
      public var typeId:int;
      
      public function RecipesFilterWrapper(param1:int, param2:int, param3:int, param4:int = 0)
      {
         super();
         this.jobId = param1;
         this.minLevel = param2;
         this.maxLevel = param3;
         this.typeId = param4;
      }
   }
}
