class PlaceItem < Item
	@url = nil
  def url
    return "http://local.yahoo.com/details?id=#{self.yahoo_local_id}"
  end

	@map_url = nil
  def map_url 
    address = "#{self.street}, #{self.city.name}, #{self.state.abbreviation}"
    map_url = "http://maps.yahoo.com/index.php#mvt=m&gid1=#{self.yahoo_local_id}"
    map_url << "&q1=#{address}%2C+us&trf=0&lon=#{self.longitude}&lat=#{self.latitude}&mag=3"
    return URI.encode(map_url)
  end
end
