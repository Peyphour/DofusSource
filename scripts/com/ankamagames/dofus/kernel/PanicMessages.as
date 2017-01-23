package com.ankamagames.dofus.kernel
{
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.misc.utils.ParamsDecoder;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.jerakine.data.XmlConfig;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   
   public final class PanicMessages
   {
      
      private static const _i18nFile:Class = PanicMessages__i18nFile;
      
      private static const _bytes:ByteArray = new _i18nFile() as ByteArray;
      
      private static const _i18n = by.blooddy.crypto.serialization.JSON.decode(_bytes.readUTFBytes(_bytes.bytesAvailable));
      
      private static const SUPPORT_URL:String = "https://support.ankama.com/";
      
      public static const CONFIG_LOADING_FAILED:uint = 1;
      
      public static const I18N_LOADING_FAILED:uint = 2;
      
      public static const WRONG_CONTEXT_CREATED:uint = 3;
      
      public static const PROTOCOL_TOO_OLD:uint = 4;
      
      public static const PROTOCOL_TOO_NEW:uint = 5;
      
      public static const TOO_MANY_CLIENTS:uint = 6;
      
      public static const UNABLE_TO_GET_FLASHKEY:uint = 7;
       
      
      public function PanicMessages()
      {
         super();
      }
      
      public static function getMessage(param1:uint, param2:Array) : String
      {
         var _loc3_:String = XmlConfig.getInstance().getEntry("config.lang.current");
         if(!_loc3_)
         {
            _loc3_ = Capabilities.language;
         }
         _loc3_ = !_i18n[_loc3_]?"en":_loc3_;
         var _loc4_:String = "error" + param1;
         var _loc5_:String = !_i18n[_loc3_][_loc4_]?_i18n[_loc3_]["unknown"]:_i18n[_loc3_][_loc4_];
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA)
         {
            _loc5_ = _loc5_ + ("\n" + _i18n[_loc3_]["update"]);
         }
         else
         {
            _loc5_ = _loc5_ + ("\n" + _i18n[_loc3_]["support"] + " <a href=\'" + SUPPORT_URL + "\'><font color=\'#ffd376\'><b>" + SUPPORT_URL + "</b></font></a>");
         }
         return !!_loc5_?ParamsDecoder.applyParams(_loc5_,param2):"";
      }
   }
}
