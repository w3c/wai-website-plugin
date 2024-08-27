# Prep: If a page has no language, add English language as default (unintended consequences)

# Jekyll::Hooks.register :site, :post_read do |site|
  # Jekyll.logger.debug "Eric’s SITE HOOK"
  # site.documents.each do |document|
    # Jekyll.logger.debug "Eric’s HOOK before:", document.data['lang']
    # if document.data['lang'].nil?
      # document.data['lang'] = 'en'
    # end
    # Jekyll.logger.debug "Eric’s HOOK after:", document.data['lang']
  # end
# end

def getPage (site, ref, lang = "en")
  translatedpages = site.documents.find_all {|a| a.data['ref'] == ref}
  translatedpages = translatedpages.concat(site.pages.find_all {|a| a.data['ref'] == ref})
  return translatedpages.find {|a| a.data['lang'] == lang}
end

def transform(document, inenglishtext)

  unless (document.content == "" || document.data['layout'] == "none")

    if (document.data['lang'] == '' || document.data['lang'] == 'en')
      inenglishtext = ""
      hreflang = ""
    else
      hreflang = '{: hreflang="en"}'
      inenglishtext =  ' (' + inenglishtext +')'
    end
    document.content.gsub!(/\[\[([^\]\]]+?)\]\]\((?!\/TR)(?!\/WAI)(\/.*?\/)(?:#(.*?))?\)/i) do |match|
      translatedpage = getPage document.site, Regexp.last_match[2], document.data['lang']
      if Regexp.last_match[3].nil?
        fragment = ''
      else
        fragment = '#' + Regexp.last_match[3]
      end
      if translatedpage.nil?
        '<<' + Regexp.last_match[1] + inenglishtext +'>>({{ "' + Regexp.last_match[2] +'" | relative_url }}'+ fragment+')' + hreflang
      else
        if translatedpage.data['title'] and translatedpage.data['permalink']
          '<<' + translatedpage.data['title'] +'>>({{ "' + translatedpage.data['permalink'] + '" | relative_url }}'+ fragment+')'
        else
          raise translatedpage.basename + " - missing title in frontmatter" unless translatedpage.data['title']
          raise translatedpage.basename + " - missing permalink in frontmatter" unless translatedpage.data['permalink']
        end
      end
    end

    document.content.gsub!(/\[([^\]]+?)\]\((?!\/TR)(?!\/WAI)(\/.*?\/)(?:#(.*?))?\)/i) do |match|
      translatedpage = getPage document.site, Regexp.last_match[2], document.data['lang']
      if Regexp.last_match[3].nil?
        fragment = ''
      else
        fragment = '#' + Regexp.last_match[3]
      end
      if translatedpage.nil?
        '[' + Regexp.last_match[1] + inenglishtext +']({{ "' + Regexp.last_match[2] +'" | relative_url }}'+ fragment+')' + hreflang
      else
        if translatedpage.data['permalink']
          '[' + Regexp.last_match[1] +']({{ "' + translatedpage.data['permalink'] + '" | relative_url }}'+ fragment+')'
        else
          raise translatedpage.basename + " - missing permalink in frontmatter"
        end
      end
    end

    document.content.gsub!(/<<(.+?)>>/i) do |match|
        '[' + Regexp.last_match[1] +']'
    end

  end

end

Jekyll::Hooks.register :documents, :pre_render do |document|
  inenglishtext = document.site.data['translations'].find {|a| a['en'] == 'in English'}
  inenglishtext = inenglishtext[document.data['lang']]
  if inenglishtext.nil?
    inenglishtext = "in English"
  end
  # Jekyll.logger.debug "Eric’s Hook EN:", inenglishtext

  transform document, inenglishtext
end

Jekyll::Hooks.register :pages, :pre_render do |document|
  inenglishtext = document.site.data['translations'].find {|a| a['en'] == 'in English'}
  inenglishtext = inenglishtext[document.data['lang']]
  if inenglishtext.nil?
    inenglishtext = "in English"
  end
  # Jekyll.logger.debug "Eric’s Hook EN:", inenglishtext

  transform document, inenglishtext
end
