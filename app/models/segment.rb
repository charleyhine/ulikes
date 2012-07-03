class Segment < ActiveRecord::Base
    acts_as_tree :order => "name"
    
    # creates the breadcrumbs string 
    def get_full_path
      current_seg = self.parent if self.parent
      full_path = ""
      while current_seg
        insert_name = current_seg.name
        if current_seg.parent
          insert_name = " > " + insert_name
        end
        full_path = insert_name + full_path
        current_seg = current_seg.parent
      end
      return full_path
    end
    
end
