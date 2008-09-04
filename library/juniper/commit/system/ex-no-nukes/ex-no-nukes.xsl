<?xml version="1.0" standalone="yes"?>
<!--
- $Id: ex-no-nukes.xsl,v 1.1 2007/10/17 18:37:04 phil Exp $
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

  <xsl:param name="user"/>

  <!--
  - This example detects missing configuration statement and reports them.
  -->
  <xsl:template match="configuration">
    <xsl:call-template name="error-if-missing">
      <xsl:with-param name="must"
                      select="interfaces/interface[name='fxp0']/
                              unit[name='0']/family/inet/address"/>
      <xsl:with-param name="statement"
                      select="'interfaces fxp0 unit 0 family inet address'"/>
    </xsl:call-template>

    <xsl:call-template name="error-if-present">
      <xsl:with-param name="must"
                      select="interfaces/interface[name='fxp0']/disable
                              | interfaces/interface[name='fxp0']/
                                   unit[name='0']/disable"/>
      <xsl:with-param name="message">
        <xsl:value-of select="$user"/>
        <xsl:text>, you're fired.  Again.</xsl:text>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="error-if-missing">
      <xsl:with-param name="must" select="protocols/bgp"/>
      <xsl:with-param name="statement" select="'protocols bgp'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="error-if-missing">
    <xsl:param name="must"/>
    <xsl:param name="statement" select="'unknown'"/>
    <xsl:param name="message"
               select="'missing mandatory configuration statement'"/>

    <xsl:if test="not($must)">
      <xnm:error>
        <edit-path><xsl:copy-of select="$statement"/></edit-path>
        <message><xsl:copy-of select="$message"/></message>
      </xnm:error>
    </xsl:if>
  </xsl:template>

  <xsl:template name="error-if-present">
    <xsl:param name="must" select="1"/>  <!-- give error if param missing -->
    <xsl:param name="message" select="'invalid configuration statement'"/>

    <xsl:for-each select="$must">
      <xnm:error>
        <xsl:call-template name="jcs:edit-path"/>
        <xsl:call-template name="jcs:statement"/>
        <message><xsl:copy-of select="$message"/></message>
      </xnm:error>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
