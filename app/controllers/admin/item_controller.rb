class Admin::ItemController < ApplicationController
	in_place_edit_for :item, :name 
	in_place_edit_for :item, :description
 
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @item_pages, @items = paginate :items, :include => :keyword, :per_page => 10
  end

  def new
    @item = Item.new
		@item.active = true

		render :action => :new
  end

  def create
    @item = Item.factory(params[:item])
		@result = @item.save
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
		@item.type = params[:item][:type]
		@result = @item.update_attributes(params[:item]) 

		#now update the keyword
		if @result 
			if @item.keyword.nil?
				@keyword = Keyword.new(params[:keyword])
				@result = @keyword.save
			else
				@keyword = @item.keyword
				@result = @keyword.update_attributes(params[:keyword])
			end
		end
  end

  def destroy
    Item.find(params[:id]).destroy
  end

	def set_item_active
		@item = Item.find(params[:id])
		#toggle the active flag
		@item.toggle!(:active)

		render :action => :save
	end

	def set_item_type
		@item = Item.find(params[:id])
		@item.type = params[:type]
		@item.save

		render :action => :save
	end

	def local_search
		search_params = params[:local_search_query].to_s.split(',', 2)
		if search_params.length != 2 then
			flash[:search_message] = 'Try something like: Art Museum, Denver, CO'
			list
			render :action => 'list'
		else
			@query = search_params[0]
			@location = search_params[1]
			y = YahooLocalV2.new
			@results = y.search(@query, @location)
			if @results.size <= 0
				flash[:search_message] = 'No results found!'
				list
				render :action => 'list'
			end
		end
	end

	def create_from_search
		result = false
		Item.transaction do
			@id = params[:id]
			@item = Item.factory(params[:item][@id])
			@item.description = @item.name
			@item.keyword = Keyword.generate(@item)
			@item.type = 'PlaceItem'
			@result = @item.save
		end
	end

end
