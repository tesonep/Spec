Class {
	#name : 'SpHorizontalBoxLayoutTest',
	#superclass : 'SpBoxLayoutTest',
	#category : 'Spec2-Tests-Layout',
	#package : 'Spec2-Tests',
	#tag : 'Layout'
}

{ #category : 'initialization' }
SpHorizontalBoxLayoutTest >> initializeTestedInstance [

	layout := SpBoxLayout newLeftToRight.
	presenter layout: layout
]

{ #category : 'tests' }
SpHorizontalBoxLayoutTest >> testPresenterExtentFollowsChildrenExtent [
	| label button |

	layout 
		add: ((label := presenter newLabel) label: 'Label1');
		add: ((button := presenter newButton) label: 'Button1').
		
	self openInstance.
	
	self assert: (self widthOf: presenter) >= ((self widthOf: label) + (self widthOf: button)).
	self assert: (self heightOf: presenter) >= ((self heightOf: label) max: (self heightOf: button))
]

{ #category : 'tests' }
SpHorizontalBoxLayoutTest >> testReplaceWithFixedWidth [
	| p1 toReplace p3 replacement |

	layout add: (p1 := SpLabelPresenter new).
	layout add: (toReplace := SpLabelPresenter new) width: 100.
	layout add: (p3 := SpLabelPresenter new).
	
	self assert: layout children second equals: toReplace.
	
	replacement := SpButtonPresenter new.
	layout replace: toReplace with: replacement.
	
	self assert: layout children second equals: replacement.
	self assert: layout children size equals: 3.
	self assert: layout children equals: { p1. replacement. p3 }
]

{ #category : 'tests' }
SpHorizontalBoxLayoutTest >> testReplaceWithFixedWidthAllFixed [
	| p1 toReplace p3 replacement |

	layout add: (p1 := SpLabelPresenter new) width: 100.
	layout add: (toReplace := SpLabelPresenter new) width: 100.
	layout add: (p3 := SpLabelPresenter new) width: 100.
	
	self assert: layout children second equals: toReplace.
	
	replacement := SpButtonPresenter new.
	layout replace: toReplace with: replacement.
	
	self assert: layout children second equals: replacement.
	self assert: layout children size equals: 3.
	self assert: layout children equals: { p1. replacement. p3 }
]

{ #category : 'tests' }
SpHorizontalBoxLayoutTest >> testReplaceWithFixedWidthComposed [
	| p1 layoutToReplace toReplace p3 replacement |

	layout add: (p1 := SpLabelPresenter new) width: 100.
	layout add: ((layoutToReplace := SpBoxLayout newLeftToRight)  
		add: (toReplace := SpLabelPresenter new) width: 100;
		add: (SpLabelPresenter new) width: 100;
		yourself).
	layout add: (p3 := SpLabelPresenter new) width: 100.
	
	replacement := SpButtonPresenter new.
	layoutToReplace 
		replace: toReplace 
		with: replacement.
	
	self assert: layout children second children first equals: replacement
]

{ #category : 'tests' }
SpHorizontalBoxLayoutTest >> testSpSearchInputFieldPresenterResizeCorrectlyWhenWindowHeightDecrease [

    | searchPresenter buttonPresenter windowWidget buttonWidget searchWidget |
    searchPresenter :=  SpSearchInputFieldPresenter new.
    buttonPresenter := SpButtonPresenter new label: 'click me'.
    presenter := SpPresenter new
                     layout: (SpBoxLayout newLeftToRight
                              add: searchPresenter;
                              add: buttonPresenter;
                              yourself);
                     yourself.
    window := presenter open.

    windowWidget := window adapter widget.
    buttonWidget := buttonPresenter adapter widget.
    searchWidget := searchPresenter adapter widget.

    self assert: (windowWidget bounds containsRect: buttonWidget bounds).
    self assert: (windowWidget bounds containsRect: searchWidget bounds).

    windowWidget extent: windowWidget extent - (0 @ 100).
    self currentWorld doOneCycle.

    self assert: (windowWidget bounds containsRect: buttonWidget bounds).
    self assert: (windowWidget bounds containsRect: searchWidget bounds)
]

{ #category : 'tests' }
SpHorizontalBoxLayoutTest >> testSpSearchInputFieldPresenterResizeCorrectlyWhenWindowWidthDecrease [

    | searchPresenter buttonPresenter windowWidget buttonWidget searchWidget |
    searchPresenter := SpSearchInputFieldPresenter new.
    buttonPresenter := SpButtonPresenter new label: 'click me'.
    presenter := SpPresenter new
                     layout: (SpBoxLayout newLeftToRight
                              add: searchPresenter;
                              add: buttonPresenter;
                              yourself);
                     yourself.
    window := presenter open.

    windowWidget := window adapter widget.
    buttonWidget := buttonPresenter adapter widget.
    searchWidget := searchPresenter adapter widget.

    self assert: (windowWidget bounds containsRect: buttonWidget bounds).
    self assert: (windowWidget bounds containsRect: searchWidget bounds).

    windowWidget extent: windowWidget extent - (100 @ 0).
    self currentWorld doOneCycle.

    self assert: (windowWidget bounds containsRect: buttonWidget bounds).
    self assert: (windowWidget bounds containsRect: searchWidget bounds)
]
