<?xml version="1.0" standalone="yes"?>
<!--
- $Id: ex-so-mtu.xsl,v 1.1 2007/10/17 18:37:04 phil Exp $
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

  <xsl:param name="min-mtu" select="2048"/>

  <!--
  - This example tests the mtu of sonet interfaces, and to report
  - when the mtu is less that $max-mtu.
  -->
  <xsl:template match="configuration">
    <xsl:for-each select="interfaces/interface[starts-with(name, 'so-')
                                               and mtu and mtu &lt; $min-mtu]">
      <xnm:error>
        <xsl:call-template name="jcs:edit-path"/>
        <xsl:call-template name="jcs:statement">
          <xsl:with-param name="dot" select="mtu"/>
        </xsl:call-template>
        <message>
          <xsl:text>SONET interfaces must have a minimum mtu of </xsl:text>
          <xsl:value-of select="$min-mtu"/>
        </message>
      </xnm:error>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
