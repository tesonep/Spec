"
A TextFieldExample is a simple example of how to use TextFields.
"
Class {
	#name : #SpTextFieldExample,
	#superclass : #SpPresenter,
	#instVars : [
		'methodBrowser',
		'textField'
	],
	#category : #'Spec2-Examples-Standalone'
}

{ #category : #specs }
SpTextFieldExample class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #textField withConstraints: [ :constraints | constraints height: StandardFonts defaultFont height + 15 ];
		add: #methodBrowser;
		yourself
]

{ #category : #example }
SpTextFieldExample class >> example [
	<sampleInstance>
	^ self new openWithSpec
]

{ #category : #specs }
SpTextFieldExample class >> title [

	^ 'Text Field Example'
]

{ #category : #api }
SpTextFieldExample >> initialExtent [
	^ 900@550
]

{ #category : #initialization }
SpTextFieldExample >> initializePresenter [
	
	textField acceptBlock: [:text | Smalltalk globals at: text asSymbol
								ifPresent: [:class | methodBrowser messages: class methods ]
								ifAbsent: [ methodBrowser messages: #() ]]
]

{ #category : #initialization }
SpTextFieldExample >> initializeWidgets [
	methodBrowser := self instantiate: MessageBrowser.

	textField := self newTextInput.
	textField
		placeholder: 'Enter a class name';
		autoAccept: true;
		removeEntryCompletion.

	methodBrowser sortingBlock: [ :a :b | a selector < b selector ]
]

{ #category : #accessing }
SpTextFieldExample >> methodBrowser [

	^ methodBrowser
]

{ #category : #accessing }
SpTextFieldExample >> textField [

	^ textField
]
