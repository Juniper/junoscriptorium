<?xml version="1.0" standalone="yes"?>
<!--
- $Id: mpls-lsp.xsl,v 1.1 2007/10/17 18:37:04 phil Exp $
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
  - This example turns a list of addresses into a list of MPLS LSPs.
  - An apply-macro under [protocols mpls] is configured with a
  - set of addresses and a 'color' parameter.  Each address is
  - turned into an LSP configuration, with the color as an admin-group.
  -->
  <xsl:template match="configuration">
    <xsl:variable name="mpls" select="protocols/mpls"/>
    <xsl:for-each select="$mpls/apply-macro[data/name = 'color']">
      <xsl:variable name="color" select="data[name = 'color']/value"/>
      <transient-change>
        <protocols>
          <mpls>
            <xsl:for-each select="data[not(value)]/name">
              <label-switched-path>
                <name>
                  <xsl:value-of select="concat($color, '-lsp-', .)"/>
                </name>
                <to><xsl:value-of select="."/></to>
                <admin-group>
                  <include><xsl:value-of select="$color"/></include>
                </admin-group>
              </label-switched-path>
            </xsl:for-each>
          </mpls>
        </protocols>
      </transient-change>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
