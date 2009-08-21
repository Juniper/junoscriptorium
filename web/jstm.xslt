<?xml version="1.0" standalone="yes"?>
<!-- modification of intf.xsl -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml">

  <xsl:param name="show-all" select="'true'"/>
  <xsl:param name="filename" select="'unknown'"/>

  <xsl:output method="xml" version="1.0"
  cdata-section-elements="pre script style" indent="yes"
  doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <xsl:template match="script">
    <xsl:variable name="title" select="title"/>
    <xsl:variable name="author" select="author"/>

    <script xmlns="http://www.w3.org/1999/xhtml">
      <div class="header" id="XXX">
        <logo>JUNOScriptorium</logo>
        <title id="title"><xsl:value-of select="$title"/></title>
        <author>
          <a href="../../../Authors/{$author}.xml">
            <xsl:value-of select="$author"/></a>
        </author>
        <xsl:copy-of select="synopsis"/>
        <div class="download">
          <div class="button">
            <a href="{$title}" type="application/download">
              <xsl:value-of select="$title"/>
            </a>
          </div>
          <xsl:if test="alternate">
            <div class="button">
              <a href="{alternate}" type="application/download">
                <xsl:value-of select="alternate"/>
              </a>
            </div>
          </xsl:if>
        </div>
      </div>

      <xsl:variable name="tabbers"
                    select="description | implementation | example"/>

      <xsl:for-each select="$tabbers">
        <xsl:call-template name="emit-tab">
          <xsl:with-param name="name" select="name()"/>
          <xsl:with-param name="id"
                          select="concat(name(), '-', position())"/>
          <xsl:with-param name="contents" select="."/>
        </xsl:call-template>
      </xsl:for-each>

      <xsl:call-template name="emit-tab">
        <xsl:with-param name="name" select="'source'"/>
        <xsl:with-param name="id" select="'source'"/>
        <xsl:with-param name="contents" select="title"/>
      </xsl:call-template>

      <div class="load-files" id="load-files">
        <xsl:for-each select="$tabbers">
          <xsl:if test="name() = 'example'">
            
            <xsl:variable name="id"
                          select="concat(name(), '-', position())"/>
            <xsl:if test="config">
              <xsl:variable name="file" select="config"/>
              <div class="load-file" filename="{$file}"
                   target="file-config-{$id}"/>
            </xsl:if>
            <xsl:if test="output">
              <xsl:variable name="file" select="output"/>
              <div class="load-file" filename="{$file}"
                   target="file-output-{$id}"/>
            </xsl:if>
            <xsl:if test="errors">
              <xsl:variable name="file" select="errors"/>
              <div class="load-file" filename="{$file}"
                   target="file-errors-{$id}"/>
            </xsl:if>
          </xsl:if>
          <div class="load-file" filename="{$title}"
               target="file-source-source"/>
        </xsl:for-each>
      </div>

      <div class="debug-container">
        <span class="title">Debug Log</span>
        <div id="debug-log" class="debug">
        </div>
      </div>
    </script>

  </xsl:template>

  <xsl:template name="emit-tab">
    <xsl:param name="name"/>
    <xsl:param name="id"/>
    <xsl:param name="classes" select="'current'"/>
    <xsl:param name="contents"/>

    <div class="tab-box">
      <div class="tab-header" xmlns="http://www.w3.org/1999/xhtml">
        <div class="tab {$classes}" id="tab-{$id}">
          <a link="#{$id}">
            <xsl:value-of select="translate(substring(name(), 1, 1),
                                  'abcdefghijklmnopqrstuvwxyz',
                                  'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
            <xsl:value-of select="substring(name(), 2)"/>
            <xsl:if test="title">
              <xsl:text>: &#0160;&#160;</xsl:text>
              <xsl:value-of select="title"/>
            </xsl:if>
          </a>
        </div>
      </div>

      <div class="tab-container" xmlns="http://www.w3.org/1999/xhtml">
        <div class="tab-body">
          <div class="tab-contents {$classes}" id="body-{$id}">
            <xsl:choose>
              <xsl:when test="$name = 'description'">
                <div class="description">
                  <xsl:value-of select="$contents"/>
                </div>
              </xsl:when>
              <xsl:when test="$name = 'implementation'">
                <xsl:value-of select="$contents"/>
              </xsl:when>
              <xsl:when test="$name = 'example'">
                <xsl:if test="description">
                  <div class="description">
                    <xsl:value-of select="description"/>
                  </div>
                </xsl:if>

                <xsl:call-template name="emit-file">
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="file" select="config"/>
                  <xsl:with-param name="class" select="'config'"/>
                </xsl:call-template>

                <xsl:call-template name="emit-file">
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="file" select="output"/>
                  <xsl:with-param name="class" select="'output'"/>
                </xsl:call-template>

                <xsl:call-template name="emit-file">
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="file" select="errors"/>
                  <xsl:with-param name="class" select="'errors'"/>
                </xsl:call-template>

              </xsl:when>
              <xsl:when test="$name = 'source'">
                <xsl:call-template name="emit-file">
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="file" select="title"/>
                  <xsl:with-param name="class" select="'source'"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </div>
        </div>
      </div>
    </div>

  </xsl:template>

  <xsl:template name="emit-file">
    <xsl:param name="id"/>
    <xsl:param name="file"/>
    <xsl:param name="class"/>
    <xsl:param name="name" select="$class"/>

    <xsl:if test="$file">
      <div xmlns="http://www.w3.org/1999/xhtml" class="file-header">
        <div class="file-tab">
          <xsl:value-of select="translate(substring($name, 1, 1),
				'abcdefghijklmnopqrstuvwxyz',
            			'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
          <xsl:value-of select="substring($name, 2)"/>
        </div>
      </div>
      <div xmlns="http://www.w3.org/1999/xhtml"
           class="file-contents {$class}">
        <textarea class="file-contents" 
                  id="file-{$class}-{$id}"
                  readonly="true">[loading ... ]</textarea>
      </div>
    </xsl:if>
    
  </xsl:template>

  <!-- We don't want these, since it makes a recursive file -->
  <xsl:template match="xhtml:script"/>

</xsl:stylesheet>

