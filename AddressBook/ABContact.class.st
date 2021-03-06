"
I represent a contact in an address book with a name, phone numbers, addresses, and emails.
"
Class {
	#name : #ABContact,
	#superclass : #Object,
	#instVars : [
		'firstName',
		'lastName',
		'phoneNumber',
		'address',
		'email',
		'description',
		'notes',
		'company',
		'lastUpdated',
		'avatar'
	],
	#category : #'AddressBook-Model'
}

{ #category : #adding }
ABContact >> addAddress: anAddress [
	self address do: [ :e | (e type = anAddress type) ifTrue: [ 
		^ Error signal: 'Can not add repetitive address type' ] ].
	address add: anAddress.
]

{ #category : #adding }
ABContact >> addAddresses: aCollectionOfAddress [
	aCollectionOfAddress do: [ :anAddress |
		self addAddress: anAddress ]
]

{ #category : #adding }
ABContact >> addEmail: anEmail [
	self email do: [ :e | e type = anEmail type ifTrue: [ 
			^ Error signal: 'Can not add repetitive email type' ] ].
	email add: anEmail.
]

{ #category : #adding }
ABContact >> addEmails: aCollectionOfEmails [
	aCollectionOfEmails do: [ :anEmail |
		self addEmail: anEmail ]
]

{ #category : #adding }
ABContact >> addPhoneNumber: aPhoneNumber [
		self phoneNumber do: [ :num | num type = aPhoneNumber type ifTrue: [ 
			^ Error signal: 'Can not add repetitive phone phone Number type' ] ].
	phoneNumber add: aPhoneNumber.
]

{ #category : #adding }
ABContact >> addPhoneNumbers: aCollectionOfPhoneNumbers [
	aCollectionOfPhoneNumbers do: [ :aPhoneNumber |
		self addPhoneNumber: aPhoneNumber ]
]

{ #category : #accessing }
ABContact >> address [
	^ address
]

{ #category : #accessing }
ABContact >> address: anObject [
	address := anObject
]

{ #category : #accessing }
ABContact >> avatar [
	^ avatar ifNil: 
		[ avatar := GtABContact unknowsJoeAvatar ]
]

{ #category : #accessing }
ABContact >> company [
	^ company
]

{ #category : #accessing }
ABContact >> company: aString [
	company := aString
]

{ #category : #accessing }
ABContact >> description [
	^ description
]

{ #category : #accessing }
ABContact >> description: anObject [
	description := anObject
]

{ #category : #accessing }
ABContact >> email [
	^ email
]

{ #category : #accessing }
ABContact >> email: emailList [
	email := emailList
]

{ #category : #accessing }
ABContact >> firstName [
	^ firstName
]

{ #category : #accessing }
ABContact >> firstName: aString [
	firstName := aString
]

{ #category : #accessing }
ABContact >> fullName [
	^ firstName, ' ', lastName.
]

{ #category : #'gt-extension' }
ABContact >> gtViewAddresses: aView [
	<gtView>
	^ aView columnedList
		title: 'Addresses';
		priority: 5;
		items: [ address ];
		column: 'Type' item: #typeName width: 200;
		column: 'Address' item: #fullAddress
]

{ #category : #accessing }
ABContact >> gtViewContactDetailsOn: aView [
	<gtView>
	^ aView explicit 
		title: 'Card' translated;
		priority: 5;
		stencil: [
			|container verticalContainer detailsTextContainer avatarContainer nameTextContainer details|
			details := ''.
			self phoneNumber ifNotEmpty: [
				details := details, self phoneNumber first toString  ].
			self address ifNotEmpty: [
				details := details,  String cr, self address first toString  ].
			
			container := BlElement new
				layout: BlLinearLayout horizontal;
				background: Color white;
				look: BrShadowLook;
				margin: (BlInsets all: 20);
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent].
			avatarContainer := BlElement new
				size: 124@124;
				background: (self avatar scaledToSize: 124@124);
				margin: (BlInsets all: 10).
			nameTextContainer := BlTextElement new
				constraintsDo: [ :c | 
					c horizontal matchParent ];
				margin: (BlInsets top: 5 right: 0 bottom: 20 left: 5);
				text: (self fullName asRopedText glamorousRegularFont
					fontSize: 30;
					foreground: Color black).
			detailsTextContainer := BrEditor new
				look: (BrGlamorousRegularEditorLook new fontSize: 16);
				text: details;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			verticalContainer := BlElement new
				layout: BlLinearLayout vertical;
				margin: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent].
			verticalContainer addChild: nameTextContainer.
			verticalContainer addChild: detailsTextContainer.
			container addChild: avatarContainer.
			container addChild: verticalContainer.
			container ].
]

{ #category : #'gt-extension' }
ABContact >> gtViewDetailsCardFor: aView [
	<gtView>
	^ aView explicit
		title: 'Details';
		priority: 1;
		stencil: [ ABContactElement new
			contact: self ]
]

{ #category : #'gt-extension' }
ABContact >> gtViewEmails: aView [
	<gtView>
	^ aView columnedList
		title: 'Email Addresses';
		priority: 2;
		items: [ email ];
		column: 'Type' item: [ :anEmail | anEmail type ];
		column: 'Email' item: [ :anEmail | anEmail toString ]
]

{ #category : #'gt-extension' }
ABContact >> gtViewPhones: aView [
	<gtView>
	^ aView columnedList
		title: 'Phone Numbers';
		priority: 3;
		items: [ phoneNumber ];
		column: 'Type' item: [ :aPhoneNumber | aPhoneNumber type ];
		column: 'Number' item: [ :aPhoneNumber | aPhoneNumber toString ]
]

{ #category : #'gt-extension' }
ABContact >> gtViewSpotterPreview: aView [
	^ self gtViewDetailsCardFor: aView
]

{ #category : #initialization }
ABContact >> initialize [
	super initialize.
	phoneNumber := OrderedCollection new.
	address := OrderedCollection new.
	email := OrderedCollection new.
	lastUpdated := DateAndTime now.
]

{ #category : #accessing }
ABContact >> lastName [
	^ lastName
]

{ #category : #accessing }
ABContact >> lastName: aString [
	lastName := aString
]

{ #category : #accessing }
ABContact >> lastUpdated [
	^ lastUpdated
]

{ #category : #accessing }
ABContact >> lastUpdated: anObject [
	lastUpdated := anObject
]

{ #category : #private }
ABContact >> mergeWith: anotherContact [
	| answer main str returnValue|
	self
		assert: [ self lastUpdated > anotherContact lastUpdated ]
		description: 'We only merge older contacts into newer ones'.

	str:= 'Contact {1} is more recent: {2} compared to {3}, overwrite and merge it''s details to contact {4}? y/n'.
	
	(self lastUpdated) > (anotherContact lastUpdated)
		ifTrue: [answer:= UIManager default request: (str format: {self fullName . self lastUpdated . anotherContact lastUpdated  . anotherContact fullName}). main:= self. Transcript show: 'ifTrueWorked'; cr.]
		ifFalse: [answer:= UIManager default request: (str format: {anotherContact fullName . anotherContact lastUpdated . self lastUpdated  . self fullName}). main:= anotherContact. Transcript show: 'ifFalseWorked'; cr.]
		.
		
	Transcript show: (('Main is {1} ' format: {main fullName}) , String cr).
			
	 ((answer = 'y') & (main = self))
		ifTrue: [
				Transcript show: 'Merging self into another contact'.
				anotherContact firstName: self firstName.
				anotherContact lastName: self lastName.
				Transcript show: 'Merging phone number'.
				anotherContact phoneNumber: (self phoneNumber isEmpty ifFalse: self phoneNumber). 
				anotherContact address: [
					self address isEmpty
					ifTrue: self address.					 							
					] value.
				anotherContact email: [
					self email isEmpty
					ifTrue: self email
					] value.
				anotherContact notes: [ 
					self notes 
					ifFalse: self notes ] value.
				anotherContact company: 	(self company isEmpty ifFalse: self company).
				
				Transcript show: 'Finished merging' , anotherContact fullName.
				returnValue := anotherContact	
			].
		
	((answer = 'y') & (main = anotherContact))
		ifTrue: [Transcript show: 'Merging another contacnt into self'.
				self firstName: anotherContact firstName.
				self lastName: anotherContact lastName.
				self phoneNumber: (anotherContact phoneNumber isEmpty ifFalse: anotherContact phoneNumber).
				self address: [
					anotherContact address isEmpty
					ifFalse: anotherContact address.					 							
					] value.
				self email: [
					anotherContact email isEmpty
					ifFalse: anotherContact email
					] value .
				self notes: [ 
					anotherContact notes = nil
					ifFalse: anotherContact notes ] value.
				self company: [
					anotherContact company = nil
					ifFalse: anotherContact company] value.
				
				Transcript show: 'Finished merging' , self fullName.
				returnValue := self	
			].		
	^ returnValue			
		
]

{ #category : #accessing }
ABContact >> notes [
	^ notes
]

{ #category : #accessing }
ABContact >> notes: aString [
	notes := aString
]

{ #category : #accessing }
ABContact >> phoneNumber [
	^ phoneNumber
]

{ #category : #accessing }
ABContact >> phoneNumber: phone [
	phoneNumber:= phone
]

{ #category : #accessing }
ABContact >> toString [
	^ 'FirstName: ' , firstName , String cr , 
	'LastName: ' , lastName	, String cr,
	'PhoneNumber: ' , phoneNumber, String cr,
	'Address: ', address, String cr,
	'Email: ' , email, String cr, 
	'Notes: ' , (notes ifNil: ['']), String cr,
	'Company: ' , (company ifNil: ['']), String cr,
	'CreatedAt ', lastUpdated asStringOrText 
]
