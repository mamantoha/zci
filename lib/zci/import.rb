module ZCI
  def build_category_xml(category)
    Nokogiri::XML::Builder.new do |xml|
      xml.root {
        xml.category(id: category.id, position: category.position, identifier: 'category', type: 'document') {
          xml.name {
            xml.cdata category.name
          }
          xml.description {
            xml.cdata category.description
          }
        }
      }
    end
  end

  def build_category_hash(category)
    {
      id:          category.id,
      position:    category.position,
      name:        category.name,
      description: category.description,
    }
  end

  def build_section_xml(section)
    Nokogiri::XML::Builder.new do |xml|
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
  end

  def build_section_hash(section)
    {
      id:          section.id,
      category_id: section.category_id,
      position:    section.position,
      name:        section.name,
      description: section.description,
    }
  end

  def build_article_xml(article)
    # remove control chars, unicode codepoints from 0001 to 001A
    article.title.to_s.gsub!(/[\u0001-\u001A]/ , '')
    article.body.to_s.gsub!(/[\u0001-\u001A]/ , '')

    Nokogiri::XML::Builder.new do |xml|
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
  end

  def build_article_hash(article)
    {
      id:         article.id,
      section_id: article.section_id,
      position:   article.position,
      title:      article.title,
      body:       article.body,
    }
  end
end
