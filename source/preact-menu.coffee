require './style/Menu.scss'
{h,Component} = require 'preact'
Overlay = require './Overlay.coffee'
cn = require 'classnames'



class MenuItem extends Component
	constructor: (props)->
		super(props)
		@state = 
			visible: no
	onMouseEnter: ()=>
		@setState
			visible: yes

	onMouseLeave: ()=>
		@setState
			visible: no
	
	getChildContext: ()=>
		vertical: @props.vertical
		inverse: @props.inverse
			
	setPos: ()->
		x = 0
		y = 0
		children_align_vertical = !@context.vertical
		children_align_inverse = @context.inverse

		if children_align_vertical 
			if children_align_inverse

				y = -@_items.clientHeight
				x = 0
			else
				y = @_item.clientHeight
				x = 0
		else if !children_align_vertical
			if children_align_inverse
				y = 0
				x = -@_items.clientWidth
			else
				y = 0 
				x = @_item.clientWidth


		rect = @_item.getBoundingClientRect()
		top = (rect.top + y + @_items.clientHeight)
		if top > window.innerHeight
			y -= (top - window.innerHeight - 5)

		left = (rect.left + x + @_items.clientWidth)

		if left > window.innerWidth
			x = -@_items.clientWidth
		x = Math.round(x)
		y = Math.round(y)
		@_items.style.transform = "translate(#{x}px,#{y}px)"
	componentDidMount: ()->
		@setPos()
	componentWillUpdate: ()->
		if !@context.visible
			@state.visible = no
	componentDidUpdate: ()->
		@setPos()

	render: ()->
		h 'div',
			ref: (el)=>
				@_item = el
			className: cn 'intui-menu-item',@props.vertical && 'vertical' || null
			onMouseEnter: @onMouseEnter
			onMouseLeave: @onMouseLeave
			onClick: @props.onClick
			style: @props.style
			h 'div',
				className: 'label'
				@props.label
			h 'div',
				ref: (el)=>
					@_items = el
				className: cn 'intui-menu-items',(@context.visible && (@state.visible || @props.visible)) && 'visible' || null,@props.vertical && 'vertical' || null,@props.inverse && 'inverse' || null
					h 'div',
						className: 'intui-menu-items-content'
						@props.children


MenuItem.defaultProps=
	vertical: no



class Menu extends Component
	constructor: (props)->
		super(props)

	getChildContext: ()=>
		vertical: @props.vertical
		inverse: @props.inverse
		visible: @props.visible

	render: ()->

		h 'div',
			className: cn @props.className || null,'intui-menu',@props.fixed && 'fixed' || null
			style: 
				transform: "translate(#{Math.round(@props.x)}px,#{Math.round(@props.y)}px)"
			# onBlur: @props.onBlur
			h 'div',
				className: cn 'intui-menu-items',(@props.visible) && 'visible' || null,@props.vertical && 'vertical' || null
				h 'div',
					className: 'intui-menu-items-content'
					@props.children

Menu.defaultProps = 
	vertical: no
	inverse: no



module.exports.Menu = Menu
module.exports.MenuItem = MenuItem