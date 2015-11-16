module ZCI
  def build_section_xml(section)
    section_xml = Nokogiri::XML::Builder.new do |xml|
      xml.root {
        # id - id of the original section
        # category_id - id of the original category
        xml.section(id: section.id, category_id: section.category_id, position: section.position, identifier: 'section', type: 'document') {
          xml.name {
            xml.cdata section.name
          }
          xml.description {
            xml.cdata section.description
          }
        }
      }
    end

    return section_xml
  end

  def build_section_hash(section)
    return {
      id:          section.id,
      category_id: section.category_id,
      position:    section.position,
      name:        section.name,
      description: section.description,
    }
  end

  def build_article_xml(article)
    # remove control chars, unicode codepoints from 0001 to 001A
    article.title.gsub!(/[\u0001-\u001A]/ , '')
    article.body.gsub!(/[\u0001-\u001A]/ , '')

    article_xml = Nokogiri::XML::Builder.new do |xml|
      xml.root {
        # id - id of the original acticle
        # section_id - id of the original section
        xml.article(id: article.id, section_id: article.section_id, position: article.position, identifier: 'article', type: 'document') {
          xml.title {
            xml.cdata article.title
          }
          xml.body {
            xml.cdata article.body
          }
        }
      }
    end

    return article_xml
  end

  def build_article_hash(article)
    return {
      id:         article.id,
      section_id: article.section_id,
      position:   article.position,
      title:      article.title,
      body:       article.body,
    }
  end

end
