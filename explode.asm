#Lets do some label testing
        add $1, $3
        cmp $2, %4
next:   sub $2, $4 #comment
        andi 3, $2
        movi 10, $5
        jeq next
        movi 13, $6
        lshi 8, $13
	