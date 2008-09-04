<?xml version="1.0" standalone="yes"?>
<!--
- $Id: ex-ldp.xsl,v 1.1 2007/10/17 18:37:04 phil Exp $
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
  - This example tests for interfaces that are listed under
  - either [protocols ospf] or [protocols isis] which are
  - not configured under [protocols ldp].  If there is no
  - configuration for ldp, there is no problem, but otherwise
  - a warning is emitted telling the user that the interface
  - does not have ldp enabled.  The warning can be avoided
  - by configuring the 'no-ldp' apply-macro wherever the
  - interface is referenced.
  - A second test is then made of all ldp-enabled interfaces
  - to ensure that they are configured for an IGP.  If no
  - IGP is found and the 'no-igp' apply-macro has not been
  - configured, a warning is emitted.
  -->

  <xsl:template match="configuration">
    <xsl:variable name="ldp" select="protocols/ldp"/>
    <xsl:variable name="isis" select="protocols/isis"/>
    <xsl:variable name="ospf" select="protocols/ospf"/>
    <xsl:if test="$ldp">
      <xsl:for-each select="$isis/interface/name | $ospf/area/interface/name">
        <xsl:variable name="ifname" select="."/>
        <xsl:if test="not(../apply-macro[name = 'no-ldp'])
                      and not($ldp/interface[name = $ifname])">
          <xnm:warning>
            <xsl:call-template name="jcs:edit-path"/>
            <xsl:call-template name="jcs:statement"/>
            <message>ldp not enabled for this interface</message>
          </xnm:warning>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="protocols/ldp/interface/name">
        <xsl:variable name="ifname" select="."/>
        <xsl:if test="not(apply-macro[name = 'no-igp'])
                      and not($isis/interface[name = $ifname])
                      and not($ospf/area/interface[name = $ifname])">
          <xnm:warning>
            <xsl:call-template name="jcs:edit-path"/>
            <xsl:call-template name="jcs:statement"/>
            <message>
              <xsl:text>ldp-enabled interface does not have </xsl:text>
              <xsl:text>an IGP configured</xsl:text>
            </message>
          </xnm:warning>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
