"
I'm a presenter used to describe a DialogWindow. 
Pay attention that it will not create a real modal in the sense that the user will keep the focus on other windows.

Usually instances of `SpDialogWindowPresenter` are created using the method `SpAbstractPresenter>>#openDialogWithSpec`.

If you want to make the user focus only on your dialog you should use `SpAbstractPresenter>>#openModalWithSpec` instead.

Canonical actions can be parameterized using the methods: `SpDialogWindowPresenter>>#cancelAction:` and `SpDialogWindowPresenter>>#okAction:`. 

## Usage 
Typically, you do not instantiate directly a dialog, but you open a presenter as one.

```
SomePresenter >> open
	^ self openDialogWithSpec
		okAction: [ self accept ];
		cancelAction: [ self cancel ];
		yourself
```
And to control how the dialog should behave, you define the method `initializeDialogWindow:` in your presenters.

```
SomePresenter >> initializeDialogWindow: aDialogPresenter 
	super initializeDialogWindow: aDialogPresenter.
	aDialogPresenter
		initialExtent: 600@400;
		title: 'A title'	
```
"
Class {
	#name : 'SpDialogWindowPresenter',
	#superclass : 'SpWindowPresenter',
	#instVars : [
		'#buttons',
		'#okAction',
		'#cancelAction',
		'#cancelled',
		'#defaultButton',
		'#buttonDecorations => ObservableSlot'
	],
	#category : 'Spec2-Core-Windows',
	#package : 'Spec2-Core',
	#tag : 'Windows'
}

{ #category : 'specs' }
SpDialogWindowPresenter class >> adapterName [

	^ #DialogWindowAdapter
]

{ #category : 'visiting' }
SpDialogWindowPresenter >> acceptVisitor: aVisitor [

	aVisitor visitDialogWindowPresenter: self
]

{ #category : 'private' }
SpDialogWindowPresenter >> addButton: aButtonPresenter [

	buttons add: aButtonPresenter.
	^ aButtonPresenter
]

{ #category : 'api' }
SpDialogWindowPresenter >> addButton: aString do: aBlock [
	"Adds button logic to dialog.
	 This method will add a standard button to the button bar of the dialog, having `aString` 
	 as label and executing `aBlock` when pressed. 
	 `aBlock` receives this dialog as an optional argument.
	 This methods answers the added button presenter, to allow more specific/non standard  
	 definitions.
	 See `SpAbstractPresenter>>#initializeDialogWindow:` as an example of usage."
	
	^ self addButton: (SpButtonPresenter new 
		owner: self;
		label: aString;
		action: [ aBlock cull: self ];
		yourself)
]

{ #category : 'private' }
SpDialogWindowPresenter >> addDefaultButton: aButtonPresenter [
	"Adds button logic to dialog."
	| actionBlock |
	
	
	actionBlock := aButtonPresenter action.
	defaultButton := self addButton: aButtonPresenter.
	aButtonPresenter action: [ 
		actionBlock value.
		"this is ugly, but this is how we can ensure this is not keeping the status as cancelled."
		self beOk ].
	defaultButton addStyle: 'default'.
	^ defaultButton
]

{ #category : 'api' }
SpDialogWindowPresenter >> addDefaultButton: aString do: aBlock [
	"Adds button logic to dialog."
	
	defaultButton := self addButton: aString do: aBlock.
	defaultButton addStyle: 'default'.
	^ defaultButton
]

{ #category : 'api' }
SpDialogWindowPresenter >> beCancel [
	"Set the status of this dialog as 'cancelled'. 
	 See `SpDialogWindowPresenter>>#isCancelled`"

	cancelled := true
]

{ #category : 'api' }
SpDialogWindowPresenter >> beOk [
	"Set the status of this dialog as 'Ok'. 
	 See `SpDialogWindowPresenter>>#isOk`"

	cancelled := false
]

{ #category : 'api' }
SpDialogWindowPresenter >> buttons [ 
	"Answer an OrderedCollection that contains all defined buttons."
	
	^ buttons 
]

{ #category : 'api' }
SpDialogWindowPresenter >> cancelAction [
	"Answer the defined cancel action (the one that is executed when pressed 'cancel' button 
	 by default). In initialization phase, cancel action is defined as: 
	 ``` 
	self cancelAction: [ 
		cancelled := true.
		self close ]
	```
	(but it can be redefined by the user)"

	^ cancelAction
]

{ #category : 'api' }
SpDialogWindowPresenter >> cancelAction: aBlock [
	"Set the action to execute when 'cancel' button is pressed."

	cancelAction := aBlock
]

{ #category : 'testing' }
SpDialogWindowPresenter >> cancelled [
	"Answer true if dialog has been cancelled. 
	 This is a synonym of `SpDialogWindowPresenter>>#cancelled`"

	^ cancelled
]

{ #category : 'api' }
SpDialogWindowPresenter >> defaultButton [
	"add a previously defined defaultButton.
	 this is also a 'suggested action'."

	^ defaultButton
]

{ #category : 'private' }
SpDialogWindowPresenter >> executeDefaultAction [

	defaultButton ifNil: [ ^ self ].
	defaultButton action cull: self
]

{ #category : 'testing' }
SpDialogWindowPresenter >> hasButtonDecorations [
	
	^ buttonDecorations and: [ self buttons isNotEmpty ]
]

{ #category : 'testing' }
SpDialogWindowPresenter >> hasDefaultButton [

	^ defaultButton isNotNil
]

{ #category : 'initialization' }
SpDialogWindowPresenter >> initialize [

	super initialize.
	buttons := OrderedCollection new.
	cancelled := true.
	self withButtons.
	self initializeDefaultActions
	
]

{ #category : 'initialization' }
SpDialogWindowPresenter >> initializeDefaultActions [
	"default ok/cancel actions. 
	 this is just for backwards compatibility"
	self okAction: [ 
		cancelled := false.
		self close ].
	self cancelAction: [ 
		cancelled := true.
		self close ]
]

{ #category : 'initialization' }
SpDialogWindowPresenter >> initializeWindow [
		
	super initializeWindow.
	self presenter initializeDialogWindow: self
]

{ #category : 'testing' }
SpDialogWindowPresenter >> isButtonEnabled: aButtonName [
	| button |
	button := self buttons detect: [ :aButton | aButton label = aButtonName ].
	^ button isEnabled
		
]

{ #category : 'testing' }
SpDialogWindowPresenter >> isCancelled [
	"Answer true if dialog has been cancelled."

	^ cancelled
]

{ #category : 'testing' }
SpDialogWindowPresenter >> isDialog [

	^ true
]

{ #category : 'testing' }
SpDialogWindowPresenter >> isOk [
	"Answer true if dialog has been accepted."

	^ self isCancelled not
]

{ #category : 'api' }
SpDialogWindowPresenter >> okAction [
	"Answer the defined ok action (the one that is executed when pressed 'ok' button 
	 by default). In initialization phase, ok action is defined as: 
	 ``` 
	self okAction: [ 
		cancelled := false.
		self close ]
	```
	(but it can be redefined by the user)"

	^ okAction
]

{ #category : 'api' }
SpDialogWindowPresenter >> okAction: aBlock [
	"Set the action to execute when 'ok' button is pressed."

	okAction := aBlock
]

{ #category : 'private - traversing' }
SpDialogWindowPresenter >> traverseInFocusOrderDo: aBlock excluding: excludes [

	super traverseInFocusOrderDo: aBlock excluding: excludes.
	self buttons do: [ :each |
		each traverseInFocusOrderDo: aBlock excluding: excludes ]	
]

{ #category : 'api' }
SpDialogWindowPresenter >> triggerCancelAction [
	"Trigger defined cancel action. 
	 See `SpDialogWindowPresenter>>#cancelAction:`"
	
	cancelAction ifNil: [ ^ self ].
	cancelAction cull: self
]

{ #category : 'api' }
SpDialogWindowPresenter >> triggerOkAction [
	"Trigger defined ok action. 
	 See `SpDialogWindowPresenter>>#okAction:`"

	okAction ifNil: [ ^ nil ].
	^ okAction cull: self
]

{ #category : 'api - events' }
SpDialogWindowPresenter >> whenButtonDecorationsChangedDo: aBlock [

	self 
		property: #buttonDecorations 
		whenChangedDo: aBlock 
]

{ #category : 'api' }
SpDialogWindowPresenter >> withButtons [
	"Show buttons"

	buttonDecorations := true
]

{ #category : 'api' }
SpDialogWindowPresenter >> withoutButtons [
	"Remove all previously added buttons"

	buttonDecorations := false
]
