<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- Templates which operate on directed graphs -->

    <xsl:import href="util-map.xsl"/>

    <!--
        Simple breadth-first search implementation to return a tree from a starting node
    -->
    <xsl:template name="generate-paths">
        <!-- All known edges - these are <path>s with distance 1 -->
        <xsl:param name="edges"/>
        <!-- Starting-point paths - usually a <path> with distance 0 on first invocation -->
        <xsl:param name="paths"/>
        <!-- Allow duplicate paths to a given node? -->
        <xsl:param name="duplicates" select="false()"/>
        <!-- Nodes that we've already evaluated and don't need to revisit -->
        <xsl:param name="seen" select="$empty-map"/>

        <!-- Only continue processing if we have paths to use as a starting point - this is
             effectively our base case -->
        <xsl:if test="count($paths/node()) &gt; 0">

            <!-- Return each starting-point path -->
            <xsl:copy-of select="$paths"/>

            <!-- Update our list of seen nodes using the starting-point paths -->
            <xsl:variable name="updated-seen">
                <xsl:call-template name="map-insert">
                    <xsl:with-param name="map" select="$seen"/>
                    <xsl:with-param name="pairs">
                        <!-- Generate key/value pairs from each path -->
                        <xsl:apply-templates select="$paths" mode="seen-flag"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>

            <!-- Multiply all of our starting-point paths to include all nodes they can reach -->
            <xsl:variable name="all-paths">
                <xsl:apply-templates select="$paths" mode="extend">
                    <xsl:with-param name="edges" select="$edges"/>
                </xsl:apply-templates>
            </xsl:variable>

            <!-- Filter out paths we've created to nodes we've already seen -->
            <xsl:variable name="filtered">
                <xsl:call-template name="filter-seen">
                    <xsl:with-param name="duplicates" select="$duplicates"/>
                    <xsl:with-param name="paths" select="$all-paths"/>
                    <xsl:with-param name="seen" select="$updated-seen"/>
                </xsl:call-template>
            </xsl:variable>

            <!-- Recurse in to the template with our newly-added paths -->
            <xsl:call-template name="generate-paths">
                <xsl:with-param name="edges" select="$edges"/>
                <xsl:with-param name="paths" select="$filtered"/>
                <xsl:with-param name="seen" select="$updated-seen"/>
                <xsl:with-param name="duplicates" select="$duplicates"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Remove paths to nodes we've already seen, and deduplicate -->
    <xsl:template name="filter-seen">
        <xsl:param name="seen"/>
        <xsl:param name="paths"/>
        <!-- Allow duplicates? -->
        <xsl:param name="duplicates" select="false()"/>

        <!-- Get the head and the tail of our list of paths to filter -->
        <xsl:variable name="head" select="$paths/node()[position()  = 1]"/>
        <xsl:variable name="tail" select="$paths/node()[position() != 1]"/>

        <!-- Assuming we have a head -->
        <xsl:if test="boolean( $head )">

            <!-- Have we already seen the node it goes to? -->
            <xsl:variable name="seen-head-to">
                <xsl:call-template name="map-lookup">
                    <xsl:with-param name="key" select="$head/@to"/>
                    <xsl:with-param name="map" select="$seen"/>
                </xsl:call-template>
            </xsl:variable>

            <!-- If not, output it -->
            <xsl:if test="not(string($seen-head-to))">
                <xsl:copy-of select="$head"/>
            </xsl:if>

            <!-- Add it to the seen list -->
            <xsl:variable name="new-seen">
                <xsl:call-template name="map-insert">
                    <xsl:with-param name="map" select="$seen"/>
                    <xsl:with-param name="pairs">
                        <xsl:apply-templates select="$head" mode="seen-flag"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>

            <!-- Redispatch the tail -->
            <xsl:call-template name="filter-seen">
                <!-- Either use the old seen list, or the one including `head` depending on if
                     duplicates are allowed -->
                <xsl:with-param name="seen" select="if ($duplicates) then $seen else $new-seen"/>
                <xsl:with-param name="paths">
                    <xsl:copy-of select="$tail"/>
                </xsl:with-param>
                <xsl:with-param name="duplicates" select="$duplicates"/>
            </xsl:call-template>

        </xsl:if>
    </xsl:template>

    <!-- Given a path, adds a node to it -->
    <xsl:template match="path" mode="add-node">
        <xsl:param name="node"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="distance" select="if (@from != @to) then (count(./v) + 2) else 1 "/>
            <xsl:attribute name="to">
                <xsl:value-of select="$node"/>
            </xsl:attribute>
            <xsl:copy-of select="v"/>
            <xsl:if test="@from != @to">
                <v name="{@to}"/>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

    <!-- Given a path, returns a list of all derivative paths based on a graph -->
    <xsl:template match="path" mode="extend">
        <xsl:param name="edges"/>
        <xsl:variable name="path" select="."/>
        <xsl:for-each select="$edges/node()[@from=$path/@to]">
            <xsl:apply-templates select="$path" mode="add-node">
                <xsl:with-param name="node" select="@to"/>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>

    <!-- Generate a key-value pair for use in `seen` map from a path -->
    <xsl:template match="path" mode="seen-flag">
        <pair key="{@to}">
            <xsl:value-of select="@from"/>
        </pair>
    </xsl:template>

</xsl:stylesheet>