class AddSponsorLogoToSponsorships < ActiveRecord::Migration[7.0]
  def change
    add_column :sponsorships, :sponsor_logo, :string
  end
end
