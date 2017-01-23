package adminMenu
{
   import adminMenu.items.BasicItem;
   import adminMenu.items.BatchItem;
   import adminMenu.items.MenuItem;
   import adminMenu.items.PrepareCommanditem;
   import adminMenu.items.ReloadXmlItem;
   import adminMenu.items.SendChatItem;
   import adminMenu.items.SendCommandItem;
   import adminMenu.items.SeparatorItem;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import d2enums.BuildTypeEnum;
   import d2enums.GameHierarchyEnum;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class AdminMenu
   {
      
      private static const ADMIN_CONFIG_URL_RELEASE:String = "http://menuadmin.dofus.com/dofus2/";
      
      private static const ADMIN_CONFIG_URL_BETA:String = "http://menuadmin.dofus.com/dofus2-beta/";
      
      private static const ADMIN_CONFIG_URL_INTERNAL:String = "http://deposit.dofus2.lan/admin/";
       
      
      private var _menu:Array;
      
      private var _startCmd:Array;
      
      private var _rank:int = 0;
      
      private var _hierarchyString:String = null;
      
      private var _rights:Array;
      
      private var _menuAdminUrls:Array;
      
      public function AdminMenu()
      {
         this._menu = [];
         this._startCmd = [];
         this._menuAdminUrls = [];
         super();
         if(Api.systemApi.getBuildType() >= BuildTypeEnum.INTERNAL)
         {
            Api.fileApi.trustedLoadXmlFile(ADMIN_CONFIG_URL_INTERNAL + "ranks.xml",this.onRanksFileLoaded,this.onRanksLoadError);
         }
         else if(Api.systemApi.getBuildType() == BuildTypeEnum.BETA)
         {
            Api.fileApi.trustedLoadXmlFile(ADMIN_CONFIG_URL_BETA + "ranks.xml",this.onRanksFileLoaded,this.onRanksLoadError);
         }
         else
         {
            Api.fileApi.trustedLoadXmlFile(ADMIN_CONFIG_URL_RELEASE + "ranks.xml",this.onRanksFileLoaded,this.onRanksLoadError);
         }
      }
      
      public function process(param1:Object) : Array
      {
         var _loc3_:BasicItem = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this._menu)
         {
            if(_loc3_.rank <= this._rank)
            {
               _loc2_.push(_loc3_.getContextMenuItem(param1));
            }
         }
         return _loc2_;
      }
      
      public function onStart() : void
      {
         var _loc2_:SendCommandItem = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this._startCmd.length)
         {
            _loc2_ = this._startCmd[_loc1_];
            if(_loc2_)
            {
               _loc2_.callbackFunction.apply(null,_loc2_.getcallbackArgs([]));
            }
            _loc1_++;
         }
      }
      
      private function parseNode(param1:XMLNode, param2:Array, param3:Array = null) : void
      {
         var _loc4_:XMLNode = null;
         var _loc5_:BasicItem = null;
         for each(_loc4_ in param1.childNodes)
         {
            if(!param3 || param3.indexOf(_loc4_.nodeName) != -1)
            {
               switch(_loc4_.nodeName)
               {
                  case "item":
                     _loc5_ = this.parseItem(_loc4_);
                     if(_loc5_)
                     {
                        param2.push(_loc5_);
                     }
                     continue;
                  case "move":
                     this.parseMove(_loc4_,param2);
                     continue;
                  case "delete":
                     this.parseDelete(_loc4_,param2);
                     continue;
                  case "add":
                     this.parseAdd(_loc4_,param2);
                     continue;
                  default:
                     continue;
               }
            }
            else
            {
               continue;
            }
         }
      }
      
      private function parseItem(param1:XMLNode) : BasicItem
      {
         if(!param1.attributes["type"])
         {
            return null;
         }
         var _loc2_:BasicItem = null;
         switch(param1.attributes["type"].toLowerCase())
         {
            case "static":
               _loc2_ = new BasicItem();
               break;
            case "separator":
               _loc2_ = new SeparatorItem();
               break;
            case "sendcommand":
               _loc2_ = new SendCommandItem(param1.attributes["command"],param1.attributes["delay"],param1.attributes["repeat"]);
               break;
            case "sendchat":
               _loc2_ = new SendChatItem(param1.attributes["command"],param1.attributes["delay"],param1.attributes["repeat"]);
               break;
            case "preparecommand":
               _loc2_ = new PrepareCommanditem(param1.attributes["command"],param1.attributes["delay"],param1.attributes["repeat"]);
               break;
            case "batch":
               _loc2_ = new BatchItem(param1.attributes["delay"],param1.attributes["repeat"]);
               this.parseNode(param1,BatchItem(_loc2_).subItem);
               break;
            case "menu":
               _loc2_ = new MenuItem();
               this.parseNode(param1,MenuItem(_loc2_).children);
               break;
            case "startup":
               this.parseNode(param1,this._startCmd);
               break;
            case "loadxml":
               _loc2_ = new ReloadXmlItem();
         }
         if(_loc2_)
         {
            _loc2_.label = param1.attributes["label"];
            _loc2_.help = param1.attributes["help"];
            _loc2_.rank = param1.attributes["rank"];
            return _loc2_;
         }
         return null;
      }
      
      private function parseMove(param1:XMLNode, param2:Array) : void
      {
         var _loc3_:String = param1.attributes["label"];
         var _loc4_:String = param1.attributes["target"];
         var _loc5_:String = param1.attributes["position"];
         var _loc6_:Object = this.locate(_loc3_,param2);
         this.move(param2,_loc6_,_loc4_,_loc5_);
      }
      
      private function parseDelete(param1:XMLNode, param2:Array) : void
      {
         var _loc3_:String = param1.attributes["label"];
         var _loc4_:Object = this.locate(_loc3_,param2);
         this.move(param2,_loc4_);
      }
      
      private function parseAdd(param1:XMLNode, param2:Array) : void
      {
         var _loc5_:XMLNode = null;
         var _loc6_:BasicItem = null;
         var _loc3_:String = param1.attributes["target"];
         var _loc4_:String = param1.attributes["position"];
         for each(_loc5_ in param1.childNodes)
         {
            _loc6_ = this.parseItem(_loc5_);
            if(_loc6_)
            {
               this.add(param2,_loc6_,_loc3_,_loc4_);
            }
         }
      }
      
      private function move(param1:Array, param2:Object, param3:String = null, param4:String = null) : void
      {
         var _loc5_:BasicItem = param2.container[param2.position];
         param2.container.splice(param2.position,1);
         if(param4)
         {
            this.add(param1,_loc5_,param3,param4);
         }
      }
      
      private function add(param1:Array, param2:BasicItem, param3:String = null, param4:String = null) : void
      {
         var _loc6_:BasicItem = null;
         var _loc5_:Object = this.locate(param3,param1);
         if(_loc5_.container)
         {
            _loc6_ = _loc5_.container[_loc5_.position];
         }
         switch(param4)
         {
            case "first":
               if(!_loc6_)
               {
                  this._menu.unshift(param2);
               }
               else if(_loc6_ is MenuItem)
               {
                  MenuItem(_loc6_).children.unshift(param2);
               }
               break;
            case "last":
               if(!_loc6_)
               {
                  this._menu.push(param2);
               }
               else if(_loc6_ is MenuItem)
               {
                  MenuItem(_loc6_).children.push(param2);
               }
               break;
            case "before":
               _loc5_.container.splice(_loc5_.position,0,param2);
               break;
            case "after":
               _loc5_.container.splice(_loc5_.position + 1,0,param2);
         }
      }
      
      private function locate(param1:String, param2:Array) : Object
      {
         var _loc4_:BasicItem = null;
         var _loc5_:Object = null;
         if(param1 == null)
         {
            return {"container":null};
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = param2[_loc3_];
            if(_loc4_.label == param1)
            {
               return {
                  "container":param2,
                  "position":_loc3_
               };
            }
            switch(true)
            {
               case _loc4_ is MenuItem:
                  _loc5_ = this.locate(param1,MenuItem(_loc4_).children);
                  if(_loc5_)
                  {
                     return _loc5_;
                  }
                  break;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function onRanksFileLoaded(param1:*) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:String = null;
         var _loc5_:Server = null;
         var _loc6_:String = null;
         var _loc2_:XMLDocument = new XMLDocument(param1.toString());
         _loc2_.ignoreWhite = true;
         this._rank = 0;
         this._hierarchyString = null;
         if(_loc2_.firstChild && _loc2_.firstChild.childNodes)
         {
            for each(_loc3_ in _loc2_.firstChild.childNodes)
            {
               if(_loc3_.attributes["type"])
               {
                  if(GameHierarchyEnum[_loc3_.attributes["type"].toUpperCase()] == Api.systemApi.getAdminStatus())
                  {
                     if(_loc3_.attributes["level"] > this._rank)
                     {
                        if(Api.systemApi.hasAdminCommand(_loc3_.attributes["command"]))
                        {
                           this._rank = _loc3_.attributes["level"];
                           _loc4_ = _loc3_.attributes["rights"];
                           if(_loc4_)
                           {
                              this._rights = _loc4_.split(",");
                           }
                           else
                           {
                              this._rights = ["item","add","move","remove"];
                           }
                        }
                     }
                     this._hierarchyString = _loc3_.attributes["type"].toUpperCase();
                  }
               }
            }
         }
         if(this._hierarchyString)
         {
            _loc5_ = Api.systemApi.getCurrentServer();
            if(Api.systemApi.getBuildType() >= BuildTypeEnum.INTERNAL)
            {
               _loc6_ = ADMIN_CONFIG_URL_INTERNAL + this._hierarchyString.toLowerCase() + "_" + Api.systemApi.getCurrentLanguage();
            }
            else if(Api.systemApi.getBuildType() == BuildTypeEnum.BETA)
            {
               _loc6_ = ADMIN_CONFIG_URL_BETA + this._hierarchyString.toLowerCase() + "_" + Api.systemApi.getCurrentLanguage();
            }
            else
            {
               _loc6_ = ADMIN_CONFIG_URL_RELEASE + this._hierarchyString.toLowerCase() + "_" + Api.systemApi.getCurrentLanguage();
            }
            if(Api.systemApi.getBuildType() < BuildTypeEnum.INTERNAL)
            {
               this._menuAdminUrls.push("ui/Ankama_Admin/menuadmin.xml");
            }
            this._menuAdminUrls.push(_loc6_ + ".xml");
            this._menuAdminUrls.push(_loc6_ + "_" + _loc5_.id + ".xml");
            if(Api.systemApi.getBuildType() >= BuildTypeEnum.INTERNAL)
            {
               this._menuAdminUrls.push("ui/Ankama_Admin/menuadmin.xml");
            }
            Api.fileApi.trustedLoadXmlFile(this._menuAdminUrls.pop(),this.onFileLoaded,this.onLoadError);
         }
         else
         {
            Api.fileApi.loadXmlFile("menuadmin.xml",this.onFileLoaded,this.onLoadError);
         }
      }
      
      private function onFileLoaded(param1:*) : void
      {
         var _loc3_:Server = null;
         var _loc2_:XMLDocument = new XMLDocument(param1.toString());
         _loc2_.ignoreWhite = true;
         this.parseNode(_loc2_.firstChild,this._menu);
         if(this._hierarchyString)
         {
            _loc3_ = Api.systemApi.getCurrentServer();
            Api.fileApi.loadXmlFile(this._hierarchyString.toLowerCase() + "_" + _loc3_.community.shortId + ".xml",this.onOverwriteFileLoaded,this.onLoadError);
         }
      }
      
      private function onOverwriteFileLoaded(param1:*) : void
      {
         var _loc2_:XMLDocument = new XMLDocument(param1.toString());
         _loc2_.ignoreWhite = true;
         this.parseNode(_loc2_.firstChild,this._menu,this._rights);
      }
      
      private function onLoadError(param1:uint, param2:String) : void
      {
         if(this._menuAdminUrls.length)
         {
            Api.fileApi.trustedLoadXmlFile(this._menuAdminUrls.pop(),this.onFileLoaded,this.onLoadError);
         }
         else
         {
            Api.systemApi.log(0,"Impossible de charger " + param2);
         }
      }
      
      private function onRanksLoadError(param1:uint, param2:String) : void
      {
         Api.fileApi.loadXmlFile("menuadmin.xml",this.onFileLoaded,this.onLoadError);
      }
   }
}
