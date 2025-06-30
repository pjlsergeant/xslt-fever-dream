# XSLT Fever Dream

XSLT is a great general-purpose programming language! Here are some examples I hacked together in 2012 when I was spending a lot of time in hotel rooms with little else to occupy myself.

* [./util-logic.xsl](./util-logic.xsl) evaluating nested boolean assertions
* [./util-graph.xsl](./util-graph.xsl) breadth-first graph search
* [./util-map.xsl](./util-map.xsl) simple map data-structure

The repo of course includes tests, also written in XSLT:

[./test-logic.xsl](./test-logic.xsl), [./test-graph.xsl](./test-graph.xsl), and [./test-map.xsl](./test-map.xsl) can all be run with Saxon, using something like:

`echo "<dummy/>" | saxon -xsl:test-logic.xsl -it:start -s:-`
