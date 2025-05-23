"
Set of demos that show some of the capabilities of the Spec UI framework.
Execute the following expression: `SpDemo open`
"
Class {
	#name : 'SpDemo',
	#superclass : 'SpPresenter',
	#instVars : [
		'menu',
		'list',
		'page',
		'selectedPage'
	],
	#category : 'Spec2-Examples-Demo',
	#package : 'Spec2-Examples',
	#tag : 'Demo'
}

{ #category : 'user interface' }
SpDemo class >> defaultPreferredExtent [ 
	
	| fontWidth rowHeight |
	fontWidth := (StandardFonts defaultFont widthOfString: 'M').
	rowHeight := self inputTextHeight.

	^ (90@24) * (fontWidth @ rowHeight)
	
]

{ #category : 'user interface' }
SpDemo class >> menuExamplesOn: aBuilder [
	"Add a custom menu item to the world menu"
	<worldMenu>

	(aBuilder item: #'Spec2 demo')
		iconName: #smallHelp;
		parent: #Help;
		order: 3.5;
		help: 'Open Spec2 demo browser.';
		action: [ self open ]
]

{ #category : 'instance creation' }
SpDemo class >> on: aModel [

	^ self basicNew 
		model: aModel;
		initialize;
		yourself.
]

{ #category : 'specs' }
SpDemo class >> open [
	<example>
	
	^ self new open
]

{ #category : 'accessing' }
SpDemo >> addItemTo: aGroup [
	aGroup
		addItem: [ :item | 
			item
				name: 'Dynamic';
				icon: (self iconNamed: #delete);
				action: [ aGroup menuItems remove: item.
					self needRebuild: false.
					self build ] ].
	self needRebuild: false.
	self build
]

{ #category : 'accessing' }
SpDemo >> availablePages [
	^ SpDemoPage availablePages
]

{ #category : 'initialization' }
SpDemo >> connectPresenters [

	list selectItem: self selectedPage.
	list whenSelectionChangedDo: [ :selection | 
		selection selectedItem
			ifNotNil: [ :newPageClass | 
				newPageClass = self selectedPage
					ifFalse: [ 
						self selectedPage: newPageClass.
						page
							removeAll; 
							add: (self instantiate: newPageClass);
							yourself ] ]
			ifNil: [ 
				"Avoid the user to have no page selected at all." 
				list selectItem: self selectedPage ] ]
]

{ #category : 'layout' }
SpDemo >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: menu expand: false;
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: 200;
				   add: list;
				   add: page;
				   yourself);
		  yourself
]

{ #category : 'accessing' }
SpDemo >> defaultPage [

	^ self availablePages first.
]

{ #category : 'initialization' }
SpDemo >> initializePresenters [

	page := SpBoxLayout newTopToBottom 
		add: (self instantiate: (selectedPage := self availablePages first));
		yourself.
	
	menu := self mainMenu.
	menu addKeyBindingsTo: self.
	
	list := self newList.
	list
		items: self availablePages;
		display: [ :item | item pageName ];
		addActionWith: [ :item | item
			name: 'Browse';
			iconName: #smallHelp;
			action: [ list selectedItem browse ] ];
		addActionWith: [ :item | item
			name: 'Browse presenter';
			iconName: #smallHelp;
			action: [ list selectedItem new pageClass browse ] ].

	self focusOrder
		add: list;
		addAll: page presenters
]

{ #category : 'accessing' }
SpDemo >> list [
	^ list
]

{ #category : 'accessing' }
SpDemo >> list: anObject [
	list := anObject
]

{ #category : 'initialization' }
SpDemo >> mainMenu [
	| aMenu |
	aMenu := self newMenuBar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'File';
						icon: (self iconNamed: #open);
						subMenu: self subMenu ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Open file';
						icon: (self iconNamed: #open);
						action: [ self inform: 'Open File' ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Save File';
						icon: (self iconNamed: #smallSave);
						action: [ self inform: 'Save File' ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Print file';
						icon: (self iconNamed: #smallPrint);
						action: [ self inform: 'Print file' ] ] ];
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Undo';
						icon: (self iconNamed: #smallUndo);
						action: [ self inform: 'Undo' ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Redo';
						icon: (self iconNamed: #smallRedo);
						action: [ self inform: 'Redo' ] ] ];
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Add menu item';
						icon: (self iconNamed: #add);
						action: [ self addItemTo: group ] ] ].
	^ aMenu
]

{ #category : 'accessing' }
SpDemo >> menu [
	^ menu
]

{ #category : 'accessing' }
SpDemo >> menu: anObject [
	menu := anObject
]

{ #category : 'accessing' }
SpDemo >> page [
	^ page
]

{ #category : 'accessing' }
SpDemo >> page: anObject [
	page := anObject
]

{ #category : 'accessing' }
SpDemo >> selectedPage [
	^ selectedPage
]

{ #category : 'accessing' }
SpDemo >> selectedPage: anObject [
	selectedPage := anObject
]

{ #category : 'initialization' }
SpDemo >> subMenu [
	^ self newMenu
		addItem: [ :item | 
			item
				name: 'Open';
				icon: (self iconNamed: #open);
				shortcut: $o meta;
				action: [ self inform: 'Open' ] ];
		addItem: [ :item | 
			item
				name: 'Save';
				icon: (self iconNamed: #smallSave);
				shortcut: $s meta;
				action: [ self inform: 'Save' ] ];
		addItem: [ :item | 
			item
				name: 'Print';
				shortcut: $p meta;
				icon: (self iconNamed: #smallPrint);
				action: [ self inform: 'Print' ] ];
		addItem: [ :item | 
			item
				name: 'Close';
				shortcut: $c meta;
				icon: (self iconNamed: #smallCancel);
				action: [ self inform: 'Kill' ] ];
		yourself
]

{ #category : 'api' }
SpDemo >> windowTitle [
	
	^ 'Spec UI Framework Demo'.
]
