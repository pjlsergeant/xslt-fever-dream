<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- Simple tests for util-map.xsl -->

    <!-- Library under test -->
    <xsl:include href="util-map.xsl"/>
    <!-- Test framework -->
    <xsl:include href="util-test-framework.xsl"/>

    <xsl:template name="start">
        <xsl:call-template name="run-tests">
            <xsl:with-param name="tests">

                <!-- Define a simple map with two elements -->
                <xsl:variable name="my-map-1">
                    <xsl:call-template name="map-insert">
                        <xsl:with-param name="pairs">
                            <pair key="foo">1</pair>
                            <pair key="bar">2</pair>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>

                <!-- Test: Can we lookup `foo`? -->
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">my-map-1: foo set correctly</xsl:with-param>
                    <xsl:with-param name="expected" select="1"/>
                    <xsl:with-param name="actual">
                        <xsl:call-template name="map-lookup">
                            <xsl:with-param name="map" select="$my-map-1"/>
                            <xsl:with-param name="key">foo</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Test: Can we lookup `bar`? -->
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">my-map-1: bar set correctly</xsl:with-param>
                    <xsl:with-param name="expected" select="2"/>
                    <xsl:with-param name="actual">
                        <xsl:call-template name="map-lookup">
                            <xsl:with-param name="map" select="$my-map-1"/>
                            <xsl:with-param name="key">bar</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Update one of the elements -->
                <xsl:variable name="my-map-2">
                    <xsl:call-template name="map-insert">
                        <xsl:with-param name="map" select="$my-map-1"/>
                        <xsl:with-param name="pairs">
                            <pair key="foo">3</pair>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>

                <!-- Test: Does that element reflect the new value? -->
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">my-map-2: foo has been updated</xsl:with-param>
                    <xsl:with-param name="expected" select="3"/>
                    <xsl:with-param name="actual">
                        <xsl:call-template name="map-lookup">
                            <xsl:with-param name="map" select="$my-map-2"/>
                            <xsl:with-param name="key">foo</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Insert a nodeset rather than a number -->
                <xsl:variable name="my-map-3">
                    <xsl:call-template name="map-insert">
                        <xsl:with-param name="map" select="$my-map-2"/>
                        <xsl:with-param name="pairs">
                            <pair key="foo"><foo><bar/></foo></pair>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>

                <!-- Test: Is a nodeset successfully returned? -->
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">my-map-3: foo has been set to a nodeset</xsl:with-param>
                    <xsl:with-param name="expected"><foo><bar/></foo>
                    </xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:call-template name="map-lookup">
                            <xsl:with-param name="map" select="$my-map-3"/>
                            <xsl:with-param name="key">foo</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>

            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
