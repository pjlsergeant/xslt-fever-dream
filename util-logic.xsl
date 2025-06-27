<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
    <!-- Evaluate nested and, or, not, and boolean values -->

    <!--
         There are two outputs possible from this - either a boolean value for the whole
         expression, or each connective expressed as a boolean value depending on its children.
         The latter is used to generate the former.
    -->

    <!-- Show the value of the ruleset as the value of its connectives -->
    <xsl:template match="rule">
        <xsl:copy><xsl:apply-templates/></xsl:copy>
    </xsl:template>

    <!-- Show the value of the rulest as a value which can be fed to boolean() -->
    <xsl:template match="rule" mode="boolean" as="xs:boolean">
        <!-- Generate the value of the connectives -->
        <xsl:variable name="result">
            <xsl:apply-templates/>
        </xsl:variable>
        <!-- Absense of a false means it's true -->
        <xsl:choose>
            <xsl:when test="count( $result/false ) &gt; 0">0</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Match primitive true and false - child:: is used so the processor doesn't
         think we're trying to match on literal true() and false() -->
    <xsl:template match="child::true|child::false">
        <xsl:element name="{local-name()}">
            <xsl:attribute name="from" select="if (@from) then @from else 'primitive'"/>
        </xsl:element>
    </xsl:template>

    <!-- Match `or` -->
    <xsl:template match="or">
        <xsl:variable name="children">
            <xsl:apply-templates/>
        </xsl:variable>
        <!-- `or` is true if any children are true -->
        <xsl:variable name="boolean" select="count( $children/true ) &gt; 0"/>
        <!-- Render it -->
        <xsl:call-template name="build-wrapper">
            <xsl:with-param name="children" select="$children"/>
            <xsl:with-param name="boolean" select="$boolean"/>
            <xsl:with-param name="from">or</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Match `and` -->
    <xsl:template match="and">
        <xsl:variable name="children">
            <xsl:apply-templates/>
        </xsl:variable>
        <!-- `and` is true if no children are false -->
        <xsl:variable name="boolean" select="count( $children/false ) &lt; 1"/>
        <!-- Render it -->
        <xsl:call-template name="build-wrapper">
            <xsl:with-param name="children" select="$children"/>
            <xsl:with-param name="boolean" select="$boolean"/>
            <xsl:with-param name="from">and</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Match `not` -->
    <xsl:template match="not">
        <xsl:variable name="children">
            <xsl:apply-templates/>
        </xsl:variable>
        <!-- `not` is the inverse of `and` -->
        <xsl:variable name="boolean" select="not(count( $children/false ) &lt; 1)"/>
        <!-- Render it -->
        <xsl:call-template name="build-wrapper">
            <xsl:with-param name="children" select="$children"/>
            <xsl:with-param name="boolean" select="$boolean"/>
            <xsl:with-param name="from">not</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Print out the long-form of a connective, showing its value, how it got there, and
         children -->
    <xsl:template name="build-wrapper">
        <xsl:param name="children"/>
        <xsl:param name="boolean"/>
        <xsl:param name="from"/>
        <xsl:element name="{$boolean}">
            <xsl:attribute name="from">
                <xsl:value-of select="$from"/>
            </xsl:attribute>
            <xsl:copy-of select="$children"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>