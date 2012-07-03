# ULikes Adobe PDF library - Creates PDF file
#
# @version: 1
# @author: chashine

module ULikes
  class PdfCreator
  
   def initialize(item)
      @item = item
   end
  
   def get_pdf
      pdf_output = nil
      begin
        keyword = @item.keyword
        
        # The form item named 'value' on the pdf matches 
        # the Keyword.value attribute/db column
        fdf = create_fdf(keyword.attributes)
        
	file_name = File.expand_path("ulikes_keyword_template.pdf")
        pdf_output = `pdftk #{file_name} fill_form #{fdf.path} output - flatten`
      rescue Exception => e
        puts e
      ensure
        File.delete(fdf.path)
      end
      return pdf_output
    end
    
    def create_fdf(info)
      #info = the hash of the object attributes
      data = "%FDF-1.2\x0d%\xe2\xe3\xcf\xd3\x0d\x0a"; # header
      data += "1 0 obj\x0d<< " # open the Root dictionary
      data += "\x0d/FDF << " # open the FDF dictionary
      data += "/Fields [ " # open the form Fields array
  
			info.each { |key,value|
					if value.class == Hash
							value.each { |sub_key,sub_value|
									data += '<< /T (' + key + '_' + sub_key + ') /V '
									data += '(' + sub_value.to_s.strip + ') /ClrF 2 /ClrFf 1 >> '
							}
					else
							puts key
							puts value
							data += '<< /T (' + key + ') /V (' + value.to_s.strip + ') /ClrF 2 /ClrFf 1 >> '
					end
			}
  
      data += "] \x0d" # close the Fields array
      data += ">> \x0d" # close the FDF dictionary
      data += ">> \x0dendobj\x0d" # close the Root dictionary
  
      # trailer note the "1 0 R" reference to "1 0 obj" above
      data += "trailer\x0d<<\x0d/Root 1 0 R \x0d\x0d>>\x0d" 
      data += "%%EOF\x0d\x0a" 
      afile = File.new("tmpApplesauce" + rand.to_s, "w") << data
      afile.close
      return afile
    end
  end #end PdfCreator class
end #end module ULikes
