<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" >
    <!--
         These three templates are *NOT* my own work. Instead, they've been taken from
         http://stackoverflow.com/questions/6696382/xslt-how-to-convert-xml-node-to-string-
         The comments however /have/ been added by me
    -->

    <!-- Match all nodes -->
    <xsl:template match="*" mode="serialize">

        <!-- Print an opening tag -->
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="name()"/>

        <!-- Serialize all attributes -->
        <xsl:apply-templates select="@*" mode="serialize"/>

        <xsl:choose>

            <!-- If there are children -->
            <xsl:when test="node()">
                <xsl:text>&gt;</xsl:text>

                <!-- Yield to apply-templates -->
                <xsl:apply-templates mode="serialize"/>

                <!-- Close the tag -->
                <xsl:text>&lt;/</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>&gt;</xsl:text>
            </xsl:when>

            <xsl:otherwise>
                <xsl:text> /&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- For each attribute -->
    <xsl:template match="@*" mode="serialize">
        <xsl:text> </xsl:text>
        <!-- Copy its name -->
        <xsl:value-of select="name()"/>
        <xsl:text>="</xsl:text>
        <!-- Stringify its value -->
        <xsl:value-of select="."/>
        <xsl:text>"</xsl:text>
    </xsl:template>

    <!-- Simply copy over text nodes -->
    <xsl:template match="text()" mode="serialize">
        <xsl:value-of select="."/>
    </xsl:template>

</xsl:stylesheet>