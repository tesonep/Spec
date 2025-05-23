"
Create and schedule a message set browser on all versions of the method returned by the evaluation of the context.
"
Class {
	#name : 'SpBrowseMethodVersionsCommand',
	#superclass : 'SpSystemNavigationCommand',
	#category : 'Spec2-Commands-Navigation',
	#package : 'Spec2-Commands',
	#tag : 'Navigation'
}

{ #category : 'default' }
SpBrowseMethodVersionsCommand class >> defaultDescription [ 
	^'Browse history of the method' 
]

{ #category : 'default' }
SpBrowseMethodVersionsCommand class >> shortName [

	^ 'method versions'
]

{ #category : 'executing' }
SpBrowseMethodVersionsCommand >> execute [

	| target |
	target := self target.
	(self context application toolNamed: #versionBrowser)
		browseVersionsForClass: target methodClass
		selector: target selector
]
