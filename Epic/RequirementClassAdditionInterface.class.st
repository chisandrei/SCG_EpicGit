Class {
	#name : #RequirementClassAdditionInterface,
	#superclass : #BlElement,
	#instVars : [
		'element',
		'coderContent',
		'navigationModel',
		'futureClassName'
	],
	#category : #'Epic-Model'
}

{ #category : #ui }
RequirementClassAdditionInterface >> buildAddButton [
	| look |
	^BrButton new
		label: 'Add class';
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousVectorIcons add;
								yourself ]
						content: [ | element |
							element := BlElement new.
							element
								constraintsDo: [ :c | 
									c horizontal exact: 400.
									c vertical exact: 300 ].
							element addChild: (self buildAddInterface: look).
							element ]);
		icon: BrGlamorousVectorIcons add;
		yourself.
]

{ #category : #ui }
RequirementClassAdditionInterface >> buildAddInterface: look [
	| contentTabs tab |
	contentTabs := BrTabGroup new.
	contentTabs look: BrGlamorousTabGroupLook new.
	contentTabs
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	tab := BrTab new
		look: BrGlamorousTabLook new;
		label: 'Class';
		stencil: [ | el |
			el := GtCreateBehaviorElement new.
			el
				behaviorBlock: [ :cls | 
					look hide.
					navigationModel selectClass: cls ].
			el forClassDefinitionWithName: futureClassName.
			navigationModel
				selectedPackageDo: [ :package | el forPackage: package ].
			navigationModel
				selectedTagDo: [ :tag | el forPackageTag: tag ].
			navigationModel
				selectedClassDo: [ :cls | el forSuperclass: cls ].
			el ].
	contentTabs addTab: tab.
	^ contentTabs
]

{ #category : #accessing }
RequirementClassAdditionInterface >> element: anObject [
	element := anObject.
]

{ #category : #initialization }
RequirementClassAdditionInterface >> initialize [ 
	super initialize.
	self initializeNavigationModel.
	self initializeMainContent.
	self initializeElement.
]

{ #category : #initialization }
RequirementClassAdditionInterface >> initializeElement [
	self addChild: self buildAddButton
]

{ #category : #initialization }
RequirementClassAdditionInterface >> initializeMainContent [
	coderContent := BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
]

{ #category : #initialization }
RequirementClassAdditionInterface >> initializeNavigationModel [
	navigationModel := GtCoderNavigationPackagesTagsClassesModel new.
	element ifNotNil: [ navigationModel when: GtCoderNavigationAnnouncement send: #updateElement to: self ].
	
	
]

{ #category : #initialization }
RequirementClassAdditionInterface >> initializeWithElement: anElement [
	self element: anElement.
	self initialize.
]

{ #category : #initialization }
RequirementClassAdditionInterface >> initializeWithFutureClassName: aString [
	futureClassName := aString.
	self initialize.
]

{ #category : #initialization }
RequirementClassAdditionInterface >> initializeWithFutureClassName: aString andElement: anElement [
	element := anElement.
	futureClassName := aString.
	self initialize.
]

{ #category : #accessing }
RequirementClassAdditionInterface >> navigationModel [
	^navigationModel
]

{ #category : #'api - spawning' }
RequirementClassAdditionInterface >> updateElement [
	element announcer announce: ERequirementStateChangedAnnouncement.
]
