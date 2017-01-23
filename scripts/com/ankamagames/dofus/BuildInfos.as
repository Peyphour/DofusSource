package com.ankamagames.dofus
{
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.jerakine.types.Version;
   
   public final class BuildInfos
   {
      
      public static var BUILD_VERSION:Version = new Version(2,39,0);
      
      public static var BUILD_TYPE:uint = BuildTypeEnum.RELEASE;
      
      public static var BUILD_REVISION:int = 117547;
      
      public static var BUILD_PATCH:int = 0;
      
      public static const BUILD_DATE:String = "Jan 10, 2017 - 10:18:04 CET";
       
      
      public function BuildInfos()
      {
         super();
      }
   }
}
