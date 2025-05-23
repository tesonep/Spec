"
I am the component of DynamycSpecExample used for Integer.

self example 
"
Class {
	#name : 'SpOpenOnIntExample',
	#superclass : 'SpPresenter',
	#instVars : [
		'text',
		'plus',
		'minus'
	],
	#category : 'Spec2-Examples-Wrapper',
	#package : 'Spec2-Examples',
	#tag : 'Wrapper'
}

{ #category : 'examples' }
SpOpenOnIntExample class >> example [

	<sampleInstance>
	^ (self new: 42)
		  extent: 100 @ 100;
		  open;
		  yourself
]

{ #category : 'instantiation' }
SpOpenOnIntExample class >> new: anInteger [
	^ self new initialize: anInteger
]

{ #category : 'initialization' }
SpOpenOnIntExample >> connectPresenters [
	minus
		action: [ | currentValue |
			currentValue := text label asInteger.
			text label: (currentValue - 1) asString ].
	plus
		action: [ | currentValue |
			currentValue := text label asInteger.
			text label: (currentValue + 1) asString ]
]

{ #category : 'layout' }
SpOpenOnIntExample >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: text expand: false;
		add: (SpBoxLayout newLeftToRight
			add: minus;
			add: plus;
			yourself)
		expand: false;
		yourself
]

{ #category : 'initialization' }
SpOpenOnIntExample >> initialize: anInteger [
	text label: anInteger asString
]

{ #category : 'initialization' }
SpOpenOnIntExample >> initializePresenters [
	text := self instantiate: SpLabelPresenter.
	plus := self instantiate: SpButtonPresenter.
	minus := self instantiate: SpButtonPresenter.
	plus
		label: '+'.
	minus
		label: '-'
]

{ #category : 'accessing' }
SpOpenOnIntExample >> minus [
	^ minus
]

{ #category : 'accessing' }
SpOpenOnIntExample >> plus [
	^ plus
]

{ #category : 'accessing' }
SpOpenOnIntExample >> text [
	^ text
]

{ #category : 'accessing' }
SpOpenOnIntExample >> windowTitle [
	^ 'OpenOnIntExample'
]
