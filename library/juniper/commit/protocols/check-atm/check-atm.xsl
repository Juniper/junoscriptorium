<?xml version="1.0" standalone="yes"?>
<!--
- $Id: check-atm.xsl,v 1.1 2007/10/17 18:37:04 phil Exp $
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

  <xsl:template match="configuration">
      <xsl:apply-templates select="interfaces" mode="limit"/>
  </xsl:template>

  <xsl:template match="*" mode="limit">
    <xsl:variable name="limits" select="apply-macro[name='limits']"/>
    <xsl:variable name="gold-max"
                  select="$limits/data[name = 'gold-max']/value"/>
    <xsl:variable name="silver-max"
                  select="$limits/data[name = 'silver-max']/value"/>
    <xsl:variable name="bronze-max"
                  select="$limits/data[name = 'bronze-max']/value"/>

    <xsl:for-each select="interface[starts-with(name, 'at-')]">
      <xsl:variable name="ifdev" select="name"/>
      <xsl:for-each select="unit">
        <xsl:variable name="class">
          <xsl:choose>
            <xsl:when test="name &lt;= $gold-max">gold</xsl:when>
            <xsl:when test="name &lt;= $silver-max">silver</xsl:when>
            <xsl:when test="name &lt;= $bronze-max">bronze</xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="jcs:emit-change">
          <!--
          <xsl:with-param name="message">
            <xsl:text>Turning on class </xsl:text>
            <xsl:value-of select="$class"/>
            <xsl:text> for interface </xsl:text>
            <xsl:value-of select="$name"/>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="name"/>
          </xsl:with-param>
          -->
          <xsl:with-param name="content">
            <vci><xsl:value-of select="name"/></vci>
            <xsl:if test="string-length($class) &gt; 0">
              <apply-groups>
                <xsl:text>class-</xsl:text>
                <xsl:value-of select="$class"/>
              </apply-groups>
            </xsl:if>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
