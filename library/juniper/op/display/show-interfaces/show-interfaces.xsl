<?xml version="1.0" standalone="yes"?>
<!--
- $Id: show-interfaces.xsl,v 1.1 2007/10/17 18:37:04 phil Exp $
-
- Copyright (c) 2005, Juniper Networks, Inc.
- All rights reserved.
-
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:junos="http://xml.juniper.net/junos/*/junos"
  xmlns:xnm="http://xml.juniper.net/xnm/1.1/xnm"
  xmlns:jcs="http://xml.juniper.net/junos/commit-scripts/1.0">

  <xsl:import href="../import/junos.xsl"/>

  <xsl:variable name="arguments">
    <argument>
      <name>interface</name>
      <description>Name of interface to display</description>
    </argument>
    <argument>
      <name>protocol</name>
      <description>Protocol to display (inet, inet6)</description>
    </argument>
  </xsl:variable>

  <xsl:param name="interface"/>
  <xsl:param name="protocol"/>

  <xsl:template match="/">
    <op-script-output>
      <xsl:variable name="rpc">
        <get-interface-information>
          <terse/>
          <xsl:if test="$interface">
            <interface-name>
              <xsl:value-of select="$interface"/>
            </interface-name>
          </xsl:if>
        </get-interface-information>
      </xsl:variable>

      <xsl:variable name="out" select="jcs:invoke($rpc)"/>

      <interface-information junos:style="terse">
        <xsl:choose>
          <xsl:when test="$protocol='inet' or $protocol='inet6' 
                          or $protocol='mpls' or $protocol='tnp'">
            <xsl:for-each select="$out/physical-interface/
      logical-interface[ address-family/address-family-name = $protocol]">
              <xsl:call-template name="intf"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$protocol">
            <xnm:error>
              <message>
                <xsl:text>invalid protocol: </xsl:text>
                <xsl:value-of select="$protocol"/>
              </message>
            </xnm:error>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$out/physical-interface/logical-interface">
              <xsl:call-template name="intf"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </interface-information>
    </op-script-output>
  </xsl:template>

  <xsl:template name="intf">
    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="admin-status='up' and oper-status='up'">
          <xsl:text> </xsl:text>
        </xsl:when>
        <xsl:when test="admin-status='down'">
          <xsl:text>offline</xsl:text>
        </xsl:when>
        <xsl:when test="oper-status='down' and ../admin-status='down'">
          <xsl:text>p-offline</xsl:text>
        </xsl:when>
        <xsl:when test="oper-status='down' and ../oper-status='down'">
          <xsl:text>p-down</xsl:text>
        </xsl:when>
        <xsl:when test="oper-status='down'">
          <xsl:text>down</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(oper-status, '/', admin-status)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
          
    <xsl:variable name="desc">
      <xsl:choose>
        <xsl:when test="description">
          <xsl:value-of select="description"/>
        </xsl:when>
        <xsl:when test="../description">
          <xsl:value-of select="../description"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <logical-interface>
      <name><xsl:value-of select="name"/></name>
      <xsl:if test="string-length($desc)">
        <admin-status><xsl:value-of select="$desc"/></admin-status>
      </xsl:if>
      <admin-status><xsl:value-of select="$status"/></admin-status>
      <xsl:choose>
        <xsl:when test="$protocol">
          <xsl:copy-of 
            select="address-family[address-family-name = $protocol]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="address-family"/>
        </xsl:otherwise>
      </xsl:choose>
    </logical-interface>
  </xsl:template>

</xsl:stylesheet>
