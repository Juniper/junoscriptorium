<?xml version="1.0" standalone="yes"?>
<!--
- $Id: add-accept.xsl,v 1.1 2007/10/17 18:37:03 phil Exp $
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
    <xsl:apply-templates select="firewall/filter | firewall/family/inet
                                    | firewall/family/inet6" mode="filter"/>
  </xsl:template>

  <!--
  - This example adds a 'then accept' to any firewall filter
  - that does not already end with one.  This counteracts the
  - normal JUNOS default of an implicit 'then reject'.
  -->
  <xsl:template match="filter" mode="filter">
    <xsl:param name="last" select="term[position() = last()]"/>
    <xsl:comment>
      <xsl:text>Found </xsl:text>
      <xsl:value-of select="name"/>
      <xsl:text>; last </xsl:text>
      <xsl:value-of select="$last/name"/>
    </xsl:comment>

    <xsl:if test="$last and
                   ($last/from or $last/to or not($last/then/accept))">
      <xnm:warning>
        <xsl:call-template name="jcs:edit-path"/>
        <message>
          <xsl:text>filter is missing bare 'then accept' rule</xsl:text>
        </message>
      </xnm:warning>
      <xsl:call-template name="jcs:emit-change">
        <xsl:with-param name="content">
          <term>
            <name>very-last</name>
            <junos:comment>
              <xsl:text>This term was added by a commit script</xsl:text>
            </junos:comment>
            <then>
              <accept/>
            </then>
          </term>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
