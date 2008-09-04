<?xml version="1.0" standalone="yes"?>
<!--
- $Id: ex-deprecated.xsl,v 1.1 2007/10/17 18:37:03 phil Exp $
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
    <xsl:if test="system/ports/console/undocumented/speed &lt; 9600">
      <xnm:warning>
        <xsl:call-template name="jcs:edit-path">
          <xsl:with-param name="dot" 
                     select="system/ports/console"/>
        </xsl:call-template>
        <xsl:call-template name="jcs:statement">
          <xsl:with-param name="dot" 
                     select="system/ports/console/undocumented/speed"/>
        </xsl:call-template>
        <message>
          <xsl:text>Console speeds less </xsl:text>
          <xsl:text>9600 baud are deprecated</xsl:text>
        </message>
      </xnm:warning>
      <change>
        <system>
          <ports>
            <console>
              <speed delete="delete"/>
            </console>
          </ports>
        </system>
      </change>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
