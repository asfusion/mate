package com.asfusion.mate.ioc
{
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;

	[Exclude(name="activate", kind="event")]
    [Exclude(name="deactivate", kind="event")]
	public class InjectorTarget extends EventDispatcher implements IMXMLObject
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Public Methods
		-------------------------------------------------------------------------------------------------------------*/
		public function register():void
		{
			InjectorRegistry.register(this, id);
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Implementation of IMXMLObject interface
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................document..........................................*/
		/**
		 * A reference to the document object associated with this InjectorTarget. A document object is an Object at the top
		 * of the hierarchy of a Flex application, MXML component, or AS component.
		 */
		protected var document:Object;
		
		/*-.........................................id..........................................*/
		/**
		 * ID of the component.
		 */
		protected var id:String;
		
		/*-.........................................initialized..........................................*/
		/**
		 * Called automatically by the MXML compiler if the InjectorTarget is set up using a tag.
		 */
		public function initialized(document:Object, id:String):void
		{
			this.document = document;
			this.id = id;
			register();
		}
	}
}