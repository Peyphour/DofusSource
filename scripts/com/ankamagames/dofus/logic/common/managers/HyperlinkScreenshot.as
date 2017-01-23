package com.ankamagames.dofus.logic.common.managers
{
   import by.blooddy.crypto.MD5;
   import by.blooddy.crypto.image.JPEGEncoder;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.ScreenCaptureFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.ExternalGameHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class HyperlinkScreenshot
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(HyperlinkScreenshot));
      
      private static var sysApi:SystemApi = new SystemApi();
       
      
      public function HyperlinkScreenshot()
      {
         super();
      }
      
      public static function click(param1:String) : void
      {
         var _loc2_:File = new File(unescape(param1));
         var _loc3_:Object = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
         var _loc4_:Array = new Array();
         _loc4_.push(_loc3_.createContextMenuItemObject(I18n.getUiText("ui.common.openDirectory"),onOpenLocation,[_loc2_]));
         _loc4_.push(_loc3_.createContextMenuItemObject(I18n.getUiText("ui.common.socialNetworkShare"),onShareFile,[_loc2_],!_loc2_.exists));
         _loc3_.createContextMenu(_loc4_);
      }
      
      private static function onOpenLocation(param1:File) : void
      {
         if(param1.exists && param1.parent)
         {
            param1.parent.openWithDefaultApplication();
         }
      }
      
      private static function onShareFile(param1:File) : void
      {
         var fs:FileStream = null;
         var ba:ByteArray = null;
         var checkSum:String = null;
         var screenshotAsBase64:String = null;
         var pFile:File = param1;
         if(pFile.exists)
         {
            fs = new FileStream();
            try
            {
               fs.open(pFile,FileMode.READ);
            }
            catch(e:Error)
            {
               onUploadFail();
               return;
            }
            ba = new ByteArray();
            fs.readBytes(ba);
            fs.close();
            checkSum = (Kernel.getWorker().getFrame(ScreenCaptureFrame) as ScreenCaptureFrame).getChecksum(pFile.name);
            if(checkSum && MD5.hashBytes(ba) == checkSum)
            {
               screenshotAsBase64 = Base64.encodeByteArray(JPEGEncoder.encode(PNGEncoder2.decode(ba),80));
               if(screenshotAsBase64)
               {
                  if(Berilia.getInstance().getUi("sharePopup"))
                  {
                     Berilia.getInstance().unloadUi("sharePopup");
                  }
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.common.screenshot.upload",[pFile.name]),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  sysApi.getUrltoShareContent({
                     "title":I18n.getUiText("ui.social.share.staticPage.defaultTitle",[PlayedCharacterManager.getInstance().infos.name]),
                     "description":I18n.getUiText("ui.social.share.staticPage.defaultDescription"),
                     "image":screenshotAsBase64
                  },function(param1:String = null):void
                  {
                     if(param1)
                     {
                        KernelEventsManager.getInstance().processCallback(ExternalGameHookList.OpenSharePopup,param1);
                     }
                  });
               }
            }
            else
            {
               onUploadFail();
            }
         }
         else
         {
            onUploadFail();
         }
      }
      
      private static function onUploadFail() : void
      {
         KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.common.screenshot.uploadfail"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
      }
   }
}
