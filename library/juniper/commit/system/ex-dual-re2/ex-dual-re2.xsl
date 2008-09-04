<?xml version="1.0" standalone="yes"?>
<!--
- $Id: ex-dual-re2.xsl,v 1.1 2007/10/17 18:37:04 phil Exp $
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
  - This example builds the config to all a single [system host-name]
  - statement to support dual REs.  The appropriate configuration groups
  - are built using $host-name-RE0 and $host-name-RE1.  Then the
  - foreground configuration is deactivated.
  -->
  <xsl:template match="configuration">
    <xsl:variable name="hn" select="system/host-name"/>
    <xsl:choose>
      <xsl:when test="$hn/@junos:group"/>
      <xsl:when test="$hn">
        <transient-change>
          <groups>
            <name>re0</name>
            <system>
              <host-name>
                <xsl:value-of select="concat($hn, '-RE0')"/>
              </host-name>
            </system>
          </groups>
          <groups>
            <name>re1</name>
            <system>
              <host-name>
                <xsl:value-of select="concat($hn, '-RE1')"/>
              </host-name>
            </system>
          </groups>
          <system>
            <host-name inactive="inactive"/>
          </system>
        </transient-change>
      </xsl:when>
      <xsl:otherwise>
        <xnm:error>
          <message>Missing [system host-name]</message>
        </xnm:error>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
