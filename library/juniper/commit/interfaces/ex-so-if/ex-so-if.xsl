<?xml version="1.0" standalone="yes"?>
<!--
- $Id: ex-so-if.xsl,v 1.1 2007/10/17 18:37:04 phil Exp $
-
- Copyright (c) 2004-2005, Juniper Networks, Inc.
- All rights reserved.
-
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:junos="http://xml.juniper.net/junos/*/junos"
  xmlns:xnm="http://xml.juniper.net/xnm/1.1/xnm"
  xmlns:jcs="http://xml.juniper.net/junos/commit-scripts/1.0">

  <xsl:import href="../import/junos.xsl"/>

  <!--
  - This example uses an apply-macro to turn simplified interface
  - configuration into a diverse set of configuration statements.
  -->
  <xsl:template match="configuration">
    <xsl:variable name="top" select="."/>
    <xsl:for-each select="interfaces/apply-macro">
      <xsl:variable name="description" 
                    select="data[name = 'description']/value"/>
      <xsl:variable name="inet-address"
                    select="data[name = 'inet-address']/value"/>
      <xsl:variable name="isis-level-1"
                    select="data[name = 'isis-level-1']/value"/>
      <xsl:variable name="isis-level-1-metric"
                    select="data[name = 'isis-level-1-metric']/value"/>
      <xsl:variable name="isis-level-2"
                    select="data[name = 'isis-level-2']/value"/>
      <xsl:variable name="isis-level-2-metric"
                    select="data[name = 'isis-level-2-metric']/value"/>
      <xsl:variable name="param-devname" select="substring-before(name, '.')"/>
      <xsl:variable name="devname">
        <xsl:choose>
          <xsl:when test="$param-devname">
            <xsl:value-of select="$param-devname"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="name"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="param-unit" select="substring-after(name, '.')"/>
      <xsl:variable name="unit">
        <xsl:choose>
          <xsl:when test="$param-unit">
            <xsl:value-of select="$param-unit"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'0'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="ifname" select="concat($devname, '.', $unit)"/>

      <transient-change>
        <interfaces>
          <interface>
            <name><xsl:value-of select="$devname"/></name>
            <apply-groups>
              <name>interface-details</name>
            </apply-groups>
            <xsl:if test="$description">
              <description><xsl:value-of select="$description"/></description>
            </xsl:if>
            <unit>
              <name><xsl:value-of select="$unit"/></name>
              <xsl:if test="string-length($inet-address) &gt; 0">
                <family>
                  <inet>
                    <address><xsl:value-of select="$inet-address"/></address>
                  </inet>
                </family>
              </xsl:if>
            </unit>
          </interface>
        </interfaces>
        <protocols>
          <rsvp>
            <interface>
              <name><xsl:value-of select="$ifname"/></name>
            </interface>
          </rsvp>
          <isis>
            <interface>
              <name><xsl:value-of select="$ifname"/></name>
              <xsl:if test="$isis-level-1 or $isis-level-1-metric">
                <level>
                  <name>1</name>
                  <xsl:if test="$isis-level-1">
                    <xsl:element name="{$isis-level-1}"/>
                  </xsl:if>
                  <xsl:if test="$isis-level-1-metric">
                    <metric>
                      <xsl:value-of select="$isis-level-1-metric"/>
                    </metric>
                  </xsl:if>
                </level>
              </xsl:if>
              <xsl:if test="$isis-level-2 or $isis-level-2-metric">
                <level>
                  <name>2</name>
                  <xsl:if test="$isis-level-2">
                    <xsl:element name="{$isis-level-2}"/>
                  </xsl:if>
                  <xsl:if test="$isis-level-2-metric">
                    <metric>
                      <xsl:value-of select="$isis-level-2-metric"/>
                    </metric>
                  </xsl:if>
                </level>
              </xsl:if>
            </interface>
          </isis>
          <ldp>
            <interface>
              <name><xsl:value-of select="$ifname"/></name>
            </interface>
          </ldp>
        </protocols>
        <class-of-service>
          <interfaces>
            <name><xsl:value-of select="$devname"/></name>
            <apply-groups>
              <name>cos-details</name>
            </apply-groups>
          </interfaces>
        </class-of-service>
      </transient-change>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
