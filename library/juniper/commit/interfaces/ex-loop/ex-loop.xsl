<?xml version="1.0" standalone="yes"?>
<!--
- $Id: ex-loop.xsl,v 1.1 2007/10/17 18:37:03 phil Exp $
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
  - This example shows both the strengths and weaknesses of XSL.
  - An apply-macro is expanded, which has the name of a physical
  - interface, and a set of parameters that request a number of
  - logical units to be defined for that physical interface.  The
  - units are numbered sequentially from $unit to $max, and are
  - given IP addresses starting a $address.
  -
  - To loop thru the logical units, XSL must use recursion, which
  - is implemented in the "emit-interface" template.
  -
  - Calculating the next address is done in the "next-address" template,
  - where the nature of XSL and it's shallow data types, weak programming
  - structures, and verbosity are full exposed.
  -->
  <xsl:template match="configuration">
    <xsl:for-each select="interfaces/apply-macro">
      <xsl:variable name="device" select="name"/>
      <xsl:variable name="desc" select="data[name='description']/value"/>
      <xsl:variable name="address" select="data[name='address']/value"/>
      <xsl:variable name="max" select="data[name='max']/value"/>
      <xsl:variable name="unit" select="data[name='unit']/value"/>

      <xsl:variable name="real-max">
        <xsl:choose>
          <xsl:when test="string-length($max) &gt; 0">
            <xsl:value-of select="$max"/>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="real-unit">
        <xsl:choose>
          <xsl:when test="string-length($unit) &gt; 0">
            <xsl:value-of select="$unit"/>
          </xsl:when>
          <xsl:when test="contains($device, '.')">
            <xsl:value-of select="substring-after($device, '.')"/>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="real-device">
        <xsl:choose>
          <xsl:when test="contains($device, '.')">
            <xsl:value-of select="substring-before($device, '.')"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$device"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <transient-change>
        <interfaces>

          <interface>
            <name><xsl:value-of select="$real-device"/></name>
            <xsl:call-template name="emit-interface">
              <xsl:with-param name="desc" select="$desc"/>
              <xsl:with-param name="address" select="$address"/>
              <xsl:with-param name="unit" select="$real-unit"/>
              <xsl:with-param name="max" select="$real-max"/>
            </xsl:call-template>
          </interface>

          <apply-macro delete="delete">
            <name><xsl:value-of select="$device"/></name>
          </apply-macro>
        </interfaces>
      </transient-change>

    </xsl:for-each>
  </xsl:template>

  <xsl:template name="emit-interface">
    <xsl:param name="$desc"/>
    <xsl:param name="$max"/>
    <xsl:param name="$unit"/>
    <xsl:param name="$address"/>

    <unit>
      <name><xsl:value-of select="$unit"/></name>
      <vci><xsl:value-of select="$unit"/></vci>
      <xsl:if test="$desc">
        <description><xsl:value-of select="$desc"/></description>
      </xsl:if>
      <family>
        <inet>
          <address><xsl:value-of select="$address"/></address>
        </inet>
      </family>
    </unit>

    <xsl:if test="$max &gt; $unit">
      <xsl:call-template name="emit-interface">
        <xsl:with-param name="desc" select="$desc"/>
        <xsl:with-param name="address">
          <xsl:call-template name="next-address">
            <xsl:with-param name="address" select="$address"/>
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="unit" select="$unit + 1"/>
        <xsl:with-param name="max" select="$max"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="next-address">
    <xsl:param name="address"/>

    <xsl:variable name="arg-prefix" select="substring-after($address, '/')"/>
    <xsl:variable name="arg-addr" select="substring-before($address, '/')"/>
    <xsl:variable name="addr">
      <xsl:choose>
        <xsl:when test="string-length($arg-addr) &gt; 0">
          <xsl:value-of select="$arg-addr"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$address"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="prefix">
      <xsl:choose>
        <xsl:when test="string-length($arg-prefix) &gt; 0">
          <xsl:value-of select="$arg-prefix"/>
        </xsl:when>
        <xsl:otherwise>32</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="a1" select="substring-before($addr, '.')"/>
    <xsl:variable name="a234" select="substring-after($addr, '.')"/>
    <xsl:variable name="a2" select="substring-before($a234, '.')"/>
    <xsl:variable name="a34" select="substring-after($a234, '.')"/>
    <xsl:variable name="a3" select="substring-before($a34, '.')"/>
    <xsl:variable name="a4" select="substring-after($a34, '.')"/>

    <xsl:variable name="r3">
      <xsl:choose>
        <xsl:when test="$a4 &lt; 255">
          <xsl:value-of select="$a3"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$a3 + 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="r4">
      <xsl:choose>
        <xsl:when test="$a4 &lt; 255">
          <xsl:value-of select="$a4 + 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$a1"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$a2"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$r3"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$r4"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$prefix"/>
  </xsl:template>

</xsl:stylesheet>
