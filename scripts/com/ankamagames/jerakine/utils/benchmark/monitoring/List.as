package com.ankamagames.jerakine.utils.benchmark.monitoring
{
   public class List
   {
       
      
      public var value:Object;
      
      public var next:List;
      
      public function List(param1:Object, param2:List = null)
      {
         super();
         this.value = param1;
         this.next = param2;
      }
   }
}
