package d2api
{
   import d2components.SwfApplication;
   import d2components.WebBrowser;
   import d2data.DareWrapper;
   import d2data.Server;
   import d2network.Version;
   
   public class SystemApi
   {
       
      
      public function SystemApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function isInGame() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function isLoggingWithTicket() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function addHook(param1:Class, param2:Function) : void
      {
      }
      
      [Untrusted]
      public function removeHook(param1:Class) : void
      {
      }
      
      [Untrusted]
      public function createHook(param1:String) : void
      {
      }
      
      [Untrusted]
      public function dispatchHook(param1:Class, ... rest) : void
      {
      }
      
      [Untrusted]
      public function sendAction(param1:Object) : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function log(param1:uint, param2:*) : void
      {
      }
      
      [Untrusted]
      public function getClientId() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getNumberOfClients() : uint
      {
         return 0;
      }
      
      [Trusted]
      public function setConfigEntry(param1:String, param2:*) : void
      {
      }
      
      [Untrusted]
      public function getConfigEntry(param1:String) : *
      {
         return null;
      }
      
      [Trusted]
      public function getEnum(param1:String) : Object
      {
         return null;
      }
      
      [Trusted]
      public function isEventMode() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function isCharacterCreationAllowed() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function getConfigKey(param1:String) : *
      {
         return null;
      }
      
      [Trusted]
      public function goToUrl(param1:String) : void
      {
      }
      
      [Trusted]
      public function getPlayerManager() : Object
      {
         return null;
      }
      
      [Trusted]
      public function getPort() : uint
      {
         return 0;
      }
      
      [Trusted]
      public function setPort(param1:uint) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function setData(param1:String, param2:*, param3:int = 2) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getSetData(param1:String, param2:*, param3:int = 2) : *
      {
         return null;
      }
      
      [Untrusted]
      public function setQualityIsEnable() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function hasAir() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getAirVersion() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function isAirVersionAvailable(param1:uint) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function setAirVersion(param1:uint) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getOs() : String
      {
         return null;
      }
      
      [Untrusted]
      public function getOsVersion() : String
      {
         return null;
      }
      
      [Untrusted]
      public function getCpu() : String
      {
         return null;
      }
      
      [Untrusted]
      public function getBrowser() : String
      {
         return null;
      }
      
      [Untrusted]
      public function getData(param1:String, param2:int = 2) : *
      {
         return null;
      }
      
      [Untrusted]
      public function getOption(param1:String, param2:String) : *
      {
         return null;
      }
      
      [Untrusted]
      public function callbackHook(param1:Object, ... rest) : void
      {
      }
      
      [Untrusted]
      public function showWorld(param1:Boolean) : void
      {
      }
      
      [Untrusted]
      public function worldIsVisible() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getServerStatus() : uint
      {
         return 0;
      }
      
      [Trusted]
      public function getConsoleAutoCompletion(param1:String, param2:Boolean) : String
      {
         return null;
      }
      
      [Trusted]
      public function getAutoCompletePossibilities(param1:String, param2:Boolean = false) : Object
      {
         return null;
      }
      
      [Trusted]
      public function getAutoCompletePossibilitiesOnParam(param1:String, param2:Boolean = false, param3:uint = 0, param4:Object = null) : Object
      {
         return null;
      }
      
      [Trusted]
      public function getCmdHelp(param1:String, param2:Boolean = false) : String
      {
         return null;
      }
      
      [Untrusted]
      public function startChrono(param1:String) : void
      {
      }
      
      [Untrusted]
      public function stopChrono() : void
      {
      }
      
      [Trusted]
      public function hasAdminCommand(param1:String) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function addEventListener(param1:Function, param2:String, param3:uint = 25) : void
      {
      }
      
      [Trusted]
      public function removeEventListener(param1:Function) : void
      {
      }
      
      [Trusted]
      public function disableWorldInteraction(param1:Boolean = true) : void
      {
      }
      
      [Trusted]
      public function enableWorldInteraction() : void
      {
      }
      
      [Trusted]
      public function setFrameRate(param1:uint) : void
      {
      }
      
      [Trusted]
      public function hasWorldInteraction() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function hasRight() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isFightContext() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getEntityLookFromString(param1:String) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getCurrentVersion() : Version
      {
         return null;
      }
      
      [Untrusted]
      public function getBuildType() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getCurrentLanguage() : String
      {
         return null;
      }
      
      [Trusted]
      public function clearCache(param1:Boolean = false) : void
      {
      }
      
      [Trusted]
      public function reset() : void
      {
      }
      
      [Untrusted]
      public function getCurrentServer() : Server
      {
         return null;
      }
      
      [Trusted]
      public function getGroundCacheSize() : Number
      {
         return 0;
      }
      
      [Trusted]
      public function clearGroundCache() : void
      {
      }
      
      [Trusted]
      public function zoom(param1:Number) : void
      {
      }
      
      [Trusted]
      public function getCurrentZoom() : Number
      {
         return 0;
      }
      
      [Trusted]
      public function goToThirdPartyLogin(param1:WebBrowser) : void
      {
      }
      
      [Trusted]
      public function goToOgrinePortal(param1:WebBrowser) : void
      {
      }
      
      [Trusted]
      public function goToWebAuthentification(param1:WebBrowser, param2:String) : String
      {
         return null;
      }
      
      [Trusted]
      public function openWebModalOgrinePortal(param1:Function = null, param2:Function = null) : void
      {
      }
      
      [Trusted]
      public function goToAnkaBoxPortal(param1:WebBrowser) : void
      {
      }
      
      [Trusted]
      public function goToAnkaBoxLastMessage(param1:WebBrowser) : void
      {
      }
      
      [Trusted]
      public function goToAnkaBoxSend(param1:WebBrowser, param2:Number) : void
      {
      }
      
      [Trusted]
      public function goToSupportFAQ(param1:String) : void
      {
      }
      
      [Trusted]
      public function goToChangelogPortal(param1:WebBrowser) : void
      {
      }
      
      [Trusted]
      public function goToCheckLink(param1:String, param2:Number, param3:String) : void
      {
      }
      
      [Trusted]
      public function goToDare(param1:DareWrapper) : void
      {
      }
      
      [Trusted]
      public function setFlashCommicReaderApp(param1:SwfApplication) : void
      {
      }
      
      [Trusted]
      public function goToWebReader(param1:WebBrowser, param2:String) : void
      {
      }
      
      [Trusted]
      public function refreshUrl(param1:WebBrowser, param2:uint = 0) : void
      {
      }
      
      [Trusted]
      public function execServerCmd(param1:String) : void
      {
      }
      
      [Trusted]
      public function mouseZoom(param1:Boolean = true) : void
      {
      }
      
      [Trusted]
      public function resetZoom() : void
      {
      }
      
      [Trusted]
      public function getMaxZoom() : uint
      {
         return 0;
      }
      
      [Trusted]
      public function optimize() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function hasPart(param1:String) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function hasUpdaterConnection() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isDownloading() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isStreaming() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isDevMode() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isDownloadFinished() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function notifyUser(param1:Boolean) : void
      {
      }
      
      [Untrusted]
      public function setGameAlign(param1:String) : void
      {
      }
      
      [Untrusted]
      public function getGameAlign() : String
      {
         return null;
      }
      
      [Untrusted]
      public function getDirectoryContent(param1:String = ".") : Object
      {
         return null;
      }
      
      [Untrusted]
      public function isSteamEmbed() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function setMouseCursor(param1:String) : void
      {
      }
      
      [Trusted]
      public function getAccountId(param1:String) : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getIsAnkaBoxEnabled() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function getAdminStatus() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getObjectVariables(param1:Object, param2:Boolean = false, param3:Boolean = false) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getNewDynamicSecureObject() : Object
      {
         return null;
      }
      
      [Trusted]
      public function sendStatisticReport(param1:String, param2:String) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function isStatisticReported(param1:String) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function getNickname() : String
      {
         return null;
      }
      
      [Trusted]
      public function copyToClipboard(param1:String) : void
      {
      }
      
      [Trusted]
      public function getLaunchArgs() : String
      {
         return null;
      }
      
      [Trusted]
      public function getPartnerInfo() : String
      {
         return null;
      }
      
      [Trusted]
      public function toggleModuleInstaller() : void
      {
      }
      
      [Trusted]
      public function toggleThemeInstaller() : void
      {
      }
      
      [Trusted]
      public function isUpdaterVersion2OrUnknown() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isKeyDown(param1:uint) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function isGuest() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function isInForcedGuestMode() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function convertGuestAccount() : void
      {
      }
      
      [Trusted]
      public function getGiftList() : Object
      {
         return null;
      }
      
      [Trusted]
      public function getCharaListMinusDeadPeople() : Object
      {
         return null;
      }
      
      [Trusted]
      public function removeFocus() : void
      {
      }
      
      [Trusted]
      public function toggleProto169() : void
      {
      }
      
      [Trusted]
      public function toggleBordersMinimap() : void
      {
      }
      
      [Trusted]
      public function getUrltoShareContent(param1:Object, param2:Function, param3:String = null) : void
      {
      }
      
      [Untrusted]
      public function changeActiveFontType(param1:String) : void
      {
      }
      
      [Untrusted]
      public function getActiveFontType() : String
      {
         return null;
      }
   }
}
