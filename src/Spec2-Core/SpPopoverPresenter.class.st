"
A presenter to display a popover. 
`SpPopoverPresenter` will be relative to its owner, but Iitcan be shown pointing to a particular place (see `SpPopoverPresenter>>#popup`, and `SpPopoverPresenter>>#popupPointingTo:`)
Also, it can be show at the top, left, bottom or right of the owner or rectangle to point.

The presenter placed on a popover needs to extend `SpPopoverContentPresenter` (or implement its API) to gain all properties.
"
Class {
	#name : 'SpPopoverPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'#isClosed => ObservableSlot',
		'#presenter => ObservableSlot',
		'#position',
		'#relativeTo'
	],
	#category : 'Spec2-Core-Widgets',
	#package : 'Spec2-Core',
	#tag : 'Widgets'
}

{ #category : 'specs' }
SpPopoverPresenter class >> adapterName [

	^ #PopoverAdapter
]

{ #category : 'documentation' }
SpPopoverPresenter class >> documentFactoryMethodSelector [

	^ #newPopover
]

{ #category : 'visiting' }
SpPopoverPresenter >> acceptVisitor: aVisitor [

	aVisitor visitPopoverPresenter: self
]

{ #category : 'api' }
SpPopoverPresenter >> bePositionBottom [
	"Set the popover to appear at the bottom of the owner (or the presenter set 
	 by `SpPopoverPresenter>>#relativeTo:`). 
	 See also `SpPopoverPresenter>>#position:`"

	self position: SpPopoverPosition bottom
]

{ #category : 'api' }
SpPopoverPresenter >> bePositionLeft [
	"Set the popover to appear at the left of the owner (or the presenter set 
	 by `SpPopoverPresenter>>#relativeTo:`)
	 See also `SpPopoverPresenter>>#position:`"

	self position: SpPopoverPosition left
]

{ #category : 'api' }
SpPopoverPresenter >> bePositionRight [
	"Set the popover to appear at the right of the owner (or the presenter set 
	 by `SpPopoverPresenter>>#relativeTo:`)
	 See also `SpPopoverPresenter>>#position:`"

	self position: SpPopoverPosition right
]

{ #category : 'api' }
SpPopoverPresenter >> bePositionTop [
	"Set the popover to appear at the top of the owner (or the presenter set 
	 by `SpPopoverPresenter>>#relativeTo:`)
	 See also `SpPopoverPresenter>>#position:`"

	self position: SpPopoverPosition top
]

{ #category : 'api - focus' }
SpPopoverPresenter >> defaultKeyboardFocus [

	^ self presenter
]

{ #category : 'api' }
SpPopoverPresenter >> dismiss [ 
	"Dismiss this popover"

	^ self withAdapterDo: [ :anAdapter | anAdapter dismiss ]
]

{ #category : 'initialization' }
SpPopoverPresenter >> initialize [

	super initialize.
	isClosed := true.
	self bePositionBottom
]

{ #category : 'testing' }
SpPopoverPresenter >> isPopover [

	^ true
]

{ #category : 'private' }
SpPopoverPresenter >> nearWindowLike [

	^ self
]

{ #category : 'private' }
SpPopoverPresenter >> popoverClosed [

	isClosed := true
	
]

{ #category : 'private' }
SpPopoverPresenter >> popoverOpened [

	isClosed := false
]

{ #category : 'api' }
SpPopoverPresenter >> popup [

	"Shows the popover, relative to `SpPopoverPresenter>>#relativeTo`."

	self adapter ifNil: [ self build ].
	self withAdapterDo: [ :anAdapter | anAdapter popup ]
]

{ #category : 'api' }
SpPopoverPresenter >> popupModal [
	"Shows the popover modaly, relative to `SpPopoverPresenter>>#relativeTo`"

	self adapter ifNil: [ self build ].
	self withAdapterDo: [ :anAdapter | anAdapter popupModal ]
]

{ #category : 'api' }
SpPopoverPresenter >> popupModalAndWait [
	"Shows the popover modaly, relative to `SpPopoverPresenter>>#relativeTo`. 
	 And wait for an answer"
	| sem |
	
	sem := Semaphore new.
	self whenClosedDo: [ sem signal ].
	self popupModal.
	sem wait

	
]

{ #category : 'api' }
SpPopoverPresenter >> popupModalPointingTo: aRectangle [
	"Shows the popover, relative to `SpPopoverPresenter>>#relativeTo`, and 
	 pointing to `aRectangle`"

	self adapter ifNil: [ self build ].
	self withAdapterDo: [ :anAdapter |
		anAdapter popupModalPointingTo: aRectangle ]
]

{ #category : 'api' }
SpPopoverPresenter >> popupPointingTo: aRectangle [
	"Shows the popover, relative to `SpPopoverPresenter>>#relativeTo`, and 
	 pointing to `aRectangle`"

	self adapter ifNil: [ self build ].
	self withAdapterDo: [ :anAdapter |
		anAdapter popupPointingTo: aRectangle ]
]

{ #category : 'api' }
SpPopoverPresenter >> position [
	"Answer the position (top, left, bottom, right) of the presenter."

	^ position
]

{ #category : 'api' }
SpPopoverPresenter >> position: aPosition [
	"Set the position (top, left, bottom, right) of the presenter."

	position := aPosition
]

{ #category : 'api' }
SpPopoverPresenter >> presenter [
	"Answer the presenter that will be shown by the popover."

	^ presenter
]

{ #category : 'api' }
SpPopoverPresenter >> presenter: aPresenter [
	"Set the presenter that will be shown by the popover."

	aPresenter owner: self.
	presenter := aPresenter.
	presenter initializePopover: self
]

{ #category : 'api' }
SpPopoverPresenter >> relativeTo [
	"Answer the presenter that will show the popover (and the popover will be shown relative to it)."

	^ relativeTo ifNil: [ self owner ]
]

{ #category : 'api' }
SpPopoverPresenter >> relativeTo: aPresenter [
	"Set the presenter that will show the popover (and the popover will be shown relative to it)."

	relativeTo := aPresenter
]

{ #category : 'private - traversing' }
SpPopoverPresenter >> traversePresentersDo: aBlock excluding: excludes [

	super traversePresentersDo: aBlock excluding: excludes.
	self presenter 
		traversePresentersDo: aBlock 
		excluding: excludes
]

{ #category : 'api - events' }
SpPopoverPresenter >> whenClosedDo: aBlock [
	"Inform when window is closed.
	 `aBlock` receives zero arguments."
	
	self 
		property: #isClosed 
		whenChangedDo: [ :value | value ifTrue: aBlock ]
]

{ #category : 'api - events' }
SpPopoverPresenter >> whenOpenedDo: aBlock [
	"Inform when window is opened. 
	 `aBlock` receives zero arguments."

	self 
		property: #isClosed 
		whenChangedDo: [ :value | value ifFalse: aBlock ]
]

{ #category : 'api - events' }
SpPopoverPresenter >> whenPresenterChangedDo: aBlock [
	"Inform when content presenter has changed. 
	 `aBlock` has three optional arguments: 
	 - new value
	 - old value
	 - the announcement triggering this action"

	self property: #presenter whenChangedDo: aBlock
]
