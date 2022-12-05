"This is a comment"
name := stdin nextLine.
i := name size.
siz := (i + 1) // 4.
x := Array new: siz.
1 to: siz do: [
   :a |
   x at: a put: OrderedCollection new.
].
1 to: 8 do: [:b |
    Transcript show: name; cr; cr.
    name := stdin nextLine.
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
    i := name size.
    siz := (i + 1) // 4.
    Transcript show: name printString; cr; cr.
].

Transcript show: 'Parsed'; cr.

1 to: 10000 do: [:a |
    a < 2 ifTrue: [
        name := stdin nextLine.
        name := stdin nextLine.
        name := stdin nextLine.
        name := stdin nextLine.
        name := stdin nextLine.
        name := stdin nextLine.
        name := stdin nextLine.
        name := stdin nextLine.
        name := stdin nextLine.
        name := stdin nextLine.
    ].
    name := stdin nextLine.
    quant := 0.
    i := 6.
    char := name at: i.
    asc := char asciiValue.
    isDigit := (asc >= 48 ) & (asc <= 57).
    [isDigit] whileTrue: [
        quant := quant * 10 + asc - 48.
        i := i + 1.
        char := name at: i.
        asc := char asciiValue.
        isDigit := (asc >= 48 ) & (asc <= 57).
    ].

    Transcript show: quant printString.
    i := i + 6.
    char := name at: i.
    asc := char asciiValue.
    from := asc - 48.

    i := i + 5.
    char := name at: i.
    asc := char asciiValue.
    to := asc - 48.

    Transcript show: from printString.
    Transcript show: to printString.
    1 to: quant do: [:a |
        source := x at: from.
        target := x at: to.
        y := source removeFirst.
        target addFirst: y.
        Transcript show: y printString; cr.
        Transcript show: source printString; cr.
        Transcript show: target printString; cr.
    ].
    1 to: 9 do: [:a |
        st := x at: a.
        y := st first.
        Transcript show: y printString.
    ].
    Transcript show: ''; cr.
].
