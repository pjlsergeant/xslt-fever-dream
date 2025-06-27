<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- Simple TAP test framework -->

    <!-- Output will need to be plaintext -->
    <xsl:output method="text"/>
    
    <xsl:include href="util-serialize.xsl"/>

    <!-- Print the TAP header: 1..(number of tests) -->
    <xsl:template name="run-tests">
        <xsl:param name="tests"/>
        <xsl:text>1..</xsl:text>
        <xsl:value-of select="count($tests/node())"/>
        <xsl:apply-templates select="$tests/node()"/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!-- Creates XML test cases from parameters -->
    <xsl:template name="test-equal">
        <xsl:param name="actual"/>
        <xsl:param name="description"/>
        <xsl:param name="expected"/>

        <test-equal>
            <description>
                <xsl:value-of select="$description"/>
            </description>
            <expected>
                <xsl:copy-of select="$expected"/>
            </expected>
            <actual>
                <xsl:copy-of select="$actual"/>
            </actual>
        </test-equal>
    </xsl:template>

    <!-- Test for string-equality between serialized nodes -->
    <xsl:template match="test-equal">
        <!-- Serialized version of actual value -->
        <xsl:variable name="actual">
            <xsl:apply-templates select="actual/node()" mode="serialize"/>
        </xsl:variable>
        
        <!-- Serialized version of expected value -->
        <xsl:variable name="expected">
            <xsl:apply-templates select="expected/node()" mode="serialize"/>
        </xsl:variable>
        
        <!-- Test name and number -->
        <xsl:variable name="description" select="normalize-space(description)"/>
        <xsl:variable name="number" select="position()"/>
        
        <!-- Does it match? -->
        <xsl:choose>
            <!-- This is here because it's too easy to accidentally make tests pass if you fumble
                 the input -->
            <xsl:when test="$expected = ''">
                not ok - <xsl:value-of select="$number" /> - <xsl:value-of select="$description" />
                # expected: [ERROR: You're comparing against an empty string]
                # actual  : <xsl:value-of select="$actual" />
            </xsl:when>
            <!-- If it matches, print success -->
            <xsl:when test="$actual = $expected">
                ok - <xsl:value-of select="$number" /> - <xsl:value-of select="$description" />
            </xsl:when>
            <!-- If it doesn't match, print a failure and show what we wanted -->
            <xsl:otherwise>
                not ok - <xsl:value-of select="$number" /> - <xsl:value-of select="$description" />
                # expected: <xsl:value-of select="$expected" />
                # actual  : <xsl:value-of select="$actual" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>