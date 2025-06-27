<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
    <!-- Simple tests for util-logic.xsl -->
    
    <xsl:import href="util-logic.xsl"/>
    <xsl:import href="util-test-framework.xsl"/>

    <xsl:template name="start">
        <xsl:call-template name="run-tests">
            <xsl:with-param name="tests">

                <!-- Test: true is true -->
                <xsl:variable name="just-true">
                    <rule>
                        <true/>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">just-true</xsl:with-param>
                    <xsl:with-param name="expected">true</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$just-true" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Test: false is true -->
                <xsl:variable name="just-false">
                    <rule>
                        <false/>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">just-false</xsl:with-param>
                    <xsl:with-param name="expected">false</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$just-false" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Test: Unit of `and` is true -->
                <xsl:variable name="unit-of-and-is-true">
                    <rule>
                        <and/>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">unit-of-and-is-true</xsl:with-param>
                    <xsl:with-param name="expected">true</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$unit-of-and-is-true" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Test: Unit of `or` is false -->
                <xsl:variable name="unit-of-or-is-false">
                    <rule>
                        <or/>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">unit-of-or-is-false</xsl:with-param>
                    <xsl:with-param name="expected">false</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$unit-of-or-is-false" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Truth table for `or` -->
                <xsl:variable name="or-true-true-is-true">
                    <rule>
                        <or>
                            <true/>
                            <true/>
                        </or>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">or-true-true-is-true</xsl:with-param>
                    <xsl:with-param name="expected">true</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$or-true-true-is-true" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:variable name="or-true-false-is-true">
                    <rule>
                        <or>
                            <true/>
                            <false/>
                        </or>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">or-true-false-is-true</xsl:with-param>
                    <xsl:with-param name="expected">true</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$or-true-false-is-true" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:variable name="or-false-true-is-true">
                    <rule>
                        <or>
                            <false/>
                            <true/>
                        </or>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">or-false-true-is-true</xsl:with-param>
                    <xsl:with-param name="expected">true</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$or-false-true-is-true" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:variable name="or-false-false-is-false">
                    <rule>
                        <or>
                            <false/>
                            <false/>
                        </or>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">or-false-false-is-false</xsl:with-param>
                    <xsl:with-param name="expected">false</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$or-false-false-is-false" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Truth table for `and` -->
                <xsl:variable name="and-true-true-is-true">
                    <rule>
                        <and>
                            <true/>
                            <true/>
                        </and>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">and-true-true-is-true</xsl:with-param>
                    <xsl:with-param name="expected">true</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$and-true-true-is-true" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:variable name="and-true-false-is-false">
                    <rule>
                        <and>
                            <true/>
                            <false/>
                        </and>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">and-true-false-is-false</xsl:with-param>
                    <xsl:with-param name="expected">false</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$and-true-false-is-false" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:variable name="and-false-true-is-false">
                    <rule>
                        <and>
                            <false/>
                            <true/>
                        </and>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">and-false-true-is-false</xsl:with-param>
                    <xsl:with-param name="expected">false</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$and-false-true-is-false" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:variable name="and-false-false-is-false">
                    <rule>
                        <and>
                            <false/>
                            <false/>
                        </and>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">and-false-false-is-false</xsl:with-param>
                    <xsl:with-param name="expected">false</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$and-false-false-is-false" mode="boolean-text"
                        />
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Truth table for `not` -->
                <xsl:variable name="not-true-is-false">
                    <rule>
                        <not>
                            <true/>
                        </not>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">not-true-is-false</xsl:with-param>
                    <xsl:with-param name="expected">false</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$not-true-is-false" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:variable name="not-false-is-true">
                    <rule>
                        <not>
                            <false/>
                        </not>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">not-false-is-true</xsl:with-param>
                    <xsl:with-param name="expected">true</xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$not-false-is-true" mode="boolean-text"/>
                    </xsl:with-param>
                </xsl:call-template>

                <!-- Test: An example nested expression, in full form -->
                <xsl:variable name="complex-1">
                    <rule>
                        <and>
                            <true/>
                            <or>
                                <false/>
                                <not>
                                    <false/>
                                </not>
                            </or>
                        </and>
                    </rule>
                </xsl:variable>
                <xsl:call-template name="test-equal">
                    <xsl:with-param name="description">complex-1</xsl:with-param>
                    <xsl:with-param name="expected">
                        <rule>
                            <true from="and">
                                <true from="primitive"/>
                                <true from="or">
                                    <false from="primitive"/>
                                    <true from="not">
                                        <false from="primitive"/>
                                    </true>
                                </true>
                            </true>
                        </rule>
                    </xsl:with-param>
                    <xsl:with-param name="actual">
                        <xsl:apply-templates select="$complex-1"/>
                    </xsl:with-param>
                </xsl:call-template>

            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Our serializer function doesn't handle boolean values well, so this serializes
         the output from matching `rule` as a string -->
    <xsl:template match="rule" mode="boolean-text">
        <xsl:variable name="result" as="xs:boolean">
            <xsl:apply-templates select="." mode="boolean"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$result">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>