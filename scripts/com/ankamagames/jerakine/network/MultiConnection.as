package com.ankamagames.jerakine.network
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [Event("messageSentEvent",type="com.ankamagames.jerakine.network.NetworkSentEvent")]
   [Event("securityError",type="flash.events.SecurityErrorEvent")]
   [Event("ioError",type="flash.events.IOErrorEvent")]
   [Event("close",type="flash.events.Event")]
   [Event("connect",type="flash.events.Event")]
   public class MultiConnection extends EventDispatcher
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MultiConnection));
       
      
      private var _connectionByMsg:Dictionary;
      
      private var _connectionByEvent:Dictionary;
      
      private var _connectionById:Dictionary;
      
      private var _idByConnection:Dictionary;
      
      private var _connectionCount:uint;
      
      private var _mainConnection:IServerConnection;
      
      private var _messageRouter:IMessageRouter;
      
      private var _connectionConnectedCount:int;
      
      public function MultiConnection()
      {
         this._connectionByMsg = new Dictionary(true);
         this._connectionByEvent = new Dictionary(true);
         this._connectionById = new Dictionary();
         this._idByConnection = new Dictionary();
         super(this);
      }
      
      public function get mainConnection() : IServerConnection
      {
         return this._mainConnection;
      }
      
      public function set mainConnection(param1:IServerConnection) : void
      {
         if(!this._idByConnection[param1])
         {
            throw new ArgumentError("Connection must be added before setted to be the main connection");
         }
         this._mainConnection = param1;
      }
      
      public function get messageRouter() : IMessageRouter
      {
         return this._messageRouter;
      }
      
      public function set messageRouter(param1:IMessageRouter) : void
      {
         this._messageRouter = param1;
      }
      
      public function get connected() : Boolean
      {
         return this._connectionConnectedCount != 0;
      }
      
      public function get connectionCount() : uint
      {
         return this._connectionCount;
      }
      
      public function addConnection(param1:IServerConnection, param2:String) : void
      {
         var e:* = undefined;
         var conn:IServerConnection = param1;
         var id:String = param2;
         if(this._connectionById[id])
         {
            this.removeConnection(id);
         }
         if(this._idByConnection[conn])
         {
            this.removeConnection(conn);
         }
         this._connectionById[id] = conn;
         this._idByConnection[conn] = id;
         this._connectionCount++;
         _log.warn("Adding connection " + id);
         conn.handler = new MessageWatcher(this.proccessMsg,conn.handler,conn);
         for each(e in DescribeTypeCache.typeDescription(conn)..metadata.(@name == "Event").arg.(@key == "").@value)
         {
            IEventDispatcher(conn).addEventListener(e.toString(),this.onSubConnectionEvent);
         }
         if(conn.connected)
         {
            this._connectionConnectedCount++;
         }
      }
      
      public function removeConnection(param1:*) : Boolean
      {
         var id:String = null;
         var conn:IServerConnection = null;
         var e:* = undefined;
         var otherConn:IServerConnection = null;
         var idOrConnection:* = param1;
         if(idOrConnection is String)
         {
            id = idOrConnection;
            conn = this.getSubConnection(idOrConnection);
         }
         if(idOrConnection is IServerConnection)
         {
            id = this._idByConnection[idOrConnection];
            conn = idOrConnection;
         }
         if(!conn)
         {
            return false;
         }
         for each(e in DescribeTypeCache.typeDescription(conn)..metadata.(@name == "Event").arg.(@key == "").@value)
         {
            IEventDispatcher(conn).removeEventListener(e.toString(),this.onSubConnectionEvent);
         }
         this._connectionCount--;
         if(conn.connected)
         {
            this._connectionConnectedCount--;
         }
         delete this._connectionById[id];
         delete this._idByConnection[conn];
         if(this._mainConnection == conn)
         {
            for each(otherConn in this._connectionById)
            {
               this._mainConnection = otherConn;
            }
         }
         if(conn.handler is MultiConnection)
         {
            conn.handler = MessageWatcher(conn.handler).handler;
         }
         return true;
      }
      
      public function getSubConnection(param1:* = null) : IServerConnection
      {
         if(param1 is String)
         {
            return this._connectionById[param1];
         }
         if(param1 is Message)
         {
            return this._connectionByMsg[param1];
         }
         if(param1 is Event)
         {
            return this._connectionByEvent[param1];
         }
         throw new TypeError("Can\'t handle " + param1 + " class");
      }
      
      public function getConnectionId(param1:* = null) : String
      {
         var _loc2_:IServerConnection = this.getSubConnection(param1);
         return this._idByConnection[_loc2_];
      }
      
      public function getPauseBuffer(param1:String = null) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:IServerConnection = null;
         if(param1 && this._connectionById[param1])
         {
            return IServerConnection(this._connectionById[param1]).pauseBuffer;
         }
         if(!param1)
         {
            _loc2_ = [];
            for each(_loc3_ in this._connectionById)
            {
               _loc2_ = _loc2_.concat(_loc3_.pauseBuffer);
            }
            return _loc2_;
         }
         return null;
      }
      
      public function close(param1:String = null) : void
      {
         var _loc2_:IServerConnection = null;
         if(param1)
         {
            _log.warn("Connection " + param1 + " will be closed...");
            if(this._connectionById[param1])
            {
               IServerConnection(this._connectionById[param1]).close();
               if(this._connectionCount > 1)
               {
                  this.removeConnection(param1);
               }
            }
            return;
         }
         _log.warn("All connections will be closed...");
         for each(_loc2_ in this._connectionById)
         {
            _loc2_.close();
         }
      }
      
      public function pause(param1:String = null) : void
      {
         var _loc2_:IServerConnection = null;
         if(param1)
         {
            if(this._connectionById[param1])
            {
               IServerConnection(this._connectionById[param1]).pause();
            }
            return;
         }
         for each(_loc2_ in this._connectionById)
         {
            _loc2_.pause();
         }
      }
      
      public function resume(param1:String = null) : void
      {
         var _loc2_:IServerConnection = null;
         if(param1)
         {
            if(this._connectionById[param1])
            {
               IServerConnection(this._connectionById[param1]).resume();
            }
            return;
         }
         for each(_loc2_ in this._connectionById)
         {
            _loc2_.resume();
         }
      }
      
      public function send(param1:INetworkMessage, param2:String = "") : void
      {
         var _loc3_:IServerConnection = null;
         if(this._messageRouter)
         {
            if(param2 == "")
            {
               param2 = this._messageRouter.getConnectionId(param1);
            }
            if(!param2 || param2 == "")
            {
               _log.error(param1 + " sending impossible : no connection id");
               return;
            }
            if(param2 == "all")
            {
               for each(_loc3_ in this._connectionById)
               {
                  if(_loc3_.connected)
                  {
                     _loc3_.send(param1);
                  }
               }
            }
            else
            {
               this.getSubConnection(param2).send(param1);
            }
         }
         else if(this._mainConnection)
         {
            this._mainConnection.send(param1);
         }
         if(hasEventListener(NetworkSentEvent.EVENT_SENT))
         {
            dispatchEvent(new NetworkSentEvent(NetworkSentEvent.EVENT_SENT,param1));
         }
      }
      
      private function proccessMsg(param1:Message, param2:IServerConnection) : void
      {
         this._connectionByMsg[param1] = param2;
      }
      
      private function onSubConnectionEvent(param1:Event) : void
      {
         switch(param1.type)
         {
            case Event.CONNECT:
               this._connectionConnectedCount++;
               break;
            case Event.CLOSE:
               this._connectionConnectedCount--;
         }
         this._connectionByEvent[param1] = param1.target as IServerConnection;
         dispatchEvent(param1);
      }
   }
}

import com.ankamagames.jerakine.messages.Message;
import com.ankamagames.jerakine.messages.MessageHandler;
import com.ankamagames.jerakine.network.IServerConnection;

class MessageWatcher implements MessageHandler
{
    
   
   public var watchFunction:Function;
   
   public var handler:MessageHandler;
   
   public var conn:IServerConnection;
   
   function MessageWatcher(param1:Function, param2:MessageHandler, param3:IServerConnection)
   {
      super();
      this.watchFunction = param1;
      this.handler = param2;
      this.conn = param3;
   }
   
   public function process(param1:Message) : Boolean
   {
      this.watchFunction(param1,this.conn);
      return this.handler.process(param1);
   }
}
