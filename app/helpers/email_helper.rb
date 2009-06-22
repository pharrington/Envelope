module EmailHelper
  def clean_html(text, uid, block_images=true)
    doc = transform_cids(Hpricot(text), uid)
    doc = strip_comments doc
    doc = strip_style doc
    doc = strip_src doc if block_images
    doc = strip_doctype doc
    sanitize doc
  end

  def clean_plain(text)
    "<pre>" + html_escape(text) + "</pre>"
  end

  def strip_src(doc)
    (doc/"//img").each { |img| img.remove_attribute("src") unless img["src"] =~ /^(?:\.\.)?(?:\/|http:\/\/mce_host|cid:)/ }
    doc
  end

  def strip_comments(doc)
    (doc/"//comment()").remove
    doc
  end

  def strip_style(doc)
    (doc/"//style").remove
    doc
  end

  def transform_cids(doc, uid)
    (doc/"//img[@src^=cid]").each do |img|
      img["src"] = inline_attachments_path(uid, URI.escape(img["src"].scan(/^cid:(.+)$/).flatten.first, "."))
    end
    doc
  end

  def strip_doctype(doc)
    doc.root.to_s
  rescue Hpricot::Error
    doc.to_s
  end

  def seen_class(flags)
    flags.include?(:Seen) ? "read" : "unread"
  end
end
