package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.WorldMap;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.HighlightApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import d2enums.ChatActivableChannelsEnum;
   import d2enums.PlayerLifeStatusEnum;
   import d2enums.PrismStateEnum;
   import d2enums.SoundTypeEnum;
   import d2enums.StrataEnum;
   import d2hooks.AddMapFlag;
   import d2hooks.CurrentMap;
   import d2hooks.FlagAdded;
   import d2hooks.FlagRemoved;
   import d2hooks.OpenCartographyPopup;
   import d2hooks.OpenMap;
   import d2hooks.PhoenixUpdate;
   import d2hooks.RemoveAllFlags;
   import d2hooks.RemoveMapFlag;
   import d2hooks.TextInformation;
   import flash.display.Sprite;
   import ui.BannerMap;
   import ui.CartographyBase;
   import ui.CartographyPopup;
   import ui.CartographyTooltip;
   import ui.CartographyUi;
   import ui.type.Flag;
   
   public class Cartography extends Sprite
   {
       
      
      private var include_CartographyUi:CartographyUi;
      
      private var include_CartographyPopup:CartographyPopup;
      
      private var include_CartographyTooltip:CartographyTooltip;
      
      private var include_BannerMap:BannerMap;
      
      private var _currentWorldMapId:int;
      
      private var _flags:Array;
      
      private var _prismsStatesInfo:Array;
      
      private var _phoenixFlags:Array;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var mapApi:MapApi;
      
      public var highlightApi:HighlightApi;
      
      public var dataApi:DataApi;
      
      public var timeApi:TimeApi;
      
      public var soundApi:SoundApi;
      
      public var configApi:ConfigApi;
      
      private var _openBannerMapOnNextMap:Boolean = false;
      
      public function Cartography()
      {
         this._flags = new Array();
         this._phoenixFlags = new Array();
         super();
      }
      
      public function main() : void
      {
         var _loc2_:WorldMap = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         this.sysApi.addHook(OpenMap,this.onOpenMap);
         this.sysApi.addHook(AddMapFlag,this.onAddMapFlag);
         this.sysApi.addHook(RemoveMapFlag,this.onRemoveMapFlag);
         this.sysApi.addHook(RemoveAllFlags,this.onRemoveAllFlags);
         this.sysApi.addHook(CurrentMap,this.onCurrentMap);
         this.sysApi.addHook(PhoenixUpdate,this.onPhoenixUpdate);
         this.sysApi.addHook(OpenCartographyPopup,this.openCartographyPopup);
         this.sysApi.createHook("MapHintsFilter");
         this.sysApi.createHook("FlagAdded");
         this.sysApi.createHook("FlagRemoved");
         var _loc1_:Object = this.dataApi.getAllWorldMaps();
         for each(_loc2_ in _loc1_)
         {
            this._flags[_loc2_.id] = [];
         }
         _loc3_ = this.sysApi.getData(this.playerApi.getPlayedCharacterInfo().id + "-cartographyFlags");
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(";");
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_)
               {
                  _loc6_ = parseInt(_loc5_.split(":")[0]);
                  _loc7_ = _loc5_.split(":")[1].split(",");
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.length)
                  {
                     _loc9_ = parseInt(_loc7_[_loc8_]);
                     _loc10_ = parseInt(_loc7_[_loc8_ + 1]);
                     this._flags[_loc6_]["flag_custom_" + _loc9_ + "_" + _loc10_] = new Flag("flag_custom_" + _loc9_ + "_" + _loc10_,_loc9_,_loc10_,this.uiApi.getText("ui.cartography.customFlag") + " (" + _loc9_ + "," + _loc10_ + ")",16768256);
                     _loc8_ = _loc8_ + 2;
                  }
                  continue;
               }
            }
         }
         this._prismsStatesInfo = new Array();
         this._prismsStatesInfo[PrismStateEnum.PRISM_STATE_INVULNERABLE] = {
            "text":this.uiApi.getText("ui.prism.prismInState",this.uiApi.getText("ui.prism.state" + PrismStateEnum.PRISM_STATE_INVULNERABLE)),
            "icon":420
         };
         this._prismsStatesInfo[PrismStateEnum.PRISM_STATE_ATTACKED] = {
            "text":this.uiApi.getText("ui.prism.prismInState",this.uiApi.getText("ui.prism.state" + PrismStateEnum.PRISM_STATE_ATTACKED)),
            "icon":420
         };
         this._prismsStatesInfo[PrismStateEnum.PRISM_STATE_FIGHTING] = {
            "text":this.uiApi.getText("ui.prism.prismInState",this.uiApi.getText("ui.prism.state" + PrismStateEnum.PRISM_STATE_FIGHTING)),
            "icon":420
         };
         this._prismsStatesInfo[PrismStateEnum.PRISM_STATE_NORMAL] = {
            "text":this.uiApi.getText("ui.prism.prismInState",this.uiApi.getText("ui.prism.state" + PrismStateEnum.PRISM_STATE_NORMAL)),
            "icon":420
         };
         this._prismsStatesInfo[PrismStateEnum.PRISM_STATE_WEAKENED] = {
            "text":this.uiApi.getText("ui.prism.prismInState",this.uiApi.getText("ui.prism.state" + PrismStateEnum.PRISM_STATE_WEAKENED)),
            "icon":421
         };
         this._prismsStatesInfo[PrismStateEnum.PRISM_STATE_VULNERABLE] = {
            "text":this.uiApi.getText("ui.prism.prismInState",this.uiApi.getText("ui.prism.state" + PrismStateEnum.PRISM_STATE_VULNERABLE)),
            "icon":436
         };
         this._prismsStatesInfo[PrismStateEnum.PRISM_STATE_DEFEATED] = {
            "text":this.uiApi.getText("ui.prism.prismInState",this.uiApi.getText("ui.prism.state" + PrismStateEnum.PRISM_STATE_DEFEATED)),
            "icon":436
         };
         this._prismsStatesInfo[PrismStateEnum.PRISM_STATE_SABOTAGED] = {
            "text":this.uiApi.getText("ui.prism.prismInState",this.uiApi.getText("ui.prism.state" + PrismStateEnum.PRISM_STATE_SABOTAGED)),
            "icon":440
         };
      }
      
      public function openCartographyPopup(param1:String, param2:int, param3:Object = null, param4:String = "") : String
      {
         var _loc5_:Object = new Object();
         _loc5_.title = param1;
         _loc5_.selectedSubareaId = param2;
         _loc5_.subareaIds = param3;
         _loc5_.subtitle = param4;
         this.uiApi.loadUi("cartographyPopup",null,_loc5_,StrataEnum.STRATA_TOP,null,true);
         return "cartographyPopup";
      }
      
      public function openBannerMap() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:* = null;
         var _loc4_:Flag = null;
         if(!this.uiApi.getUi("bannerMap"))
         {
            if(this.playerApi.currentSubArea())
            {
               this._openBannerMapOnNextMap = false;
               _loc1_ = this.mapApi.getCurrentWorldMap().id;
               _loc2_ = [];
               for(_loc3_ in this._flags[_loc1_])
               {
                  _loc2_[_loc3_] = this._flags[_loc1_][_loc3_];
               }
               if(!this.playerApi.isAlive())
               {
                  for each(_loc4_ in this._phoenixFlags)
                  {
                     if(!_loc2_[_loc4_.id] && _loc4_.worldMap == _loc1_)
                     {
                        _loc2_.push(_loc4_);
                     }
                  }
               }
               this.uiApi.loadUi("bannerMap",null,{
                  "currentMap":this.playerApi.currentMap(),
                  "flags":_loc2_,
                  "conquest":false,
                  "switchingMapUi":false,
                  "fromShortcut":false
               },StrataEnum.STRATA_LOW);
            }
            else
            {
               this._openBannerMapOnNextMap = true;
            }
         }
      }
      
      private function onOpenMap(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:* = null;
         var _loc8_:Flag = null;
         var _loc4_:String = "cartographyUi";
         if(this.uiApi.getUi(_loc4_))
         {
            this.soundApi.playSound(SoundTypeEnum.MAP_CLOSE);
            this.uiApi.unloadUi(_loc4_);
         }
         else if(this.playerApi.currentSubArea())
         {
            _loc5_ = this.mapApi.getCurrentWorldMap().id;
            _loc6_ = [];
            for(_loc7_ in this._flags[_loc5_])
            {
               _loc6_[_loc7_] = this._flags[_loc5_][_loc7_];
            }
            if(!this.playerApi.isAlive())
            {
               for each(_loc8_ in this._phoenixFlags)
               {
                  if(!_loc6_[_loc8_.id] && _loc8_.worldMap == _loc5_)
                  {
                     _loc6_.push(_loc8_);
                  }
               }
            }
            this.uiApi.loadUi(_loc4_,null,{
               "currentMap":this.playerApi.currentMap(),
               "flags":_loc6_,
               "conquest":param3,
               "fromShortcut":param2
            },StrataEnum.STRATA_LOW);
         }
      }
      
      private function onAddMapFlag(param1:String, param2:String, param3:int, param4:int, param5:int, param6:uint, param7:Boolean = false, param8:Boolean = false, param9:Boolean = true, param10:Boolean = false) : void
      {
         var _loc12_:Flag = null;
         var _loc13_:WorldMap = null;
         var _loc14_:CartographyBase = null;
         var _loc15_:WorldMap = null;
         var _loc11_:Array = new Array();
         if(this.uiApi.getUi("cartographyUi"))
         {
            _loc11_.push(this.uiApi.getUi("cartographyUi").uiClass);
         }
         if(this.uiApi.getUi("bannerMap"))
         {
            _loc11_.push(this.uiApi.getUi("bannerMap").uiClass);
         }
         if(!this._flags[param3])
         {
            this.sysApi.log(8,"Failed to add new map flag because the world " + param3 + " is not valid");
            return;
         }
         if(!this._flags[param3][param1])
         {
            _loc12_ = !!this._phoenixFlags[param1]?this._phoenixFlags[param1]:new Flag(param1,param4,param5,param2,param6,param9,param10);
            if(this.mapApi.getCurrentWorldMap() && this.mapApi.getCurrentWorldMap().id != param3)
            {
               _loc13_ = this.dataApi.getWorldMap(param3);
               this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.cartography.flagAddedOnOtherMap",param4,param5,_loc13_.name),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,this.timeApi.getTimestamp());
            }
            if(_loc11_ && _loc11_.length > 0)
            {
               for each(_loc14_ in _loc11_)
               {
                  if(_loc14_.currentWorldId == param3)
                  {
                     _loc14_.addFlag(param1,param2,param4,param5,param6,true,true,param9,param10);
                  }
               }
            }
            this._flags[param3][param1] = _loc12_;
            this.sysApi.dispatchHook(FlagAdded,param1,param3,param4,param5,param6,param2,param9,param10);
            if(param8 && !this.playerApi.isInFight())
            {
               this.highlightApi.highlightUi("bannerMenu","btn_map",1,0,5,false);
            }
         }
         else
         {
            _loc12_ = this._flags[param3][param1];
            if(param7)
            {
               delete this._flags[param3][param1];
               if(this._currentWorldMapId != param3)
               {
                  _loc15_ = this.dataApi.getWorldMap(param3);
                  this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.cartography.flagRemovedOnOtherMap",param4,param5,_loc15_.name),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,this.timeApi.getTimestamp());
               }
               if(_loc11_ && _loc11_.length > 0)
               {
                  for each(_loc14_ in _loc11_)
                  {
                     if(_loc14_.currentWorldId == param3)
                     {
                        _loc14_.removeFlag(param1);
                     }
                  }
               }
               this.sysApi.dispatchHook(FlagRemoved,param1,param3);
            }
            else
            {
               _loc12_.position.x = param4;
               _loc12_.position.y = param5;
               _loc12_.legend = param2;
               if(_loc11_ && _loc11_.length > 0)
               {
                  for each(_loc14_ in _loc11_)
                  {
                     if(_loc14_ && this._currentWorldMapId == param3)
                     {
                        if(!_loc14_.updateFlag(param1,param4,param5,param2))
                        {
                           _loc14_.addFlag(param1,param2,param4,param5,param6,true,true,param9,param10);
                        }
                     }
                  }
               }
               this.sysApi.dispatchHook(FlagAdded,param1,param3,param4,param5,param6,param2,param9,param10);
               if(param8 && !this.playerApi.isInFight())
               {
                  this.highlightApi.highlightUi("bannerMenu","btn_map",1,0,5,false);
               }
            }
         }
         if(param1.indexOf("flag_custom") != -1)
         {
            this.saveFlags();
         }
      }
      
      private function onRemoveMapFlag(param1:String, param2:int) : void
      {
         var _loc3_:* = undefined;
         if(param2 != -1)
         {
            this.removeFlagFromWorldMap(param2,param1);
         }
         else
         {
            for(_loc3_ in this._flags)
            {
               this.removeFlagFromWorldMap(_loc3_,param1);
            }
         }
      }
      
      private function removeFlagFromWorldMap(param1:uint, param2:String) : void
      {
         var _loc4_:CartographyBase = null;
         if(!this._flags[param1][param2])
         {
            return;
         }
         var _loc3_:Array = new Array();
         if(this.uiApi.getUi("cartographyUi"))
         {
            _loc3_.push(this.uiApi.getUi("cartographyUi").uiClass);
         }
         if(this.uiApi.getUi("bannerMap"))
         {
            _loc3_.push(this.uiApi.getUi("bannerMap").uiClass);
         }
         delete this._flags[param1][param2];
         if(_loc3_ && _loc3_.length > 0)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.currentWorldId == param1)
               {
                  _loc4_.removeFlag(param2);
               }
            }
         }
         this.sysApi.dispatchHook(FlagRemoved,param2,param1);
         if(param2.indexOf("flag_custom") != -1)
         {
            this.saveFlags();
         }
      }
      
      private function onRemoveAllFlags() : void
      {
         this.removeAllFlags();
      }
      
      private function removeAllFlags() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = null;
         var _loc4_:CartographyBase = null;
         var _loc1_:Array = new Array();
         if(this.uiApi.getUi("cartographyUi"))
         {
            _loc1_.push(this.uiApi.getUi("cartographyUi").uiClass);
         }
         if(this.uiApi.getUi("bannerMap"))
         {
            _loc1_.push(this.uiApi.getUi("bannerMap").uiClass);
         }
         for(_loc2_ in this._flags)
         {
            for(_loc3_ in this._flags[_loc2_])
            {
               if(this._flags[_loc2_][_loc3_].canBeManuallyRemoved)
               {
                  delete this._flags[_loc2_][_loc3_];
                  if(_loc1_ && _loc1_.length > 0)
                  {
                     for each(_loc4_ in _loc1_)
                     {
                        if(_loc4_ && _loc4_.currentWorldId == _loc2_)
                        {
                           _loc4_.removeFlag(_loc3_);
                        }
                     }
                  }
                  this.sysApi.dispatchHook(FlagRemoved,_loc3_,_loc2_);
               }
            }
         }
         this.saveFlags();
      }
      
      private function onCurrentMap(param1:uint) : void
      {
         var _loc3_:Flag = null;
         if(this._openBannerMapOnNextMap)
         {
            this.openBannerMap();
         }
         if(this.uiApi.getUi("cartographyUi"))
         {
            this.uiApi.unloadUi("cartographyUi");
         }
         var _loc2_:SubArea = this.mapApi.getMapPositionById(param1).subArea;
         this._currentWorldMapId = !!_loc2_.worldmap?int(_loc2_.worldmap.id):1;
         if(!this.playerApi.isAlive())
         {
            for each(_loc3_ in this._phoenixFlags)
            {
               if(_loc3_.worldMap == this._currentWorldMapId && !this._flags[this._currentWorldMapId][_loc3_.id])
               {
                  this._flags[this._currentWorldMapId][_loc3_.id] = _loc3_;
               }
            }
         }
      }
      
      private function onPhoenixUpdate(param1:uint = 0) : void
      {
         var _loc2_:Flag = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         for each(_loc2_ in this._phoenixFlags)
         {
            this.onRemoveMapFlag(_loc2_.id,_loc2_.worldMap);
         }
         this._phoenixFlags = new Array();
         if(this.playerApi.state() == PlayerLifeStatusEnum.STATUS_PHANTOM)
         {
            if(param1)
            {
               this.addPhoenixFlag(param1);
            }
            else
            {
               _loc3_ = this.mapApi.getPhoenixsMaps();
               for each(_loc4_ in _loc3_)
               {
                  this.addPhoenixFlag(_loc4_);
               }
            }
         }
      }
      
      private function addPhoenixFlag(param1:uint) : void
      {
         var _loc2_:MapPosition = this.mapApi.getMapPositionById(param1);
         var _loc3_:Flag = new Flag("Phoenix_" + param1,_loc2_.posX,_loc2_.posY,this.uiApi.getText("ui.common.phoenix"),14759203);
         _loc3_.worldMap = _loc2_.worldMap;
         this._phoenixFlags[_loc3_.id] = _loc3_;
         if(this.mapApi.getCurrentWorldMap() && this.mapApi.getCurrentWorldMap().id == _loc3_.worldMap)
         {
            this.onAddMapFlag(_loc3_.id,_loc3_.legend,_loc2_.worldMap,_loc3_.position.x,_loc3_.position.y,_loc3_.color);
         }
      }
      
      private function removeOtherWorldMapFlags() : void
      {
         var _loc1_:Flag = null;
         var _loc2_:* = undefined;
         for(_loc2_ in this._flags)
         {
            if(_loc2_ != this._currentWorldMapId)
            {
               for each(_loc1_ in this._flags[_loc2_])
               {
                  this.removeFlagFromWorldMap(_loc2_,_loc1_.id);
               }
            }
         }
      }
      
      public function getFlags(param1:int) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Flag = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._flags[param1])
         {
            _loc2_[_loc3_.id] = _loc3_;
         }
         for each(_loc4_ in this._phoenixFlags)
         {
            if(!_loc2_[_loc4_.id] && _loc4_.worldMap == param1)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      private function saveFlags() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         var _loc5_:Flag = null;
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this._flags.length)
         {
            if(this._flags[_loc2_])
            {
               _loc3_ = [];
               _loc4_ = true;
               for each(_loc5_ in this._flags[_loc2_])
               {
                  if(_loc5_.id.indexOf("flag_custom") != -1)
                  {
                     if(_loc4_)
                     {
                        _loc1_ = _loc1_ + (_loc2_.toString() + ":");
                        _loc4_ = false;
                     }
                     _loc3_.push(_loc5_.position.x,_loc5_.position.y);
                  }
               }
               if(_loc3_.length)
               {
                  _loc1_ = _loc1_ + (_loc3_.join(",") + ";");
               }
            }
            _loc2_++;
         }
         this.sysApi.setData(this.playerApi.getPlayedCharacterInfo().id + "-cartographyFlags",_loc1_);
      }
      
      public function getPrismStateInfo(param1:uint) : Object
      {
         return this._prismsStatesInfo[param1];
      }
      
      public function showConquestInformation() : Boolean
      {
         var _loc1_:SubArea = null;
         var _loc2_:Object = this.mapApi.getAllSubArea();
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.worldmap && _loc1_.worldmap.id == this._currentWorldMapId && _loc1_.capturable)
            {
               return true;
            }
         }
         return false;
      }
   }
}
