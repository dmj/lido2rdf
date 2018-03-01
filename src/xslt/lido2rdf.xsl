<xsl:transform version="2.0"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:lido="http://www.lido-schema.org"
               xmlns:l2r="https://github.com/dmj/lido2rdf"
               xmlns:owl="http://www.w3.org/2002/07/owl#"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="l2r:conceptCodes">
    <l2r:concept code="aat" prefix="http://vocab.getty.edu/aat/"/>
  </xsl:variable>

  <xsl:template match="lido:lido">
    <xsl:variable name="ident" select="substring-after(.//lido:resourceRepresentation[@lido:type = 'purl'], '=')"/>
    <rdf:Description rdf:about="http://uri.hab.de/instance/grafik/{$ident}">
      <xsl:apply-templates/>
    </rdf:Description>
  </xsl:template>

  <xsl:template match="lido:titleWrap">
    <skos:prefLabel>
      <xsl:value-of select="lido:titleSet[1]/lido:appellationValue"/>
    </skos:prefLabel>
    <xsl:apply-templates select="lido:titleSet[position() gt 1]"/>
  </xsl:template>

  <xsl:template match="lido:titleSet">
    <dct:title>
      <xsl:value-of select="lido:appellationValue"/>
    </dct:title>
  </xsl:template>

  <xsl:template match="lido:objectWorkType">
    <dct:type>
      <skos:Concept>
        <owl:sameAs rdf:resource="{l2r:resolveConceptUri(lido:conceptID)}"/>
        <skos:prefLabel>
          <xsl:value-of select="lido:term[1]"/>
        </skos:prefLabel>
      </skos:Concept>
    </dct:type>
  </xsl:template>

  <xsl:template match="text()"/>

  <xsl:function name="l2r:resolveConceptUri" as="xs:anyURI">
    <xsl:param name="concept" as="element(lido:conceptID)"/>
    <xsl:variable name="conceptUriPart" select="normalize-space(encode-for-uri($concept))"/>
    <xsl:variable name="conceptUriPrefix" select="$l2r:conceptCodes/l2r:concept[@code = $concept/@lido:source]/@prefix"/>
    <xsl:choose>
      <xsl:when test="$concept/@lido:source = 'aat'">
        <xsl:value-of select="xs:anyURI(concat($conceptUriPrefix, $conceptUriPart))"/>
      </xsl:when>
    </xsl:choose>
  </xsl:function>

</xsl:transform>
