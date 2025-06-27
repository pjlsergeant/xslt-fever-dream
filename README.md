# XSLT Fever Dream

* [./util-logic.xsl](./util-logic.xsl) evaluating nested boolean assertions
* [./util-graph.xsl](./util-graph.xsl) breadth-first graph search
* [./util-map.xsl](./util-map.xsl) simple map data-structure

The repo of course includes tests, also written in XSLT:

[./test-logic.xsl](./test-logic.xsl), [./test-graph.xsl](./test-graph.xsl), and [./text-map.xsl](./text-map.xsl) can all be run with Saxon, using something like:

`echo "<dummy/>" | saxon -xsl:test-logic.xsl -it:start -s:-`
