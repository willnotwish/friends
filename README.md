# Friends
uTrack Ruby challenge

## The shortest path problem
I think this was the hardest part. I initially tried a recursive function to walk the connections to find the shortest. I tried it a few different ways using code I'd written myself, but I couldn't solve it.

Eventually I abandoned my home grown approach in favour of a Breadth First Search (found by Googling). Maybe I should have done this in the first place, but then I wouldn't have realised how tricky it is!

I was on the right lines by marking paths as visited and recognising the reflexive nature of friendship, but I iterated over the depth of the friendship graph, rather tha the width (breadth).

My test specs helped enormously here.

## More tests + javascript
You can never have enough tests. If this were a production application I'd definitely write some more. I'd also write some javascript to improve the front end.



