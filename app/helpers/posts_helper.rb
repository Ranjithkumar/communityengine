module PostsHelper

  def post_with_ad_in_content(post)
    string = Ad.display(:post_content, logged_in?)      

    doc = Hpricot(post.post)
    paragraphs = doc.search("p")
    
    if paragraphs.length > 4
      paragraphs.each_with_index do |p,i|
        if i.eql?(2)
          p.before string 
          p[:id] = "jump"
        end
      end
    end
    
    doc.to_html
  end

  # The ShareThis widget defines a bunch of attributes you can customize.
  # Facebook seems to ignore them (it uses title and description meta tags
  # instead).  MySpace, however, only works if you set these attributes.
  def sharethis_options(post)
    content_tag :script, :type=>"text/javascript" do   
      <<-eos
	SHARETHIS.addEntry({
		title:'#{escape_javascript(post.title)}',
                content:'#{escape_javascript(truncate_words(post.post, 75, '...' ))}'
	}, {button:true});
      eos
    end
  end

end
