<?xml version="1.0" standalone="yes"?>
<!--
- $Id: ex-ifclass.xsl,v 1.1 2007/10/17 18:37:04 phil Exp $
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
  - This example expands an apply-macro named 'ifclass' to 
  - configure an igp on the interface.  
  -->
  <xsl:template match="configuration">
    <xsl:for-each
          select="interfaces/interface/unit/apply-macro[name = 'ifclass']">
      <xsl:variable name="role" select="data[name='role']/value"/>
      <xsl:variable name="igp" select="data[name='igp']/value"/>

      <xsl:variable name="ifname">
        <xsl:value-of select="../../name"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="../name"/>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$role = 'cpe'">
          <change>
            <xsl:choose>
              <xsl:when test="$igp = 'isis'">
                <protocols>
                  <isis>
                    <interface>
                      <name><xsl:value-of select="$ifname"/></name>
                    </interface>
                  </isis>
                </protocols>
              </xsl:when>
              <xsl:when test="$igp = 'ospf'">
                <protocols>
                  <ospf>
                    <area>
                      <name>
                        <xsl:value-of select="data[name='area']/value"/>
                      </name>
                      <interface>
                        <name><xsl:value-of select="$ifname"/></name>
                      </interface>
                    </area>
                  </ospf>
                </protocols>
              </xsl:when>
            </xsl:choose>
          </change>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
