/**
 * @classdescription: 
 * @author: Sebastian Martens; sebastian@sebastian-martens.de
 * @copyright: Creative Commons. Free to use "as is"
 * @svn: $Id: swfInputs.js 23 2009-05-29 19:17:36Z dinnerout $
 */
var swfInputs = {
	_inputs: [], // collection of all used inputs
	_initialized: false,
	_channels: [], // list of channels
	_supportedTypeList: ['SWFTextInput'], // list of supported input types
	_tabIndex: 10000,
	_isFocusManager: false,
	_preFocusNode: null,
	_postFocusNode: null,
	
	/**
	 * initialisation method - must called at beginning
	 * @param swfId String - html id of Application
	 * @param channel String - name od channel
	 * 
	 */ 
	init: function( swfId, channel ){
		if( !channel || channel=='' ) channel='_swfIDefCh';
		if( this.addChannel(swfId, channel) && (this._channels.length>0) ){
			dojo.connect( window, 'onresize', this, this._handleResize);
			this._initialized = true;
		}
		return false;
	},
	
	/**
	 * handles resize event and updates input positions
	 * @param evt Event - Resize Event
	 */  
	_handleResize: function( evt ){
		var obj = null;
		var channel = '';
		var swfCoords = null;
		var node = null;
				
		for( obj in this._inputs ){
			channel = dojo.attr( this._inputs[ obj ],'swf');
			node = dojo.byId( this._inputs[ obj ].channel+ this._inputs[ obj ].id );
			swfCoords = dojo.coords( dojo.byId( dojo.attr(node,'swf') ) );
			dojo.style( node, 'top', this._inputs[ obj ].y + swfCoords['y'] );
			dojo.style( node, 'left', this._inputs[ obj ].x + swfCoords['x'] );
			
		}
	},
	
	/**
	 * returns an 
	 */
	_getObjectByInputId: function( id ){
		var obj = null;
		
		for( obj in this._inputs ){
			if( this._inputs[obj].channel+this._inputs[obj].id==id ) return this._inputs[obj];
		}
		
		return null;
	},
	
	/**
	 * creates two additional inputs
	 */
	_createFocusHandler: function(){
		if( this._isFocusManager ) return;
		//
		preNode = document.createElement("INPUT");
		preNode.setAttribute('type','text');
		preNode.style.position = "absolute";
		preNode.style.top = "-1000px";
		/* TODO: implement focus manager for multichannel */ 
		preNode.setAttribute('swf',this._channels[0].id);
		preNode.setAttribute('channel',this._channels[0].channel);
		preNode.id = "pre"+this._channels[0].channel+this._inputs[0].id;
		
		preNode.tabIndex = this._tabIndex;
		this._tabIndex++;
		
		postNode = document.createElement("INPUT");
		postNode.setAttribute('type','text');
		postNode.style.position = "absolute";
		postNode.style.top = "-1000px";
		/* TODO: implement focus manager for multichannel */ 
		postNode.setAttribute('swf',this._channels[0].id);
		postNode.setAttribute('channel',this._channels[0].channel);
		postNode.id = "post"+this._channels[0].channel+this._inputs[0].id;
		
		preNode.onfocus = this._preFocusHandler;
		postNode.onfocus = this._postFocusHandler;
		
		preNode.tabIndex = this._tabIndex;
		this._tabIndex++;
		
		this._preFocusNode = preNode;
		this._postFocusNode = postNode;
		
		// attatch to DOM
		document.getElementsByTagName('BODY')[0].appendChild( preNode );
		document.getElementsByTagName('BODY')[0].appendChild( postNode );
		
		// update tab index
		this._updatePostFocusTab();
		
		this._isFocusManager = true;
	},
	
	/**
	 * focus handler for the pre input field
	 * @param event Object - focus event
	 */
	_preFocusHandler: function( event ){
		var node = event.currentTarget;
		var swf = dojo.byId( node.getAttribute('swf') );
		swf.focus();
		eval( 'dojo.byId(\''+swf.id+'\').onPreFocus'+node.id+'()' );
	},
	
	/**
	 * focus handler for the post input field
	 * @param event Object - focus event
	 */
	_postFocusHandler: function( event ){
		var node = event.currentTarget;
		var swf = dojo.byId( node.getAttribute('swf') );
		swf.focus();
		eval( 'dojo.byId(\''+swf.id+'\').onPostFocus'+node.id+'()' );
	},
	
	/**
	 * updates the tabIndex value of the post-focus input. this field needs to have the latest index
	 */
	_updatePostFocusTab: function(){
		this._postFocusNode.tabIndex = this._tabIndex;
	},
	
	/**
	 * adds an additional channel to map between html-id an channel-name
	 * @param swfId String - html id of Application
	 * @param channel String - name od channel
	 * @return operation succesful
	 */
	addChannel: function( swfId, channel_name){
		if( swfId=="" || channel_name=="" ) return false;
		// channel already existing
		if( this._getChannelByName(channel_name) ) return false;
		// add new channel
		this._channels[ this._channels.length ] = {'id':swfId, 'channel':channel_name};
		return true;
	},
	
	/**
	 * gets an object with channel and id
	 * @param id String - id to search for
	 * @return Object - contains flash-id and channel
	 */
	_getObjectById: function( id ){
		if( !id || id=='' ) return false;
		for( var i=0; i<this._channels.length; i++ ){
			if( this._channels[i].id==id ) return this._channels[i];
		}
		return false;
	},
	
	/**
	 * initialization method from SWFInput
	 * @param obj Object
	 * @return Boolean initialisation successful
	 */
	swfInputInit: function( obj ){
		if( !this._initialized ) return false;
		// test if dojo is available
		try{
			if( !dojo ) return false;
		}catch( e ){}
		return this._initialized;
	},
	
	/**
	 * search for an channel object in channel list
	 * @param channelname String - name of channel to search
	 * @return Object - found object
	 */
	_getChannelByName: function( channelname ){
		for(var i=0; i<this._channels.length; i++){
			if( this._channels[i].channel == channelname ) return this._channels[i];
		}
		return false;
	},
	
	/**
	 * returns if this object is initialized 
	 * @return Boolean - is initialization complete
	 */
	isInitialized: function(){
		return this._initialized;
	},
	
	/**
	 * returns if the SWFInputs implementation is needed for this browser
	 * @param obj:Object - standard get object
	 * @return Boolean - is SWFInputs implementation needed
	 */
	swfInputsRequiered: function( obj ){
		return !dojo.isIE && (navigator.appVersion.indexOf("Win")!=-1);
		// return true;
	},
	
	/**
	 * create new input
	 * @param obj - Object with input parameters ( @see description of addSWFInput-method )
	 * @return Boolean creation successful
	 */
	_createInputType: function( obj ){
		// id of input required 
		if( !obj.id || !this._supportedType( obj.type ) ) return false;
		// create pre/post input for focus-management
		if( !this._isFocusManager ) this._createFocusHandler();
		// switch between different supported types
		switch( obj.type ){
			// create text input field
			case 'SWFTextInput': return this._createSWFTextInput( obj ); break;
		}
		return false;
	},
	
	/**
	 * creates an text input field and attach to DOM
	 * @param obj - Object with input parameters ( @see description of addSWFInput-method )
	 * @return Node - DOM node of created input
	 */
	_createSWFTextInput: function( obj ){
		var node = null;
		var swf = this._getChannelByName( obj.channel );

		// input basics
		node = document.createElement("INPUT");
		node.setAttribute('type','text');
		node.setAttribute('id',obj.channel+obj.id);
		node.setAttribute('swf',swf.id);
		
		// input position, dimension
		var swfCoords = dojo.coords( dojo.byId(swf.id) );
		node.style.position = 'absolute';
		node.style.top = obj.y + swfCoords['y'];
		node.style.left = obj.x + swfCoords['x'];
		
		node.style.width = obj.width;
		node.style.height = obj.height;
		
		// input styles
		node.style.border = obj.borderStyle+" "+obj.borderColor+" "+obj.border+"px";
		node.style.fontFamily = obj.font_family;
		node.style.fontSize = obj.font_size;
		
		// event handler
		node.onkeyup = this.onKeyDownHandler;
		
		// tab index
		node.tabIndex = this._tabIndex;
		this._tabIndex++;
		
		// attatch to DOM
		document.getElementsByTagName('BODY')[0].appendChild( node );
		
		// update tab index
		this._updatePostFocusTab();
		
		return node;
	},
	
	/**
	 * handles onKeyDown event of created input
	 * @param event KeyEvent - key down event 
	 */
	onKeyDownHandler: function( event ){
		var node = event.currentTarget;
		var swfId = node.getAttribute('swf');
		if(event.keyCode)
		{
			
		}
		eval( 'dojo.byId(\''+swfId+'\').onChange'+node.id+'("'+node.value+'")' );
	},
	
	/**
	 * updates content of managed input fields 
	 * @param obj Object
	 *			.id - id of input to update
	 *			.channel - channel of input
	 *			.value - value to insert
	 */
	updateContent: function( obj ){
		dojo.byId( obj.channel+obj.id ).value = obj.value;
	},
	
	/**
	 * sets the focus an input field
	 * @param obj Object
	 *			.id - id of input to update
	 *			.channel - channel of input
	 *			.value - value to insert
	 */
	setFocus: function( obj ){
		var node = dojo.byId( obj.channel+obj.id );
		node.focus();
	},
	
	/**
	 * checks if type is supported 
	 * @param type String - type to check
	 * @return is this type in supported list
	 */
	_supportedType: function( type ){
		if( type=='' ) return false;
		for( i=0; i<this._supportedTypeList.length; i++){
			if( this._supportedTypeList[i].toLowerCase() == type.toLowerCase() ) return true; 
		}
		return false;
	},
	
	/**
	 * registers a new SWFInput field
	 * @param obj - Object with input parameters 
	 * 				.x - absolute x position in flash
	 * 				.y - absolute y position in flash
	 *				.id - id of html element
	 *				.type - type of inputs
	 *				.channel - name of channel
	 * @return index:int - index of registerd field id creating successful, else returns -1
	 */
	addSWFInput: function( obj ){
		var index = this._inputs.length;
		this._inputs[ index ] = obj;
		return (this._createInputType( obj )?index:-1);
	}
}