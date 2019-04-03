# Friends
uTrack Ruby challenge

## Issues

I think the most difficult bit is deducing the relationship between friends. I think I'll need a recursive function to walk the connections and find the shortest.

*Update* Turns out I was wrong about recursion. I tried it a few different ways using code I'd written myself, but I couldn't solve it. My test specs helped enormously here.

Eventually I abandoned my home grown approach in favour of a Breadth First Search (found by Googling). My tests all pass now. Maybe I should have done this in the first place, but then I wouldn't have realised how tricky it is!

I was on the right lines by marking paths as visited and recognising the reflexive nature of friendship, but I iterated over the depth of the friendship graph, rather tha the width (breadth).

In the first instance I included the BFS in the model. However I think it's a view concern, so maybe I'm going to refactor it as a view decorator.



