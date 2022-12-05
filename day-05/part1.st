"This is a comment"
name := stdin nextLine.
i := name size.
siz := (i + 1) // 4.
x := Array new: siz.
1 to: siz do: [
   :a |
   x at: a put: OrderedCollection new.
].
[siz ~= 0] whileTrue: [
    Transcript show: name; cr; cr.
    1 to: i do:
        [:a | 
            a \\ 4 == 2 ifTrue: [
                char := name at: a.
                st := x at: ((a - 1) // 4 + 1).
                asc := char asciiValue.
                skip := (asc == 32) | ((asc >= 48 ) & (asc <= 57)).
                skip ifFalse: [
                    st add: char
                ].
                Transcript show: st printString; cr.
            ]
        ].
    name := stdin nextLine.
    i := name size.
    siz := (i + 1) // 4.
    Transcript show: name printString; cr; cr.
]
