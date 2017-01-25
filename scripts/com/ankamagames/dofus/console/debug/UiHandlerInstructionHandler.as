package com.ankamagames.dofus.console.debug
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.berilia.components.TextureBase;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.CssManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.ThemeManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.tooltip.TooltipBlock;
   import com.ankamagames.berilia.utils.ModuleScriptAnalyzer;
   import com.ankamagames.dofus.console.moduleLogger.Console;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkDisplayArrowManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.utils.Inspector;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.document.ComicReadingBeginMessage;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManagerUtils;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.display.BitmapData;
   import flash.filesystem.File;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class UiHandlerInstructionHandler implements ConsoleInstructionHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiHandlerInstructionHandler));
       
      
      private var _uiInspector:Inspector;
      
      private var _autoReloadManagers:Dictionary;
      
      public function UiHandlerInstructionHandler()
      {
         this._autoReloadManagers = new Dictionary();
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var uiName:String = null;
         var instanceName:String = null;
         var c:Dictionary = null;
         var totalBitmapsInCache:uint = 0;
         var ramFromBitmapInCache:uint = 0;
         var tmpArr:Array = null;
         var bd:BitmapData = null;
         var bdSize:uint = 0;
         var comicId:int = 0;
         var msg:ComicReadingBeginMessage = null;
         var frame:RoleplayContextFrame = null;
         var currentUiList:Dictionary = null;
         var uiOutput:Array = null;
         var ml:Array = null;
         var mod:UiModule = null;
         var m:Array = null;
         var um:UiModule = null;
         var toggleChat:Boolean = false;
         var value:Boolean = false;
         var uiTarget:UiRootContainer = null;
         var elemTarget:GraphicContainer = null;
         var xmlName:String = null;
         var uiData:UiData = null;
         var fontLocation:String = null;
         var _aFiles:Array = null;
         var fingerPrint:String = null;
         var module:UiModule = null;
         var uriPath:String = null;
         var tmpOjb:* = undefined;
         var count:uint = 0;
         var uiList:Array = null;
         var i:String = null;
         var ui:UiData = null;
         var ma:ModuleScriptAnalyzer = null;
         var modul:UiModule = null;
         var oldUiData:UiData = null;
         var j:uint = 0;
         var console:ConsoleHandler = param1;
         var cmd:String = param2;
         var args:Array = param3;
         switch(cmd)
         {
            case "loadui":
               uiName = args[0];
               instanceName = "";
               if(args[1])
               {
                  instanceName = args[1];
               }
               for each(module in UiModuleManager.getInstance().getModules())
               {
                  if(module.getUi(uiName))
                  {
                     Berilia.getInstance().loadUi(module,module.getUi(uiName),instanceName,null,true);
                     break;
                  }
               }
               break;
            case "showarrow":
               HyperlinkDisplayArrowManager.showArrow.apply(null,args);
               break;
            case "texturebitmapcache":
               c = TextureBase.getBitmapCache();
               totalBitmapsInCache = 0;
               ramFromBitmapInCache = 0;
               tmpArr = [];
               for(uriPath in c)
               {
                  bd = c[uriPath];
                  bdSize = bd.width * bd.height * 4;
                  tmpArr.push({
                     "uri":uriPath,
                     "bitmapData":bd,
                     "size":bdSize
                  });
                  totalBitmapsInCache++;
                  ramFromBitmapInCache = ramFromBitmapInCache + bdSize;
               }
               tmpArr.sortOn(["size","uri"],[Array.DESCENDING | Array.NUMERIC,Array.CASEINSENSITIVE]);
               for each(tmpOjb in tmpArr)
               {
                  console.output(tmpOjb.uri + ", " + tmpOjb.bitmapData.width + "x" + tmpOjb.bitmapData.height + ", size: " + FpsManagerUtils.calculateMB(tmpOjb.size) + "MB");
               }
               console.output(">> " + totalBitmapsInCache + " BitmapData in cache for a total of " + FpsManagerUtils.calculateMB(ramFromBitmapInCache) + "MB");
               break;
            case "debugwebreader":
               comicId = 1111;
               if(args && args[0])
               {
                  comicId = parseInt(args[0]);
               }
               msg = new ComicReadingBeginMessage();
               msg.initComicReadingBeginMessage(comicId);
               frame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
               if(frame)
               {
                  frame.process(msg);
               }
               else
               {
                  console.output("Failed to open the webReader, you need to be in Roleplay context for that!");
               }
               break;
            case "unloadui":
               if(args.length == 0)
               {
                  count = 0;
                  uiList = [];
                  for(i in Berilia.getInstance().uiList)
                  {
                     if(Berilia.getInstance().uiList[i].name != "Console")
                     {
                        uiList.push(Berilia.getInstance().uiList[i].name);
                     }
                  }
                  for each(i in uiList)
                  {
                     Berilia.getInstance().unloadUi(i);
                  }
                  console.output(uiList.length + " UI were unload");
                  break;
               }
               if(Berilia.getInstance().unloadUi(args[0]))
               {
                  console.output("RIP " + args[0]);
               }
               else
               {
                  console.output(args[0] + " does not exist or an error occured while unloading UI");
               }
               break;
            case "autoreloadui":
               Berilia.getInstance().autoReloadUiOnChange = !Berilia.getInstance().autoReloadUiOnChange;
               break;
            case "clearuicache":
               if(args && args[0])
               {
                  UiRenderManager.getInstance().clearCacheFromUiName(args[0]);
               }
               else
               {
                  UiRenderManager.getInstance().clearCache();
               }
               ThemeManager.getInstance().loadThemeData();
               break;
            case "clearcsscache":
               CssManager.clear(true);
               break;
            case "cleartooltipcache":
               TooltipManager.clearCache();
               TooltipBlock.clearCache();
               break;
            case "clearthemedata":
               ThemeManager.getInstance().clearThemeData();
               ThemeManager.getInstance().loadThemeData();
               break;
            case "setuiscale":
               Berilia.getInstance().scale = Number(args[0]);
               break;
            case "useuicache":
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_DEFINITION,"useCache",args[0] == "true");
               BeriliaConstants.USE_UI_CACHE = args[0] == "true";
               break;
            case "uilist":
               currentUiList = Berilia.getInstance().uiList;
               uiOutput = [];
               for(uiName in currentUiList)
               {
                  ui = UiRootContainer(currentUiList[uiName]).uiData;
                  uiOutput.push([uiName,ui.name,ui.uiClassName,ui.module.id,ui.module.trusted]);
               }
               console.output(StringUtils.formatArray(uiOutput,["Instance ID","Ui name","Class","Module","Trusted"]));
               break;
            case "reloadui":
               if(args[0])
               {
                  UiModuleManager.getInstance().loadModule(args[0]);
               }
               else
               {
                  console.output("Failed to reload ui, no id found in command arguments");
               }
               break;
            case "modulelist":
               ml = [];
               m = UiModuleManager.getInstance().getModules();
               for each(mod in m)
               {
                  ml.push([mod.id,mod.author,mod.trusted,true]);
               }
               m = UiModuleManager.getInstance().disabledModules;
               if(m.length)
               {
                  for each(mod in m)
                  {
                     ml.push([mod.id,mod.author,mod.trusted,false]);
                  }
               }
               console.output(StringUtils.formatArray(ml,["ID","Author","Trusted","Active"]));
               break;
            case "getmoduleinfo":
               um = UiModuleManager.getInstance().getModule(args[0]);
               if(um)
               {
                  ma = new ModuleScriptAnalyzer(um,null);
               }
               else
               {
                  console.output("Module " + args[0] + " does not exists");
               }
               break;
            case "chatoutput":
               toggleChat = !args.length || String(args[0]).toLowerCase() == "true" || String(args[0]).toLowerCase() == "on";
               Console.getInstance().chatMode = toggleChat;
               Console.getInstance().display();
               Console.getInstance().disableLogEvent();
               KernelEventsManager.getInstance().processCallback(ChatHookList.ToggleChatLog,toggleChat);
               value = OptionManager.getOptionManager("chat")["chatoutput"];
               OptionManager.getOptionManager("chat")["chatoutput"] = toggleChat;
               if(toggleChat)
               {
                  console.output("Chatoutput is on.");
               }
               else
               {
                  console.output("Chatoutput is off.");
               }
               break;
            case "uiinspector":
            case "inspector":
               if(!this._uiInspector)
               {
                  this._uiInspector = new Inspector();
               }
               this._uiInspector.enable = !this._uiInspector.enable;
               this._uiInspector.hierachicalMode = args.length == 0?true:args[1] == "false";
               if(this._uiInspector.enable)
               {
                  console.output("Inspector is ON.\n Use Ctrl-C to save the last hovered element informations.");
               }
               else
               {
                  console.output("Inspector is OFF.");
               }
               break;
            case "inspectuielementsos":
            case "inspectuielement":
               if(args.length == 0)
               {
                  console.output(cmd + " need at least one argument (" + cmd + " uiName [uiElementName])");
                  break;
               }
               uiTarget = Berilia.getInstance().getUi(args[0]);
               if(!uiTarget)
               {
                  console.output("UI " + args[0] + " not found (use /uilist to grab current displayed UI list)");
                  break;
               }
               if(args.length == 1)
               {
                  this.inspectUiElement(uiTarget,cmd == "inspectuielementsos"?null:console);
                  break;
               }
               elemTarget = uiTarget.getElement(args[1]);
               if(!elemTarget)
               {
                  console.output("UI Element " + args[0] + " not found on UI " + args[0] + "(use /uiinspector to view elements names)");
                  break;
               }
               this.inspectUiElement(elemTarget,cmd == "inspectuielementsos"?null:console);
               break;
            case "loadprotoxml":
               xmlName = args[0];
               UiRenderManager.getInstance().clearCacheFromUiName("proto");
               if(Berilia.getInstance().unloadUi("prototype"))
               {
                  console.output("Déchargement de l\'interface de prototype");
               }
               for each(modul in UiModuleManager.getInstance().getModules())
               {
                  if(modul.getUi("prototype"))
                  {
                     oldUiData = modul.getUi("prototype");
                     if(xmlName.indexOf(".xml") == -1)
                     {
                        xmlName = xmlName + ".xml";
                     }
                     uiData = new UiData(oldUiData.module,oldUiData.name,xmlName,oldUiData.uiClassName,oldUiData.uiGroupName);
                     uiData.uiClass = oldUiData.uiClass;
                     Berilia.getInstance().loadUi(modul,uiData,"prototype",null,true,StrataEnum.STRATA_TOP,false,null,false,false);
                     console.output("Chargement de l\'interface de prototype");
                     break;
                  }
               }
               break;
            case "changefonttype":
               fontLocation = LangManager.getInstance().getEntry("config.ui.asset.fontsList");
               _aFiles = [];
               _aFiles.push(LangManager.getInstance().getEntry("config.ui.asset.fontsList"));
               j = 0;
               while(j < _aFiles.length)
               {
                  FontManager.getInstance().loadFile(_aFiles[j]);
                  j++;
               }
               setTimeout(function():void
               {
                  FontManager.getInstance().activeType = args.length == 0?FontManager.DEFAULT_FONT_TYPE:args[0];
               },500);
               break;
            case "resetuisavedusermodification":
               Berilia.getInstance().resetUiSavedUserModification(args[0]);
               break;
            case "getthemefingerprint":
               fingerPrint = MD5.hash(this.getFilesFingerPrints(new Uri(LangManager.getInstance().getEntry("config.ui.skin")).toFile()));
               console.output("Finger print du theme actif : " + fingerPrint);
         }
      }
      
      private function getFilesFingerPrints(param1:File) : String
      {
         var _loc4_:File = null;
         var _loc2_:String = "";
         var _loc3_:Array = param1.getDirectoryListing();
         _loc3_.sortOn("name");
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.isDirectory)
            {
               _loc2_ = _loc2_ + this.getFilesFingerPrints(_loc4_);
            }
            else
            {
               _loc2_ = _loc2_ + _loc4_.size;
            }
         }
         return _loc2_;
      }
      
      private function inspectUiElement(param1:GraphicContainer, param2:ConsoleHandler) : void
      {
         var txt:String = null;
         var property:String = null;
         var type:String = null;
         var target:GraphicContainer = param1;
         var console:ConsoleHandler = param2;
         var properties:Array = DescribeTypeCache.getVariables(target).concat();
         properties.sort();
         for each(property in properties)
         {
            try
            {
               type = target[property] != null?getQualifiedClassName(target[property]).split("::").pop():"?";
               if(type == "Array")
               {
                  type = type + (", len: " + target[property].length);
               }
               txt = property + " (" + type + ") : " + target[property];
            }
            catch(e:Error)
            {
               txt = property + " (?) : <Exception throw by getter>";
            }
            if(!console)
            {
               _log.info(txt);
            }
            else
            {
               console.output(txt);
            }
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "loadui":
               return "Load an UI. Usage: loadUi <uiId> <uiInstanceName>(optional)";
            case "debugwebreader":
               return "Load the webReader UI in a Debug mode, you can specify the document_id from tbl_game_client_comics_reader optionally. Usage: debugReader <comicId>(optional)";
            case "unloadui":
               return "Unload UI with the given UI instance name.";
            case "clearuicache":
               return "Clear an UI/all UIs (if no paramter) in cache (will force xml parsing)";
            case "setuiscale":
               return "Set scale for all scalable UI. Usage: setUiScale <Number> (100% = 1.0)";
            case "useuicache":
               return "Enable UI caching";
            case "uilist":
               return "Get current UI list";
            case "reloadui":
               return "Unload and reload an UI/all UIs (if no paramter))";
            case "chatoutput":
               return "Display the chat content in a separated window.";
            case "modulelist":
               return "Display activated modules.";
            case "inspector":
            case "uiinspector":
               return "Display a tooltip with informations over each interactive element";
            case "inspectuielement":
               return "Display the property list of an UI element (UI or Component), usage /inspectuielement uiName (elementName)";
            case "inspectuielementsos":
               return "Display the property list of an UI element (UI or Component) to SOS, usage /inspectuielement uiName (elementName)";
            case "autoreloadui":
               return "Reload ui when XML definition file change";
            case "changefonttype":
               return "Change the current font type. @see fonts.xml";
            case "resetuisavedusermodification":
               return "Reset ui user modification (like resize, move). If an instanceId is provided, then the the reset is applyed only on this one";
            case "getthemefingerprint":
               return "Finger print du theme actuel se basant sur le poid des fichiers";
            default:
               return "No help for command \'" + param1 + "\'";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:* = null;
         var _loc8_:UiModule = null;
         var _loc9_:UiData = null;
         var _loc10_:String = null;
         var _loc4_:Array = [];
         switch(param1)
         {
            case "unloadui":
               if(param2 == 0)
               {
                  for(_loc7_ in Berilia.getInstance().uiList)
                  {
                     _loc4_.push(Berilia.getInstance().uiList[_loc7_].name);
                  }
               }
               break;
            case "loadui":
               _loc5_ = param3[0];
               for each(_loc8_ in UiModuleManager.getInstance().getModules())
               {
                  for each(_loc9_ in _loc8_.uis)
                  {
                     if(_loc9_.name.indexOf(_loc5_) != -1)
                     {
                        _loc4_.push(_loc9_.name);
                     }
                  }
               }
               break;
            case "":
            case "resetuisavedusermodification":
               _loc6_ = StoreDataManager.getInstance().getKeys(BeriliaConstants.DATASTORE_UI_POSITIONS);
               for each(_loc10_ in _loc6_)
               {
                  if(StoreDataManager.getInstance().getData(BeriliaConstants.DATASTORE_UI_POSITIONS,_loc10_))
                  {
                     _loc4_.push(_loc10_);
                  }
               }
         }
         return _loc4_;
      }
   }
}
