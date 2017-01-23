package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.mount.MountData;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ExchangeHandleMountStable;
   import d2actions.ExchangeRequestOnMountStock;
   import d2actions.MountReleaseRequest;
   import d2actions.MountRenameRequest;
   import d2actions.MountSetXpRatioRequest;
   import d2actions.MountSterilizeRequest;
   import d2actions.MountToggleRidingRequest;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.ShortcutHookListEnum;
   import d2enums.StrataEnum;
   import d2hooks.MountRenamed;
   import d2hooks.MountRiding;
   import d2hooks.MountSet;
   import d2hooks.MountSterilized;
   import d2hooks.MountUnSet;
   import d2hooks.MountXpRatio;
   import d2hooks.OpenMountFeed;
   import d2hooks.TextInformation;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   
   public class MountInfo
   {
      
      private static var _shortcutColor:String;
      
      private static const SHORTCUT_DISABLE_DURATION:Number = 500;
       
      
      public var bindsApi:BindsApi;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var mapApi:MapApi;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      public var storageApi:StorageApi;
      
      public var timeApi:TimeApi;
      
      private var _currentMount:Object;
      
      private var _paddockMode:Boolean;
      
      private var _centeredMode:Boolean;
      
      private var _aLblCap:Array;
      
      private var _serenityText:String;
      
      private var _playerMount:Boolean;
      
      private var _orangeColor:ColorTransform;
      
      private var _greenColor:ColorTransform;
      
      private var _shortcutTimerDuration:Number = 0;
      
      public var mainCtr:GraphicContainer;
      
      public var btn_changeName:ButtonContainer;
      
      public var btn_xp:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_sterilize:ButtonContainer;
      
      public var btn_release:ButtonContainer;
      
      public var btn_storage:ButtonContainer;
      
      public var btn_ancestors:ButtonContainer;
      
      public var btn_mount:ButtonContainer;
      
      public var btn_feed:ButtonContainer;
      
      public var btn_stat:ButtonContainer;
      
      public var gd_effects:Grid;
      
      public var btn_effect:ButtonContainer;
      
      public var lbl_capacity:Label;
      
      public var lbl_btn_effect:Label;
      
      public var lbl_name:Label;
      
      public var lbl_type:Label;
      
      public var lbl_level:Label;
      
      public var lbl_sex:Label;
      
      public var lbl_mountable:Label;
      
      public var lbl_wild:Label;
      
      public var lbl_xpTitle:Label;
      
      public var lbl_xp:Label;
      
      public var lbl_reproduction:Label;
      
      public var lbl_fecondation:Label;
      
      public var tx_mount:EntityDisplayer;
      
      public var pb_Energy:ProgressBar;
      
      public var pb_xp:ProgressBar;
      
      public var pb_tired:ProgressBar;
      
      public var pb_love:ProgressBar;
      
      public var pb_maturity:ProgressBar;
      
      public var pb_stamina:ProgressBar;
      
      public var pb_serenity:ProgressBar;
      
      public var tx_sex:TextureBitmap;
      
      public var ctr_stat:GraphicContainer;
      
      public var ctr_capacity:GraphicContainer;
      
      public var ctr_effect:GraphicContainer;
      
      public var lbl_love:Label;
      
      public var lbl_maturity:Label;
      
      public var lbl_stamina:Label;
      
      public var tx_love:TextureBitmap;
      
      public var tx_maturity:TextureBitmap;
      
      public var tx_stamina:TextureBitmap;
      
      public var lbl_cap0:Label;
      
      public var lbl_cap1:Label;
      
      public var lbl_cap2:Label;
      
      public var lbl_cap3:Label;
      
      public var lbl_serenity:Label;
      
      public function MountInfo()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         this.sysApi.addHook(MountSterilized,this.onMountSterilized);
         this.sysApi.addHook(MountUnSet,this.onMountUnSet);
         this.sysApi.addHook(MountRiding,this.onMountRiding);
         this.sysApi.addHook(MountSet,this.onMountSet);
         this.sysApi.addHook(MountRenamed,this.onMountRenamed);
         this.sysApi.addHook(MountXpRatio,this.onMountXpRatio);
         this.uiApi.addComponentHook(this.btn_changeName,"onRelease");
         this.uiApi.addComponentHook(this.btn_changeName,"onRollOver");
         this.uiApi.addComponentHook(this.btn_changeName,"onRollOut");
         this.uiApi.addComponentHook(this.btn_xp,"onRelease");
         this.uiApi.addComponentHook(this.btn_xp,"onRollOver");
         this.uiApi.addComponentHook(this.btn_xp,"onRollOut");
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.btn_stat,"onRelease");
         this.uiApi.addComponentHook(this.btn_effect,"onRelease");
         this.uiApi.addComponentHook(this.btn_release,"onRelease");
         this.uiApi.addComponentHook(this.btn_release,"onRollOver");
         this.uiApi.addComponentHook(this.btn_release,"onRollOut");
         this.uiApi.addComponentHook(this.btn_sterilize,"onRelease");
         this.uiApi.addComponentHook(this.btn_sterilize,"onRollOver");
         this.uiApi.addComponentHook(this.btn_sterilize,"onRollOut");
         this.uiApi.addComponentHook(this.btn_storage,"onRelease");
         this.uiApi.addComponentHook(this.btn_storage,"onRollOver");
         this.uiApi.addComponentHook(this.btn_storage,"onRollOut");
         this.uiApi.addComponentHook(this.btn_ancestors,"onRelease");
         this.uiApi.addComponentHook(this.btn_ancestors,"onRollOver");
         this.uiApi.addComponentHook(this.btn_ancestors,"onRollOut");
         this.uiApi.addComponentHook(this.btn_mount,"onRelease");
         this.uiApi.addComponentHook(this.btn_mount,"onRollOver");
         this.uiApi.addComponentHook(this.btn_mount,"onRollOut");
         this.uiApi.addComponentHook(this.btn_feed,"onRelease");
         this.uiApi.addComponentHook(this.btn_feed,"onRollOver");
         this.uiApi.addComponentHook(this.btn_feed,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_love,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_love,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_maturity,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_maturity,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_stamina,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_stamina,"onRollOut");
         this.uiApi.addComponentHook(this.tx_love,"onRollOver");
         this.uiApi.addComponentHook(this.tx_love,"onRollOut");
         this.uiApi.addComponentHook(this.tx_maturity,"onRollOver");
         this.uiApi.addComponentHook(this.tx_maturity,"onRollOut");
         this.uiApi.addComponentHook(this.tx_stamina,"onRollOver");
         this.uiApi.addComponentHook(this.tx_stamina,"onRollOut");
         this.uiApi.addComponentHook(this.pb_Energy,"onRollOver");
         this.uiApi.addComponentHook(this.pb_Energy,"onRollOut");
         this.uiApi.addComponentHook(this.pb_love,"onRollOver");
         this.uiApi.addComponentHook(this.pb_love,"onRollOut");
         this.uiApi.addComponentHook(this.pb_maturity,"onRollOver");
         this.uiApi.addComponentHook(this.pb_maturity,"onRollOut");
         this.uiApi.addComponentHook(this.pb_xp,"onRollOver");
         this.uiApi.addComponentHook(this.pb_xp,"onRollOut");
         this.uiApi.addComponentHook(this.pb_serenity,"onRollOver");
         this.uiApi.addComponentHook(this.pb_serenity,"onRollOut");
         this.uiApi.addComponentHook(this.pb_stamina,"onRollOver");
         this.uiApi.addComponentHook(this.pb_stamina,"onRollOut");
         this.uiApi.addComponentHook(this.pb_tired,"onRollOver");
         this.uiApi.addComponentHook(this.pb_tired,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_reproduction,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_reproduction,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_fecondation,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_fecondation,"onRollOut");
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.soundApi.playSound(SoundTypeEnum.OPEN_MOUNT_UI);
         this.btn_sterilize.soundId = SoundEnum.MOUNT_HURT;
         this._aLblCap = [this.lbl_cap0,this.lbl_cap1,this.lbl_cap2,this.lbl_cap3];
         this._orangeColor = new ColorTransform(1,1,1,1,71,-50,-146);
         this._greenColor = new ColorTransform(1,1,1,1,-100,0,-175);
         this._paddockMode = param1.paddockMode;
         this._centeredMode = param1.centeredMode;
         var _loc2_:Object = this.uiApi.me();
         _loc2_.x = param1.posX;
         _loc2_.y = param1.posY;
         this.lbl_capacity.text = this.uiApi.processText(this.uiApi.getText("ui.common.capacity"),"m",false);
         this.lbl_btn_effect.text = this.uiApi.processText(this.uiApi.getText("ui.common.effects"),"m",false);
         this.btn_stat.selected = true;
         this.ctr_effect.visible = false;
         this.ctr_capacity.visible = true;
         if(this.playerApi.isIncarnation())
         {
            this.btn_mount.disabled = true;
         }
         if(this._paddockMode)
         {
            this.btn_close.visible = false;
            this.btn_mount.visible = false;
            this.btn_storage.visible = false;
            this.btn_xp.visible = false;
            this.btn_feed.disabled = false;
            this.uiApi.me().visible = false;
            this.btn_changeName.x = 340;
            this.btn_changeName.visible = false;
            this.btn_feed.x = this.uiApi.me().getConstant("btnFeedBarnPos");
            this.btn_ancestors.x = this.uiApi.me().getConstant("btnAncestorsBarnPos");
         }
         else if(this._centeredMode)
         {
            this.btn_mount.visible = false;
            this.btn_storage.visible = false;
            this.btn_sterilize.disabled = true;
            this.btn_release.disabled = true;
            this.btn_feed.disabled = false;
            this.btn_xp.visible = false;
            this.btn_changeName.visible = false;
            this.btn_feed.x = this.uiApi.me().getConstant("btnFeedBarnPos");
            this.btn_ancestors.x = this.uiApi.me().getConstant("btnAncestorsBarnPos");
         }
         else
         {
            this.btn_mount.visible = true;
            this.btn_storage.visible = true;
            this.btn_mount.selected = this.playerApi.isRidding();
            _loc3_ = this.playerApi.currentMap().mapId;
            _loc4_ = this.mapApi.getMapPositionById(_loc3_).isUnderWater;
            _loc5_ = (param1.mountData as MountData).model.familyId;
            if(_loc4_ && _loc5_ != 5)
            {
               this.btn_mount.softDisabled = true;
            }
         }
         if(!this._paddockMode)
         {
            if(this.playerApi.getMount() && this.playerApi.getMount().id == param1.mountData.id)
            {
               this.showMountInformation(param1.mountData,MountPaddock.SOURCE_EQUIP);
            }
            else
            {
               this.showMountInformation(param1.mountData,MountPaddock.SOURCE_PADDOCK);
            }
         }
         this._currentMount = param1.mountData;
      }
      
      public function updateEffectLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            if(param1 is String)
            {
               param2.lbl_effect.text = param1;
            }
            else
            {
               param2.lbl_effect.text = "• " + param1.description;
            }
         }
         else
         {
            param2.lbl_effect.text = "";
         }
      }
      
      public function showMountInformation(param1:Object, param2:int) : void
      {
         var _loc7_:* = undefined;
         this._currentMount = param1;
         MountPaddock._currentSource = param2;
         switch(param2)
         {
            case MountPaddock.SOURCE_EQUIP:
            case MountPaddock.SOURCE_BARN:
               this.btn_changeName.visible = true;
               break;
            case MountPaddock.SOURCE_PADDOCK:
            case MountPaddock.SOURCE_INVENTORY:
               this.btn_changeName.visible = false;
         }
         if(param1)
         {
            this.uiApi.me().visible = true;
            if(!this._centeredMode)
            {
               this.btn_sterilize.disabled = this._currentMount.reproductionCount == -1;
            }
         }
         this.lbl_name.text = param1.name;
         this.btn_changeName.x = this.lbl_name.x + this.lbl_name.width / 2 + this.lbl_name.textWidth / 2;
         this.lbl_type.text = param1.description;
         this.lbl_level.text = this.uiApi.getText("ui.common.averageLevel") + " " + param1.level;
         this.lbl_serenity.text = param1.serenity;
         if(param1.sex)
         {
            this.tx_sex.themeDataId = "tx_mount_female";
         }
         else
         {
            this.tx_sex.themeDataId = "tx_mount_male";
         }
         if(param1.isRideable)
         {
            this.lbl_mountable.text = this.uiApi.getText("ui.common.yes");
         }
         else
         {
            this.lbl_mountable.text = this.uiApi.getText("ui.common.no");
         }
         if(param1.isWild)
         {
            this.lbl_wild.text = this.uiApi.getText("ui.common.yes");
         }
         else
         {
            this.lbl_wild.text = this.uiApi.getText("ui.common.no");
         }
         this._serenityText = this._currentMount.aggressivityMax + "/" + this._currentMount.serenity + "/" + this._currentMount.serenityMax;
         this.tx_mount.look = this._currentMount.entityLook;
         var _loc3_:Object = this.playerApi.getMount();
         if(_loc3_)
         {
            if(_loc3_.id == this._currentMount.id)
            {
               this._playerMount = true;
            }
            else
            {
               this._playerMount = false;
            }
         }
         else
         {
            this._playerMount = false;
         }
         this.btn_feed.disabled = param1.maturity != param1.maturityForAdult;
         this.lbl_xp.visible = this._playerMount;
         this.lbl_xpTitle.visible = this._playerMount;
         this.btn_xp.visible = this._playerMount;
         this.pb_Energy.value = Number(param1.energy / param1.energyMax);
         this.pb_xp.value = param1.experience / param1.experienceForNextLevel;
         this.pb_tired.value = param1.boostLimiter / param1.boostMax;
         if(param1.reproductionCount == -1)
         {
            this.lbl_reproduction.cssClass = "red";
            this.lbl_reproduction.text = this.uiApi.getText("ui.mount.castrated");
         }
         else if(param1.reproductionCount >= param1.reproductionCountMax)
         {
            this.lbl_reproduction.cssClass = "red";
            this.lbl_reproduction.text = this.uiApi.getText("ui.mount.sterilized");
         }
         else
         {
            this.lbl_reproduction.cssClass = "p";
            this.lbl_reproduction.text = param1.reproductionCount + "/" + param1.reproductionCountMax;
         }
         if(param1.fecondationTime > 0)
         {
            this.lbl_fecondation.visible = true;
            this.lbl_fecondation.text = this.uiApi.getText("ui.mount.fecondee") + " (" + param1.fecondationTime + " " + this.uiApi.processText(this.uiApi.getText("ui.time.hours"),"m",param1.fecondationTime == 1) + ")";
            if(this.lbl_reproduction.visible)
            {
               this.lbl_fecondation.cssClass = "exoticright";
               this.lbl_fecondation.x = 160;
            }
            else
            {
               this.lbl_fecondation.cssClass = "exotic";
               this.lbl_fecondation.x = 10;
            }
         }
         else if(param1.isFecondationReady)
         {
            this.lbl_fecondation.visible = true;
            this.lbl_fecondation.cssClass = "bonus";
            this.lbl_fecondation.text = this.uiApi.getText("ui.mount.fecondable");
         }
         else
         {
            this.lbl_fecondation.visible = false;
         }
         this.lbl_xp.text = param1.xpRatio + "%";
         this.pb_love.value = param1.love / param1.loveMax;
         if(param1.love >= param1.loveMax * 0.75)
         {
            this.pb_love.barColor = this.uiApi.me().getConstant("progressBarGreen");
         }
         else
         {
            this.pb_love.barColor = this.uiApi.me().getConstant("progressBarOrange");
         }
         this.pb_maturity.value = param1.maturity / param1.maturityForAdult;
         if(param1.maturity >= param1.maturityForAdult)
         {
            this.pb_maturity.barColor = this.uiApi.me().getConstant("progressBarGreen");
         }
         else
         {
            this.pb_maturity.barColor = this.uiApi.me().getConstant("progressBarOrange");
         }
         this.pb_stamina.value = param1.stamina / param1.staminaMax;
         if(param1.stamina >= param1.staminaMax * 0.75)
         {
            this.pb_stamina.barColor = this.uiApi.me().getConstant("progressBarGreen");
         }
         else
         {
            this.pb_stamina.barColor = this.uiApi.me().getConstant("progressBarOrange");
         }
         var _loc4_:int = param1.aggressivityMax;
         this.pb_serenity.value = (param1.serenity - _loc4_) / (param1.serenityMax - _loc4_);
         if(param1.serenity >= -2000 && param1.serenity <= 2000)
         {
            this.pb_serenity.barColor = this.uiApi.me().getConstant("progressBarGreen");
         }
         else
         {
            this.pb_serenity.barColor = this.uiApi.me().getConstant("progressBarOrange");
         }
         var _loc5_:int = param1.ability.length;
         var _loc6_:int = 0;
         for each(_loc7_ in this._aLblCap)
         {
            _loc7_.text = "";
         }
         if(_loc5_)
         {
            this.lbl_capacity.visible = true;
            this.ctr_capacity.visible = true;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               this._aLblCap[_loc6_].text = "• " + param1.ability[_loc6_].name;
               _loc6_++;
            }
         }
         else
         {
            this.lbl_capacity.visible = false;
            this.ctr_capacity.visible = false;
         }
         var _loc8_:int = param1.effectList.length;
         if(_loc8_)
         {
            this.gd_effects.dataProvider = param1.effectList;
         }
         else
         {
            this.gd_effects.dataProvider = ["• " + this.uiApi.processText(this.uiApi.getText("ui.common.lowerNone"),"m",true)];
         }
      }
      
      public function unload() : void
      {
         this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
      }
      
      private function onChangeName(param1:String) : void
      {
         if(param1.length >= ProtocolConstantsEnum.MIN_RIDE_NAME_LEN)
         {
            this.sysApi.sendAction(new MountRenameRequest(param1,this._currentMount.id));
         }
      }
      
      private function onValidXpRatio(param1:Number) : void
      {
         this.sysApi.sendAction(new MountSetXpRatioRequest(param1));
      }
      
      private function onConfirmCutMount() : void
      {
         if(this._paddockMode)
         {
            if(MountPaddock._currentSource == MountPaddock.SOURCE_EQUIP)
            {
               this.sysApi.sendAction(new ExchangeHandleMountStable(18,[this._currentMount.id]));
            }
            else if(MountPaddock._currentSource == MountPaddock.SOURCE_BARN)
            {
               this.sysApi.sendAction(new ExchangeHandleMountStable(17,[this._currentMount.id]));
            }
            else if(MountPaddock._currentSource == MountPaddock.SOURCE_PADDOCK)
            {
               this.sysApi.sendAction(new ExchangeHandleMountStable(19,[this._currentMount.id]));
            }
         }
         else
         {
            this.sysApi.sendAction(new MountSterilizeRequest());
         }
      }
      
      private function onConfirmKillMount() : void
      {
         if(this._paddockMode)
         {
            if(MountPaddock._currentSource == MountPaddock.SOURCE_EQUIP)
            {
               this.sysApi.sendAction(new ExchangeHandleMountStable(11,[this._currentMount.id]));
            }
            else if(MountPaddock._currentSource == MountPaddock.SOURCE_INVENTORY)
            {
               this.sysApi.sendAction(new ExchangeHandleMountStable(12,[this._currentMount.id]));
            }
            else if(MountPaddock._currentSource == MountPaddock.SOURCE_BARN)
            {
               this.sysApi.sendAction(new ExchangeHandleMountStable(3,[this._currentMount.id]));
            }
            else if(MountPaddock._currentSource == MountPaddock.SOURCE_PADDOCK)
            {
               this.sysApi.sendAction(new ExchangeHandleMountStable(8,[this._currentMount.id]));
            }
         }
         else
         {
            this.sysApi.sendAction(new MountReleaseRequest());
         }
      }
      
      private function onMountSterilized(param1:Number) : void
      {
         if(param1 == this._currentMount.id)
         {
            this.btn_sterilize.disabled = true;
            this.lbl_reproduction.text = this.uiApi.getText("ui.mount.castrated");
         }
      }
      
      private function onMountUnSet() : void
      {
         if(!this._paddockMode)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      private function onMountRiding(param1:Boolean) : void
      {
         this.btn_mount.selected = param1;
      }
      
      private function onMountRenamed(param1:Number, param2:String) : void
      {
         if(param1 == this._currentMount.id)
         {
            this.lbl_name.text = param2;
         }
         this.btn_changeName.x = this.lbl_name.x + this.lbl_name.width / 2 + this.lbl_name.textWidth / 2;
      }
      
      private function onMountXpRatio(param1:uint) : void
      {
         this.lbl_xp.text = param1 + "%";
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc7_:Object = null;
         var _loc9_:Object = null;
         var _loc2_:String = "";
         var _loc3_:int = 6;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc8_:uint = 0;
         if(param1 == this.btn_xp)
         {
            _loc2_ = this.uiApi.getText("ui.mount.xpPercentTooltip");
            _loc3_ = 7;
            _loc4_ = 1;
         }
         else if(param1 == this.btn_changeName)
         {
            _loc2_ = this.uiApi.getText("ui.mount.renameTooltip");
            _loc3_ = 7;
            _loc4_ = 1;
         }
         else if(param1 == this.btn_mount)
         {
            _loc2_ = this.uiApi.getText("ui.mount.rideTooltip");
            _loc3_ = 7;
            _loc4_ = 1;
            _loc6_ = this.bindsApi.getShortcutBindStr("toggleRide");
            if(this.btn_mount.softDisabled)
            {
               _loc2_ = this.uiApi.getText("ui.mount.underwaterRestriction");
               _loc6_ = null;
            }
         }
         else if(param1 == this.btn_storage)
         {
            _loc2_ = this.uiApi.getText("ui.mount.inventoryAccess");
            _loc6_ = this.bindsApi.getShortcutBindStr("openMountStorage");
            _loc3_ = 7;
            _loc4_ = 1;
         }
         else if(param1 == this.btn_ancestors)
         {
            _loc2_ = this.uiApi.getText("ui.mount.ancestorTooltip");
            _loc3_ = 7;
            _loc4_ = 1;
         }
         else if(param1 == this.btn_sterilize)
         {
            _loc2_ = this.uiApi.getText("ui.mount.castrateTooltip");
            _loc3_ = 7;
            _loc4_ = 1;
         }
         else if(param1 == this.btn_release)
         {
            _loc2_ = this.uiApi.getText("ui.mount.killTooltip");
            _loc3_ = 7;
            _loc4_ = 1;
         }
         else if(param1 == this.btn_feed)
         {
            _loc2_ = this.uiApi.getText("ui.mount.feed");
            _loc3_ = 7;
            _loc4_ = 1;
         }
         else if(param1 == this.lbl_love)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipLove");
            _loc8_ = 300;
         }
         else if(param1 == this.lbl_maturity)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipMaturity");
            _loc8_ = 300;
         }
         else if(param1 == this.lbl_stamina)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipStamina");
            _loc8_ = 300;
         }
         else if(param1 == this.tx_stamina)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipZone1");
            _loc3_ = 1;
            _loc4_ = 7;
            _loc5_ = 10;
            _loc8_ = 300;
         }
         else if(param1 == this.tx_maturity)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerToolTipZone2");
            _loc3_ = 1;
            _loc4_ = 7;
            _loc5_ = 10;
            _loc8_ = 300;
         }
         else if(param1 == this.tx_love)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipZone3");
            _loc3_ = 1;
            _loc4_ = 7;
            _loc5_ = 10;
            _loc8_ = 300;
         }
         if(!this._currentMount)
         {
            return;
         }
         if(param1 == this.pb_Energy)
         {
            _loc2_ = this._currentMount.energy + "/" + this._currentMount.energyMax;
         }
         else if(param1 == this.pb_love)
         {
            _loc2_ = this._currentMount.love + "/" + this._currentMount.loveMax;
         }
         else if(param1 == this.pb_maturity)
         {
            _loc2_ = this._currentMount.maturity + "/" + this._currentMount.maturityForAdult;
         }
         else if(param1 == this.pb_serenity)
         {
            _loc2_ = this._currentMount.aggressivityMax + "/" + this._currentMount.serenity + "/" + this._currentMount.serenityMax;
         }
         else if(param1 == this.pb_stamina)
         {
            _loc2_ = this._currentMount.stamina + "/" + this._currentMount.staminaMax;
         }
         else if(param1 == this.pb_tired)
         {
            _loc2_ = this._currentMount.boostLimiter + "/" + this._currentMount.boostMax;
         }
         else if(param1 == this.pb_xp)
         {
            _loc2_ = this._currentMount.experience + "/" + this._currentMount.experienceForNextLevel;
         }
         else if(param1 == this.lbl_reproduction)
         {
            if(this._currentMount.reproductionCount == 20 || this._currentMount.reproductionCount == -1)
            {
               _loc2_ = this.uiApi.getText("ui.mount.sterileTooltip");
            }
         }
         else if(param1 == this.lbl_fecondation)
         {
            if(this._currentMount.fecondationTime > 0)
            {
               _loc2_ = this.uiApi.getText("ui.mount.timeToBirthTooltip");
            }
            else if(this._currentMount.isFecondationReady)
            {
               _loc2_ = this.uiApi.getText("ui.mount.fecondableTooltip");
            }
         }
         if(_loc2_ != "")
         {
            if(_loc6_)
            {
               if(!_shortcutColor)
               {
                  _shortcutColor = this.sysApi.getConfigEntry("colors.shortcut");
                  _shortcutColor = _shortcutColor.replace("0x","#");
               }
               _loc9_ = this.uiApi.textTooltipInfo(_loc2_ + " <font color=\'" + _shortcutColor + "\'>(" + _loc6_ + ")</font>",null,null,_loc8_);
            }
            else
            {
               _loc9_ = this.uiApi.textTooltipInfo(_loc2_,null,null,_loc8_);
            }
            this.uiApi.showTooltip(_loc9_,param1,false,"standard",_loc3_,_loc4_,_loc5_,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRelease(param1:Object) : void
      {
         var target:Object = param1;
         switch(target)
         {
            case this.btn_changeName:
               this.modCommon.openInputPopup(this.uiApi.getText("ui.mount.renameTooltip"),this.uiApi.getText("ui.mount.popupRename"),this.onChangeName,null,this._currentMount.name,"A-Za-z",ProtocolConstantsEnum.MAX_RIDE_NAME_LEN);
               break;
            case this.btn_xp:
               this.modCommon.openQuantityPopup(0,90,this._currentMount.xpRatio,this.onValidXpRatio);
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_sterilize:
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.mount.doUCastrateYourMount"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmCutMount,null]);
               break;
            case this.btn_release:
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.mount.doUKillYourMount"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmKillMount,null],this.onConfirmKillMount,function():void
               {
               });
               break;
            case this.btn_ancestors:
               if(!this.uiApi.getUi(UIEnum.MOUNT_ANCESTORS))
               {
                  this.uiApi.loadUi(UIEnum.MOUNT_ANCESTORS,UIEnum.MOUNT_ANCESTORS,{"mount":this._currentMount},StrataEnum.STRATA_TOP);
               }
               break;
            case this.btn_storage:
               if(this.playerApi.isInFight())
               {
                  this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.error.cantDoInFight"),666,this.timeApi.getTimestamp());
               }
               else
               {
                  this.sysApi.sendAction(new ExchangeRequestOnMountStock());
               }
               break;
            case this.btn_mount:
               if(this.shortcutTimerReady())
               {
                  this.sysApi.sendAction(new MountToggleRidingRequest());
                  this.btn_mount.selected = false;
               }
               else
               {
                  this.btn_mount.selected = !this.btn_mount.selected;
               }
               break;
            case this.btn_feed:
               this.initFeed();
               break;
            case this.btn_stat:
               this.ctr_stat.visible = true;
               this.ctr_capacity.visible = true;
               this.ctr_effect.visible = false;
               break;
            case this.btn_effect:
               this.ctr_stat.visible = false;
               this.ctr_capacity.visible = true;
               this.ctr_effect.visible = true;
         }
      }
      
      private function shortcutTimerReady() : Boolean
      {
         var _loc1_:int = getTimer();
         var _loc2_:* = _loc1_ - this._shortcutTimerDuration > SHORTCUT_DISABLE_DURATION;
         this._shortcutTimerDuration = _loc1_;
         return _loc2_;
      }
      
      private function initFeed() : void
      {
         var _loc1_:Object = null;
         if((MountPaddock._currentSource == MountPaddock.SOURCE_EQUIP || MountPaddock._currentSource == MountPaddock.SOURCE_BARN) && (!this.playerApi.isInFight() || this.playerApi.isInPreFight()))
         {
            _loc1_ = this.storageApi.getRideFoods();
            if(_loc1_.length)
            {
               this.sysApi.dispatchHook(OpenMountFeed,this._currentMount.id,MountPaddock._currentSource,_loc1_);
            }
            else
            {
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.item.errorNoFoodMount"),[this.uiApi.getText("ui.common.ok")]);
            }
         }
         else
         {
            this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.mount.impossibleFeed"),666,this.timeApi.getTimestamp());
         }
      }
      
      private function onMountSet() : void
      {
         this.showMountInformation(this.playerApi.getMount(),MountPaddock.SOURCE_EQUIP);
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            if(this._paddockMode)
            {
               return false;
            }
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
   }
}
