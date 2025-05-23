"
I am a demo to show how to use radio buttons with Spec.

self example
"
Class {
	#name : 'SpRadioButtonExample',
	#superclass : 'SpPresenter',
	#instVars : [
		'button1',
		'button2',
		'button3',
		'label'
	],
	#category : 'Spec2-Examples-Demo-Buttons',
	#package : 'Spec2-Examples',
	#tag : 'Demo-Buttons'
}

{ #category : 'examples' }
SpRadioButtonExample class >> example [

	^ self new open
]

{ #category : 'initialization' }
SpRadioButtonExample >> connectPresenters [

	button1 whenActivatedDo: [ self updateLabel ].
	button1 whenDeactivatedDo: [ self updateLabel ].
	button2 whenChangedDo: [ self updateLabel ].
	button3 whenChangedDo: [ self updateLabel ]
]

{ #category : 'layout' }
SpRadioButtonExample >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newTopToBottom
				add: button1 expand: false;
				add: button2 expand: false;
				add: button3 expand: false;
				yourself);
		add: label expand: false;
		yourself
]

{ #category : 'initialization' }
SpRadioButtonExample >> initializePresenters [

	button1 := self newRadioButton.
	button2 := self newRadioButton.
	button3 := self newRadioButton.
	label := self newLabel.
	button1 associatedRadioButtons: { button2. button3 }.

	button1 label: 'Button 1'.
	button2 label: 'Button 2'.
	button3 label: 'Button 3'.

	self updateLabel.
]

{ #category : 'updating' }
SpRadioButtonExample >> updateLabel [
	label
		label:
			(String
				streamContents: [ :s | 
					{button1 . button2 . button3}
						do: [ :button | 
							s
								<< button label;
								<< ' : ';
								<< (button state ifTrue: [ 'V' ] ifFalse: [ 'X' ]) ]
						separatedBy: [ s << ' - ' ] ])
]

{ #category : 'updating' }
SpRadioButtonExample >> windowTitle [

	^ 'Radio Button Example'
]
