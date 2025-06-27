<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- Simple tests for util-graph.xsl -->

    <xsl:import href="util-graph.xsl"/>
    <xsl:import href="util-test-framework.xsl"/>

    <xsl:template name="start">
        <xsl:call-template name="run-tests">
            <xsl:with-param name="tests">

                <!-- Define a simple graph -->
                <xsl:variable name="simple-graph">
                    <path from="A" to="B" distance="1"/>
                    <path from="A" to="C" distance="1"/>
                    <path from="B" to="C" distance="1"/>
                    <path from="B" to="D" distance="1"/>
                    <path from="B" to="E" distance="1"/>
                    <path from="D" to="A" distance="1"/>
                    <path from="C" to="E" distance="1"/>
                    <path from="D" to="F" distance="1"/>
                    <path from="E" to="D" distance="1"/>
                    <path from="A" to="D" distance="1"/>
                </xsl:variable>

                <!-- Define a simple path -->
                <xsl:variable name="simple-path">
                    <path from="A" to="A" distance="0"/>
                </xsl:variable>

                <!-- Explicitly add nodes to the path -->
                <xsl:variable name="simple-path-b">
                    <xsl:apply-templates select="$simple-path" mode="add-node">
                        <xsl:with-param name="node">B</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:variable name="simple-path-b-c">
                    <xsl:apply-templates select="$simple-path-b" mode="add-node">
                        <xsl:with-param name="node">C</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:variable>

                <!-- Test that -->
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">Adding a node works</xsl:with-param>
                    <xsl:with-param name="expected">
                        <path from="A" to="C" distance="2">
                            <v name="B"/>
                        </path>
                    </xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:copy-of select="$simple-path-b-c"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Try adding all the nodes in the graph -->
                <xsl:variable name="simple-path-extended">
                    <xsl:apply-templates select="$simple-path" mode="extend">
                        <xsl:with-param name="edges" select="$simple-graph"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">Extending a path with a graph
                        </xsl:with-param>
                    <xsl:with-param name="expected">
                        <path from="A" to="B" distance="1"/>
                        <path from="A" to="C" distance="1"/>
                        <path from="A" to="D" distance="1"/>
                    </xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:copy-of select="$simple-path-extended"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Filter a set of paths. We prime `seen` with A and B, which means we should get
                     the first path only back for each of C, D, E, F -->
                <xsl:variable name="filtered-paths">
                    <xsl:variable name="seen">
                        <xsl:call-template name="map-insert">
                            <xsl:with-param name="pairs">
                                <pair key="A">1</pair>
                                <pair key="B">1</pair>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:call-template name="filter-seen">
                        <xsl:with-param name="seen" select="$seen"/>
                        <xsl:with-param name="paths" select="$simple-graph"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">Filtering seen nodes</xsl:with-param>
                    <xsl:with-param name="expected">
                        <path from="A" to="C" distance="1"/>
                        <path from="B" to="D" distance="1"/>
                        <path from="B" to="E" distance="1"/>
                        <path from="D" to="F" distance="1"/>
                    </xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:copy-of select="$filtered-paths"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- All-together now! Find the shortest-paths from `A` -->
                <xsl:variable name="shortest-paths">
                    <xsl:call-template name="generate-paths">
                        <xsl:with-param name="edges" select="$simple-graph"/>
                        <xsl:with-param name="paths">
                            <path from="A" to="A" distance="0"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">Shortest paths</xsl:with-param>
                    <xsl:with-param name="expected">
                        <path from="A" to="A" distance="0"/>
                        <path from="A" to="B" distance="1"/>
                        <path from="A" to="C" distance="1"/>
                        <path from="A" to="D" distance="1"/>
                        <path from="A" to="E" distance="2">
                            <v name="B"/>
                        </path>
                        <path from="A" to="F" distance="2">
                            <v name="D"/>
                        </path>
                    </xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:copy-of select="$shortest-paths"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Same again but allow duplicates -->
                <xsl:variable name="shortest-paths-dupes">
                    <xsl:call-template name="generate-paths">
                        <xsl:with-param name="edges" select="$simple-graph"/>
                        <xsl:with-param name="duplicates" select="true()"/>
                        <xsl:with-param name="paths">
                            <path from="A" to="A" distance="0"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">Shortest paths with duplicates
                        </xsl:with-param>
                    <xsl:with-param name="expected">
                        <path from="A" to="A" distance="0"/>
                        <path from="A" to="B" distance="1"/>
                        <path from="A" to="C" distance="1"/>
                        <path from="A" to="D" distance="1"/>
                        <path from="A" to="E" distance="2">
                            <v name="B"/>
                        </path>
                        <path from="A" to="E" distance="2">
                            <v name="C"/>
                        </path>
                        <path from="A" to="F" distance="2">
                            <v name="D"/>
                        </path>
                    </xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:copy-of select="$shortest-paths-dupes"/>
                    </xsl:with-param>
                </xsl:call-template>

            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>