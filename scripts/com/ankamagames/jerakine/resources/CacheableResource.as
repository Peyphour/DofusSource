package com.ankamagames.jerakine.resources
{
   public class CacheableResource
   {
       
      
      public var resource;
      
      public var resourceType:uint;
      
      public function CacheableResource(param1:uint, param2:*)
      {
         super();
         this.resourceType = param1;
         this.resource = param2;
      }
   }
}
