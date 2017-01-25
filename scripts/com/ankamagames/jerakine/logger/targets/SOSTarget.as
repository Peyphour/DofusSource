package com.ankamagames.jerakine.logger.targets
{
   import com.ankamagames.jerakine.logger.LogEvent;
   import com.ankamagames.jerakine.logger.LogLevel;
   import com.ankamagames.jerakine.logger.TextLogEvent;
   import flash.events.Event;
   import flash.net.XMLSocket;
   
   public class SOSTarget extends AbstractTarget implements ConfigurableLoggingTarget
   {
      
      private static var _socket:XMLSocket = new XMLSocket();
      
      private static var _history:Array = new Array();
      
      private static var _connecting:Boolean = false;
      
      public static var enabled:Boolean = true;
      
      public static var serverHost:String = "localhost";
      
      public static var serverPort:int = 4444;
       
      
      public function SOSTarget()
      {
         super();
      }
      
      private static function send(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:LoggerHistoryElement = null;
         if(_socket.connected)
         {
            if(param1 != LogLevel.COMMANDS)
            {
               if(param3)
               {
                  _socket.send("!SOS<showFoldMessage key=\"" + getKeyName(param1) + "\"><title><![CDATA[" + param2 + "]]></title><message><![CDATA[" + param3 + "]]></message></showFoldMessage>");
               }
               else
               {
                  _socket.send("!SOS<showMessage key=\"" + getKeyName(param1) + "\"><![CDATA[" + param2 + "]]></showMessage>");
               }
            }
            else
            {
               _socket.send("!SOS<" + param2 + "/>");
            }
         }
         else
         {
            if(!_socket.hasEventListener("connect"))
            {
               _socket.addEventListener("connect",onSocket);
               _socket.addEventListener("ioError",onSocketError);
               _socket.addEventListener("securityError",onSocketError);
            }
            if(!_connecting)
            {
               _socket.connect(serverHost,serverPort);
               _connecting = true;
            }
            _loc4_ = new LoggerHistoryElement(param1,param2,param3);
            _history.push(_loc4_);
         }
      }
      
      private static function getKeyName(param1:int) : String
      {
         switch(param1)
         {
            case LogLevel.TRACE:
               return "trace";
            case LogLevel.DEBUG:
               return "debug";
            case LogLevel.INFO:
               return "info";
            case LogLevel.WARN:
               return "warning";
            case LogLevel.ERROR:
               return "error";
            case LogLevel.FATAL:
               return "fatal";
            default:
               return "severe";
         }
      }
      
      private static function onSocket(param1:Event) : void
      {
         var _loc2_:LoggerHistoryElement = null;
         _connecting = false;
         for each(_loc2_ in _history)
         {
            send(_loc2_.level,_loc2_.message,_loc2_.subMessage);
         }
         _history = new Array();
      }
      
      private static function onSocketError(param1:Event) : void
      {
         _connecting = false;
      }
      
      public function get socket() : XMLSocket
      {
         return _socket;
      }
      
      public function get connected() : Boolean
      {
         return _connecting;
      }
      
      override public function logEvent(param1:LogEvent) : void
      {
         var _loc2_:String = null;
         if(enabled && param1 is TextLogEvent)
         {
            _loc2_ = param1.message;
            if(param1.level == LogLevel.COMMANDS)
            {
               switch(_loc2_)
               {
                  case "clear":
                     _loc2_ = "<clear/>";
               }
            }
            send(param1.level,param1.message,param1.stackTrace);
         }
      }
      
      public function configure(param1:XML) : void
      {
         if(param1..server.@host != undefined)
         {
            serverHost = String(param1..server.@host);
         }
         if(param1..server.@port != undefined)
         {
            serverPort = int(param1..server.@port);
         }
      }
   }
}
