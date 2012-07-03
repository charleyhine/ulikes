class ItemController < ApplicationController
  layout "global"

  def index
    #if !param[:id].nil? && !param[:id].empty? 
    #	show
    #	render :action => 'show'
    #end
    list
    render :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }
  
  #def list
  #end
  
  def show
    @item = Item.find(params[:id])
    @results = Array.new
    @results.push(@item)
    render :action => 'lookup'
  end
 
  def lookup
    @results = Array.new
 
    @query_text = params[:query].to_s
    @location = params[:location].to_s

    if @query_text.nil? || @query_text.empty?
      flash[:search_message] = "You didn't enter something to search for! Try putting something in the first box."
			@query_text = 'Nothing'
			@location = 'Nowhere'
		elsif @location.nil? || @location.empty?
      flash[:search_message] = "You didn't enter a location to search in! Try putting something in the second box."
			@query_text = 'Nothing'
			@location = 'Nowhere'
    elsif @query_text == 'search for a place' || @location == 'in this city, state'
      flash[:search_message] = "You need to enter something to search for!"
			@query_text = 'Nothing'
			@location = 'Nowhere'
		else
      #search for a previous query, or execute a new one
      query = Query.find_or_create(@query_text, @location)

      #paginate the results of the query
      @result_pages = Paginator.new(self, query.items.count, 4, @params['page'])
      @results = Item.find_by_query(query, @result_pages.current.offset, 4)  

			if @results.nil? || @results.length == 0 
				flash[:search_message] = "Couldn't find anything! Try searching for something else."
			end
    end
  end

	def print_banner
    @item = Item.find(params[:id])
		pdf_creator = PdfCreator.new(@item)
		pdf = pdf_creator.get_pdf()
		send_data pdf, :filename => "uLikes_" + @item.keyword.value + ".pdf", :type => "application/pdf"
	end

  def create
    result = false
    @item = Item.find(params[:id])
    
    if @item.keyword.nil?
      @item.keyword = Keyword.generate(@item)
      @item.save
    end
    @result = true
  end
end
