# Friends
uTrack Ruby challenge

## The shortest path problem
I think this was the hardest part. I initially tried a recursive function to walk the connections to find the shortest. I tried it a few different ways using code I'd written myself, but I couldn't solve it.

Eventually I abandoned my home grown approach in favour of a Breadth First Search (found by Googling). Maybe I should have done this in the first place, but then I wouldn't have realised how tricky it is!

I was on the right lines by marking paths as visited and recognising the reflexive nature of friendship, but I iterated over the depth of the friendship graph, rather tha the width (breadth).

My test specs helped enormously here.

## More tests + javascript
You can never have enough tests. If this were a production application I'd definitely write some more. I'd also write some javascript to improve the front end.

## Separating concerns a little more
I moved the shortest path calculation (aka breadth first search) to a separate class in the /lib folder, away from the previous FriendshipDecorator, which I have removed. Doing this makes the shortest path calculation easier to test. This functionality may be also useful in other projects, which is why I decoupled it.

I added MemberDecorator. I believe decorators are more appropriate than global view helpers, which always get messy at some point. Decorators can get essy too, but at least you are not polluting the global namespace.

I added a controller spec. Normally I am a bit skeptical about controller tests. I believe they are soft deprecated these days, and request specs are favoured instead. I don't know enough about integration testing -- I would like to improve my knowledge in this area.


