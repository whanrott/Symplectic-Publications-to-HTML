<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:api="http://www.symplectic.co.uk/publications/api">
    <xsl:output method="html" encoding="UTF-8"/>
<!-- Key to generate list of journals by year -->
    <xsl:key 
        name="journals"
       match="atom:entry"
         use="api:relationship[child::api:is-visible='true']/api:related/
         api:object[@type-id='5']/api:records/
         api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/
         api:field[@name='publication-date']/api:date/api:year"/>
    <!-- Key to generate list of Books and Chapters by year -->
    <xsl:key 
        name="books"
       match="atom:entry"
         use="api:relationship[child::api:is-visible='true']/api:related/
         api:object[@type-id='2' or @type-id='3']/api:records/
         api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/
         api:field[@name='publication-date']/api:date/api:year"/>
    <!-- Key to generate list of conference abstracts by year -->
    <xsl:key 
        name="conferences"
       match="atom:entry"
         use="api:relationship[child::api:is-visible='true']/api:related/
         api:object[@type-id='4']/api:records/
         api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/
         api:field[@name='publication-date']/api:date/api:year"/>
<!-- Paramater to extract Researcher Name from atom:title node and format it in Sentence Case
    this is used to highlight author name in bold in publication list -->
    <xsl:param name="researcher" select="concat(substring(substring-after(/atom:feed/atom:title,': '),1,1),substring(translate(substring-before(substring-after(/atom:feed/atom:title,': '),','),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),2))" />
<!-- Parameter to extract display name -->
    <xsl:param name="display_name" select="concat(substring-after(/atom:feed/atom:title,', '),' ',substring(substring-after(/atom:feed/atom:title,': '),1,1),substring(translate(substring-before(substring-after(/atom:feed/atom:title,': '),','),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),2))" />
<!-- Base Template start -->
    <xsl:template match="/">
            <h1><a name="top" />Extended Publication List for <xsl:value-of select="$display_name"/></h1>
            <ul>
                <li><a href="#journals">Journal Publications</a></li>
                <li><a href="#books">Books and Chapters</a></li>
                <li><a href="#conferences">Conference Abstracts</a></li>
            </ul>
<!-- Journals start -->
            <h2><a name="journals" />Journal Publications</h2>
<!-- FOR-EACH start: generates lists of journals by publication year -->
            <xsl:for-each select="/atom:feed/atom:entry[generate-id(.)=
                generate-id(key('journals',api:relationship/api:related/
                api:object[@type-id='5']/api:records/
                api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/
                api:field[@name='publication-date']/api:date/api:year)[1])]">
                <xsl:sort select="api:relationship//api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/api:field[@name='publication-date']/api:date/api:year" order="descending" />
                <h3><xsl:value-of select="api:relationship//api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/api:field[@name='publication-date']/api:date/api:year"/></h3>
<!-- FOR-EACH start: lists members of given publication type -->
                <ul>
                    <xsl:for-each select="key('journals',api:relationship//api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/api:field[@name='publication-date']/api:date/api:year)">
                        <li>
                            <xsl:call-template name="article" />
                        </li>
                    </xsl:for-each>
                </ul>
<!-- FOR-EACH end: lists members of given publication type -->
            </xsl:for-each>
<!-- Catch empty Journals Section -->
            <xsl:if test="not(/atom:feed/atom:entry[generate-id(.)=
                generate-id(key('journals',api:relationship//
                api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/
                api:field[@name='publication-date']/api:date/api:year)[1])])">This author has no Journals listed</xsl:if>
<!-- Link to top menu -->
            <p><a href="#top">Top</a></p>
<!-- Journals End -->

<!-- Books and Chapters Begin -->
            <h2><a name="books" />Books and Chapter Contributions</h2>
<!-- FOR-EACH start: generates lists of journals by publication year -->
            <xsl:for-each select="/atom:feed/atom:entry[generate-id(.)=
                generate-id(key('books',api:relationship/api:related/
                api:object[@type-id='2' or @type-id='3']/api:records/
                api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/
                api:field[@name='publication-date']/api:date/api:year)[1])]">
                <h3><xsl:value-of select="api:relationship//api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/api:field[@name='publication-date']/api:date/api:year"/></h3>
<!-- FOR-EACH start: lists members of given publication type -->
                <ul>
                    <xsl:for-each select="key('books',api:relationship//api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/api:field[@name='publication-date']/api:date/api:year)">
                        <li>
                            <xsl:call-template name="book" />
                        </li>
                    </xsl:for-each>
                </ul>
<!-- FOR-EACH end: lists members of given publication type -->
            </xsl:for-each>
<!-- Catch empty Books/Chapter Section -->
            <xsl:if test="not(/atom:feed/atom:entry[generate-id(.)=
                generate-id(key('books',api:relationship//
                api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/
                api:field[@name='publication-date']/api:date/api:year)[1])])">This author has no Books or Chapters listed</xsl:if>
<!-- Link to top menu -->
            <p><a href="#top">Top</a></p>
<!-- Books and Chapters End -->

<!-- Conferences Begin -->
            <h2><a name="conferences" />Conference Abstracts</h2>
<!-- FOR-EACH start: generates lists of journals by publication year -->
            <xsl:for-each select="/atom:feed/atom:entry[generate-id(.)=
                generate-id(key('conferences',api:relationship/api:related/
                api:object[@type-id='4']/api:records/
                api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/
                api:field[@name='publication-date']/api:date/api:year)[1])]">
                <h3><xsl:value-of select="api:relationship//api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/api:field[@name='publication-date']/api:date/api:year"/></h3>

<!-- FOR-EACH start: lists members of given publication type -->
                <ul>
                    <xsl:for-each select="key('conferences',api:relationship//api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/api:field[@name='publication-date']/api:date/api:year)">
                        <li>
                            <xsl:call-template name="article" />
                        </li>
                    </xsl:for-each>
                </ul>

<!-- FOR-EACH end: lists members of given publication type -->
            </xsl:for-each>
<!-- Catch empty Conferences Section -->
            <xsl:if test="not(/atom:feed/atom:entry[generate-id(.)=
                generate-id(key('conferences',api:relationship//
                api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]/api:native/
                api:field[@name='publication-date']/api:date/api:year)[1])])">This author has no Conference Abstracts listed</xsl:if>

<!-- Link to top menu -->
            <p><a href="#top">Top</a></p>
<!-- Conferences End -->
    </xsl:template><!-- Base Template ends -->

<!-- Section containing templates to describe publication types -->
    <xsl:template name="book">
        <!-- Citation format for Book or Chapter: 
            Author, Initial (Year) 'Title of Chapter' in Editor (ed.) <em>Title of Book<em>. Place of Publication: Publisher, pp. Page Reference -->
        <xsl:for-each select="api:relationship//api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]">
            <xsl:choose>
                <xsl:when test="ancestor::api:object[@type-id='2']">
                    <xsl:choose>
                        <xsl:when test="api:native/api:field[@name='authors']">
                            <xsl:apply-templates select="api:native/api:field[@name='authors']/api:people"/>
                            <xsl:if test="api:native/api:field[@name='publication-date']">
                                <xsl:apply-templates select="api:native/api:field[@name='publication-date']"/>
                            </xsl:if>
                            <xsl:apply-templates select="api:native/api:field[@name='title']"/>
                        </xsl:when>
                        <xsl:when test="api:native/api:field[@name='editors']">
                            <xsl:apply-templates select="api:native/api:field[@name='editors']/api:people"/>
                            <xsl:if test="api:native/api:field[@name='publication-date']">
                                <xsl:apply-templates select="api:native/api:field[@name='publication-date']"/>
                            </xsl:if>
                            <xsl:apply-templates select="api:native/api:field[@name='title']"/>
                        </xsl:when>
                        <xsl:when test="not(api:native/api:field[@name='authors']) and not(api:native/api:field[@name='editors'])">
                            <xsl:apply-templates select="api:native/api:field[@name='title']"/>
                            <xsl:if test="api:native/api:field[@name='publication-date']">
                                <xsl:apply-templates select="api:native/api:field[@name='publication-date']"/>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="ancestor::api:object[@type-id='3']">
                    <xsl:apply-templates select="api:native/api:field[@name='authors']/api:people"/>
                    <xsl:if test="api:native/api:field[@name='publication-date']">
                        <xsl:apply-templates select="api:native/api:field[@name='publication-date']"/>
                    </xsl:if>
                    <xsl:text> '</xsl:text>
                    <xsl:apply-templates select="api:native/api:field[@name='title']"/>
                    <xsl:text>' </xsl:text>
                    <xsl:text> in </xsl:text>
                    <xsl:if test="api:native/api:field[@name='editors']">
                        <xsl:apply-templates select="api:native/api:field[@name='editors']/api:people"/>
                    </xsl:if>
                    <em><xsl:apply-templates select="api:native/api:field[@name='parent-title']"/></em>
                </xsl:when>
            </xsl:choose>
            <xsl:text>. </xsl:text> 
            <xsl:if test="api:native/api:field[@name='edition']">
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="api:native/api:field[@name='edition']" />
            </xsl:if>
            <xsl:choose>
                <xsl:when test="api:native/api:field[@name='place-of-publication'] and api:native/api:field[@name='publisher']">
                    <xsl:apply-templates select="api:native/api:field[@name='place-of-publication']" />
                    <xsl:text>: </xsl:text>
                    <xsl:apply-templates select="api:native/api:field[@name='publisher']" />
                    <xsl:text>, </xsl:text>
                </xsl:when>
                <xsl:when test="api:native/api:field[@name='place-of-publication']">
                    <xsl:apply-templates select="api:native/api:field[@name='place-of-publication']" />
                    <xsl:text>, </xsl:text>
                </xsl:when>
                <xsl:when test="api:native/api:field[@name='publisher']">
                    <xsl:apply-templates select="api:native/api:field[@name='publisher']" />
                    <xsl:text>, </xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="api:native/api:field[@name='series']">
                    <xsl:apply-templates select="api:native/api:field[@name='series']" />
                    <xsl:text>, </xsl:text> 
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="api:native/api:field[@name='volume']">
                    <xsl:apply-templates select="api:native/api:field[@name='volume']" />
                    <xsl:text>, </xsl:text> 
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="api:native/api:field[@name='pagination']/api:pagination/api:begin-page">
                    <xsl:text>, </xsl:text> 
                    <xsl:apply-templates select="api:native/api:field[@name='pagination']"/>
                </xsl:when>
                <xsl:when test="api:native/api:field[@name='pagination']/api:pagination/api:page-count">
                    <xsl:text>, </xsl:text> 
                    <xsl:apply-templates select="api:native/api:field[@name='pagination']"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="article">
        <!-- Citation format for Conference: 
            Author, Initial (Year) 'Title of Chapter' <em>Title of Conference: Subtitle<em> Location and Date of Conference. Place of Publication: Publisher, pp. Page Reference -->
        <xsl:for-each select="api:relationship//api:record[ancestor::api:relationship/api:preferred-source-id=@source-id]">
            <xsl:apply-templates select="api:native/api:field[@name='authors']/api:people"/>
            <xsl:if test="api:native/api:field[@name='publication-date']">
                <xsl:apply-templates select="api:native/api:field[@name='publication-date']"/>
            </xsl:if>
            <xsl:text> '</xsl:text>
            <xsl:apply-templates select="api:native/api:field[@name='title']"/>
            <xsl:text>'</xsl:text>
            <xsl:text>, </xsl:text>
            <xsl:choose>
                <xsl:when test="ancestor::api:object[@type-id='5']">
                    <em><xsl:apply-templates select="api:native/api:field[@name='journal']"/></em>
                </xsl:when>
                <xsl:when test="ancestor::api:object[@type-id='4']">
                    <em><xsl:apply-templates select="api:native/api:field[@name='name-of-conference']"/></em>
                </xsl:when>
            </xsl:choose>
            <xsl:text>. </xsl:text>
            <xsl:if test="api:native/api:field[@name='location']">
                <xsl:apply-templates select="api:native/api:field[@name='location']"/>
            <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="api:native/api:field[@name='start-date'] and api:native/api:field[@name='finish-date']">
                    <xsl:apply-templates select="api:native/api:field[@name='start-date']"/>
                    <xsl:text> to </xsl:text>
                    <xsl:apply-templates select="api:native/api:field[@name='finish-date']"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
                <xsl:when test="api:native/api:field[@name='start-date'] or api:native/api:field[@name='finish-date']">
                    <xsl:apply-templates select="api:native/api:field[@name='start-date']"/>
                    <xsl:apply-templates select="api:native/api:field[@name='finish-date']"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="api:native/api:field[@name='place-of-publication'] and api:native/api:field[@name='publisher']">
                    <xsl:apply-templates select="api:native/api:field[@name='place-of-publication']" />
                    <xsl:text>: </xsl:text>
                    <xsl:apply-templates select="api:native/api:field[@name='publisher']" />
                    <xsl:text>, </xsl:text>
                </xsl:when>
                <xsl:when test="api:native/api:field[@name='place-of-publication']">
                    <xsl:apply-templates select="api:native/api:field[@name='place-of-publication']" />
                    <xsl:text>, </xsl:text>
                </xsl:when>
                <xsl:when test="api:native/api:field[@name='publisher']">
                    <xsl:apply-templates select="api:native/api:field[@name='publisher']" />
                    <xsl:text>, </xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="api:native/api:field[@name='series']!=''">
                <xsl:apply-templates select="api:native/api:field[@name='series']" />
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="api:native/api:field[@name='volume']">
                    <xsl:apply-templates select="api:native/api:field[@name='volume']" />
                    <xsl:text>, </xsl:text> 
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="api:native/api:field[@name='pagination']/api:pagination/api:begin-page">
                    <xsl:apply-templates select="api:native/api:field[@name='pagination']"/>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="api:native/api:field[@name='doi']"/>
        </xsl:for-each>
    </xsl:template>

    <!-- begin templates for specific bits of information -->

    <xsl:template name="authors" match="api:native/api:field[@name='authors']/api:people">
        <xsl:param name="count_person_nodes" select="count(api:person)" />
        <xsl:for-each select="api:person">
            <xsl:choose>
                <xsl:when test="api:last-name=$researcher">
                    <strong>
                        <xsl:call-template name="author_name" />
                    </strong>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="author_name" />
                </xsl:otherwise>
            </xsl:choose>
        <xsl:choose>
            <xsl:when test="$count_person_nodes = 1"></xsl:when>
            <xsl:when test="$count_person_nodes &gt; 1 and position()=last()-1"> and </xsl:when>
            <xsl:otherwise>, </xsl:otherwise>
        </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="editors" match="api:native/api:field[@name='editors']/api:people">
        <xsl:param name="count_person_nodes" select="count(api:person)" />
        <xsl:for-each select="api:person">
            <xsl:choose>
                <xsl:when test="api:last-name=$researcher" >
                    <strong>
                        <xsl:call-template name="author_name" />
                    </strong>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:call-template name="author_name" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$count_person_nodes = 1"> (ed.) </xsl:when>
                <xsl:when test="$count_person_nodes &gt; 1 and not(position()=last())">, </xsl:when>
                <xsl:when test="$count_person_nodes &gt; 1 and position()=last()"> (eds.) </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="author_name">
        <xsl:value-of select="api:last-name"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="api:initials"/>
    </xsl:template>
    <xsl:template name="title" 
        match="api:native/api:field[@name=
        'title' or
        'parent-title' or
        'publisher' or
        'place-of-publication' or
        'name-of-conference' or
        'location' or
        'journal'
        ]">
        <xsl:value-of select="api:text" disable-output-escaping="yes" />
    </xsl:template>
    <xsl:template name="conference_start_date" match="api:native/api:field[@name='start-date']">
        <xsl:if test="api:date/api:month">
            <xsl:value-of select="api:date/api:month"/>
            <xsl:text>/</xsl:text>
        </xsl:if>
        <xsl:value-of select="api:date/api:year"/>
    </xsl:template>
    <xsl:template name="conference_finish_date" match="api:native/api:field[@name='finish-date']">
        <xsl:if test="api:date/api:month">
            <xsl:value-of select="api:date/api:month"/>
            <xsl:text>/</xsl:text>
        </xsl:if>
        <xsl:value-of select="api:date/api:year"/>
    </xsl:template>
    <xsl:template name="year" match="api:native/api:field[@name='publication-date']">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="api:date/api:year"/>
        <xsl:text>) </xsl:text>
    </xsl:template>
    <xsl:template name="pages" match="api:native/api:field[@name='pagination']">
        <xsl:choose>
            <xsl:when test="ancestor::api:object[@type-id='2']">
                <!-- Pagination for book -->
                <xsl:value-of select="api:pagination/api:page-count"/>
                <xsl:text> pages.</xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::api:object[@type-id='3' or '4' or '5']">
                <!-- pagination for journal article, conference or chapter -->
                <xsl:text> pp. </xsl:text>
                <xsl:value-of select="api:pagination/api:begin-page"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="api:pagination/api:end-page"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="issue" match="api:native/api:field[@name='issue']">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="api:text"/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    <xsl:template name="volume" match="api:native/api:field[@name='volume']">
        <xsl:text>Vol. </xsl:text>
        <xsl:value-of select="api:text"/>
    </xsl:template>
    <xsl:template name="series" match="api:native/api:field[@name='series']">
        <xsl:text> Ser: </xsl:text>
        <xsl:value-of select="api:text"/>
    </xsl:template>
    <xsl:template name="doi" match="api:native/api:field[@name='doi']">
        <xsl:text> doi: </xsl:text>
        <a>
            <xsl:attribute name="href">http://dx.doi.org/<xsl:value-of select="api:text"
                /></xsl:attribute>
            <xsl:value-of select="api:text"/>
        </a>
    </xsl:template>
    <xsl:template name="isbn-10" match="api:native/api:field[@name='isbn-10']">
        <xsl:value-of select="api:text"/>
    </xsl:template>
    <xsl:template name="isbn-13" match="api:native/api:field[@name='isbn-13']">
        <xsl:value-of select="api:text"/>
    </xsl:template>
    <xsl:template name="issn" match="api:native/api:field[@name='issn']">
        <xsl:value-of select="api:text"/>
    </xsl:template>
    <xsl:template name="edition" match="api:native/api:field[@name='edition']">
        <xsl:value-of select="api:text"/>
        <xsl:text> edn. </xsl:text>
    </xsl:template>
 

</xsl:stylesheet>
