module ZCI

  def parse_category_xml(xml_file)
    doc = Nokogiri::XML.parse(xml_file)
    category_xml = doc.xpath("//category").first

    category = {
      id: category_xml[:id],
      name: category_xml.xpath('name').text,
      description: category_xml.xpath('description').text,
      position: category_xml[:position],
    }

    return category
  end

  def parse_section_xml(xml_file)
    doc = Nokogiri::XML.parse(xml_file)
    section_xml = doc.xpath("//section").first

    section = {
      id: section_xml[:id],
      category_id: section_xml[:category_id],
      name: section_xml.xpath('name').text,
      description: section_xml.xpath('description').text,
      position: section_xml[:position],
    }

    return section
  end

  def parse_article_xml(xml_file)
    doc = Nokogiri::XML.parse(xml_file)
    article_xml = doc.xpath('//article').first

    article = {
      id: article_xml[:id],
      section_id: article_xml[:section_id],
      title: article_xml.xpath('title').text,
      body: article_xml.xpath('body').text,
      position: article_xml[:position],
    }

    return article
  end

end
