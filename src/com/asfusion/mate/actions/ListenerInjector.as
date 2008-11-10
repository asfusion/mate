package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.ISmartObject;
	import com.asfusion.mate.events.InjectorEvent;
	import mx.core.EventPriority;
	import flash.events.IEventDispatcher;
	
	public class ListenerInjector extends AbstractAction implements IAction
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                         Public Setters and Getters
		//------------------------------------------------------------------------------------------------------------
		
		//.........................................dispatcher..........................................
		private var _dispatcher:Object;
		/**
		 * @TODO
		 */
		public function get dispatcher():Object
		{
			return _dispatcher;
		}
		public function set dispatcher(value:Object):void
		{
			_dispatcher = value;
		}
		
		//.........................................eventType..........................................
		private var _eventType:String;
		/**
		 * @TODO
		 */
		public function get eventType():String
		{
			return _eventType;
		}
		public function set eventType(value:String):void
		{
			_eventType = value;
		}
		
		//.........................................method..........................................
		private var _method:String;
		/**
		 * @TODO
		 */
		public function get method():String
		{
			return _method;
		}
		public function set method(value:String):void
		{
			_method = value;
		}
		
		//.........................................useCapture..........................................
		private var _useCapture:Boolean;
		/**
		 * @TODO
		 */
		public function get useCapture():Boolean
		{
			return _useCapture;
		}
		public function set useCapture(value:Boolean):void
		{
			_useCapture = value;
		}
		
		//.........................................useWeakReference..........................................
		private var _useWeakReference:Boolean = true;
		/**
		 * @todo
		 */
		public function get useWeakReference():Boolean
		{
			return _useWeakReference;
		}
		public function set useWeakReference(value:Boolean):void
		{
			_useWeakReference = value;
		}
		
		//.........................................priority..........................................
		private var _priority:int = EventPriority.DEFAULT;
		/**
		 * @TODO
		 */
		public function get priority():int
		{
			return _priority;
		}
		public function set priority(value:int):void
		{
			_priority = value;
		}
		
		//........................................targetId..........................................
		private var _targetId:String;
		/**
		 * @TODO
		 * 
		 * @default null
		 * */
		public function get targetId():String
		{
			return _targetId;
		}
		public function set targetId(value:String):void
		{
			_targetId = value;
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                         Override protected methods
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................run.................................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			if(!scope.event is InjectorEvent) return;
			
			var event:InjectorEvent = InjectorEvent(scope.event);
			if(eventType && (targetId == null || targetId == event.uid))
			{
				if(event.injectorTarget.hasOwnProperty(method) && event.injectorTarget[method] is Function)
				{
					var targetFunction:Function = event.injectorTarget[method];
					var currentDispatcher:Object = (currentDispatcher is ISmartObject) ? ISmartObject(currentDispatcher).getValue(scope) : currentDispatcher;
					if(!currentDispatcher) currentDispatcher = scope.dispatcher;
					
					if(currentDispatcher is IEventDispatcher)
					{
						IEventDispatcher(currentDispatcher).addEventListener(eventType, targetFunction, useCapture, priority, useWeakReference);
					}
				}
			}
		}
	}
}