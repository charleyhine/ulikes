class AddCarriers < ActiveRecord::Migration
  def self.up
    Carrier.create(:name => 'T-Mobile', :email_domain => 'tmomail.net')
    Carrier.create(:name => 'Cingular', :email_domain => 'cingularme.com')
    Carrier.create(:name => 'Sprint', :email_domain => 'messaging.sprintpcs.com')
    Carrier.create(:name => 'Verizon', :email_domain => 'vtext.com')
    Carrier.create(:name => 'Nextel', :email_domain => 'messaging.nextel.com')
    Carrier.create(:name => 'Virgin Mobile', :email_domain => 'vmobl.com')
  end

  def self.down
  end
end
