"
A column that displays images.

The user need to set the evaluation block (by sending `SpTableColumn>>#evaluated:`) to answer an image (an instance of `Form`).

## Example
```
SpImageTableColumn 
	title: 'My Image' 
	evaluated: [ :anObject | anObject systemIcon ]
```
"
Class {
	#name : 'SpImageTableColumn',
	#superclass : 'SpTableColumn',
	#category : 'Spec2-Core-Widgets-Table',
	#package : 'Spec2-Core',
	#tag : 'Widgets-Table'
}

{ #category : 'examples' }
SpImageTableColumn class >> example [

	SpEasyColumnViewPresenter new
		addColumn:
			((SpImageTableColumn 
				title: 'Icon' 
				evaluated: [ :aClass | self iconNamed: aClass systemIconName ])
				width: 50;
				yourself);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		items: self class environment allClasses;
		beResizable;
		open
]

{ #category : 'visiting' }
SpImageTableColumn >> acceptColumnVisitor: aBuilder [

	^ aBuilder visitImageColumn: self
]
