<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!--
        Naïve functional key/value store - Stores arbitrary values against QName keys

        This has gone through a few iterations. The very first one wouldn't try and remove
        duplicates, and would simply keep adding kv pairs to the front, and then selecting the
        first one. A later iteration tried to store the key/values as attributes against a single
        node (which I reasoned would probably give me access to an internal hash-lookup of
        attributes for performance), but that meant that I couldn't store complex values.

        No effort has been made to evaluate performance, or add safety features, other than some
        minimal tests (src/test-map.xsl).
    -->

    <xsl:variable name="empty-map" select="/.." />

    <xsl:template name="map-insert">
        <!-- Default initial value and insertion values are empty nodes -->
        <xsl:param name="map" select="$empty-map" />
        <xsl:param name="pairs" select="$empty-map" />

        <!-- Inserted values -->
        <xsl:copy-of select="$pairs/pair" />

        <!-- Existing values (assuming we haven't insert one) -->
        <xsl:for-each select="$map/pair">
            <xsl:variable name="key" select="@key" />
            <xsl:if test="not(count($pairs/pair[@key=$key]))">
                <xsl:copy-of select="." />
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="map-lookup">
        <xsl:param name="map" />
        <xsl:param name="key" />
        <xsl:copy-of select="$map/pair[@key=$key]/node()" />
    </xsl:template>

</xsl:stylesheet>